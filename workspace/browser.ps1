# Browse OpenPLC OPC UA variables and export NodeIds.
# Run from the directory containing docker-compose.yml.
# This runs the node-opcua client from inside the Node-RED container.

$ServiceName = "node-red"
$EndpointUrl = "opc.tcp://openplc-runtime:4840/openplc/opcua"

# Normal OPC UA Objects folder.
$RootNodeId = "ns=0;i=85"

# Increase if needed, but 8 is usually enough for OpenPLC variables.
$MaxDepth = "8"

# Use "" to export all variables.
# Use "IceRequest" to find one variable.
# Use "PLC|main" to focus on OpenPLC program variables.
$Filter = "PLC|main|IceRequest|DispenseIce|MixType|Liqueur|Water|DispenseMix|Ready"

$OutputCsv = ".\openplc-opcua-nodeids.csv"

$js = @'
const {
  OPCUAClient,
  AttributeIds,
  BrowseDirection,
  NodeClass
} = require("node-opcua");

const endpointUrl = process.env.OPCUA_ENDPOINT;
const rootNodeId = process.env.OPCUA_ROOT_NODEID || "ns=0;i=85";
const maxDepth = Number(process.env.OPCUA_MAX_DEPTH || "8");
const filterText = process.env.OPCUA_FILTER || "";
const filter = filterText ? new RegExp(filterText, "i") : null;

const results = [];

function nodeClassName(value) {
  if (typeof value === "number") {
    return NodeClass[value] || String(value);
  }

  if (value && value.key) {
    return value.key;
  }

  return String(value);
}

function accessText(value) {
  if (typeof value !== "number") {
    return String(value);
  }

  const flags = [];

  if (value & 0x01) {
    flags.push("Read");
  }

  if (value & 0x02) {
    flags.push("Write");
  }

  return flags.length ? `${value} (${flags.join("+")})` : `${value} (None)`;
}

function cleanQualifiedName(value) {
  if (!value) {
    return "";
  }

  const text = value.toString();

  // Convert "2:IceRequest" to "IceRequest" while preserving the full form elsewhere.
  return text.replace(/^[0-9]+:/, "");
}

function dataValueToString(dataValue) {
  if (!dataValue) {
    return "";
  }

  if (!dataValue.statusCode || dataValue.statusCode.name !== "Good") {
    return dataValue.statusCode ? dataValue.statusCode.toString() : "Bad/Unknown";
  }

  if (!dataValue.value) {
    return "";
  }

  if (dataValue.value.value === null || dataValue.value.value === undefined) {
    return dataValue.value.toString();
  }

  return String(dataValue.value.value);
}

async function readBrowseName(session, nodeId) {
  try {
    const result = await session.read({
      nodeId,
      attributeId: AttributeIds.BrowseName
    });

    if (result.statusCode.name === "Good" && result.value && result.value.value) {
      return result.value.value.toString();
    }

    return result.statusCode.toString();
  } catch (err) {
    return "ReadError: " + err.message;
  }
}

async function readVariableMetadata(session, nodeId) {
  const readResults = await session.read([
    { nodeId, attributeId: AttributeIds.Value },
    { nodeId, attributeId: AttributeIds.DataType },
    { nodeId, attributeId: AttributeIds.AccessLevel },
    { nodeId, attributeId: AttributeIds.UserAccessLevel }
  ]);

  const valueResult = readResults[0];
  const dataTypeResult = readResults[1];
  const accessLevelResult = readResults[2];
  const userAccessLevelResult = readResults[3];

  let dataTypeNodeId = "";
  let dataTypeName = "";

  if (dataTypeResult.statusCode.name === "Good" && dataTypeResult.value && dataTypeResult.value.value) {
    dataTypeNodeId = dataTypeResult.value.value.toString();
    dataTypeName = await readBrowseName(session, dataTypeNodeId);
    dataTypeName = cleanQualifiedName(dataTypeName);
  } else {
    dataTypeName = dataTypeResult.statusCode.toString();
  }

  const accessLevel =
    accessLevelResult.statusCode.name === "Good"
      ? accessLevelResult.value.value
      : accessLevelResult.statusCode.toString();

  const userAccessLevel =
    userAccessLevelResult.statusCode.name === "Good"
      ? userAccessLevelResult.value.value
      : userAccessLevelResult.statusCode.toString();

  return {
    DataTypeNodeId: dataTypeNodeId,
    DataType: dataTypeName,
    AccessLevelRaw: accessLevel,
    AccessLevel: accessText(accessLevel),
    UserAccessLevelRaw: userAccessLevel,
    UserAccessLevel: accessText(userAccessLevel),
    Value: dataValueToString(valueResult),
    ValueStatus: valueResult.statusCode ? valueResult.statusCode.toString() : ""
  };
}

