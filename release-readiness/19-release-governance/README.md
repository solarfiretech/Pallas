# Task 19: Add release governance files

## Prerequisite

The release contract, dependency inventory, and operational documentation must be current.

## Execute

Submit `PROMPT.md`. Maintainers must review contact, support, disclosure, and licensing statements.

## Expected deliverables

- `CHANGELOG.md`, `SECURITY.md`, and `CONTRIBUTING.md` or justified equivalents.
- Versioning and support policies.
- A concrete release checklist.
- Required third-party attribution.
- Explicit placeholders for decisions only maintainers can make.

## Test and verify

- Validate all links and commands.
- Compare supported versions with the release contract.
- Compare notices with image and Python dependency licenses.
- Confirm the security process contains a real approved contact path before release.
- Walk through the release checklist against current CI gates.

Acceptance requires accurate, maintainable governance with no fabricated commitments.
