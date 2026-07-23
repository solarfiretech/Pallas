# Prompt: Complete the environment-variable contract

Implement release task 3 for Pallas. Inventory every environment variable read by Compose and FastAPI, define which values are required or optional, expose supported settings in `.env.example`, and document defaults and valid ranges. Include OPC UA endpoint, namespace, browse root, maximum depth, timeout, service health targets and statuses, PostgreSQL health target, ports, image versions, and time zone.

Add clear startup validation for malformed numeric values and missing values that are required by the current release contract. Do not perform credential-hardening work reserved for task 4 beyond what is necessary to describe required fields. Add focused tests for validation behavior. Keep examples optional. Report changes and test evidence.
