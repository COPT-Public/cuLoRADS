# Release validation

Project repository: https://github.com/COPT-Public/cuLoRADS

## Build identity

- cuLoRADS version: 1.1.0
- target: Linux x86_64
- Julia runtime: 1.12.6 (bundled)
- CUDA.jl: 6.2.1
- bundled CUDA runtime preference: 13.3
- CPU compilation target: generic x86-64 with AES-NI (`generic,+aes`)
- build host C library: glibc 2.35

The dependency versions used to construct the application are recorded in
`share/dependency-manifest.toml`.

## Required acceptance checks

Before publishing or embedding this directory in a larger release, run these
checks on a clean supported GPU machine:

```sh
./scripts/verify_install.sh
./scripts/run_example.sh
```

Acceptance requires all of the following:

1. the structural verification script succeeds;
2. `nvidia-smi` identifies the allocated GPU;
3. the example process returns successfully;
4. the log contains `Problem Solved`;
5. `results/tiny.out.mat` exists; and
6. reconstruction of the 2-by-2 test matrix is feasible and has objective
   approximately `-2` within an application-approved tolerance.

For reproducibility, retain the commands, combined logs, archive checksum,
Linux distribution, GPU model, driver version, and `nvidia-smi` output.

The repository's numerical checker automates the final reconstruction checks:

```sh
python -m pip install -r scripts/requirements-validation.txt
python scripts/verify_tiny_solution.py \
  /path/to/cuLoRADS-1.1.0-linux-x86_64/results/tiny.out.mat
```

The manual self-hosted GPU workflow downloads the published release, verifies
its checksum and layout, runs the example, and invokes this checker.

## Recorded release validation (2026-09-30)

The solver was built from the cuLoRADS 1.1.0 source revision recorded by the
release builder, including the fix that gives small sparse SDPA inputs a
nonzero initial storage capacity. Validation used an NVIDIA H100 80 GB GPU with
driver 595.71.05. The solver ran from the binary application tree in offline
package mode with Julia warm start disabled.

The included `tiny.dat-s` problem completed with `Problem Solved` and wrote
`tiny.out.mat`. The final solver report was:

| Quantity | Value |
| --- | ---: |
| Primal objective | `-1.999999e+00` |
| Dual objective | `-1.999998e+00` |
| Primal infeasibility (DIMACS) | `1.487066e-06` |
| Dual infeasibility (DIMACS) | `2.949951e-07` |
| Primal-dual gap (DIMACS) | `2.508633e-07` |

An independent read of the saved factor reconstructed `X = U*U'` and obtained:

| Check | Value | Acceptance |
| --- | ---: | ---: |
| Objective `-2*X[1,2]` | `-1.9999994867228474` | absolute error at most `1e-3` |
| Maximum diagonal error | `3.198410388760564e-6` | at most `1e-3` |
| Minimum eigenvalue | `3.007902638074711e-7` | at least `-1e-8` |

Package verification also checks the complete internal SHA-256 manifest and
starts the command-line entry point with downloads disabled. This single small
problem is an installation smoke test, not a general solver-accuracy study.

After that GPU run, build-host filesystem names in compiled diagnostic metadata
were replaced by a neutral release-build prefix using equal-length byte
substitutions; executable code, solver data, and the command-line contract were
not changed.

## Final packaged-binary retest (2026-09-30)

The final archive with SHA-256
`6f055f8866d2c985db4d042862ca1e2f39bc23c5fa6adcf4012470bc6bf7496c`
was verified, extracted into a fresh directory, and tested on NVIDIA H100 GPU
`GPU-b215c6b4-13b7-1ed8-3af0-8667d6d444cb` with driver 595.71.05. Both
`scripts/verify_install.sh` and `scripts/run_example.sh` passed. The solver log
contained `Problem Solved` and reported:

| Quantity | Value |
| --- | ---: |
| Primal objective | `-2.000000e+00` |
| Dual objective | `-1.999999e+00` |
| Primal infeasibility (DIMACS) | `3.419223e-06` |
| Dual infeasibility (DIMACS) | `1.820270e-07` |
| Primal-dual gap (DIMACS) | `1.917876e-07` |

An independent read of the newly written factor reconstructed `X = U*U'` and
obtained:

| Check | Value | Acceptance |
| --- | ---: | ---: |
| Objective `-2*X[1,2]` | `-1.999999891140233` | absolute error at most `1e-3` |
| Maximum diagonal error | `7.273313084255051e-6` | at most `1e-3` |
| Minimum eigenvalue | `7.447677666566029e-8` | at least `-1e-8` |

All final-archive smoke-test acceptance checks passed.
