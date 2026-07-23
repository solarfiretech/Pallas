# Prompt: Harden network and host exposure

Implement release task 15 for Pallas. Review every published port against the release contract and reduce host exposure to the minimum useful default. Keep database and administrative access internal or loopback-bound where appropriate, consider a documented optional profile for PGAdmin, and document authentication expectations for OpenPLC and Node-RED.

Preserve service-to-service connectivity through the Compose network. Do not claim the stack is safe on untrusted networks unless that is verified. Keep development access available through explicit overrides when needed. Test published ports from the host and internal connectivity from containers; report the exposure matrix before and after.
