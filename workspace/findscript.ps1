$ServiceName = "node-red"
$EndpointUrl = "opc.tcp://openplc-runtime:4840/openplc/opcua"   # adjust if needed

$js = @'
const {
  OPCUAClient,
  AttributeIds,
  DataType
} = require("node-opcua");

const endpointUrl = process.env.OPCUA_ENDPOINT;

const candidates = [
  "ns=0;s=PLC.main.IceRequest",
  "ns=1;s=PLC.main.IceRequest",
  "ns=2;s=PLC.main.IceRequest",
  "ns=0;s=C.main.IceRequest",
  "ns=1;s=C.main.IceRequest",
  "ns=2;s=C.main.IceRequest",
  "ns=0;s=main.IceRequest",
  "ns=1;s=main.IceRequest",
  "ns=2;s=main.IceRequest",
  "ns=0;s=IceRequest",
  "ns=1;s=IceRequest",
  "ns=2;s=IceRequest"
];

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
    await client.connect(endpointUrl);
    const session = await client.createSession();

    for (const nodeId of candidates) {
      try {
        const result = await session.read({
          nodeId,
          attributeId: AttributeIds.Value
        });

        console.log("");
        console.log("Candidate:", nodeId);
        console.log("Status:", result.statusCode.toString());
        console.log("Value:", result.toString());

        if (result.statusCode.name === "Good") {
          console.log("FOUND_VALID_NODEID=" + nodeId);
        }
      } catch (err) {
        console.log("");
        console.log("Candidate:", nodeId);
        console.log("Error:", err.message);
      }
    }

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
  $ServiceName `
  sh -lc 'cat > /tmp/opcua-nodeid-probe.js && node /tmp/opcua-nodeid-probe.js'