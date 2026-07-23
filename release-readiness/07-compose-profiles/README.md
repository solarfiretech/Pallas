# Task 7: Separate development and release Compose configurations

## Prerequisites

Tasks 1–6 must be stable because both modes must preserve their contracts.

## Execute

Submit `PROMPT.md`. Use explicit Compose file arguments during tests so the selected mode is undeniable.

## Expected deliverables

- Immutable release-capable base configuration.
- A development override with live-source behavior.
- Explicitly tagged project images.
- Documented commands for both modes.

## Test and verify

- Render both configurations.
- Build and start both modes.
- Edit host FastAPI source after a release build and confirm release behavior is unchanged.
- Confirm the same edit appears in development mode as documented.
- Re-run all service health checks in both modes.

Acceptance requires clearly separated, working development and release workflows.
