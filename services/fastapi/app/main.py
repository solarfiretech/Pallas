from __future__ import annotations

import asyncio
import os
from dataclasses import dataclass
from datetime import datetime, timezone
from typing import Any

from asyncua import Client, ua
from fastapi import FastAPI, HTTPException

app = FastAPI(title="Pallas FastAPI", version="0.1.0")

DEFAULT_OPCUA_ENDPOINT_URL = os.getenv(
    "OPCUA_ENDPOINT_URL",
    "opc.tcp://openplc-runtime:4840/openplc/opcua",
)
DEFAULT_OPCUA_NAMESPACE_URI = os.getenv(
    "OPCUA_NAMESPACE_URI",
    "urn:openplc:opcua:cocktails",
)

DEFAULT_OPCUA_BROWSE_ROOT = os.getenv("OPCUA_BROWSE_ROOT", "ns=0;i=85")
DEFAULT_OPCUA_MAX_DEPTH = int(os.getenv("OPCUA_MAX_DEPTH", "8"))
DEFAULT_OPCUA_TIMEOUT_SECONDS = float(os.getenv("OPCUA_TIMEOUT_SECONDS", "10"))

NODE_RED_DATATYPE_MAP = {
    "Boolean": "Boolean",
    "BOOL": "Boolean",
    "Int16": "Int16",
    "Int32": "Int32",
    "UInt16": "UInt16",
    "UInt32": "UInt32",
    "Float": "Float",
    "Double": "Double",
    "String": "String",
    "DateTime": "DateTime",
}


def _to_int(value: Any) -> int:
    try:
        return int(str(value).strip())
    except (TypeError, ValueError):
        return 0


def _node_red_datatype(data_type: str) -> str:
    return NODE_RED_DATATYPE_MAP.get(data_type, data_type)


def _can_read(access_level: str, access_level_raw: int) -> bool:
    return "Read" in access_level or bool(access_level_raw & 1)


def _can_write(access_level: str, access_level_raw: int) -> bool:
    return "Write" in access_level or bool(access_level_raw & 2)


def _clean_qualified_name(value: Any) -> str:
    if value is None:
        return ""

    return str(value).replace("ns=", "").split(":", 1)[-1]


def _node_id_to_string(node_id: ua.NodeId | str | None) -> str:
    if node_id is None:
        return ""

    return str(node_id)


def _namespace_uri(namespace_uris: list[str], namespace_index: int) -> str:
    if 0 <= namespace_index < len(namespace_uris):
        return namespace_uris[namespace_index]

    return ""


def _node_red_datatype(data_type_name: str) -> str:
    return NODE_RED_DATATYPE_MAP.get(data_type_name, data_type_name)


def _access_text(access_level_raw: int) -> str:
    flags: list[str] = []
    if access_level_raw & 1:
        flags.append("Read")
    if access_level_raw & 2:
        flags.append("Write")

    if flags:
        return f"{access_level_raw} ({'+'.join(flags)})"

    return f"{access_level_raw} (None)"


@dataclass(frozen=True)
class PollSettings:
    endpoint_url: str = DEFAULT_OPCUA_ENDPOINT_URL
    browse_root: str = DEFAULT_OPCUA_BROWSE_ROOT
    max_depth: int = DEFAULT_OPCUA_MAX_DEPTH
    timeout_seconds: float = DEFAULT_OPCUA_TIMEOUT_SECONDS


