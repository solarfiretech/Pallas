# Task 21: Produce and validate a release candidate

## Prerequisites

Tasks 1–20 must be complete and CI must be green on a clean commit.

## Execute

Submit `PROMPT.md` only when the worktree is clean. Treat any missing required platform test or blocking security finding as a failed candidate.

## Expected deliverables

- A uniquely identified release-candidate build.
- Recorded source commit, dependency versions, image tags, and digests.
- Complete release-gate evidence.
- Known limitations, accepted risks, and blocker list.
- A completed release checklist except publication steps.

## Test and verify

- Re-run all CI and local release gates from clean state.
- Perform clean installation and upgrade installation tests.
- Verify every supported platform.
- Reproduce artifacts from the recorded commit.
- Confirm generated digests match the candidate report.

Acceptance requires zero unresolved release blockers and reproducible candidate artifacts.
