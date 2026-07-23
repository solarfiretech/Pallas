# Prompt: Add container-level integration tests

Implement release task 12 for Pallas. Add automated integration tests for the built FastAPI release image and only the dependencies necessary to validate its container contract. Verify image build, non-root startup, immutable code, configured environment overrides, required endpoints, health behavior, and graceful shutdown.

Use an isolated Compose project or equivalent harness. Do not rely on example assets or mutate developer volumes. Capture useful diagnostics on failure and guarantee cleanup. Provide one documented command and report results from a clean build.