async def _read_variable_metadata(client: Client, namespace_uris: list[str], node: Any) -> dict[str, Any]:
    browse_name = await node.read_browse_name()
    display_name = await node.read_display_name()
    node_class = await node.read_node_class()
    value_data = await node.read_attribute(ua.AttributeIds.Value)
    data_type_data = await node.read_attribute(ua.AttributeIds.DataType)
    access_level_data = await node.read_attribute(ua.AttributeIds.AccessLevel)
    user_access_level_data = await node.read_attribute(ua.AttributeIds.UserAccessLevel)

    value_variant = getattr(value_data, "Value", None)
    data_type_variant = getattr(data_type_data, "Value", None)
    access_level_variant = getattr(access_level_data, "Value", None)
    user_access_level_variant = getattr(user_access_level_data, "Value", None)

    data_type_node_id = getattr(data_type_variant, "Value", None)
    access_level_raw = int(getattr(access_level_variant, "Value", 0) or 0)
    user_access_level_raw = int(getattr(user_access_level_variant, "Value", 0) or 0)

    data_type_name = ""
    if data_type_node_id:
        try:
            data_type_node = client.get_node(data_type_node_id)
            data_type_browse_name = await data_type_node.read_browse_name()
            data_type_name = _clean_qualified_name(data_type_browse_name.Name)
        except Exception:
            data_type_name = _node_id_to_string(data_type_node_id)

    node_id = node.nodeid
    namespace_index = int(node_id.NamespaceIndex)
    return {
        "name": display_name.Text or _clean_qualified_name(browse_name.Name),
        "browseName": _clean_qualified_name(browse_name.Name),
        "browseNameFull": str(browse_name.Name),
        "variablePath": "",
        "nodeId": _node_id_to_string(node_id),
        "namespaceIndex": namespace_index,
        "namespaceUri": _namespace_uri(namespace_uris, namespace_index),
        "nodeClass": getattr(node_class, "name", str(node_class)),
        "dataType": data_type_name,
        "dataTypeNodeId": _node_id_to_string(data_type_node_id),
        "accessLevel": _access_text(access_level_raw),
        "userAccessLevel": _access_text(user_access_level_raw),
        "accessLevelRaw": access_level_raw,
        "userAccessLevelRaw": user_access_level_raw,
        "value": getattr(value_variant, "Value", None),
        "valueStatus": str(getattr(value_data, "StatusCode_", getattr(value_data, "StatusCode", ""))),
        "valueTimestamp": value_data.SourceTimestamp.isoformat() if value_data.SourceTimestamp else "",
        "endpointUrl": DEFAULT_OPCUA_ENDPOINT_URL,
        "nodeRedDatatype": _node_red_datatype(data_type_name),
        "canRead": _can_read(_access_text(access_level_raw), access_level_raw),
        "canWrite": _can_write(_access_text(access_level_raw), access_level_raw),
        "nodeRed": {
            "endpointUrl": DEFAULT_OPCUA_ENDPOINT_URL,
            "nodeId": _node_id_to_string(node_id),
            "datatype": _node_red_datatype(data_type_name),
        },
    }


async def _browse_variables(settings: PollSettings) -> list[dict[str, Any]]:
    discovered: list[dict[str, Any]] = []
    visited: set[str] = set()

    async with Client(url=settings.endpoint_url, timeout=settings.timeout_seconds) as client:
        namespace_uris = await client.get_namespace_array()
        root = client.get_node(settings.browse_root)

        async def walk(node: Any, path: str, depth: int) -> None:
            if depth > settings.max_depth:
                return

            node_id_text = _node_id_to_string(node.nodeid)
            if node_id_text in visited:
                return

            visited.add(node_id_text)

            try:
                children = await node.get_children()
            except Exception:
                return

            for child in children:
                try:
                    child_node_id = child.nodeid
                    child_namespace_index = int(child_node_id.NamespaceIndex)
                    child_node_class = await child.read_node_class()
                    child_browse_name = await child.read_browse_name()
                    child_name = _clean_qualified_name(child_browse_name.Name)
                    child_path = f"{path}.{child_name}" if path else child_name

                    if getattr(child_node_class, "name", str(child_node_class)) == "Variable" and child_namespace_index != 0:
                        variable = await _read_variable_metadata(client, namespace_uris, child)
                        variable["variablePath"] = child_path
                        variable["namespaceUri"] = _namespace_uri(namespace_uris, child_namespace_index)
                        discovered.append(variable)

                    await walk(child, child_path, depth + 1)
                except Exception:
                    continue

        await walk(root, "", 0)

    discovered.sort(key=lambda item: (item.get("variablePath", ""), item.get("nodeId", "")))
    return discovered


@app.get("/")
def read_root() -> dict[str, str]:
    return {"message": "Pallas FastAPI is running"}


@app.get("/health")
def health_check() -> dict[str, str]:
    return {"status": "ok"}


@app.get("/opcua/variables")
async def list_opcua_variables() -> dict[str, Any]:
    settings = PollSettings()

    try:
        variables = await asyncio.wait_for(_browse_variables(settings), timeout=settings.timeout_seconds)
    except asyncio.TimeoutError as exc:
        raise HTTPException(status_code=504, detail="Timed out while polling the OPC UA server") from exc
    except Exception as exc:
        raise HTTPException(status_code=503, detail=f"Failed to poll OPC UA server: {exc}") from exc

    return {
        "polledAt": datetime.now(timezone.utc).isoformat(),
        "endpointUrl": settings.endpoint_url,
        "browseRoot": settings.browse_root,
        "namespaceUri": DEFAULT_OPCUA_NAMESPACE_URI,
        "count": len(variables),
        "variables": variables,
    }
