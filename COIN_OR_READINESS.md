# Binary-distribution readiness

This record maps the 2026-10-02 review findings to the cuLoRADS 1.1.0 binary
distribution. It describes evidence; it does not claim COIN-OR acceptance.

| Review area | Current status | Evidence |
| --- | --- | --- |
| License | Addressed for the distributed binary and repository materials | Apache License 2.0 in `LICENSE`; attribution in `NOTICE`; bundled components in `THIRD_PARTY_NOTICES.md` and the archive license tree |
| Installation | Addressed for the supported binary platform | `INSTALL.md`, archive checksum, relocatable application layout, and `scripts/verify_install.sh` |
| User documentation | Addressed | `README.md`, `docs/CLI.md`, and `docs/INTEGRATION.md` |
| Tests | Addressed within a binary-only boundary | structural and integrity scripts, GPU example, independent saved-solution checker, and recorded H100 results in `docs/VALIDATION.md` |
| CI | Addressed for repository and release integrity; GPU CI is opt-in | hosted repository checks, hosted published-asset integrity job, and a manual self-hosted NVIDIA job in `.github/workflows/package-checks.yml` |
| Versioning | Addressed | `VERSION` is 1.1.0; public tag and GitHub Release are `v1.1.0` |
| Binary distribution | Addressed | versioned Linux x86-64 archive, independent `.sha256` asset, internal `SHA256SUMS`, dependency manifest, and collected runtime licenses |
| Buildable implementation source | **Not addressed by design** | implementation source and source build system are not distributed |

## Important limitation

The archive can be installed, verified, tested, and integrated without Julia
or a separate CUDA toolkit. It cannot be independently rebuilt or audited at
the implementation-source level from these materials. If COIN-OR requires the
implementation source as a condition of contribution, this binary-only package
does not meet that condition and must instead be treated as an external binary
component of a larger project.

The open-source status of surrounding software does not change this boundary.
The Apache-2.0 license provided here does not imply that omitted source files
are present.
