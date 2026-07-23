# Prompt: Test persistence, backup, restore, and destructive operations

Implement release task 14 for Pallas. Define and automate verification for each named volume: OpenPLC runtime data, OpenPLC work directory, Node-RED data, PostgreSQL data, and PGAdmin data. Document contents, persistence guarantees, backup, restore, and the destructive effect of volume-removal commands.

Use non-example test state and isolated resources. Add safe scripts or procedures that refuse ambiguous targets. Demonstrate state survival across container and stack restarts, then perform backup and restore verification. Do not claim application-level consistency beyond what is tested. Report evidence and limitations.
