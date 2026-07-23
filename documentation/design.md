# Pallas Design Documentation

## Overview
Pallas is a development environment for experimenting with industrial automation workflows using OpenPLC Runtime v4, Node-RED, PostgreSQL, PGAdmin, and a FastAPI service for custom web applications.

The normative version 0.1.0 support and acceptance boundary is defined in [release-contract.md](release-contract.md). This design document describes architecture; it does not expand that release contract.

## Architecture
- OpenPLC Runtime v4 hosts the runtime environment.
- Node-RED provides low-code workflow automation and integrations.
- PostgreSQL stores application and workflow data.
- PGAdmin provides a browser-based interface for database administration.
- FastAPI exposes a lightweight API layer for custom web applications.

All services run in a single Docker Compose project and share one bridge network (`pallas-network`).

## Runtime Topology
- Service-to-service communication uses Docker service names on the internal network.
- OpenPLC OPC UA endpoint inside the stack: `opc.tcp://openplc-runtime:4840/openplc/opcua`.
- Host browser access uses mapped ports from `.env`.

## Persistence Model
- `openplc_runtime_data`: OpenPLC runtime state.
- `openplc_runtime_workdir`: loaded OpenPLC project and build state.
- `node_red_data`: Node-RED flows and installed palette packages.
- `postgres_data`: PostgreSQL database files.
- `pgadmin_data`: PGAdmin configuration and saved connections.

Named volumes are used to keep local state between container restarts.

## Directory Structure
- docker-compose.yml: central compose stack configuration.
- .env.example: environment template for the stack.
- services/fastapi: FastAPI application and container definition.
- documentation/: design and operations documentation.
- Examples/: sample OpenPLC project and Node-RED flow assets.
- workspace/: PowerShell helper scripts for OPC UA node browsing and read/write testing.

## Data Flow (Reference)
1. OpenPLC publishes runtime variables through OPC UA.
2. Node-RED reads/writes those variables for HMI and control logic.
3. FastAPI provides a web API surface for custom workflows and can be extended to consume OPC UA or PostgreSQL data.
4. PostgreSQL persists application data used by API or automation workflows.
5. PGAdmin is used for local DB inspection and administration.

The contents of `Examples/` illustrate this reference flow but are optional and excluded from core release completion requirements.

## Scaling Guidance
- Add new services to the compose stack by introducing a new section in docker-compose.yml.
- Keep service-specific code under services/<name>/.
- Store environment values in .env and copy from .env.example.
- Prefer named volumes for persistent data.
- Keep endpoint and service-name assumptions documented whenever network topology changes.
