# Task 17: Add continuous integration

## Prerequisites

Tasks 11–16 must provide stable commands and release gates.

## Execute

Submit `PROMPT.md`. Review workflow permissions and third-party actions before enabling CI.

## Expected deliverables

- CI jobs for configuration, tests, builds, smoke tests, and security.
- Pinned actions and least-privilege permissions.
- Safe Docker cleanup and retained failure diagnostics.
- Documented local equivalents.

## Test and verify

- Run all local equivalents.
- Trigger CI on a branch or pull request.
- Introduce a controlled failure in each major job.
- Confirm prohibited security findings block CI.
- Confirm isolated containers and volumes are cleaned up.

Acceptance requires every release gate to run automatically and block merges on failure.
