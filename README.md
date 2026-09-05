# NetFlow ISP - Public OLT Monitoring

This build is preconfigured for direct LAN monitoring of the VSOL OLT:

- OLT LAN host: `192.168.8.100`
- SNMP: UDP `161`
- SNMP version: `v2c`
- Read-only community: `public`
- Web UI: `http://38.68.84.52:308`
- Adapter: local FastAPI/Uvicorn, read-only SNMP GET/GETBULK

## Start

1. Install Python 3.13.
2. Double-click `START_ADAPTER.bat` and keep the black window open.
3. If you open `index.html` directly as a `file://` page, the dashboard automatically talks to the local adapter at `http://127.0.0.1:8080`.
4. Prefer opening `http://127.0.0.1:8080/` when using live OLT monitoring; this guarantees the dashboard and adapter are on the same origin.
5. The preconfigured `main-olt` uses `192.168.8.100:161`, SNMP v2c, community `public`.
6. For a LAN test, use the OLT Adapter page and run the SNMP connection test. The adapter must be running on the same PC that is connected to the OLT by LAN.

No SNMP SET/write operations are implemented.

## V23 Added Business Functions
- Excel/CSV import and export (existing feature expanded in the dashboard)
- WhatsApp/SMS customer communication center (WhatsApp prefilled links and SMS composer; gateway-ready)
- OLT/ONU information and live read-only telemetry (existing VSOL adapter integration)
- API Integrations / Webhook configuration page
- Automatic browser backup snapshots + JSON download/restore
- Audit Logs with export to CSV

## Ping Monitoring
- Administration → Ping Monitoring
- Real server-side ICMP/TCP checks, default 3-second interval
- Live device table, ping/loss graph, packet activity, branch health and network-path view
- Offline/recovery/high-latency/packet-loss/branch-outage alerts
- Persistent `config/ping_monitor.db` with retention and hourly/daily aggregation
- Owner/Admin threshold settings and optional bulk application to existing devices
- Monitoring report CSV export

See `PING_MONITORING_SETUP.md` for setup and operation details.

## Professional Ping Monitoring
See `PING_MONITORING_SETUP.md` for the complete real ICMP/TCP monitoring module, 3-second worker scheduler, historical retention, alerts, topology mapping and security setup.

## Fiber Mapping & Calculation
- Sidebar now includes **Fiber** with **Fiber Mapping** and **Fiber Calculation**.
- Fiber Mapping stores POP/OLT/MikroTik/splitter/joint/ONU/customer nodes and fiber segments, including planning loss.
- Fiber Calculation computes fiber attenuation, splitter insertion loss, splice/joint loss, connector loss, engineering margin, total optical loss and estimated receive power.
- Typical splitter values are provided as editable planning defaults; replace them with actual datasheet values for production planning.
- Mapping/calculation data is stored in the existing application data model and participates in the existing local/cloud sync mechanism.
