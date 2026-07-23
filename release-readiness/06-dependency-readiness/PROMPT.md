# Prompt: Add dependency readiness and resilient startup

Implement release task 6 for Pallas. Use the health checks established in task 5 to make dependency startup readiness explicit. Ensure PGAdmin and FastAPI handle PostgreSQL startup appropriately, and ensure services that communicate with OpenPLC tolerate delayed availability. Verify recovery when PostgreSQL and OpenPLC restart after the stack is already running.

Use Compose dependency conditions only where they reflect actual runtime requirements; do not create unnecessary coupling. Keep examples optional. Document startup behavior and failure recovery, add tests or scripts as appropriate, and report timed evidence from cold start, delayed dependency, and restart scenarios.
