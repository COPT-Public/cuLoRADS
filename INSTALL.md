# Installation and verification

cuLoRADS 1.1.0 is distributed as a self-contained Linux x86-64 application.
Julia and a separate CUDA toolkit are not required.

## Requirements

- x86-64 Linux with AES-NI
- an NVIDIA GPU and functional NVIDIA driver
- a driver compatible with the bundled CUDA 13.3 user-space runtime
- a Linux environment compatible with the glibc 2.35 build host

Compatibility with older Linux distributions has not been established. The
solver has no CPU fallback.

## Download and extract

Download the archive and checksum from the `v1.1.0` GitHub Release, then run:

```sh
sha256sum -c cuLoRADS-1.1.0-linux-x86_64.tar.zst.sha256
tar --zstd -xf cuLoRADS-1.1.0-linux-x86_64.tar.zst
cd cuLoRADS-1.1.0-linux-x86_64
./scripts/verify_install.sh
```

If `tar` lacks zstd support, install `zstd` and use:

```sh
zstd -dc ../cuLoRADS-1.1.0-linux-x86_64.tar.zst | tar -xf -
```

Keep the complete extracted directory together. The application depends on
the relative placement of `bin/`, `lib/`, `libexec/`, and `share/`.

The launcher writes small Julia runtime bookkeeping files under
`${XDG_CACHE_HOME}/cuLoRADS/1.1.0` or `${HOME}/.cache/cuLoRADS/1.1.0`. Select a
different writable directory when needed:

```sh
export CULORADS_CACHE_DIR=/path/to/private/cache
```

Package downloads are disabled at runtime.

## GPU smoke test

```sh
nvidia-smi
CUDA_VISIBLE_DEVICES=0 ./scripts/run_example.sh
```

Success requires a zero exit status, `Problem Solved` in the log, and a new
`results/tiny.out.mat`. The release-validation workflow additionally checks
the saved solution numerically.

## Troubleshooting

- `CUDA driver not found`: verify `nvidia-smi` in the same shell or container.
- `GLIBC_x.y not found`: use a compatible host/container or request a build
  targeting an older distribution.
- missing library after copying an executable: restore the complete extracted
  application tree.
- unwritable cache: set `CULORADS_CACHE_DIR` to private writable storage.
- invalid output path: create `--outputPath` before launching the solver.

When reporting a problem, include the archive checksum, full command, input
dimensions, Linux distribution, CPU architecture, GPU, driver, exit status,
and complete combined output.
