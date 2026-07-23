# Prompt: Add continuous integration

Implement release task 17 for Pallas. Add CI that validates documentation and Compose configuration, runs FastAPI linting and unit tests, builds the release image, runs container integration tests, runs the full-stack smoke test, and performs the security scans established in task 16. Use pinned CI actions and tool versions, appropriate permissions, caching that cannot conceal failures, and useful diagnostics.

Keep examples outside release completion gates unless a repository-wide security check applies. Ensure jobs clean up containers and volumes. Document required runner capabilities and one local equivalent for each job. Validate controlled failures and report CI structure, permissions, and test evidence.
