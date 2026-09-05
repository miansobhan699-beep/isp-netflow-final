# NetFlow ISP — MikroTik Management V31

MikroTik is integrated under **Network / OLT** with role-based access.

## Ready now, even without a router

The adapter has a **Demo / Test mode**. It returns realistic RouterOS-style data for:

- Router resources (CPU, memory, uptime, identity)
- Interfaces and traffic counters
- Active PPPoE sessions
- DHCP leases
- IP addresses, routes and ARP
- Firewall filter rules and NAT rules
- Simple queues / bandwidth
- Hotspot active sessions
- Router logs
- RouterOS identity, DNS and NTP
- Backup list

Demo write actions are safe no-op responses so the UI can be tested without a real MikroTik.

## When a real MikroTik becomes available

Open **Network / OLT → MikroTik Dashboard → Router Settings** and choose **Real MikroTik**.

Supported connection modes:

- RouterOS API: TCP 8728
- RouterOS API-SSL: TCP 8729 (select RouterOS API and use port 8729)
- RouterOS REST: HTTP/HTTPS REST endpoint (commonly 80/443)

Create a dedicated RouterOS management user. Do not expose API ports to the public Internet; allow only the adapter/server IP to reach the management port.

The dashboard sends credentials to the local/server-side adapter. The browser does not store the MikroTik password in localStorage.

## Management actions

The adapter is prepared for:

- Enable/disable interfaces
- Disconnect active PPPoE sessions
- Change simple queue speed limits
- Edit firewall filter rules
- Edit NAT rules
- Edit DHCP leases
- Create backups
- RouterOS identity / DNS / NTP changes
- Reboot endpoint (protected action; only expose to authorized admin roles)

## Retail ISP role

Retail ISP accounts keep **OLT/ONU monitoring only**. MikroTik configuration is blocked by application permission, not merely hidden from the menu.

Owner/Admin/Manager can access MikroTik management according to the role matrix in the application.
