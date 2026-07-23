# Task 9: Clarify FastAPI's PostgreSQL responsibility

## Prerequisite

The release contract and resilient startup behavior must be established.

## Execute

Submit `PROMPT.md`. Require a written rationale before accepting either implementation path.

## Expected deliverables

- An explicit PostgreSQL responsibility decision.
- No unused runtime dependency or falsely documented integration.
- Consistent Compose, dependencies, API behavior, tests, and docs.

## Test and verify

- Test FastAPI with PostgreSQL healthy.
- Test FastAPI with PostgreSQL absent or unreachable.
- Confirm startup/readiness matches the chosen contract.
- Confirm dependency manifests contain only required libraries.
- Confirm design documentation reflects actual behavior.

Acceptance requires implementation and documentation to agree on whether PostgreSQL is required.
