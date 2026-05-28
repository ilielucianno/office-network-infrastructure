# Weekly Progress Report: May 25 – May 31, 2026

## Network Reconfiguration & Disaster Recovery Drill

**Author:** Ilie Lucian
**Scope:** Complete MikroTik router reconfiguration from factory defaults

### 1. Overview
This week, as part of a disaster recovery drill and knowledge refresh, the MikroTik router (hAP ac²) was reset to factory settings and fully reconfigured from scratch. All existing configurations (VLANs, firewall, DHCP, NAT, port forwarding) were reapplied manually via WebFig.

### 2. Actions Completed

#### 2.1. MikroTik Router (hAP ac²) – Full Reconfiguration

**Initial State:**
- Router reset to factory defaults
- Internet cable connected to ether1 (WAN)
- Main switch connected to ether3
- Server connected to switch

**Configuration Steps (all via WebFig):**

| Step | Configuration |
|------|---------------|
| 1 | Changed admin password |
| 2 | Renamed ether1 to "WAN" |
| 3 | Added DHCP client on WAN interface |
| 4 | Created bridge-LAN with VLAN Filtering enabled |
| 5 | Added ether3 to bridge-LAN |
| 6 | Created VLANs: 10 (HR), 20 (Support), 30 (Server) |
| 7 | Assigned IP addresses: 192.168.10.1/24, 192.168.20.1/24, 192.168.30.1/24 |
| 8 | Configured DHCP servers for each VLAN (lease time 1 day, DNS 8.8.8.8,1.1.1.1) |

**Firewall Rules (in order):**

| Order | Rule | Action |
|-------|------|--------|
| 1 | Established/related connections | Accept |
| 2 | HR → Server | Accept |
| 3 | VPN → HR & Server | Accept |
| 4 | Support → HR | Drop |
| 5 | Support → Server | Drop |
| 6 | HR → Support | Drop |
| 7 | All inter-VLAN traffic | Drop |

**NAT & DNS:**
- Added NAT masquerade for internet access
- Enabled DNS Allow Remote Requests

#### 2.2. WireGuard Port Forwarding (to OPNsense VM)

| Rule Type | Configuration |
|-----------|---------------|
| DNAT | chain=dstnat, protocol=udp, dst-port=51820, action=dst-nat, to-addresses=192.168.30.10, to-ports=51820 |
| Filter | chain=input, protocol=udp, dst-port=51820, action=accept |
| Static Route | dst-address=10.0.0.0/24, gateway=192.168.30.10 |

**Result:** WireGuard connection tested successfully from external network.

#### 2.3. Switch Configuration (TP-Link TL-SG108E)

- Port mirroring (SPAN) verified active
- Mirror destination: Server port
- Mirror source: Router port
- Purpose: DarkGhost NDR monitors all inter-VLAN traffic

### 3. Testing Results

| Test | Result |
|------|--------|
| Device in VLAN 10 receives IP | Pass |
| Device in VLAN 20 receives IP | Pass |
| Device in VLAN 30 receives IP | Pass |
| Internet access from any VLAN | Pass |
| Support → HR traffic | Blocked |
| Support → Server traffic | Blocked |
| HR → Server traffic | Allowed |
| WireGuard connection | Pass |

### 4. Current System State (May 31, 2026)

| Component | Status |
|-----------|--------|
| MikroTik router | Configured, backup saved |
| VLANs (10,20,30) | Operational |
| Firewall isolation | Verified |
| Port mirroring | Active |
| WireGuard | Reachable from internet |
| DHCP servers | Running |
| Internet access | Working |

### 5. Notes

- WebFig was used for all configurations (no WinBox required)
- WireGuard remains on OPNsense VM by design
- Configuration backup saved to Files section

---
**Date:** May 31, 2026
