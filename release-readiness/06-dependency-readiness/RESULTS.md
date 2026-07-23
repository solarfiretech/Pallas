# Task 6 verification results

Verified on 2026-07-23 with Docker Engine 29.6.2 using the repeatable test in
this directory. The test used Compose project `pallas-readiness-d6778b7c` and
fresh project-scoped volumes, then removed all of them after passing.

## Command

Git-ignored disposable secret files were supplied without printing their
contents:

```powershell
$env:POSTGRES_PASSWORD_FILE = (Resolve-Path '.secrets/postgres_password').Path
$env:PGADMIN_DEFAULT_PASSWORD_FILE = (Resolve-Path '.secrets/pgadmin_password').Path
pwsh -NoProfile -File release-readiness/06-dependency-readiness/Test-DependencyReadiness.ps1
```

## Timed evidence

Times are elapsed from invocation and include the FastAPI image build and fresh
named-volume initialization.

| Event | Elapsed | Result |
| --- | ---: | --- |
| Node-RED healthy with PostgreSQL and OpenPLC absent | 54.7s | Passed |
| PGAdmin healthy with PostgreSQL absent | 447.0s | Passed; pristine PGAdmin database initialization dominated the cold start |
| FastAPI healthy with PostgreSQL and OpenPLC absent | 447.3s | Passed |
| FastAPI aggregate while dependencies absent | 451.3s | `degraded`, as expected |
| Delayed PostgreSQL healthy | 468.7s | 11.4s after its container entered `starting` |
| Aggregate after PostgreSQL only | 472.6s | Still `degraded`, because OpenPLC remained absent |
| Delayed OpenPLC healthy | 510.7s | 6.8s after its container entered `starting` |
| Aggregate after both dependencies recovered | 510.7s | `ok` |
| PostgreSQL restart recovery | 525.1s | Healthy 6.8s after the observed `starting` transition; aggregate `ok` |
| OpenPLC restart recovery | 547.5s | Healthy 6.7s after the observed `starting` transition; aggregate `ok` |

The script ended with `PASS: cold start, delayed dependencies, and restart
recovery` at 547.6s. PGAdmin, FastAPI, and Node-RED did not restart when either
dependency appeared or restarted. Cleanup removed every container, network, and
volume belonging to the isolated project.

An earlier diagnostic run used a 180-second cold-readiness deadline. It failed
only because pristine PGAdmin initialization took about 399 seconds after its
container started on this Docker Desktop host. The repeatable test now allows
600 seconds for first-run readiness while retaining a 120-second dependency
recovery deadline.
