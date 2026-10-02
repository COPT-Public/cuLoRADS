#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
repo_dir="$(cd -- "$script_dir/.." && pwd)"

required=(
    README.md
    COIN_OR_READINESS.md
    INSTALL.md
    LICENSE
    NOTICE
    AUTHORS
    CITATION.cff
    CONTRIBUTING.md
    RELEASE.md
    THIRD_PARTY_NOTICES.md
    OWNERSHIP.md
    SOURCE_PROVENANCE.json
    VERSION
    docs/CLI.md
    docs/INTEGRATION.md
    docs/VALIDATION.md
    examples/tiny.dat-s
    bin/README.md
    bin/cuLoRADS
    bin/cuLoRADS.bin
    scripts/check_package.sh
    scripts/run_example.sh
    scripts/verify_install.sh
    scripts/verify_tiny_solution.py
    scripts/requirements-validation.txt
    cuLoRADS-1.1.0-linux-x86_64.tar.zst.sha256
)

for relative in "${required[@]}"; do
    if [[ ! -f "$repo_dir/$relative" ]]; then
        echo "Missing required repository file: $relative" >&2
        exit 1
    fi
done

version="$(tr -d '[:space:]' < "$repo_dir/VERSION")"
if [[ "$version" != "1.1.0" ]]; then
    echo "Unexpected VERSION value: $version" >&2
    exit 1
fi

grep -Fq 'Current version: `1.1.0`' "$repo_dir/README.md"
grep -Fq 'version: "1.1.0"' "$repo_dir/CITATION.cff"
grep -Fq 'license: Apache-2.0' "$repo_dir/CITATION.cff"
grep -Fq '10.1073/pnas.2516128123' "$repo_dir/CITATION.cff"
grep -Fq 'Apache License' "$repo_dir/LICENSE"

python3 - "$repo_dir" <<'PY'
import hashlib
import json
import pathlib
import re
import sys

root = pathlib.Path(sys.argv[1])
provenance = json.loads((root / "SOURCE_PROVENANCE.json").read_text())
if provenance["version"] != "1.1.0":
    raise SystemExit("SOURCE_PROVENANCE.json version mismatch")
if provenance["license"] != "Apache-2.0":
    raise SystemExit("SOURCE_PROVENANCE.json license mismatch")
if provenance["implementation_source_included"] is not False:
    raise SystemExit("binary-only source boundary is not recorded")
if provenance["source_build_supported_from_distribution"] is not False:
    raise SystemExit("source-build boundary is not recorded")
if provenance["build_record"]["source_repository_visibility"] != "non-public":
    raise SystemExit("build-source visibility is not recorded accurately")

for name, expected in provenance["outer_binary_copies"]["sha256"].items():
    digest = hashlib.sha256((root / "bin" / name).read_bytes()).hexdigest()
    if digest != expected:
        raise SystemExit(f"binary inspection copy checksum mismatch: {name}")

checksum_text = (root / "cuLoRADS-1.1.0-linux-x86_64.tar.zst.sha256").read_text().strip()
match = re.fullmatch(r"([0-9a-f]{64})  cuLoRADS-1\.1\.0-linux-x86_64\.tar\.zst", checksum_text)
if not match:
    raise SystemExit("release checksum file has an invalid format")
archive = provenance["archive"]
if archive["sha256"] != match.group(1):
    raise SystemExit("release checksum and provenance do not match")
if not isinstance(archive["size_bytes"], int) or archive["size_bytes"] <= 0:
    raise SystemExit("release archive size is not finalized")

text_suffixes = {"", ".cff", ".json", ".md", ".sh", ".txt", ".yml", ".yaml"}
for path in root.rglob("*"):
    if not path.is_file() or ".git" in path.parts or path.suffix not in text_suffixes:
        continue
    text = path.read_text(errors="ignore")
    if re.search(r"[\u3400-\u4dbf\u4e00-\u9fff]", text):
        raise SystemExit(f"Chinese text remains in public file: {path.relative_to(root)}")
PY

if find "$repo_dir" -path "$repo_dir/.git" -prune -o -type f -name '*.jl' -print -quit |
    grep -q .; then
    echo "Implementation source unexpectedly appears in the binary repository." >&2
    exit 1
fi

forbidden_regex='/home/|PDCS.fork|culorads.submission|free for academic'" use|tar -xz"'vf'
if grep -RIl --exclude-dir=.git --exclude=check_repository.sh -E "$forbidden_regex" "$repo_dir" |
    grep -q .; then
    echo "A public file contains a development path or stale release wording." >&2
    grep -RIn --exclude-dir=.git --exclude=check_repository.sh -E "$forbidden_regex" "$repo_dir" >&2
    exit 1
fi

while IFS= read -r shell_file; do
    bash -n "$shell_file"
done < <(find "$repo_dir/scripts" -maxdepth 1 -type f -name '*.sh' -print)

python3 - "$repo_dir/scripts/verify_tiny_solution.py" <<'PY'
import pathlib
import sys

path = pathlib.Path(sys.argv[1])
compile(path.read_text(), str(path), "exec")
PY

if [[ ! -x "$repo_dir/bin/cuLoRADS" || ! -x "$repo_dir/bin/cuLoRADS.bin" ]]; then
    echo "Binary inspection copies are not executable." >&2
    exit 1
fi

echo "Repository metadata, documentation, scripts, and binary-only boundary verified."
