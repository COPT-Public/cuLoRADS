#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
package_dir="$(cd -- "$script_dir/.." && pwd)"
solver="$package_dir/bin/cuLoRADS"
problem="$package_dir/examples/tiny.dat-s"
output_dir="${1:-$package_dir/results}"

if [[ ! -x "$solver" ]]; then
    echo "cuLoRADS executable is missing or not executable: $solver" >&2
    exit 1
fi
if ! command -v nvidia-smi >/dev/null 2>&1 || ! nvidia-smi >/dev/null 2>&1; then
    echo "A working NVIDIA driver is required; nvidia-smi failed." >&2
    exit 1
fi

mkdir -p "$output_dir"
log_file="$output_dir/tiny.run.log"
solution="$output_dir/tiny.out.mat"
start_marker="$(mktemp "$output_dir/.culorads-smoke.XXXXXX")"
trap 'rm -f "$start_marker"' EXIT

set +e
"$solver" \
    --filePath "$problem" \
    --outputPath "$output_dir" \
    --timeSecLimit 60 \
    --juliaWarmStart false \
    2>&1 | tee "$log_file"
solver_status="${PIPESTATUS[0]}"
set -e

if [[ "$solver_status" -ne 0 ]]; then
    echo "cuLoRADS exited with status $solver_status; see $log_file" >&2
    exit "$solver_status"
fi
if ! grep -q "Problem Solved" "$log_file"; then
    echo "Solver log does not contain 'Problem Solved': $log_file" >&2
    exit 1
fi
if [[ ! -s "$solution" ]] || [[ ! "$solution" -nt "$start_marker" ]]; then
    echo "Expected solution was not created: $solution" >&2
    exit 1
fi

echo "Smoke-test log: $log_file"
echo "Smoke-test solution: $solution"
