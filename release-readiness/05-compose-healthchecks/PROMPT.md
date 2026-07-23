# Prompt: Add Compose-native health checks

Implement release task 5 for Pallas. Add reliable Docker Compose health checks for OpenPLC Runtime, Node-RED, PostgreSQL, PGAdmin, and FastAPI. Choose probes that establish useful service readiness without depending on example applications. Configure reasonable intervals, timeouts, retries, and start periods, and document their semantics.

Retain FastAPI's aggregate container-health endpoint but do not use it as a substitute for per-container health. Avoid adding dependency conditions reserved for task 6 unless minimally required to test probes. Test healthy, intentionally unhealthy, and recovery states. Report exact commands and observed transitions.
