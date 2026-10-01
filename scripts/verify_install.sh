#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
package_dir="$(cd -- "$script_dir/.." && pwd)"
solver="$package_dir/bin/cuLoRADS"

required=(
    "$solver"
    "$package_dir/bin/cuLoRADS.bin"
    "$package_dir/lib"
    "$package_dir/libexec"
    "$package_dir/share"
    "$package_dir/examples/tiny.dat-s"
    "$package_dir/LICENSE"
    "$package_dir/VERSION"
)
for path in "${required[@]}"; do
    if [[ ! -e "$path" ]]; then
        echo "Missing required package component: $path" >&2
        exit 1
    fi
done

if [[ ! -x "$solver" || ! -x "$package_dir/bin/cuLoRADS.bin" ]]; then
    echo "Packaged solver entry points are not executable." >&2
    exit 1
fi
if [[ -r /proc/cpuinfo ]] && ! grep -q -w aes /proc/cpuinfo; then
    echo "This build requires the AES-NI CPU feature." >&2
    exit 1
fi
if [[ "$(tr -d '[:space:]' < "$package_dir/VERSION")" != "1.1.0" ]]; then
    echo "Unexpected package VERSION." >&2
    exit 1
fi
if [[ -f "$package_dir/SHA256SUMS" ]]; then
    (cd "$package_dir" && sha256sum --check --quiet SHA256SUMS)
fi

help_output="$($solver --help 2>&1)"
if [[ "$help_output" != *"--filePath"* ]] || [[ "$help_output" != *"--outputPath"* ]]; then
    echo "cuLoRADS help output is incomplete." >&2
    exit 1
fi

echo "Package structure, checksums, and command-line entry point verified."
