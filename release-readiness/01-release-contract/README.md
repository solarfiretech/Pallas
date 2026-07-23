# Task 1: Define the release contract

## Execute

Submit `PROMPT.md` from the repository root. Review the existing documentation and `docker-compose.yml` before accepting changes. Do not alter application or container behavior in this task.

## Expected deliverables

- A clearly identified 0.1.0 release contract in the documentation.
- Supported platforms and Docker/Compose versions.
- Required services, ports, resources, lifecycle, and persistence guarantees.
- Explicit development, release, and example-application boundaries.
- A list of unresolved release decisions, if any.

## Test and verify

- Confirm every named service and port matches `docker-compose.yml`.
- Confirm examples are described as optional.
- Confirm setup commands use Compose v2 syntax.
- Check all local documentation links and commands.
- Ensure `git diff` contains documentation changes only.

Acceptance requires an unambiguous, internally consistent contract that later tests can use as their source of truth.
