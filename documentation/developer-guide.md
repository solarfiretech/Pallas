# Developer Guide

## Local Workflow
1. Copy .env.example to .env and adjust secrets.
2. Start the stack with docker compose up --build -d.
3. Use the service URLs listed in the README.
4. Make changes in the relevant service folder.

Recommended day-to-day command set:

- Check status: `docker compose ps`
- Tail logs: `docker compose logs -f <service-name>`
- Rebuild one service: `docker compose up -d --build <service-name>`
- Restart one service: `docker compose restart <service-name>`

## Adding a New Service
1. Create a new directory under services/.
2. Add a Dockerfile and any required app files.
3. Add a service block to docker-compose.yml.
4. Update .env.example with any new environment variables.
5. Document the service in this folder.

## OPC UA Development Workflow

The repository includes helper scripts in `workspace/` for OpenPLC OPC UA development:

1. Browse/export nodes with `./workspace/findscript.ps1`.
2. Probe candidate NodeIds with `./workspace/browser.ps1`.
3. Validate read/write behavior with `./workspace/writescript.ps1`.

Endpoint reference:

- Host tools: `opc.tcp://localhost:4840/openplc/opcua`
- In-stack services (Node-RED/FastAPI): `opc.tcp://openplc-runtime:4840/openplc/opcua`

## Troubleshooting
- If a container fails to start, run docker compose logs <service-name>.
- If the FastAPI container cannot connect to PostgreSQL, confirm that the database service is healthy and that .env contains valid credentials.
- To reset local data, run docker compose down -v.
- If Node-RED OPC UA flows or helper scripts fail due to missing nodes/modules, install the tutorial palette packages in Node-RED and redeploy.
- If OPC UA writes fail, confirm the target variable has write permissions (`rw`) in the OpenPLC server configuration.

## Documentation Maintenance

Update docs when any of the following changes:

- Service names, ports, or compose networking.
- OPC UA endpoint path or security mode.
- Example asset locations under `Examples/`.
- Environment variables in `.env.example`.
