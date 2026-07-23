# Pallas Release-Readiness Task Pack

This directory contains the ordered implementation prompts for preparing Pallas for a release. Example applications are explicitly outside the release requirements.

## How to use this pack

1. Work through the numbered directories in order.
2. Open the task's `README.md` and satisfy its prerequisites.
3. Submit the contents of `PROMPT.md` as a standalone implementation request.
4. Review the changes and run every verification listed in the task README.
5. Commit the verified task before starting the next task.

Each prompt instructs the implementer to inspect the current repository state, preserve unrelated changes, implement only that task, test it, and report evidence. Later prompts must respect decisions and artifacts established by earlier tasks.

## Ordered tasks

1. Define the release contract
2. Pin third-party container images
3. Complete the environment-variable contract
4. Remove insecure credential defaults
5. Add Compose-native health checks
6. Add dependency readiness and resilient startup
7. Separate development and release Compose configurations
8. Harden the FastAPI container
9. Clarify FastAPI's PostgreSQL responsibility
10. Harden health and readiness API behavior
11. Add FastAPI unit tests
12. Add container-level integration tests
13. Add a full-stack smoke test
14. Test persistence, backup, restore, and destructive operations
15. Harden network and host exposure
16. Add dependency and image security scanning
17. Add continuous integration
18. Reconcile operational documentation
19. Add release governance files
20. Define and test upgrade and rollback
21. Produce and validate a release candidate
22. Tag and publish the release

Do not execute task 22 until the release candidate from task 21 has passed all release gates.
