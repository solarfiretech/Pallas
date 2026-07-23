# Prompt: Add dependency and image security scanning

Implement release task 16 for Pallas. Add reproducible checks for Python dependency vulnerabilities, container image vulnerabilities, committed secrets, Dockerfile and Compose misconfiguration, and license compatibility. Prefer maintained tools with pinned versions and configuration checked into the repository.

Define severity-based release gates and a documented, time-bounded exception process. Exclude example applications from release completion scanning only where the policy explicitly justifies it; still prevent secrets from being committed anywhere. Keep this task focused on scanning rather than broad remediation. Run the checks, summarize findings, and distinguish blockers from accepted risks.
