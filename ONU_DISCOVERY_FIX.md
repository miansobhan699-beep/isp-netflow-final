# ONU Discovery Fix

The OLT Adapter now has an **ONU Discovery** button in addition to SNMP Diagnostic.

## What changed
- `/api/olts/{olt_id}/onu-discovery` performs a bounded, read-only SNMP discovery probe.
- `/api/olts/{olt_id}/snmp-debug` now puts `discovery` at the top of the JSON response so it is visible immediately.
- The discovery probe checks VSOL 37950 branches, the V1600D authorization table, generic ONU list, and BDCOM EPON ONU tables.
- No SNMP SET/write operations are performed.

## Important
If all ONU branches still show `count: 0`, the OLT is reachable but its current firmware/community does not expose the tested ONU MIB tables. The returned `nonEmptyBranches` data can then be used to map the exact firmware OIDs without inventing ONU data.

## Run
Start `START_ADAPTER.bat`, open the dashboard, go to Network -> OLT Adapter, select the OLT, and click **ONU Discovery**.
