# Task 8: Harden the FastAPI container

## Prerequisite

Task 7 must provide the release image workflow.

## Execute

Submit `PROMPT.md` with Docker running. Test the image itself as well as its Compose service.

## Expected deliverables

- Non-root runtime user.
- Minimal deterministic image contents.
- OCI image metadata.
- Graceful stop behavior.
- Read-only filesystem support or a documented exception.

## Test and verify

- Inspect the effective UID and image labels.
- Start the API and confirm all required endpoints.
- Send a normal container stop and confirm graceful exit.
- Attempt writes outside approved temporary locations.
- Scan image contents and size for obvious build artifacts.

Acceptance requires a functional non-root image with documented and verified runtime restrictions.
