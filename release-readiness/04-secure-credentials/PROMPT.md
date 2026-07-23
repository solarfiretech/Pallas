# Prompt: Remove insecure release credential defaults

Implement release task 4 for Pallas. Remove working fallback credentials such as `change-me` from release operation and require explicit PostgreSQL and PGAdmin secrets. Keep `.env.example` safe and useful with nonfunctional placeholders. Add a documented local secret-generation workflow and explain when a managed secret store should be used.

Ensure secrets are not committed, rendered into public artifacts, returned by APIs, or exposed in routine logs. Preserve a convenient local setup without weakening release behavior. Do not implement broader network hardening from task 15. Add automated checks where appropriate and report verification evidence.
