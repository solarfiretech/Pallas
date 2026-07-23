# Task 16: Add dependency and image security scanning

## Prerequisites

Images, dependencies, container hardening, and network exposure must be stable.

## Execute

Submit `PROMPT.md`. Review tool provenance, pinned versions, and data-sharing behavior before adoption.

## Expected deliverables

- Reproducible dependency, image, secret, configuration, and license scans.
- Checked-in policies and severity gates.
- A documented exception process with owner and expiry.
- An initial findings report.

## Test and verify

- Run all scanners against the release configuration.
- Introduce safe synthetic findings and confirm blocking behavior.
- Confirm secrets are scanned repository-wide.
- Confirm reports identify the exact artifact and version.
- Re-run to check deterministic exit behavior.

Acceptance requires automated blocking of prohibited findings and explicit handling of accepted risks.
