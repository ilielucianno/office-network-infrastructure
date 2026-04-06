# Network Diagram

This document describes the logical and physical network architecture of the office infrastructure.

Last updated: **April 6, 2026**

---

## Physical Topology

**Level 1:** Internet → MikroTik Router → TP-Link TL-SG108E (Backbone)

**Level 2 (Backbone ports):**
- Port 2 → Server
- Port 3 → WiFi AP
- Port 4 → HR Room Switch (TL-SG105)
- Port 5 → Consultancy Room Switch (TL-SG105)
- Port 6 → Spare

**Level 3 (HR Room - TL-SG105):**
- HR PC1 | HR PC2 | HR Printer

**Level 3 (Consultancy Room - TL-SG105):**
- IT Laptop | Consultancy 1 | Consultancy 2

---

## New Architecture (April 6, 2026)

The network has been restructured from a "router-centric" design to a **star topology** with a dedicated backbone switch.

### Before (Old Setup):
- All devices connected directly to the MikroTik router (only 5 ports)
- Router was overloaded with cabling
- Difficult to expand

### After (New Setup):
- **Backbone switch (TL-SG108E)** handles all internal traffic
- Router only connects to backbone switch (1 cable)
- Each room has its own small switch (TL-SG105)
- Clean, professional, expandable

---

## Logical Topology (VLANs)

| VLAN ID | Name | Subnet | Gateway | Purpose |
|---------|------|--------|---------|---------|
| 10 | HR | 192.168.10.0/24 | 192.168.10.1 | HR workstations, printer, accountant |
| 20 | Support | 192.168.20.0/24 | 192.168.20.1 | Support team laptops (internet only) |
| 30 | Server | 192.168.30.0/24 | 192.168.30.1 | Odoo server, database |

*Note: VLAN configuration remains on the MikroTik router. The TP-Link switches currently operate in default mode (all ports same VLAN). Future VLAN implementation is possible on the TL-SG108E.*

---

## Wireless SSIDs

| SSID | VLAN | Access | Users |
|------|------|--------|-------|
| Company-HR | 10 | Server + Internet | HR staff, Accountant |
| Company-Support | 20 | Internet only | Support agents |

**WiFi Isolation:** Client Device Isolation is enabled on Company-Support WiFi.

WiFi is provided by **Ubiquiti UniFi 6 Plus** connected to the backbone switch (Port 3).

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
| Backbone Switch | 192.168.10.2 (optional, for management) | - |
| HR PCs | 192.168.10.x (DHCP) | - |
| HR Printer | 192.168.10.x (DHCP/reserved) | - |
| Support Laptops | 192.168.20.x (DHCP) | - |
| VPN Clients | 10.10.10.x (static per client) | - |

---

## Cabling Issues & Resolution

During installation:
- Two Cat6 cables were found to be faulty (too short and intermittent connectivity)
- Both were replaced with new Cat6 cables
- After replacement, all connections worked immediately

**Lesson learned:** Always test cables before final routing. Faulty cables can cause intermittent issues that are hard to debug.

---

## Key Design Decisions

1. **Star topology** – Backbone switch centralizes all internal traffic
2. **Router offload** – Router only handles routing, firewall, VPN (not switching)
3. **Room-level switches** – Easy to add new devices in each room
4. **Managed backbone** – TL-SG108E allows future VLAN implementation
5. **Unmanaged room switches** – Simple, reliable, no configuration needed

---

## Diagram Files

A visual diagram can be created using tools like:
- **draw.io** – free online diagram tool
- **Lucidchart** – professional diagrams
- **Visio** – Microsoft's diagram software
