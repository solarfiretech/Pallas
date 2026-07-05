# Cocktail Mixer HMI tutorial for Node-RED

This tutorial shows how to build a basic HMI for a cocktail mixer using Node-RED, the OPCUA-IIoT-Flex-Connector, and the OpenPLC Runtime inside the container stack.

> Tested for Node-RED `4.1.11-debian` and `node-red-contrib-iiot-opcua` version `4.1.2` or later.

## 1. Start the stack

From the project root:

```powershell
cd c:\workspace\Projects\Pallas
docker compose up -d
```

Open Node-RED at:

- `http://localhost:1880`

OpenPLC Runtime is also available inside the stack at:

- `opc.tcp://openplc-runtime:4840/openplc/opcua`

## 2. Install the recommended Node-RED nodes

In Node-RED:

1. Open the top-right menu.
2. Select `Manage palette`.
3. Choose the `Install` tab.
4. Install these packages:
   - Required for OPC UA PLC communication: `node-red-contrib-iiot-opcua`
   - Required for HMI pages/widgets: `@flowfuse/node-red-dashboard`

This tutorial uses only these two packages and does not require optional dashboard add-ons.

Recommended node usage in this tutorial:

- OPC UA connection/session: `OPCUA-IIoT-Flex-Connector`
- OPC UA read/write items: `IIoT OPC UA Item`
- HMI controls and displays: FlowFuse dashboard nodes (`ui_switch`, `ui_button`, `ui_gauge`)

After install, deploy once so all newly installed nodes initialize in the runtime.

## 3. Configure the OPCUA-IIoT-Flex-Connector

1. Drag an `OPCUA-IIoT-Flex-Connector` node onto the canvas.
2. Double-click it to configure.
3. Create a new connection with:
   - Endpoint: `opc.tcp://openplc-runtime:4840/openplc/opcua`
   - Security Policy: `None`
   - Security Mode: `None`
   - Login: disabled
4. Save the connector configuration.

This connector is shared by all OPC UA read/write item nodes in the flow.

## 4. Cocktail mixer variables

The OpenPLC recipe should expose these PLC tags:

- Write-enabled operator controls:
  - `PLC.main.IceRequest` (BOOL)
  - `PLC.main.MixType1` (BOOL)
  - `PLC.main.MixType2` (BOOL)
  - `PLC.main.MixType3` (BOOL)
  - `PLC.main.Liqueur1` (BOOL)
  - `PLC.main.Liqueur2` (BOOL)
  - `PLC.main.WaterRequest` (BOOL)
- Read-only output/status tags:
  - `PLC.main.DispenseIce` (BOOL)
  - `PLC.main.DispenseMix1` (BOOL)
  - `PLC.main.DispenseMix2` (BOOL)
  - `PLC.main.DispenseMix3` (BOOL)
  - `PLC.main.DispenseLiqueur1` (BOOL)
  - `PLC.main.DispenseLiqueur2` (BOOL)
  - `PLC.main.DispenseWater` (BOOL)
  - `PLC.main.CocktailReady` (BOOL)

## 5. Build the HMI dashboard

### Controls

1. Add a dashboard group named `Cocktail Controls`.
2. Add one `ui_switch` or `ui_button` for each control variable:
   - `IceRequest`
   - `MixType1`
   - `MixType2`
   - `MixType3`
   - `Liqueur1`
   - `Liqueur2`
   - `WaterRequest`
3. Set each node to send a boolean payload.
4. Wire the outputs into `IIoT OPC UA Item` nodes configured for write.

### Status indicators

1. Add a dashboard group named `Mixer Status`.
2. Add one `ui_gauge` node for each output/status tag.
3. Wire them from `IIoT OPC UA Item` nodes configured for read.

## 6. Configure OPC UA item nodes

### Write nodes

For each control variable:

1. Drag an `IIoT OPC UA Item` node.
2. Select the `OPCUA-IIoT-Flex-Connector`.
3. Set `NodeId` to the corresponding write tag, for example `PLC.main.IceRequest`.
4. Set `Datatype` to `Boolean`.
5. Set `Input Type` to `write`.
6. Wire from the dashboard switch/button to this node.

### Read nodes

For each status tag:

1. Drag an `IIoT OPC UA Item` node.
2. Select the same connector.
3. Set `NodeId` to the output tag, for example `PLC.main.DispenseIce`.
4. Set `Datatype` to `Boolean`.
5. Set `Input Type` to `read`.
6. Wire the node into a `ui_gauge` widget.

## 7. Example HMI flow diagram

```text
[ui_switch IceRequest] --> [IIoT OPC UA Item write PLC.main.IceRequest]
[ui_switch MixType1] --> [IIoT OPC UA Item write PLC.main.MixType1]
...

[IIoT OPC UA Item read PLC.main.DispenseIce] --> [ui_gauge DispenseIce]
[IIoT OPC UA Item read PLC.main.CocktailReady] --> [ui_gauge CocktailReady]

All OPC UA item nodes use the same OPCUA-IIoT-Flex-Connector.
```

## 8. Running the HMI

1. Deploy the Node-RED flow.
2. Use the dashboard at `http://localhost:1880/ui`.
3. Toggle `IceRequest`, choose a mix type, add a liqueur, and push `WaterRequest`.
4. Watch the dispenser indicators update as the PLC logic runs.

## 9. Notes for this tutorial

- The HMI assumes the OpenPLC program handles the cocktail mixing logic and sets the dispense outputs.
- Keep the Node-RED flow focused on operator inputs and status displays.
- Use `opc.tcp://openplc-runtime:4840/openplc/opcua` from Node-RED inside the container network.
