# Task 15: Harden network and host exposure

## Prerequisites

Release and development Compose modes plus persistence behavior must be stable.

## Execute

Submit `PROMPT.md`. Compare the resulting exposure with the release contract before acceptance.

## Expected deliverables

- A documented host-port exposure matrix.
- Minimal release-default published ports.
- Optional tooling profiles or development overrides where justified.
- Clear authentication and network-boundary warnings.

## Test and verify

- Inspect resolved published ports.
- Probe each port from the host.
- Verify internal service-name connectivity.
- Confirm internal-only services are not externally reachable.
- Re-run full-stack health and smoke tests.

Acceptance requires least-necessary exposure without breaking documented workflows.
