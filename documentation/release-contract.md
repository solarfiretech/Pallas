# Pallas 0.1.0 Release Contract

## Purpose and status

This document defines the behavior that a Pallas 0.1.0 release must provide. It is the source of truth for release-readiness tests and acceptance. The current development branch does not yet satisfy every requirement in this contract; unresolved decisions and known gaps are listed below.

Pallas 0.1.0 is a single-host Docker Compose development environment for industrial automation and web workflow development. It is not a production control system, high-availability service, safety system, or hardened deployment for an untrusted network.

## Supported environment

The 0.1.0 release targets Linux containers on an x86-64 host in either of these environments:

- A current 64-bit Linux distribution with Docker Engine 24 or newer and Docker Compose 2.20 or newer.
- Windows 11 with a supported Docker Desktop release using the WSL 2 Linux-container backend and Docker Compose 2.20 or newer.

Native Windows containers, ARM hosts, Kubernetes, Docker Swarm, Podman Compose, macOS, and remote multi-host deployment are not part of the 0.1.0 support contract unless they are added after release-candidate testing.

The initial minimum host allocation is:

- 2 x86-64 CPU cores.
- 4 GB RAM available to Docker.
- 10 GB free disk space, plus capacity for persistent application data and container images.

The recommended development allocation is 4 CPU cores and 8 GB RAM. These resource figures are provisional until release-candidate testing records measured startup and steady-state use.

## Required services

All five services below are required in the default Compose project:

| Compose service | Role | Default host port | Container port |
| --- | --- | ---: | ---: |
| `openplc-runtime` | OpenPLC Runtime v4 | 8443 | 8443 |
| `node-red` | Workflow editor and runtime | 1880 | 1880 |
| `postgres` | Application and workflow database | 5432 | 5432 |
| `pgadmin` | Browser-based PostgreSQL administration | 5050 | 80 |
| `fastapi` | Pallas API and stack health surface | 8000 | 8000 |

Host ports may be changed through `.env`. Within the `pallas-network` bridge network, services communicate using their Compose service names and container ports.

OpenPLC OPC UA is supported inside the Compose network at `opc.tcp://openplc-runtime:4840/openplc/opcua`. Host access at `opc.tcp://localhost:4840/openplc/opcua` is not currently supplied by `docker-compose.yml` and is therefore not part of the implemented 0.1.0 contract until the unresolved port decision is completed.

## Required user-visible behavior

From a configured repository checkout, this command must create or update and start the complete stack:

```bash
docker compose up --build -d
```

The release must provide these user-facing surfaces on their configured host ports:

- OpenPLC Runtime interface.
- Node-RED editor.
- PGAdmin interface.
- FastAPI root, health, aggregate container-health, OpenAPI documentation, and OPC UA variable-poll endpoints.
- PostgreSQL client connectivity when its host port is enabled by the release configuration.

Node-RED dashboards, PLC programs, prebuilt flows, and application-specific database content are not supplied by the core release contract.

## Lifecycle contract

- A normal start uses `docker compose up --build -d`.
- `docker compose ps` must show all five required services after startup.
- Startup may be asynchronous; release acceptance will define and test a bounded readiness period after per-service health checks are implemented.
- A normal stop uses `docker compose down` and must preserve all named-volume data.
- Container or Docker-host restart must restart services according to `restart: unless-stopped` and retain named-volume data.
- `docker compose down -v` or `docker compose down --volumes` is an intentional destructive reset and removes Compose-managed persistent data. It is not an ordinary shutdown command.
- The release must document log inspection with `docker compose logs` and service-specific recovery procedures.

Automatic recovery guarantees, health-based dependency ordering, maximum startup duration, and graceful-shutdown timing remain release-readiness work and are not yet verified.

## Persistence contract

The following Compose named volumes must survive container replacement, service restart, normal stack shutdown, and subsequent stack startup:

| Volume | Persistent content |
| --- | --- |
| `openplc_runtime_data` | OpenPLC runtime API state and credentials at `/var/run/runtime` |
| `openplc_runtime_workdir` | Loaded PLC project and build state at `/workdir` |
| `node_red_data` | Node-RED flows, settings, and installed palette data at `/data` |
| `postgres_data` | PostgreSQL database files at `/var/lib/postgresql/data` |
| `pgadmin_data` | PGAdmin configuration and saved connections at `/var/lib/pgadmin` |

FastAPI has no persistent volume in 0.1.0. Persistence does not constitute a backup. Backup, restore, upgrade compatibility, and rollback guarantees must be established and tested before release.

## Development and release boundaries

The repository currently provides a development-oriented Compose configuration. Its FastAPI source bind mount remains release-readiness work. Compose-native health checks now cover every required service as documented in `compose-healthchecks.md`; later tasks will define health-based dependency behavior and additional release acceptance. Required third-party images are pinned to immutable digests as documented in `container-images.md`.

The 0.1.0 release contract covers:

- One local Compose project on one supported host.
- Startup, shutdown, service access, internal networking, and named-volume persistence.
- The API and OPC UA inspection capabilities documented in the repository.
- Documentation and automated verification needed to reproduce the release.

The contract does not cover:

- Production, safety-critical, real-time, high-availability, or multi-host operation.
- Internet-facing operation or operation on an untrusted LAN.
- Automated PLC control logic, HMI behavior, or business workflows.
- Kubernetes, Swarm, or other orchestrators.
- Managed database deployment or disaster-recovery service levels.

## Optional examples and tools

Everything under `Examples/` is optional tutorial material. Example PLC projects, generated OpenPLC files, Node-RED flows, dashboards, and example-specific palette packages are excluded from release completion and acceptance tests.

The PowerShell scripts under `workspace/` are development aids. They may support manual OPC UA exploration, but the core stack must install, start, report health, and pass release acceptance without running them.

## Release acceptance boundary

A 0.1.0 release is acceptable only when the required services and behavior in this contract are reproducibly validated from a clean checkout using pinned artifacts. Unit, container-integration, full-stack smoke, persistence, security, upgrade, and rollback gates will be defined by subsequent release-readiness tasks. Optional examples must not be prerequisites for any release gate.

## Unresolved decisions and current gaps

The following items must be resolved or explicitly accepted before the release candidate:

1. Decide whether host OPC UA access on port 4840 is supported and either publish it or remove the host endpoint claim from user documentation.
2. Validate or revise the provisional CPU, memory, disk, Docker, Compose, and host-platform support matrix using release-candidate tests.
3. Decide whether PostgreSQL host port 5432 and PGAdmin are enabled by default in the release or moved behind local-development configuration or profiles.
4. Define per-service health checks, readiness deadlines, dependency behavior, and recovery guarantees.
5. Replace the documented example credential placeholders with a hardened credential workflow.
6. Separate development source mounts from the immutable release configuration.
7. Decide whether PostgreSQL is an actual FastAPI runtime dependency; the API currently receives `DATABASE_URL` but does not perform database work.
8. Define backup, restore, upgrade, rollback, security scanning, supported-version, and release-publication policies.
9. Validate all promised behavior on every supported host platform.
