# Task 5 verification results

Verified on 2026-07-22 with Docker Engine 29.6.2 and Docker Compose 5.3.1.
The repository's default host port 8443 was already occupied during the test,
so the stack was started with temporary host-port overrides. Health probes use
container-local ports and were unchanged by these overrides.

## Commands

The local secret generator declined to overwrite the existing `.env`, so
Git-ignored disposable secret files were used through
`POSTGRES_PASSWORD_FILE` and `PGADMIN_DEFAULT_PASSWORD_FILE` for this run.

```powershell
$env:POSTGRES_PASSWORD_FILE = (Resolve-Path '.secrets/postgres_password').Path
$env:PGADMIN_DEFAULT_PASSWORD_FILE = (Resolve-Path '.secrets/pgadmin_password').Path
$env:OPENPLC_RUNTIME_PORT = '28443'
$env:NODE_RED_PORT = '21880'
$env:POSTGRES_PORT = '25432'
$env:PGADMIN_PORT = '25050'
$env:FASTAPI_PORT = '28000'

docker compose config --quiet
docker compose up --build --detach
docker inspect --format '{{.Name}} health={{.State.Health.Status}} failingStreak={{.State.Health.FailingStreak}}' pallas-openplc-runtime pallas-node-red pallas-postgres pallas-pgadmin pallas-fastapi
```

All five containers transitioned from `starting` to `healthy`. The initial
inspection showed PostgreSQL and FastAPI healthy while OpenPLC, Node-RED, and
PGAdmin were still in their startup grace periods. The final healthy inspection
reported `healthy` and `failingStreak=0` for every container.

Probe availability in the pinned images was confirmed with:

```powershell
docker exec pallas-openplc-runtime sh -c 'command -v curl'
docker exec pallas-node-red sh -c 'command -v curl'
docker exec pallas-postgres sh -c 'command -v pg_isready'
docker exec pallas-pgadmin sh -c 'command -v wget'
docker exec pallas-fastapi sh -c 'command -v python'
```

## Intentional failure and recovery

The probe executables were temporarily renamed inside the disposable
containers, one service at a time. `-u 0` was required for containers whose
service user cannot modify system binary directories.

```powershell
docker exec -u 0 pallas-openplc-runtime sh -c 'mv /usr/bin/curl /usr/bin/curl.health-disabled'
docker exec -u 0 pallas-node-red sh -c 'mv /usr/bin/curl /usr/bin/curl.health-disabled'
docker exec -u 0 pallas-postgres sh -c 'probe=$(command -v pg_isready); mv "$probe" "$probe.health-disabled"'
docker exec -u 0 pallas-pgadmin sh -c 'mv /usr/bin/wget /usr/bin/wget.health-disabled'
docker exec -u 0 pallas-fastapi sh -c 'probe=$(command -v python); mv "$probe" "$probe.health-disabled"'
```

After five scheduled failures for each service, the inspection command reported
the faulted service as `unhealthy` while the other four remained `healthy`.
OpenPLC Runtime, Node-RED, PostgreSQL, PGAdmin, and FastAPI all passed this
isolated transition check independently.

```powershell
docker exec -u 0 pallas-openplc-runtime sh -c 'mv /usr/bin/curl.health-disabled /usr/bin/curl'
docker exec -u 0 pallas-node-red sh -c 'mv /usr/bin/curl.health-disabled /usr/bin/curl'
docker exec -u 0 pallas-postgres sh -c 'mv /usr/local/bin/pg_isready.health-disabled /usr/local/bin/pg_isready'
docker exec -u 0 pallas-pgadmin sh -c 'mv /usr/bin/wget.health-disabled /usr/bin/wget'
docker exec -u 0 pallas-fastapi sh -c 'mv /usr/local/bin/python.health-disabled /usr/local/bin/python'
```

Each service returned to `healthy` on the first or second observed probe cycle
after its executable was restored. After the final recovery, all five
containers reported `healthy` and `failingStreak=0`. Container processes and
persistent volumes were not removed or altered during the failure/recovery
exercise.
