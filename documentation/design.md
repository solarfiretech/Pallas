# Pallas Design Documentation

## Overview
Pallas is a development environment for experimenting with industrial automation workflows using OpenPLC Runtime v4, Node-RED, PostgreSQL, PGAdmin, and a FastAPI service for custom web applications.

## Architecture
- OpenPLC Runtime v4 hosts the runtime environment.
- Node-RED provides low-code workflow automation and integrations.
- PostgreSQL stores application and workflow data.
- PGAdmin provides a browser-based interface for database administration.
- FastAPI exposes a lightweight API layer for custom web applications.

## Directory Structure
- docker-compose.yml: central compose stack configuration.
- .env.example: environment template for the stack.
- services/fastapi: FastAPI application and container definition.
- documentation/: design and operations documentation.

## Scaling Guidance
- Add new services to the compose stack by introducing a new section in docker-compose.yml.
- Keep service-specific code under services/<name>/.
- Store environment values in .env and copy from .env.example.
- Prefer named volumes for persistent data.
