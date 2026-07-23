# Task 6: Add dependency readiness and resilient startup

## Prerequisite

Task 5 health checks must be working.

## Execute

Submit `PROMPT.md` with Docker running. Test from an isolated Compose project to avoid affecting developer data.

## Expected deliverables

- Health-aware dependency conditions where justified.
- Retry or recovery behavior for runtime dependency loss.
- Documented cold-start and restart expectations.
- Automated or repeatable readiness tests.

## Test and verify

- Start from a clean state and record health order.
- Delay PostgreSQL and OpenPLC startup.
- Restart each dependency independently.
- Confirm dependents recover without manual intervention.
- Confirm unrelated services can still start when appropriate.

Acceptance requires predictable startup and automatic recovery from supported dependency restarts.
