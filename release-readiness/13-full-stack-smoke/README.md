# Task 13: Add a full-stack smoke test

## Prerequisites

Container integration tests and all five service health checks must pass.

## Execute

Submit `PROMPT.md` with Docker running. Inspect teardown logic carefully before the first run.

## Expected deliverables

- One-command full-stack smoke harness.
- Bounded wait logic for five healthy services.
- Endpoint, DNS/connectivity, and restart-persistence checks.
- Failure logs and safe cleanup.

## Test and verify

- Run twice consecutively from a clean state.
- Confirm no example asset is loaded.
- Confirm unique project/container/volume names.
- Force startup and endpoint failures and inspect diagnostics.
- Verify no pre-existing Pallas resources are modified.

Acceptance requires two consecutive clean passes with safe teardown.
