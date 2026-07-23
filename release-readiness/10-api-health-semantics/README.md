# Task 10: Harden health and readiness API behavior

## Prerequisites

Tasks 5, 6, and 9 must define service health and dependency responsibilities.

## Execute

Submit `PROMPT.md`. Review API compatibility implications before accepting status-code or schema changes.

## Expected deliverables

- Separate liveness and readiness contracts.
- Stable aggregate-health response schema.
- Defensible OpenPLC and TLS behavior.
- Startup validation of probe settings.
- Tests and documentation for every state.

## Test and verify

- Exercise healthy, degraded, unreachable, and timeout cases.
- Verify exact HTTP codes and JSON schemas.
- Test malformed expected-status and timeout settings.
- Confirm release TLS verification is enabled.
- Confirm every request terminates within its configured bound.

Acceptance requires accurate, bounded, and documented health reporting.
