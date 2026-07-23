# Prompt: Pin third-party container images

Implement release task 2 for Pallas: replace floating or overly broad third-party container image references with exact, tested versions. Cover OpenPLC Runtime, Node-RED, PostgreSQL, and PGAdmin. Prefer immutable digests where practical for the release configuration, while keeping version information understandable and maintainable. Update `.env.example` and documentation consistently.

Do not change application behavior or introduce unrelated hardening. Exclude example applications from requirements. Validate Compose rendering, pull the selected images when the environment permits, record resolved versions or digests, and identify platform-compatibility limitations. Report exact evidence and any validation blocked by local Docker availability.
