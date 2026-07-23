# Prompt: Separate development and release Compose configurations

Implement release task 7 for Pallas. Make the base Compose configuration release-capable and immutable, especially by removing the FastAPI source bind mount from release operation. Put live source mounts and other developer conveniences in a clearly named development override. Define unambiguous commands for release and development startup, and assign explicit version tags to project-built images.

Preserve persistent data behavior and all health/readiness work from earlier tasks. Do not add production orchestration beyond the documented release contract. Test both modes and demonstrate that source edits do not mutate an already built release container while development iteration still works.
