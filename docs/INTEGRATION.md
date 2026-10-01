# Integrating the cuLoRADS binary

Project repository: https://github.com/COPT-Public/cuLoRADS

cuLoRADS is integrated as a child process. The host project may be open source;
only the precompiled cuLoRADS application tree is required at runtime. There is
no supported in-process C, C++, Python, or Julia library API in this release.

## Package boundary

Install the following tree as one unit:

```text
cuLoRADS-1.1.0-linux-x86_64/
├── bin/cuLoRADS       # launcher
├── bin/cuLoRADS.bin   # compiled program
├── lib/
├── share/
├── examples/
├── scripts/
└── documentation and notices
```

The parent application should resolve the executable relative to its installed
resource directory, not assume that `cuLoRADS` is on `PATH`. Never copy only
the executable.

The launcher sets `JULIA_PKG_OFFLINE=true` and keeps runtime bookkeeping out of
the installation tree. Set `CULORADS_CACHE_DIR` in the child environment when
the default user cache is unsuitable (for example, to a job-local scratch
directory). The cache must be writable and should not be shared by mutually
untrusted users.

## Process contract

1. Ensure the input file exists and has a supported suffix.
2. Create the output directory before launch when a saved solution is needed.
3. Select GPU visibility through the scheduler or `CUDA_VISIBLE_DEVICES`.
4. Launch `bin/cuLoRADS` with an argument vector; do not build a shell command
   by concatenating untrusted paths.
5. Capture standard output and standard error together with the exact command,
   version, GPU, driver, wall time, and process exit status.
6. Treat `Problem Solved` plus acceptable final residuals (or independent
   verification of the saved solution) as the numerical acceptance condition.

An operating-system timeout should be slightly longer than `--timeSecLimit` to
allow input loading, startup, final evaluation, and solution writing.

## Python example

```python
from pathlib import Path
import os
import subprocess

package = Path("/opt/cuLoRADS-1.1.0-linux-x86_64")
problem = Path("/data/problem.dat-s")
output = Path("/data/results")
output.mkdir(parents=True, exist_ok=True)

env = os.environ.copy()
env.setdefault("CUDA_VISIBLE_DEVICES", "0")
command = [
    str(package / "bin" / "cuLoRADS"),
    "--filePath", str(problem),
    "--outputPath", str(output),
    "--timeSecLimit", "600",
]
completed = subprocess.run(
    command,
    env=env,
    text=True,
    stdout=subprocess.PIPE,
    stderr=subprocess.STDOUT,
    timeout=660,
)
log = completed.stdout
if completed.returncode != 0 or "Problem Solved" not in log:
    raise RuntimeError(f"cuLoRADS did not complete successfully:\n{log}")

solution = output / f"{problem.stem}.out.mat"
if not solution.is_file():
    raise RuntimeError(f"cuLoRADS did not create {solution}")
```

## Shell example

```sh
install_root=/opt/cuLoRADS-1.1.0-linux-x86_64
input=/data/problem.dat-s
output=/data/results
mkdir -p "$output"
CUDA_VISIBLE_DEVICES=0 "$install_root/bin/cuLoRADS" \
  --filePath "$input" \
  --outputPath "$output" \
  --timeSecLimit 600 \
  >"$output/problem.log" 2>&1
```

## Concurrency

Use one process per assigned GPU unless resource testing establishes a
different policy. Give each process its own output/log location. Multiple runs
using the same input basename and output directory overwrite the same
`<name>.out.mat` path.

## Containers and schedulers

The container must receive NVIDIA GPU access and the host's NVIDIA driver
interface. The bundled user-space CUDA runtime does not replace the host
kernel driver. In Slurm, request a GPU and let Slurm set device visibility when
possible; do not override its `CUDA_VISIBLE_DEVICES` assignment.
