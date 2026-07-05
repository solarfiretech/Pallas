# OPC UA write/read test through the Node-RED container.
# Edit these values for the node you want to test.

$ServiceName  = "node-red"
$EndpointUrl  = "opc.tcp://openplc-runtime:4840/openplc/opcua"
$NodeId = "ns=2;i=1"
$DatatypeName = "Boolean"
$Value        = "true"

$js = @'
const {
  OPCUAClient,
  AttributeIds,
  DataType
} = require("node-opcua");

const endpointUrl = process.env.OPCUA_ENDPOINT || "opc.tcp://openplc:4840/openplc/opcua";
const nodeId = process.env.OPCUA_NODEID || "ns=2;s=HMI_OUTPUT1_CMD";
const datatypeName = process.env.OPCUA_DATATYPE || "Boolean";
const rawValue = process.env.OPCUA_VALUE || "true";

function castValue(datatypeName, raw) {
  switch (datatypeName) {
    case "Boolean":
      return raw === "true" || raw === "1" || raw === "on";
    case "Float":
    case "Double":
      return Number(raw);
    case "Int16":
    case "UInt16":
    case "Int32":
    case "UInt32":
      return parseInt(raw, 10);
    case "String":
      return String(raw);
    default:
      throw new Error(`Unsupported datatypeName: ${datatypeName}`);
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

  try {
    console.log("Endpoint:", endpointUrl);
    console.log("NodeId:", nodeId);
    console.log("Datatype:", datatypeName);
    console.log("Write Value:", rawValue);
    console.log("");

    await client.connect(endpointUrl);
    const session = await client.createSession();

    const readResults = await session.read([
      { nodeId, attributeId: AttributeIds.Value },
      { nodeId, attributeId: AttributeIds.DataType },
      { nodeId, attributeId: AttributeIds.AccessLevel },
      { nodeId, attributeId: AttributeIds.UserAccessLevel }
    ]);

    console.log("Before Value:", readResults[0].toString());
    console.log("DataType:", readResults[1].toString());
    console.log("AccessLevel:", readResults[2].toString());
    console.log("UserAccessLevel:", readResults[3].toString());

    const value = castValue(datatypeName, rawValue);

    const statusCode = await session.writeSingleNode(nodeId, {
      dataType: DataType[datatypeName],
      value
    });

    console.log("Write result:", statusCode.toString());

    const verify = await session.read({
      nodeId,
      attributeId: AttributeIds.Value
    });

    console.log("After Value:", verify.toString());

    await session.close();
  } finally {
    await client.disconnect();
  }
})().catch((err) => {
  console.error(err);
  process.exit(1);
});
'@

$js |
docker compose exec `
  -T `
  -e OPCUA_ENDPOINT="$EndpointUrl" `
  -e OPCUA_NODEID="$NodeId" `
  -e OPCUA_DATATYPE="$DatatypeName" `
  -e OPCUA_VALUE="$Value" `
  $ServiceName `
  sh -lc 'cat > /tmp/opcua-write-test.js && node /tmp/opcua-write-test.js'