async function browseRecursive(session, nodeId, path, depth, visited) {
  if (depth > maxDepth) {
    return;
  }

  const visitedKey = String(nodeId);

  if (visited.has(visitedKey)) {
    return;
  }

  visited.add(visitedKey);

  let browseResult;

  try {
    browseResult = await session.browse({
      nodeId,
      browseDirection: BrowseDirection.Forward,
      referenceTypeId: "HierarchicalReferences",
      includeSubtypes: true,
      nodeClassMask: 0,
      resultMask: 0x3f
    });
  } catch (err) {
    console.error(`Browse failed at ${nodeId}: ${err.message}`);
    return;
  }

  for (const ref of browseResult.references || []) {
    const childNodeId = ref.nodeId.toString();
    const browseNameFull = ref.browseName ? ref.browseName.toString() : "";
    const browseName = cleanQualifiedName(browseNameFull);
    const displayName = ref.displayName && ref.displayName.text ? ref.displayName.text : "";
    const nodeClass = nodeClassName(ref.nodeClass);
    const childPath = path ? `${path}.${browseName}` : browseName;

    if (nodeClass === "Variable") {
      const meta = await readVariableMetadata(session, childNodeId);

      results.push({
        Name: displayName || browseName,
        BrowseName: browseName,
        BrowseNameFull: browseNameFull,
        Path: childPath,
        NodeId: childNodeId,
        NodeClass: nodeClass,
        DataType: meta.DataType,
        DataTypeNodeId: meta.DataTypeNodeId,
        AccessLevel: meta.AccessLevel,
        UserAccessLevel: meta.UserAccessLevel,
        AccessLevelRaw: meta.AccessLevelRaw,
        UserAccessLevelRaw: meta.UserAccessLevelRaw,
        Value: meta.Value,
        ValueStatus: meta.ValueStatus
      });
    }

    await browseRecursive(session, childNodeId, childPath, depth + 1, visited);
  }
}

(async () => {
  const client = OPCUAClient.create({
    endpointMustExist: false,
    securityMode: "None",
    securityPolicy: "None",
    connectionStrategy: {
      initialDelay: 500,
      maxRetry: 1
    }
  });

  console.error("Endpoint:", endpointUrl);
  console.error("RootNodeId:", rootNodeId);
  console.error("MaxDepth:", maxDepth);
  console.error("Filter:", filterText || "<none>");

  try {
    await client.connect(endpointUrl);
    const session = await client.createSession();

    await browseRecursive(session, rootNodeId, "", 0, new Set());

    await session.close();
  } finally {
    await client.disconnect();
  }

  let filteredResults = results;

  if (filter) {
    filteredResults = results.filter((item) => {
      const text = [
        item.Name,
        item.BrowseName,
        item.BrowseNameFull,
        item.Path,
        item.NodeId,
        item.DataType
      ].join(" ");

      return filter.test(text);
    });
  }

  filteredResults.sort((a, b) => {
    return a.Path.localeCompare(b.Path, undefined, { numeric: true });
  });

  console.log(JSON.stringify(filteredResults, null, 2));
})().catch((err) => {
  console.error(err);
  process.exit(1);
});
'@

$json = $js |
docker compose exec `
  -T `
  -e OPCUA_ENDPOINT="$EndpointUrl" `
  -e OPCUA_ROOT_NODEID="$RootNodeId" `
  -e OPCUA_MAX_DEPTH="$MaxDepth" `
  -e OPCUA_FILTER="$Filter" `
  $ServiceName `
  sh -lc 'cat > /tmp/openplc-opcua-browse.js && node /tmp/openplc-opcua-browse.js'

if (-not $json) {
    throw "No JSON output was returned from the OPC UA browser script."
}

$nodes = $json | ConvertFrom-Json

if (-not $nodes) {
    Write-Warning "No OPC UA variables matched the filter: $Filter"
    return
}

$nodes |
    Select-Object Name, NodeId, DataType, AccessLevel, UserAccessLevel, Value, Path |
    Format-Table -AutoSize

$nodes |
    Export-Csv -NoTypeInformation -Path $OutputCsv

Write-Host ""
Write-Host "Exported OPC UA node list to: $OutputCsv"
