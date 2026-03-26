# Network Diagram

This document describes the logical and physical network architecture of the office infrastructure.

---

## Physical Topology

Internet → MikroTik Router (ether1 = WAN, ether2-5 = LAN) → MikroTik Switch (port1 = trunk from router, ports 2-9 = access)

Switch Ports:
- Port 2: HR PC1
- Port 3: HR PC2
- Port 4: Accounting PC3 
- Port 5: HR Printer
- Port 6: Support Laptop 1
- Port 7: Support Laptop 2
- Port 8: Support Laptop 3
- Port 9: Server (DB + Odoo)
- Port 10: WiFi AP (Ubiquiti UniFi 6 Plus)

---

## Logical Topology (VLANs)

| VLAN ID | Name | Subnet | Gateway | Purpose |
|---------|------|--------|---------|---------|
| 10 | HR | 192.168.10.0/24 | 192.168.10.1 | HR workstations, printer, accountant |
| 20 | Support | 192.168.20.0/24 | 192.168.20.1 | Support team laptops (internet only) |
| 30 | Server | 192.168.30.0/24 | 192.168.30.1 | Odoo server, database |

---

## Wireless SSIDs

| SSID | VLAN | Access | Users |
|------|------|--------|-------|
| Company-HR | 10 | Server + Internet | HR staff, Accountant |
| Company-Support | 20 | Internet only | Support agents |

**WiFi Isolation:** Client Device Isolation is enabled on Company-Support WiFi. Laptops on this network cannot see each other.

WiFi is provided by **Ubiquiti UniFi 6 Plus** connected to the switch (port 10, trunk with VLAN 10 and 20).

---

## VPN Access (WireGuard)

Remote users (10-15 support agents + admin) connect via WireGuard VPN:

Remote Client (WireGuard) → Internet → MikroTik Router (WireGuard server on port 13231) → VPN Tunnel (10.10.10.0/24) → Server (192.168.30.10) → Odoo HR System (port 8069)

**VPN Subnet:** 10.10.10.0/24
**Server Address:** 10.10.10.1 (router)
**Client Addresses:** 10.10.10.2 to 10.10.10.254

---

## Firewall Rules

| Rule | Action |
|------|--------|
| HR → Server | ALLOWED |
| HR → Support | DENIED |
| Support → HR | DENIED |
| Support → Server | DENIED |
| VPN → Server | ALLOWED |
| VPN → HR | ALLOWED |

---

## IP Addressing Summary

| Device / Network | IP Address | Interface |
|------------------|------------|-----------|
| Router (WAN) | DHCP from ISP | ether1 |
| Router (VLAN 10) | 192.168.10.1 | vlan10-hr |
| Router (VLAN 20) | 192.168.20.1 | vlan20-support |
| Router (VLAN 30) | 192.168.30.1 | vlan30-server |
| Router (VPN) | 10.10.10.1 | wg0 |
| Server | 192.168.30.10 (static) | eth0 |
| HR PCs | 192.168.10.x (DHCP) | - |
| HR Printer | 192.168.10.x (DHCP/reserved) | - |
| Support Laptops | 192.168.20.x (DHCP) | - |
| VPN Clients | 10.10.10.x (static per client) | - |

---

## Odoo Roles

| Role | Access |
|------|--------|
| HR Manager | Employee data, contracts, salaries |
| Accountant | Invoices, payments, VAT reports, bank accounts |
| Admin | Full access, user management |

---

## Key Design Decisions

1. Server is on VLAN 30, accessible only from HR VLAN and VPN. Not exposed to internet.

2. Support team cannot access HR data or server. They only have internet access.

3. All remote employees connect via WireGuard. No port forwarding to server.

4. Router handles routing, firewall, DHCP, and VPN. Switch handles VLAN tagging.

5. Two SSIDs mapped to VLAN 10 and VLAN 20 keep wireless traffic isolated. Support WiFi has client isolation enabled.

6. Accountant has access to Odoo Accounting module through HR WiFi.

---

## Diagram Files

A visual diagram can be created using tools like draw.io, Lucidchart, or Visio.
