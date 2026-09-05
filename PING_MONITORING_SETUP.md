# NetFlow ISP - Professional Ping Monitoring

## What is included
- Real ICMP monitoring from the server-side/local monitoring adapter.
- Optional TCP connect health checks for hosts/services that do not answer ICMP.
- Default monitoring interval: 3 seconds (minimum 3 seconds).
- Bounded asynchronous worker queue with configurable concurrency; no browser-side ping loop per device.
- Live dashboard, filters, device details drawer, graphs, packet events, branch health, network path view, alerts and CSV export.
- SQLite persistence in `config/ping_monitor.db` on the monitoring agent machine.
- Raw results retained for recent history, then aggregated hourly/daily to limit database growth.
- Admin/Owner threshold settings in Settings.

## Start the monitoring agent
Run:

`START_ADAPTER.bat`

Keep the adapter window running while live monitoring is required. The web page connects to the adapter API and never performs ICMP directly from browser JavaScript.

## Add a device
Administration -> Ping Monitoring -> Add Device.

Required fields:
- Device name
- IP/hostname
- Device type

Optional topology fields:
- Branch
- Location
- OLT
- MikroTik
- Network segment
- Parent device

Monitoring:
- ICMP or TCP
- TCP port when TCP is selected
- Interval (3 seconds default)
- Warning latency threshold
- Critical latency threshold
- Packet-loss alert threshold

## Default thresholds
- 0-50 ms: Good
- 51-100 ms: Warning
- 101-200 ms: High Latency
- 200+ ms: Critical
- 100% loss / failed check: Offline

Thresholds can be changed by Owner/Admin from Settings. Existing enabled devices can optionally receive the new defaults.

## Alerts
The agent creates alerts for:
- Three consecutive failed checks / device offline
- Recovery / back online
- High or critical latency
- Packet loss above the configured threshold
- Multiple devices in the same branch offline

Active alerts appear in the dashboard notification panel.

## Accuracy rule
If the monitoring agent is unavailable or a device has not been checked yet, the dashboard displays an unavailable/not-checked state. It does not fabricate ping, packet loss, online or uptime values.

## Security
The adapter supports `ADAPTER_API_KEY` as an optional Bearer token. For deployments where the adapter is reachable beyond localhost, configure an API key and restrict firewall access to the management server/network.
