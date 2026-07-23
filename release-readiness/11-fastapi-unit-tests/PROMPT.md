# Prompt: Add FastAPI unit tests

Implement release task 11 for Pallas. Add a maintainable unit-test suite covering expected-status parsing, HTTP probes, PostgreSQL socket probes if still applicable, access-level conversion, NodeId and namespace formatting, OPC UA metadata transformation, API success and failure responses, timeouts, and unreachable dependencies.

Keep unit tests deterministic and independent of Docker, the network, example applications, and a live OPC UA server. Add test dependencies and a documented command without mixing them into the release runtime image unnecessarily. Establish a justified initial coverage threshold and report test and coverage results.
