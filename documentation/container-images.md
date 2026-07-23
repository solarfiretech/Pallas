# Third-party container images

Pallas 0.1.0 pins every required third-party image to an OCI image-index digest. The version tag keeps the reference understandable, while the digest prevents a registry tag update from changing the release artifact. To upgrade an image, update its tag and digest together in both `docker-compose.yml` and `.env.example`, then repeat the manifest and runtime validation below.

## Release pins

| Service | Selected version | Image-index digest | Linux platforms in the index |
| --- | --- | --- | --- |
| OpenPLC Runtime | Immutable upstream snapshot resolved 2026-07-22 (no semantic version is published for the selected artifact) | `sha256:76bc9e4647f1e9177779156e3668426711e5f12769e9fe140b48c6b35fb4a840` | `amd64`, `arm64`, `arm/v7` |
| Node-RED | `4.1.11-debian` | `sha256:4d46f0a52a65ab45d37c1a785f635286d49d17fe0dbc547ff724beefb8d42ac1` | `amd64`, `arm64`, `arm/v7` |
| PostgreSQL | `16.10-alpine` (manifest identifies Alpine 3.22) | `sha256:029660641a0cfc575b14f336ba448fb8a75fd595d42e1fa316b9fb4378742297` | `amd64`, `arm/v6`, `arm/v7`, `arm64/v8`, `386`, `ppc64le`, `riscv64`, `s390x` |
| PGAdmin | `9.6.0` | `sha256:2c7d73e13bd6c30b1d53e4c25d0d6d81adbd0799c4f4d6a09efc5d68fca5d16d` | `amd64`, `arm64` |

The release support contract remains narrower than the images' published platform lists: Pallas 0.1.0 supports Linux containers on `linux/amd64` only. The common digest nevertheless preserves registry selection on every platform in an image index. `unknown/unknown` entries reported by registry tooling are supply-chain attestations, not runnable platforms.

OpenPLC is the exception to version-tag readability: its publisher exposed the selected artifact without a semantic release tag. The release reference therefore omits the floating tag entirely; the resolution date documents the selected snapshot and the digest supplies its exact immutable identity.

## Verification record

On 2026-07-22, `docker buildx imagetools inspect` resolved each tag to the digest and platform list above from its authoritative registry (Docker Hub for Node-RED, PostgreSQL, and PGAdmin; GitHub Container Registry for OpenPLC). `docker compose config --quiet` rendered successfully with these defaults.

To revalidate a proposed update:

```console
docker compose config --quiet
docker compose config --images
docker buildx imagetools inspect <tag>
docker compose pull openplc-runtime node-red postgres pgadmin
docker compose up -d openplc-runtime node-red postgres pgadmin
```

The last two commands require a running Linux-container Docker daemon. Manifest inspection proves registry resolution and advertised architectures; it does not replace a pull and startup test on each release-supported host platform.
