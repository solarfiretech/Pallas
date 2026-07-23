# Task 20: Define and test upgrade and rollback

## Prerequisites

Persistence recovery, pinned artifacts, and operational documentation must be complete.

## Execute

Submit `PROMPT.md` using an isolated Compose project and disposable test state.

## Expected deliverables

- Versioned upgrade and rollback instructions.
- Preflight, backup, verification, and restoration steps.
- A safe repeatable test harness or procedure.
- A compatibility and irreversible-change statement.

## Test and verify

- Create identifiable state in every persistent service.
- Upgrade from the recorded baseline.
- Verify health and data after upgrade.
- Roll back images and configuration.
- Verify health and data after rollback or documented restore.

Acceptance requires a demonstrated recovery path that never touches non-test volumes.
