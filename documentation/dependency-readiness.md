# Dependency readiness and recovery

Pallas services start independently. Compose health checks report readiness, but
the required services do not use `depends_on` because none has another required
service as a process-start prerequisite:

- PGAdmin can start and serve its UI while PostgreSQL is unavailable. A database
  connection attempted during that interval fails normally and can be retried
  after PostgreSQL is healthy.
- FastAPI does not currently perform database work or receive database
  credentials. Its PostgreSQL check is diagnostic only, so PostgreSQL must not
  gate FastAPI startup.
- FastAPI contacts OpenPLC only when `/health/containers` or
  `/opcua/variables` is requested. An unavailable OPC UA server produces a
  bounded `503` or `504`; a later request creates a new connection and recovers
  without restarting FastAPI.
- Node-RED is a general workflow host. User-installed flows may contact OpenPLC,
  but examples and user flows are optional and cannot be stack startup
  prerequisites. Connection/retry behavior belongs to each flow and node.

Consequently, the stack intentionally has no health-gated dependency edges.
Adding `condition: service_healthy` would make `docker compose up` ordering look
stronger while coupling otherwise usable services to optional peers. The
per-container health checks remain the readiness source of truth.

## Expected behavior

On cold start, containers are created concurrently and become healthy within
their documented health-check windows. Health order is not guaranteed. A caller
that needs a specific service must wait for that service's `healthy` state.

If PostgreSQL or OpenPLC starts late, the other required services still start.
The aggregate FastAPI endpoint reports `degraded` while a checked dependency is
unavailable and returns to `ok` after it recovers. FastAPI's own `/health`
endpoint remains healthy because it is a liveness/readiness check for the API
process, not an aggregate dependency gate.

After PostgreSQL or OpenPLC is restarted, Docker DNS continues to resolve the
service name. PGAdmin reconnects on a subsequent database operation, and
FastAPI creates fresh TCP/HTTP/OPC UA connections on each request. No dependent
container restart is required.

## Repeatable verification

Run the isolated test from the repository root with Docker running:

```powershell
pwsh -NoProfile -File release-readiness/06-dependency-readiness/Test-DependencyReadiness.ps1
```

The script uses a unique Compose project and project-scoped volumes, records
timestamped container health transitions, starts PGAdmin, FastAPI, and Node-RED
before PostgreSQL and OpenPLC,
restarts each dependency, and verifies automatic aggregate-health recovery. It
always removes its isolated containers and volumes. Set `-KeepEnvironment` to
retain the test project for inspection.

The test deadlines are deliberately longer than the health-check start periods:
600 seconds for cold, first-run readiness and 120 seconds for recovery. The
long cold-start allowance includes image-backed named-volume initialization;
normal dependency recovery retains the shorter bound. Failure to
reach the expected state within a deadline fails the script with its transition
log intact.
