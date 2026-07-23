# Prompt: Produce and validate a release candidate

Implement release task 21 for Pallas without publishing a final release. Produce a fixed release candidate from a specific clean commit using pinned dependencies and recorded image digests. Run every release gate: configuration validation, unit tests, image integration tests, full-stack smoke tests, persistence and recovery tests, upgrade/rollback tests, and security scans. Test every host platform promised by the release contract or explicitly record unavailable evidence as a blocker.

Create a release-candidate evidence report containing commit, versions, digests, commands, results, timings, known limitations, accepted risks, and unresolved blockers. Do not tag or publish final artifacts. Do not use examples as completion requirements.
