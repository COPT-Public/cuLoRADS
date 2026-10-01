# Release process

The current software version is `1.1.0`. Release archives are GitHub Release
assets and are not committed as Git blobs.

Before publishing a release:

1. Keep `VERSION`, README, citation metadata, archive name, and tag synchronized.
2. Build the application from the reviewed maintainer revision.
3. Include Apache-2.0 and all applicable third-party license materials.
4. Generate the archive's internal `SHA256SUMS` and the external `.sha256` file.
5. Run `scripts/check_repository.sh` and `scripts/check_package.sh`.
6. On a clean NVIDIA host, run the extracted `scripts/verify_install.sh`,
   `scripts/run_example.sh`, and `scripts/verify_tiny_solution.py`.
7. Tag the reviewed repository commit, for example `v1.1.0`.
8. Upload the `.tar.zst` archive and `.sha256` file to the matching GitHub Release.
9. Run the manual self-hosted GPU workflow against the published tag.

Retain the validation log, GPU/driver identity, dependency manifest, archive
checksum, and build-revision record with the release evidence.
