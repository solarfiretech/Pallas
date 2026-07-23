# Task 3: Complete the environment-variable contract

## Prerequisites

Tasks 1 and 2 must be complete so supported settings and image versions are stable.

## Execute

Submit `PROMPT.md`, then review every `os.getenv` and `${...}` expression against the resulting environment documentation.

## Expected deliverables

- Complete `.env.example` coverage.
- Documentation of required fields, defaults, types, and ranges.
- Explicit Compose wiring for supported FastAPI settings.
- Startup validation with actionable, secret-safe errors.
- Focused validation tests.

## Test and verify

- Render Compose with a valid environment.
- Test missing required values.
- Test invalid ports, timeouts, depths, and status lists.
- Confirm valid overrides reach the container.
- Confirm errors do not disclose credentials.

Acceptance requires every supported setting to be discoverable, documented, wired, and validated.
