# Live Bandwidth Monitoring

## OLT
- Uses standard IF-MIB `ifHCInOctets` / `ifHCOutOctets` when exposed by the OLT, with 32-bit IF-MIB fallback.
- Calculates RX/TX throughput from successive SNMP counter samples.
- Shows total live bandwidth and current bandwidth per PON/uplink port.
- If the OLT firmware does not expose interface counters for its PON indexes, the dashboard will not invent a bandwidth value.

## MikroTik
- Uses RouterOS interface RX/TX byte counters and calculates throughput between samples.
- Shows total RX/TX live bandwidth and current bandwidth per interface.
- Demo mode generates changing sample counters so the graphs can be tested without a physical router.

Graphs refresh automatically while the relevant dashboard is open.
