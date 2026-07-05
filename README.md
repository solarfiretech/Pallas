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

## Useful Commands

- View running containers:
  - docker compose ps
- View logs:
  - docker compose logs -f
- Stop the stack:
  - docker compose down
- Stop and remove volumes:
  - docker compose down -v

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

