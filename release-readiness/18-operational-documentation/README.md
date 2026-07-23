# Task 18: Reconcile operational documentation

## Prerequisite

Runtime behavior, tests, security gates, and CI must be stable enough to document accurately.

## Execute

Submit `PROMPT.md`, then perform a clean-checkout walkthrough using only the resulting documentation.

## Expected deliverables

- Consistent setup, operation, health, persistence, and recovery guidance.
- Complete environment reference.
- Separate development and release workflows.
- Clear optional-example boundary.
- No stale service, port, volume, or command references.

## Test and verify

- Check all internal links.
- Execute every non-destructive command.
- Perform a clean release startup from documentation alone.
- Compare docs with resolved Compose configuration and API schemas.
- Search for obsolete image tags, credentials, and endpoint behavior.

Acceptance requires a new user to operate the tested release without undocumented knowledge.
