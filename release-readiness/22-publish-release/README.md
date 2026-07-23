# Task 22: Tag and publish the release

## Prerequisites

Task 21 must be approved with no blockers. Registry and repository destinations, credentials, signing method, version, and maintainers must be explicitly authorized.

## Execute

Submit `PROMPT.md`. Review and approve the proposed external writes before tagging, pushing, or publishing. This task changes external state and may not be safely reversible.

## Expected deliverables

- Consistent project version and finalized changelog.
- An approved signed or annotated immutable Git tag.
- Published versioned container images.
- Release notes with digests, checksums, limitations, and upgrade guidance.
- Post-publication verification evidence.

## Test and verify

- Confirm the tag points to the approved candidate commit.
- Compare published image digests with candidate digests.
- Install using only published files and images.
- Run the clean full-stack smoke test.
- Confirm mutable tags, if provided, resolve to the same immutable digest.

Acceptance requires published artifacts to exactly match the approved, tested release candidate.
