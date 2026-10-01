# cuLoRADS

[![Package checks](https://github.com/COPT-Public/cuLoRADS/actions/workflows/package-checks.yml/badge.svg)](https://github.com/COPT-Public/cuLoRADS/actions/workflows/package-checks.yml)

cuLoRADS is a GPU solver for semidefinite programs based on low-rank
factorization, augmented-Lagrangian iterations, and ADMM. This repository
distributes a precompiled Linux application. The cuLoRADS implementation
source is not included.

Current version: `1.1.0`.

- Project repository: <https://github.com/COPT-Public/cuLoRADS>
- Downloads: <https://github.com/COPT-Public/cuLoRADS/releases>
- Issues: <https://github.com/COPT-Public/cuLoRADS/issues>

## Authors

The authors of the associated cuLoRADS paper, in publication order, are
Qiushi Han, Zhenwei Lin, Hanwen Liu, Caihua Chen, Qi Deng, Dongdong Ge, and
Yinyu Ye. Qiushi Han is the release contact. See [AUTHORS](AUTHORS) and
[CITATION.cff](CITATION.cff).

## Supported environment

- 64-bit x86 Linux with the AES-NI CPU feature
- an NVIDIA GPU and working NVIDIA driver
- a driver compatible with the bundled CUDA 13.3 user-space runtime
- sufficient host and GPU memory for the selected problem

The 1.1.0 package was built with Julia 1.12.6 for the `generic,+aes` CPU target
on a system using glibc 2.35. Compatibility with older Linux distributions has
not been established. Julia and a separate CUDA toolkit are not required.
There is no CPU solver fallback.

## Install

Download these two files from the `v1.1.0` release:

- `cuLoRADS-1.1.0-linux-x86_64.tar.zst`
- `cuLoRADS-1.1.0-linux-x86_64.tar.zst.sha256`

Then verify and extract the application:

```sh
sha256sum -c cuLoRADS-1.1.0-linux-x86_64.tar.zst.sha256
tar --zstd -xf cuLoRADS-1.1.0-linux-x86_64.tar.zst
cd cuLoRADS-1.1.0-linux-x86_64
./scripts/verify_install.sh
```

Keep the complete extracted directory together. `bin/cuLoRADS` launches the
compiled program using the adjacent `lib/`, `libexec/`, and `share/` trees;
neither executable in `bin/` is a standalone installation.

See [INSTALL.md](INSTALL.md) for detailed requirements and troubleshooting.

## Quick start

Check GPU access and solve the included two-dimensional example:

```sh
nvidia-smi
CUDA_VISIBLE_DEVICES=0 ./scripts/run_example.sh
```

A successful run prints `Problem Solved` and writes
`results/tiny.out.mat`. To solve another problem:

```sh
mkdir -p /absolute/path/to/results
CUDA_VISIBLE_DEVICES=0 ./bin/cuLoRADS \
  --filePath /absolute/path/to/problem.dat-s \
  --outputPath /absolute/path/to/results \
  --timeSecLimit 600
```

`--filePath` accepts sparse SDPA `.dat-s` files and SeDuMi-style `.mat` files
containing `A` (or `At`), `b`, `c`, and `K`. The output directory must already
exist. A saved `.out.mat` file contains:

- `primal_sdp`: low-rank factors `U`; reconstruct each SDP block as `U * U'`
- `primal_lp`: the primal linear-variable vector
- `dual`: the dual-variable vector

See [docs/CLI.md](docs/CLI.md) for every option and
[docs/INTEGRATION.md](docs/INTEGRATION.md) for child-process integration.

## Validation

The final 1.1.0 application was verified on an NVIDIA H100 80 GB GPU with
driver 595.71.05. The packaged example passed the archive integrity check,
completed with `Problem Solved`, and satisfied independent objective,
feasibility, and positive-semidefiniteness checks. See
[docs/VALIDATION.md](docs/VALIDATION.md) for the recorded scope and tolerances.

The repository workflow checks metadata and scripts on hosted Linux. An
opt-in job validates a published release on a self-hosted NVIDIA runner.
Hosted CI does not claim GPU coverage.

## License

The cuLoRADS binary distribution and repository documentation are provided
under the [Apache License 2.0](LICENSE). Bundled Julia, CUDA, and other runtime
components retain their own licenses; see
[THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md) and the license collection in
the release archive.

## Citation

Qiushi Han, Zhenwei Lin, Hanwen Liu, Caihua Chen, Qi Deng, Dongdong Ge, and
Yinyu Ye, “Accelerating Low-Rank Factorization-Based Semidefinite Programming
Algorithms on GPU,” arXiv:2407.15049, 2024.
<https://doi.org/10.48550/arXiv.2407.15049>

Machine-readable citation metadata is available in [CITATION.cff](CITATION.cff).
