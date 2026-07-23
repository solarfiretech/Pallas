# Task 14: Test persistence, backup, restore, and destructive operations

## Prerequisite

The full-stack smoke test must pass reliably.

## Execute

Submit `PROMPT.md`. Back up any relevant developer data before reviewing destructive test paths.

## Expected deliverables

- A volume inventory and data ownership map.
- Safe backup and restore instructions or tooling.
- Persistence tests for all five volumes.
- Prominent warnings for destructive commands.

## Test and verify

- Write uniquely identifiable non-example state to every service.
- Restart containers and the full stack.
- Back up, remove only isolated test volumes, restore, and verify state.
- Confirm scripts reject broad or unresolved targets.
- Confirm documentation distinguishes stop, reset, and deletion.

Acceptance requires verified persistence and recoverability for every declared volume.
