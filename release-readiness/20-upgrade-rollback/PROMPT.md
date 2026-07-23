# Prompt: Define and test upgrade and rollback

Implement release task 20 for Pallas. Define a supported upgrade and rollback procedure that preserves named-volume data. Include pre-upgrade backup, image acquisition, configuration changes, health verification, rollback of container versions, restoration when data is incompatible, and explicit identification of irreversible changes.

Create an isolated, repeatable test from a recorded baseline to the candidate configuration and back. Do not use example applications as migration fixtures. Never target developer volumes. Automate safe portions, add target validation to destructive operations, and report data checks before upgrade, after upgrade, and after rollback.
