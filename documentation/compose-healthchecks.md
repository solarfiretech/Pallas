# Compose health checks

Every required Pallas service has its own Docker health check. These checks are
container-local: they establish that the service in that container is ready to
accept its basic class of work, without requiring an example PLC project,
Node-RED flow, or another container to be healthy.

| Service | Probe | Ready means | Start period |
| --- | --- | --- | --- |
| OpenPLC Runtime | HTTPS `GET /api/status` with `curl`, requiring status `401` | The runtime's protected status API is accepting requests on port 8443 and correctly requires authentication. Requiring this specific response is stronger than accepting the root route's generic `404`, and avoids placing runtime credentials in the probe. TLS verification is disabled only for this loopback probe because the runtime supplies its own local certificate. It does not require a loaded PLC application or assert OPC UA project state. | 60 seconds |
| Node-RED | HTTP `GET /` with `curl --fail` | The Node-RED editor/runtime HTTP server returns a successful response on port 1880. No flow or dashboard is required. | 30 seconds |
| PostgreSQL | `pg_isready` for the configured user and database | PostgreSQL is accepting connections on its local socket/TCP listener. `pg_isready` does not authenticate or run a query, so this is server readiness rather than credential or schema validation. | 30 seconds |
| PGAdmin | HTTP `GET /misc/ping` with `wget --spider` | PGAdmin's process and HTTP server report ready through its purpose-built ping route. A PostgreSQL connection is not required. | 60 seconds |
| FastAPI | Python HTTP request to `GET /health`, requiring HTTP 200 and exactly `{"status":"ok"}` | Uvicorn is serving the Pallas API and its local liveness response has the expected contract. This deliberately does not call `/health/containers`, so another service cannot make the FastAPI container unhealthy. | 20 seconds |

All checks run every 10 seconds, have a 5-second timeout, and require five
consecutive failures after the start period before Docker marks a container
`unhealthy`. A successful probe immediately changes an unhealthy container back
to `healthy`. Failures during `start_period` do not consume the five-retry
failure budget. The maximum detection time after startup grace is therefore
approximately 45 to 55 seconds, depending on where the failure falls relative
to the probe schedule; recovery is normally detected within 10 seconds.

The FastAPI aggregate endpoint at `/health/containers` remains available for an
operator's cross-service view. It is not used by any Compose health check and is
not a replacement for the five per-container checks.

Health checks do not impose startup ordering. Health-based dependency
conditions are intentionally deferred to release-readiness task 6.

## Inspecting health

Validate and start the stack, then wait for all containers:

```powershell
docker compose config --quiet
docker compose up --build --detach
docker compose ps
docker inspect --format '{{.State.Health.Status}}' pallas-fastapi
```

For probe output and recent transitions:

```powershell
docker inspect --format '{{json .State.Health}}' pallas-fastapi
```

The same inspection command works with each `pallas-*` container name. Docker
records probe exit codes and output in `.State.Health.Log`.
