# Task 5: Add Compose-native health checks

## Prerequisites

Tasks 2–4 must provide stable images and configuration.

## Execute

Submit `PROMPT.md` with Docker running. Review probes for low overhead and service-specific meaning.

## Expected deliverables

- A health check for every required service.
- Documented timing and readiness semantics.
- No dependency on optional examples.

## Test and verify

- Run `docker compose config --quiet`.
- Start the stack and wait for five healthy containers.
- Break each probe or service individually and observe `unhealthy`.
- Restore it and observe recovery.
- Confirm health commands exist in their target images.

Acceptance requires deterministic health transitions for all five services.
