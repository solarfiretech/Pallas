# OpenPLC Editor v4 Cocktail Mixer Tutorial

This tutorial is an entry-level introduction to building a simple cocktail mixer PLC application for OpenPLC Editor v4 and connecting it to a Node-RED HMI.

## Goal

Build a small PLC program for a cocktail mixer with:

- an ice dispenser
- three mix types
- two liqueurs
- a water dispenser
- a ready status indicator

The program will expose simple Boolean inputs and outputs that Node-RED can use for an HMI.

## 1. Create a new OpenPLC Editor project

1. Open OpenPLC Editor v4.
2. Create a new project and name it `CocktailMixer`.
3. Add a new program named `main`.
4. Choose the Ladder Diagram (LD) language for the program.

## 2. Define the PLC variables

Create the following global variables in the project:

- Inputs / requests:
  - `IceRequest : BOOL`
  - `MixType1 : BOOL`
  - `MixType2 : BOOL`
  - `MixType3 : BOOL`
  - `Liqueur1 : BOOL`
  - `Liqueur2 : BOOL`
  - `WaterRequest : BOOL`
- Outputs / dispensers:
  - `DispenseIce : BOOL`
  - `DispenseMix1 : BOOL`
  - `DispenseMix2 : BOOL`
  - `DispenseMix3 : BOOL`
  - `DispenseLiqueur1 : BOOL`
  - `DispenseLiqueur2 : BOOL`
  - `DispenseWater : BOOL`
  - `CocktailReady : BOOL`

> Tip: Keep the initial program simple so new engineers can focus on basic ladder logic and HMI integration.

## 3. Implement the mixer logic in ladder logic

In Ladder Diagram, create one rung for each dispenser output and one rung for the ready indicator.

### Rung examples

- `DispenseIce` rung:
  - contact: `IceRequest`
  - coil: `DispenseIce`

- `DispenseWater` rung:
  - contact: `WaterRequest`
  - coil: `DispenseWater`

- `DispenseMix1` rung:
  - contact: `MixType1`
  - normally-closed contact: `MixType2`
  - normally-closed contact: `MixType3`
  - coil: `DispenseMix1`

- `DispenseMix2` rung:
  - contact: `MixType2`
  - normally-closed contact: `MixType1`
  - normally-closed contact: `MixType3`
  - coil: `DispenseMix2`

- `DispenseMix3` rung:
  - contact: `MixType3`
  - normally-closed contact: `MixType1`
  - normally-closed contact: `MixType2`
  - coil: `DispenseMix3`

- `DispenseLiqueur1` rung:
  - contact: `Liqueur1`
  - normally-closed contact: `Liqueur2`
  - coil: `DispenseLiqueur1`

- `DispenseLiqueur2` rung:
  - contact: `Liqueur2`
  - normally-closed contact: `Liqueur1`
  - coil: `DispenseLiqueur2`

- `CocktailReady` rung:
  - contact: `DispenseIce`
  - parallel branch with contacts: `DispenseMix1`, `DispenseMix2`, `DispenseMix3`
  - parallel branch with contacts: `DispenseLiqueur1`, `DispenseLiqueur2`
  - contact: `DispenseWater`
  - coil: `CocktailReady`

### Example ladder logic structure

1. Single input rungs for ice and water request outputs.
2. Exclusive mix type rungs using one active mix contact and two normally-closed contacts to block the others.
3. Exclusive liqueur rungs using one liqueur contact and one normally-closed contact.
4. A final `CocktailReady` rung that requires ice, one mix, one liqueur, and water.

This ladder logic ensures only one mix type and one liqueur are active at once, and the ready indicator only energizes when all dispensers are present.

## 4. Configure the OpenPLC OPC UA server in OpenPLC Editor

Use OpenPLC Editor v4 to configure the OPC UA server so both Node-RED and FastAPI can connect from the same Docker Compose network.

1. In OpenPLC Editor, open your project and go to device/server configuration.
2. Add a new server named `SCADA` and select protocol `opcua`.
3. Configure the OPC UA server settings:
  - Enabled: `true`
  - Bind address: `0.0.0.0`
  - Port: `4840`
  - Endpoint path: `/openplc/opcua`
4. Configure security for container compatibility:
  - Security policy: `None`
  - Security mode: `None`
  - Authentication: `Anonymous`
5. Set a namespace URI, for example `urn:openplc:opcua:namespace`.
6. Add OPC UA address-space variables for the mixer tags:
  - `PLC.main.IceRequest`
  - `PLC.main.MixType1`
  - `PLC.main.MixType2`
  - `PLC.main.MixType3`
  - `PLC.main.Liqueur1`
  - `PLC.main.Liqueur2`
  - `PLC.main.WaterRequest`
  - `PLC.main.DispenseIce`
  - `PLC.main.DispenseMix1`
  - `PLC.main.DispenseMix2`
  - `PLC.main.DispenseMix3`
  - `PLC.main.DispenseLiqueur1`
  - `PLC.main.DispenseLiqueur2`
  - `PLC.main.DispenseWater`
  - `PLC.main.CocktailReady`
7. Set permissions by function:
  - Operator input/request tags: `rw`
  - Output/status tags: `r`
8. Save and deploy the project.

Compatibility notes for this stack:

- Node-RED container endpoint: `opc.tcp://openplc-runtime:4840/openplc/opcua`
- FastAPI container can use the same endpoint if you add an OPC UA client workflow to the API service.
- Keep `None/None` security for this starter project to match the current Node-RED OPC UA tutorial and avoid certificate setup complexity in containerized development.

## 5. Deploy to OpenPLC Runtime

1. Save your project files.
2. Deploy the project to the OpenPLC Runtime using the editor's deploy/publish feature.
3. Confirm the runtime is running and the OPC UA server is listening on the expected endpoint:

- `opc.tcp://openplc-runtime:4840/openplc/opcua`

## 6. What entry-level engineers learn

This tutorial is designed for new automation engineers to learn:

- how to create PLC inputs and outputs in OpenPLC Editor v4
- how to write basic ladder logic
- how to expose variables through OPC UA
- how to connect a Node-RED HMI to PLC data

## 7. Next step

Use the Node-RED tutorial in `Examples/NodeRED/Pallas/README.md` to build the cocktail mixer HMI and wire the dashboard to your OpenPLC variables.
