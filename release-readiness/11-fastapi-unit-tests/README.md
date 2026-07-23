# Task 11: Add FastAPI unit tests

## Prerequisite

The API and dependency contracts from tasks 9 and 10 must be stable.

## Execute

Submit `PROMPT.md` in a clean development environment.

## Expected deliverables

- Deterministic unit tests for core helpers and endpoints.
- Separate development/test dependencies.
- A documented one-command test workflow.
- Coverage configuration and threshold.

## Test and verify

- Run the suite twice from a clean environment.
- Run with network and Docker unavailable.
- Review coverage for meaningful branch coverage, not only line count.
- Introduce a controlled assertion failure and confirm a nonzero exit.
- Confirm test packages are absent from the release image unless required.

Acceptance requires repeatable tests meeting the documented coverage gate.
