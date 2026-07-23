# Task 4: Remove insecure release credential defaults

## Prerequisite

Task 3's environment contract must be complete.

## Execute

Submit `PROMPT.md`. Use newly generated disposable credentials during testing, never personal credentials.

## Expected deliverables

- No functional default database or PGAdmin password.
- Safe placeholders in `.env.example`.
- Clear failure behavior for absent secrets.
- Secret-generation and storage guidance.
- Checks preventing accidental secret inclusion where practical.

## Test and verify

- Confirm configuration fails clearly without required secrets.
- Start successfully with generated test secrets.
- Search tracked files and logs for the test values.
- Confirm `.env` is ignored and remains untracked.
- Inspect API responses and Compose output for disclosure.

Acceptance requires explicit secrets for release startup and no observed leakage.
