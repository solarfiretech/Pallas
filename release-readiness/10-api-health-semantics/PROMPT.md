# Prompt: Harden health and readiness API behavior

Implement release task 10 for Pallas. Separate liveness from readiness semantics, define stable response schemas and HTTP status behavior, validate all health configuration at startup, and make degraded and timeout behavior explicit. Replace broad or misleading probes—especially treating OpenPLC HTTP 404 as healthy—unless repository evidence proves they are the correct readiness signal.

Do not disable TLS verification by default in release mode; make any local-development exception explicit and configurable. Preserve Compose health behavior and avoid example dependencies. Add focused tests for healthy, degraded, unreachable, timeout, malformed configuration, and TLS cases. Document the API contract and report results.
