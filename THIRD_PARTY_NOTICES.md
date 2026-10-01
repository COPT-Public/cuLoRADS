# Third-party software notices

The cuLoRADS binary release bundles the Julia runtime, ArgParse.jl, CUDA.jl,
KrylovKit.jl, MAT.jl, their transitive dependencies, and NVIDIA CUDA user-space
components. These components remain subject to their respective upstream
licenses and are not relicensed by the cuLoRADS Apache License 2.0.

The release archive contains:

- `share/dependency-manifest.toml`, recording the dependency graph and versions;
- `share/licenses/`, containing collected runtime and package licenses; and
- the NVIDIA CUDA runtime license applicable to bundled CUDA components.

The NVIDIA host driver is not distributed with cuLoRADS.
