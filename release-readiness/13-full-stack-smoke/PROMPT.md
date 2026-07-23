# Prompt: Add a full-stack smoke test

Implement release task 13 for Pallas. Create an automated smoke test that validates Compose configuration, builds or pulls all release images, starts the complete five-service stack, waits for health, verifies documented endpoints and inter-container connectivity, confirms basic volume persistence across restart, captures diagnostics on failure, and tears down safely.

The harness must use an isolated Compose project name and must never remove a developer's existing containers or volumes. Do not load or require example applications. Provide a single command suitable for local execution and later CI use. Run it twice consecutively and report timings and evidence.
