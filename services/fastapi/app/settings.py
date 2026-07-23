from __future__ import annotations

import os
from dataclasses import dataclass
from typing import Mapping
from urllib.parse import urlparse


class ConfigurationError(ValueError):
    """Raised when the process environment violates the release contract."""


def _text(env: Mapping[str, str], name: str, default: str) -> str:
    value = env.get(name, default).strip()
    if not value:
        raise ConfigurationError(f"{name} must not be empty")
    return value


def _number(env: Mapping[str, str], name: str, default: str, *, integer: bool,
            minimum: float, maximum: float) -> int | float:
    raw = env.get(name, default).strip()
    try:
        value = int(raw) if integer else float(raw)
    except ValueError as exc:
        kind = "an integer" if integer else "a number"
        raise ConfigurationError(f"{name} must be {kind}; got {raw!r}") from exc
    if not minimum <= value <= maximum:
        raise ConfigurationError(
            f"{name} must be between {minimum:g} and {maximum:g}; got {raw!r}"
        )
    return value


def _http_url(env: Mapping[str, str], name: str, default: str) -> str:
    value = _text(env, name, default)
    parsed = urlparse(value)
    if parsed.scheme not in {"http", "https"} or not parsed.netloc:
        raise ConfigurationError(
            f"{name} must be an absolute http:// or https:// URL; got {value!r}"
        )
    return value


def _statuses(env: Mapping[str, str], name: str, default: str) -> frozenset[int]:
    raw = _text(env, name, default)
    tokens = [token.strip() for token in raw.split(",")]
    if any(not token for token in tokens):
        raise ConfigurationError(f"{name} must be a comma-separated list of HTTP status codes")
    try:
        statuses = frozenset(int(token) for token in tokens)
    except ValueError as exc:
        raise ConfigurationError(f"{name} must contain only integer HTTP status codes; got {raw!r}") from exc
    if any(status < 100 or status > 599 for status in statuses):
        raise ConfigurationError(f"{name} status codes must be between 100 and 599; got {raw!r}")
    return statuses


@dataclass(frozen=True)
class Settings:
    opcua_endpoint_url: str
    opcua_namespace_uri: str
    opcua_browse_root: str
    opcua_max_depth: int
    opcua_timeout_seconds: float
    healthcheck_timeout_seconds: float
    openplc_healthcheck_url: str
    node_red_healthcheck_url: str
    pgadmin_healthcheck_url: str
    postgres_healthcheck_host: str
    postgres_healthcheck_port: int
    openplc_expected_http_statuses: frozenset[int]
    node_red_expected_http_statuses: frozenset[int]
    pgadmin_expected_http_statuses: frozenset[int]

    @classmethod
    def from_env(cls, env: Mapping[str, str] | None = None) -> "Settings":
        source = os.environ if env is None else env
        endpoint = _text(source, "OPCUA_ENDPOINT_URL", "opc.tcp://openplc-runtime:4840/openplc/opcua")
        parsed = urlparse(endpoint)
        try:
            endpoint_port = parsed.port
        except ValueError as exc:
            raise ConfigurationError(
                f"OPCUA_ENDPOINT_URL must have a numeric port; got {endpoint!r}"
            ) from exc
        if parsed.scheme != "opc.tcp" or not parsed.hostname or endpoint_port is None:
            raise ConfigurationError(
                f"OPCUA_ENDPOINT_URL must be an absolute opc.tcp URL with a port; got {endpoint!r}"
            )
        return cls(
            opcua_endpoint_url=endpoint,
            opcua_namespace_uri=_text(source, "OPCUA_NAMESPACE_URI", "urn:openplc:opcua:cocktails"),
            opcua_browse_root=_text(source, "OPCUA_BROWSE_ROOT", "ns=0;i=85"),
            opcua_max_depth=int(_number(source, "OPCUA_MAX_DEPTH", "8", integer=True, minimum=0, maximum=100)),
            opcua_timeout_seconds=float(_number(source, "OPCUA_TIMEOUT_SECONDS", "10", integer=False, minimum=0.1, maximum=300)),
            healthcheck_timeout_seconds=float(_number(source, "HEALTHCHECK_TIMEOUT_SECONDS", "3", integer=False, minimum=0.1, maximum=300)),
            openplc_healthcheck_url=_http_url(source, "OPENPLC_HEALTHCHECK_URL", "https://openplc-runtime:8443/"),
            node_red_healthcheck_url=_http_url(source, "NODE_RED_HEALTHCHECK_URL", "http://node-red:1880/"),
            pgadmin_healthcheck_url=_http_url(source, "PGADMIN_HEALTHCHECK_URL", "http://pgadmin:80/"),
            postgres_healthcheck_host=_text(source, "POSTGRES_HEALTHCHECK_HOST", "postgres"),
            postgres_healthcheck_port=int(_number(source, "POSTGRES_HEALTHCHECK_PORT", "5432", integer=True, minimum=1, maximum=65535)),
            openplc_expected_http_statuses=_statuses(source, "OPENPLC_EXPECTED_HTTP_STATUSES", "200,404"),
            node_red_expected_http_statuses=_statuses(source, "NODE_RED_EXPECTED_HTTP_STATUSES", "200"),
            pgadmin_expected_http_statuses=_statuses(source, "PGADMIN_EXPECTED_HTTP_STATUSES", "200,302"),
        )
