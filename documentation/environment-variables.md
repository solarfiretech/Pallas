# Environment-variable contract

This is the complete Pallas 0.1.0 environment contract. For local development,
run `workspace/generate-local-secrets.ps1` before `docker compose up --build -d`.
Compose stops with a named error when a required value is absent or empty.
FastAPI validates its configuration before the application starts and reports
the offending variable.

Password values are supplied through local secret files or a managed secret
store. They are not environment variables and are never included in the
rendered Compose model.

## Compose settings

| Variable | Requirement | Default / valid value |
| --- | --- | --- |
| `TZ` | Optional | `UTC`; a non-empty IANA time-zone name used by OpenPLC, Node-RED, and FastAPI. |
| `OPENPLC_RUNTIME_IMAGE` | Optional | Pinned OpenPLC image shown in `.env.example`; a valid container image reference. |
| `NODE_RED_IMAGE` | Optional | Pinned Node-RED image shown in `.env.example`; a valid container image reference. |
| `POSTGRES_IMAGE` | Optional | Pinned PostgreSQL image shown in `.env.example`; a valid container image reference. |
| `PGADMIN_IMAGE` | Optional | Pinned PGAdmin image shown in `.env.example`; a valid container image reference. |
| `OPENPLC_RUNTIME_PORT` | Optional | `8443`; integer 1-65535, available on the host. |
| `NODE_RED_PORT` | Optional | `1880`; integer 1-65535, available on the host. |
| `POSTGRES_PORT` | Optional | `5432`; integer 1-65535, available on the host. |
| `PGADMIN_PORT` | Optional | `5050`; integer 1-65535, available on the host. |
| `FASTAPI_PORT` | Optional | `8000`; integer 1-65535, available on the host. |
| `POSTGRES_DB` | Optional | `pallas`; non-empty PostgreSQL database name. |
| `POSTGRES_USER` | Optional | `pallas`; non-empty PostgreSQL role name. |
| `PGADMIN_DEFAULT_EMAIL` | **Required** | No default; syntactically valid email address accepted by PGAdmin. |
| `POSTGRES_PASSWORD_FILE` | **Required** | No default; path to a readable file containing only the PostgreSQL password. |
| `PGADMIN_DEFAULT_PASSWORD_FILE` | **Required** | No default; path to a readable file containing only the PGAdmin password. |

The secret files are mounted at runtime and consumed through the images'
`*_FILE` settings. FastAPI does not receive database credentials; the API does
not yet perform database work.
Docker validates image references and host-port syntax when the Compose model is
created. Port collisions are reported when containers start.

## FastAPI settings

All FastAPI variables below are optional and have validated defaults. Empty
values are invalid because Compose's `:-` substitution deliberately replaces
them with defaults; direct non-Compose startup rejects them.

| Variable | Default | Valid value |
| --- | --- | --- |
| `OPCUA_ENDPOINT_URL` | `opc.tcp://openplc-runtime:4840/openplc/opcua` | Absolute `opc.tcp` URL with host and port. |
| `OPCUA_NAMESPACE_URI` | `urn:openplc:opcua:cocktails` | Non-empty namespace URI. |
| `OPCUA_BROWSE_ROOT` | `ns=0;i=85` | Non-empty asyncua-compatible NodeId. |
| `OPCUA_MAX_DEPTH` | `8` | Integer 0-100. |
| `OPCUA_TIMEOUT_SECONDS` | `10` | Number 0.1-300 seconds. |
| `HEALTHCHECK_TIMEOUT_SECONDS` | `3` | Number 0.1-300 seconds per service. |
| `OPENPLC_HEALTHCHECK_URL` | `https://openplc-runtime:8443/` | Absolute HTTP(S) URL. TLS certificates are not verified for this development endpoint. |
| `OPENPLC_EXPECTED_HTTP_STATUSES` | `200,404` | Non-empty comma-separated integers 100-599. |
| `NODE_RED_HEALTHCHECK_URL` | `http://node-red:1880/` | Absolute HTTP(S) URL. |
| `NODE_RED_EXPECTED_HTTP_STATUSES` | `200` | Non-empty comma-separated integers 100-599. |
| `PGADMIN_HEALTHCHECK_URL` | `http://pgadmin:80/` | Absolute HTTP(S) URL. |
| `PGADMIN_EXPECTED_HTTP_STATUSES` | `200,302` | Non-empty comma-separated integers 100-599. |
| `POSTGRES_HEALTHCHECK_HOST` | `postgres` | Non-empty TCP host name or address. |
| `POSTGRES_HEALTHCHECK_PORT` | `5432` | Integer 1-65535. |

FastAPI loads this contract once during module import. A malformed value causes
the process to exit rather than serving with a partial or silently altered
configuration.
