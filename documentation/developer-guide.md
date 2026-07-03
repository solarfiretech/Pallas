# Developer Guide

## Local Workflow
1. Copy .env.example to .env and adjust secrets.
2. Start the stack with docker compose up --build -d.
3. Use the service URLs listed in the README.
4. Make changes in the relevant service folder.

## Adding a New Service
1. Create a new directory under services/.
2. Add a Dockerfile and any required app files.
3. Add a service block to docker-compose.yml.
4. Update .env.example with any new environment variables.
5. Document the service in this folder.

## Troubleshooting
- If a container fails to start, run docker compose logs <service-name>.
- If the FastAPI container cannot connect to PostgreSQL, confirm that the database service is healthy and that .env contains valid credentials.
- To reset local data, run docker compose down -v.
