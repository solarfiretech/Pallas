# Prompt: Harden the FastAPI container

Implement release task 8 for Pallas. Harden the FastAPI image by running as a non-root user, minimizing installed and copied content, supporting graceful shutdown, and adding useful OCI metadata such as version, source revision, and license. Evaluate a read-only root filesystem and explicitly configured temporary writable locations. Preserve health checks and immutable release behavior.

Do not introduce unrelated API changes. Add image-focused tests or inspection commands. Verify effective UID, signals, filesystem permissions, metadata, installed content, startup, health, and shutdown. Document any hardening measure that cannot be enabled and explain why.
