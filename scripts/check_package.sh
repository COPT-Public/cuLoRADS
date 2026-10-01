#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
repo_dir="$(cd -- "$script_dir/.." && pwd)"
archive_name="cuLoRADS-1.1.0-linux-x86_64.tar.zst"
archive="${1:-$repo_dir/$archive_name}"
archive_root="cuLoRADS-1.1.0-linux-x86_64"

if [[ ! -f "$archive" ]]; then
    echo "Release archive not found: $archive" >&2
    exit 1
fi
if [[ "$(basename -- "$archive")" != "$archive_name" ]]; then
    echo "Unexpected archive name: $archive" >&2
    exit 1
fi

expected="$(cut -d' ' -f1 "$repo_dir/$archive_name.sha256")"
actual="$(sha256sum "$archive" | cut -d' ' -f1)"
if [[ "$actual" != "$expected" ]]; then
    echo "Release archive checksum mismatch." >&2
    exit 1
fi

listing="$(mktemp)"
trap 'rm -f "$listing"' EXIT
tar --zstd -tf "$archive" >"$listing"

required_members=(
    "$archive_root/LICENSE"
    "$archive_root/NOTICE"
    "$archive_root/README.md"
    "$archive_root/VERSION"
    "$archive_root/bin/cuLoRADS"
    "$archive_root/bin/cuLoRADS.bin"
    "$archive_root/lib/"
    "$archive_root/libexec/"
    "$archive_root/share/"
    "$archive_root/SHA256SUMS"
    "$archive_root/scripts/verify_install.sh"
    "$archive_root/scripts/run_example.sh"
)
for member in "${required_members[@]}"; do
    if ! grep -Fqx -- "$member" "$listing"; then
        echo "Missing required archive member: $member" >&2
        exit 1
    fi
done

if grep -Eq '(^|/)\.\.(/|$)|^/' "$listing"; then
    echo "Archive contains an unsafe absolute or parent-relative path." >&2
    exit 1
fi
if grep -Eq '\.jl$' "$listing"; then
    echo "Archive unexpectedly contains Julia implementation source." >&2
    exit 1
fi

if ! cmp --silent "$repo_dir/LICENSE" \
    <(tar --zstd -xOf "$archive" "$archive_root/LICENSE"); then
    echo "Repository and archive licenses differ." >&2
    exit 1
fi
if [[ -f "$repo_dir/bin/cuLoRADS" ]] && ! cmp --silent "$repo_dir/bin/cuLoRADS" \
    <(tar --zstd -xOf "$archive" "$archive_root/bin/cuLoRADS"); then
    echo "Repository launcher copy differs from the release archive." >&2
    exit 1
fi
if [[ -f "$repo_dir/bin/cuLoRADS.bin" ]] && ! cmp --silent "$repo_dir/bin/cuLoRADS.bin" \
    <(tar --zstd -xOf "$archive" "$archive_root/bin/cuLoRADS.bin"); then
    echo "Repository executable copy differs from the release archive." >&2
    exit 1
fi

echo "Release archive checksum, layout, license, and source boundary verified."
