# Task 2: Pin third-party container images

## Prerequisite

Task 1's supported platforms and version policy must be documented.

## Execute

Submit `PROMPT.md`. Approve image versions only from authoritative registries and release metadata.

## Expected deliverables

- Exact versions for all four third-party images.
- Optional immutable digests for release use.
- Updated environment template and documentation.
- A short record of selected versions and supported architectures.

## Test and verify

- Run `docker compose config --quiet`.
- Pull every selected image.
- Inspect the resolved image digests and architectures.
- Confirm no required service still uses `latest` or an unbounded major/minor tag.
- Start each image or the full stack if Docker is available.

Acceptance requires reproducible image resolution on every platform promised by the release contract.
