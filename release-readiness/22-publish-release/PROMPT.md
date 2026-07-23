# Prompt: Tag and publish the release

Implement release task 22 for Pallas only after confirming that task 21 produced an approved release candidate with no blockers. Before any external write, present the exact source commit, version, tag, image names, registries, release notes, and publication plan for confirmation. Then set project and FastAPI versions consistently, finalize the changelog, create the approved signed or annotated tag, publish immutable versioned images, and publish release notes with digests, checksums, limitations, and upgrade instructions.

Verify published artifacts by installing exclusively from the published release and running the clean full-stack smoke test. Never rewrite an existing tag or mutable release artifact. Do not publish examples as required runtime artifacts. Report URLs, digests, verification results, and any partial publication requiring recovery.
