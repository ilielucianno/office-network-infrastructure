# Weekly Progress Report: May 25 – May 31, 2026

## Complete Network Reconfiguration & Disaster Recovery Drill

**Author:** Ilie Lucian
**Scope:** Full MikroTik router reconfiguration, network topology optimization, and switch setup.

### 1. Overview
This week, as part of a planned disaster recovery drill and knowledge refresh, the entire office network was decommissioned and rebuilt from scratch. All configurations were reapplied manually via WebFig, and the physical topology was optimized for better network visibility (NDR/SPAN).

### 2. Actions Completed

#### 2.1. Physical Topology Change
- **Before:** Server was connected directly to Router (ether2), limiting traffic visibility for DarkGhost NDR.
- **After:** Migrated the main server to the managed switch (TP-Link TL-SG108E). Port ether2 on the router is now reserved.
- **Result:** The server can now receive mirrored traffic (SPAN) from all network segments.

#### 2.2. MikroTik Router (hAP ac²) – Full Reconfiguration
Reset the router to factory settings and reconfigured all services via WebFig (browser interface), without using WinBox due to the Linux-based environment.

**Steps executed on the router:**
1.  **WAN Setup:** Renamed `ether1` to `WAN`, configured DHCP client on WAN.
2.  **Bridge & VLANs:**
    - Created `bridge-LAN` with **VLAN Filtering enabled** (critical for inter-VLAN routing).
    - Added `ether3` (connected to main switch) to the bridge.
    - Created VLANs: 10 (HR), 20 (Support), 30 (Server).
3.  **IP & DHCP:**
    - Assigned gateways: `192.168.10.1/24`, `192.168.20.1/24`, `192.168.30.1/24`.
    - Configured DHCP servers for each VLAN with lease time 1 day and DNS `8.8.8.8,1.1.1.1`.
4.  **Firewall Rules (Inter-VLAN Isolation):**
    - Rule 1: Accept established/related.
    - Rule 2: Allow HR → Server.
    - Rule 3: Allow VPN (future) → HR & Server.
    - Rule 4: Block Support → HR.
    - Rule 5: Block Support → Server.
    - Rule 6: Block HR → Support.
    - Rule 7: Block all inter-VLAN traffic by default.
5.  **NAT & DNS:**
    - Added NAT masquerade for internet access (srcnat, out-interface=WAN).
    - Enabled DNS "Allow Remote Requests".
6.  **WireGuard Port Forwarding:**
    - DNAT rule: UDP `dst-port=51820` → `to-addresses=192.168.30.10` (OPNsense VM).
    - Filter rule: Allow UDP 51820 on `input` chain.

#### 2.3. TP-Link Switch (TL-SG108E) – Port Mirroring (SPAN)
- **Purpose:** Enable DarkGhost NDR to monitor all inter-VLAN and lateral traffic.
- **Configuration:**
    - Accessed switch via `192.168.0.1` (static IP on laptop).
    - Activated `Port Mirroring` in `Advanced` menu.
    - Source Port: Port connected to Router (monitor all traffic).
    - Destination Port: Port connected to the Ubuntu Server (DarkGhost).

#### 2.4. Connectivity & VPN Validation
- **WireGuard VPN:** Tested successfully from an external guest network. Connection established via OPNsense VM (running on the server), using the port forwarding rule configured on MikroTik.
- **Internal Devices:** Verified that devices receive correct IPs from their respective VLAN DHCP pools.

### 3. Tools & Interfaces Used
| Tool | Purpose |
| :--- | :--- |
| **WebFig** | 100% of router configuration (browser-based, no WinBox due to Ubuntu environment). |
| **RouterOS Terminal** | Not used. All changes applied via WebFig GUI. |
| **TP-Link Web Interface** | Port mirroring configuration. |
| **Ubuntu Server** | Hosting OPNsense VM (WireGuard) and DarkGhost NDR. |

### 4. Lessons Learned / Reaffirmed
1.  **Bridge VLAN Filtering:** This must be enabled on the main bridge before VLANs can pass traffic correctly.
2.  **Port Mirroring:** For effective NDR, the server must be connected to the **switch** (not the router) and the switch must mirror all traffic to that port.
3.  **Router vs. Firewall VM:** Keeping WireGuard on OPNsense (behind a port forward on MikroTik) is cleaner than hosting it on the router, especially when the server already runs multiple security services.
4.  **WebFig is sufficient:** No feature required for this production network was missing in WebFig compared to WinBox. The interface is fully capable for VLAN, firewall, NAT, and port forwarding configurations.

### 5. Current State (as of May 31, 2026)
| Component | Status |
| :--- | :--- |
| MikroTik Router | ✅ Fully reconfigured, backed up |
| VLANs (10,20,30) | ✅ Operational |
| Firewall Isolation | ✅ Verified (Support → HR blocked) |
| Port Mirroring | ✅ Active on TP-Link switch |
| WireGuard (via OPNsense) | ✅ Reachable from internet |
| Server (Ubuntu) | ✅ Connected to switch port 8 (mirror destination) |
| Internet Access | ✅ Working on all VLANs |

### 6. Next Steps (Planned)
- Offsite backup testing (Google Drive).
- Complete Shuffle SOAR automation workflows.
- Document full DR runbook with RTO < 1h.

### 7. Notes for the Repository
- Configuration files (`.rsc`, `.txt`) are up-to-date in `configs/`.
- The new physical topology is reflected in `docs/network-diagram.md` (to be updated).

---
**Prepared by:** Ilie Lucian  
**Date:** May 31, 2026  
**Related documentation:** `PENDING-TASKS.md`, `CHEATSHEET.md`
