# Pallas

Pallas is a Docker Compose-based development environment for building and testing automation and web application workflows. The stack includes:

- OpenPLC Runtime v4
- Node-RED
- PostgreSQL
- PGAdmin
- FastAPI for custom web applications

## Project Structure

- docker-compose.yml: defines the complete stack
- .env.example: environment variable template
- services/fastapi/: FastAPI application and container definition
- documentation/: design and developer documentation
- Examples/: sample OpenPLC and Node-RED assets
- workspace/: PowerShell helper scripts for OPC UA discovery and write tests

## Prerequisites

Before you start, ensure you have the following installed:

- Docker Engine
- Docker Compose v2

## Configuration

1. Copy the example environment file:
   - Windows PowerShell:
     - Copy-Item .env.example .env
   - Bash:
     - cp .env.example .env
2. Open .env and update any secrets or ports as needed.
   - Set a strong PostgreSQL password.
   - Update PGAdmin credentials.

## Build and Run

From the project root, run:

```bash
docker compose up --build -d
```

This builds the FastAPI image and starts the complete stack in the background, including OpenPLC Runtime.

## Quick Verify

After startup, run:

```bash
docker compose ps
```

Then verify these URLs:

- OpenPLC Runtime UI: http://localhost:8443
- Node-RED editor: http://localhost:1880
- Node-RED dashboard (if a dashboard flow is deployed): http://localhost:1880/ui
- PGAdmin: http://localhost:5050
- FastAPI root endpoint: http://localhost:8000/
- FastAPI health endpoint: http://localhost:8000/health

## Clean rebuild

To clean up after the most recent build and start fresh:

```bash
docker compose down --volumes --remove-orphans
docker compose up --build -d
```

If you want to also remove unused images and networks, run:

```bash
docker system prune -af
```

## Service Access

- OpenPLC Runtime: http://localhost:8443
- Node-RED: http://localhost:1880
- PGAdmin: http://localhost:5050
- FastAPI: http://localhost:8000
- FastAPI health endpoint: http://localhost:8000/health

For OPC UA clients:

- From host machine tools: opc.tcp://localhost:4840/openplc/opcua
- From containers in this stack (Node-RED/FastAPI): opc.tcp://openplc-runtime:4840/openplc/opcua

## Useful Commands

- View running containers:
  - docker compose ps
- View logs:
  - docker compose logs -f
- Stop the stack:
  - docker compose down
- Stop and remove volumes:
  - docker compose down -v

## Examples

- Node-RED tutorial and sample flow: Examples/NodeRED/Pallas/README.md
- OpenPLC Editor tutorial and sample project: Examples/OpenPLCEditor/Pallas/README.md

## OPC UA Helper Scripts

The workspace folder includes helper scripts for working with OpenPLC OPC UA variables from inside the Node-RED container:

- workspace/findscript.ps1: browse the OPC UA address space and export NodeIds to openplc-opcua-nodeids.csv
- workspace/writescript.ps1: read/write test for one OPC UA node
- workspace/browser.ps1: probe candidate NodeIds for quick validation

Run them from the repository root in PowerShell, for example:

```powershell
.\workspace\findscript.ps1
.\workspace\browser.ps1
.\workspace\writescript.ps1
```

If a script fails with module errors, install Node-RED palette dependencies from the Node-RED UI first (see Examples/NodeRED/Pallas/README.md), then redeploy.

## Database Access

- PostgreSQL host: localhost
- Port: 5432
- Database: pallas
- Username: pallas
- Password: the value in .env

Use PGAdmin to connect to the PostgreSQL server using the host name postgres or localhost and the credentials above.

## Development Notes

- Keep service-specific code under services/<service-name>/.
- Use .env for environment-specific values and avoid hard-coding secrets.
- Add design or operational documentation to documentation/.

## Documentation

See documentation/design.md for the initial architecture and scaling guidance.

