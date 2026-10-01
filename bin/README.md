# Binary inspection copies

`cuLoRADS` and `cuLoRADS.bin` are byte-identical copies of the launcher and
compiled entry point in the 1.1.0 release archive. They make the distributed
executable visible during repository review.

These files are not a standalone installation. The complete application also
requires the `lib/`, `libexec/`, and `share/` trees provided in the GitHub
Release archive. Download, verify, and extract that archive before running the
solver; see [INSTALL.md](../INSTALL.md).
