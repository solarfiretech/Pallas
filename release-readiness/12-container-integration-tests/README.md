# Task 12: Add container-level integration tests

## Prerequisites

Tasks 7–11 must be complete and the release image/API stable.

## Execute

Submit `PROMPT.md` with Docker running and enough space for clean builds.

## Expected deliverables

- An isolated container integration-test harness.
- Tests for build, startup, endpoints, configuration, restrictions, and shutdown.
- Automatic cleanup and failure diagnostics.
- A single documented execution command.

## Test and verify

- Run from a clean image cache where practical.
- Confirm tests use a unique Compose project name.
- Confirm developer volumes and containers are untouched.
- Force a failure and inspect captured logs.
- Run twice consecutively to prove cleanup.

Acceptance requires repeatable, isolated validation of the actual release image.
