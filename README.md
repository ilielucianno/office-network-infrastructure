# Office Network Infrastructure with VLAN Segmentation & VPN Access

## Overview

This project documents the complete setup of a secure office network for a small company (3 HR offices + 10-15 remote support agents). The infrastructure implements enterprise-grade security practices including VLAN isolation, firewall rules, VPN access, and a self-hosted HR management system.

The business operates online casinos (branded separately, no connection to this infrastructure). All financial operations (withdrawals, bonuses) are protected by additional layers: 2FA on Zoho, IP verification, 7-21 day withdrawal delays, and manual approval by owners.

---

## Upgrade History

This infrastructure started on a budget Mini PC (Intel N100, 16GB RAM) and was later upgraded to a more powerful server to handle multiple VMs and security services.

### Original Server (2023 - 2026)
- **Model:** Mini PC Intel N100
- **RAM:** 16GB (soldered, not upgradeable)
- **Storage:** 512GB SSD
- **Cost:** ~€300
- **Limitation:** Could not run all services (Wazuh + OPNsense VM + DarkGhost + SQL Detector) simultaneously due to RAM constraints.

### Current Server (2026 - present)
- **Model:** Geekom A9 Max
- **CPU:** AMD Ryzen AI 9 HX 370 (12 cores, much more powerful than N100)
- **RAM:** 32GB DDR5
- **Storage:** 1TB NVMe SSD (upgradeable to 2TB)
- **Cost:** €1,140
- **Why upgraded:** Needed more RAM and CPU power to run OPNsense as VM alongside Wazuh, DarkGhost, and SQL Detector without performance issues.

All services were migrated using VirtualBox OVA export/import. The new server runs Ubuntu 22.04 LTS with SVM Mode enabled in BIOS for hardware virtualization.

---

## Server Architecture (All-in-One)

All security services run on the same physical server (Geekom A9 Max):

- Ubuntu Server 22.04 LTS (base OS)
- Wazuh SIEM (native service, port 443)
- DarkGhost NDR (Python script, port 8081)
- SQL Injection Detector (Python script, port 8082)
- OPNsense NGFW (runs as VirtualBox VM on the same server)

OPNsense runs as a virtual machine on the same Ubuntu server. This allows the NGFW to run without additional hardware.

---

## Key features

- Network segmentation — HR, Support, Server completely isolated with VLANs
- Full VLAN isolation — MikroTik router + switch with strict firewall rules
- WireGuard VPN — key-based authentication, unique keys per user
- Self-hosted Odoo HR system — employee database with 2FA
- Automated backups — daily database backups, 30-day retention
- Security hardening — UFW, Fail2Ban, Snort 3 IDS with community rules (low-memory mode)
- Operational security — 2FA on Zoho, withdrawal delays, manual approvals
- Odoo Accounting — invoices, payments, VAT reports for Cyprus
- Separate WiFi — HR + Accountant on VLAN 10, Support on VLAN 20 with client isolation
- SIEM monitoring — Wazuh centralizes logs from server, router, and Snort with email alerts
- NGFW — OPNsense (as VM) + Zenarmor for Layer 7 filtering and application control (added April 2026)
- NDR (Network Detection & Response) — DarkGhost NDR monitors mirrored traffic for anomalies, port scans, TTL spoofing, and lateral movement between VLANs (added May 2026)
- SQL Injection Detection — Real-time SQL injection detection using TensorFlow + Scapy + Flask (open-source Zenarmor alternative)

---

## Hardware List

| Component | Model | Price (€) | Notes |
|-----------|-------|-----------|-------|
| Router | MikroTik hAP ac² | ~65 | Firewall, VPN, VLAN routing |
| Backbone Switch | TP-Link TL-SG108E | ~30 | 8-port managed switch |
| HR Room Switch | TP-Link TL-SG105 | ~18 | 5-port unmanaged |
| Consultancy Switch | TP-Link TL-SG105 | ~18 | 5-port unmanaged |
| WiFi AP | Ubiquiti UniFi 6 Plus | ~110 | Wireless access |
| **Main Server (current)** | **Geekom A9 Max (AMD Ryzen AI 9, 32GB RAM, 1TB SSD)** | **~1,140** | **Runs Ubuntu + Wazuh + DarkGhost + SQL Detector + OPNsense VM** |
| Backup Server (retired) | Mini PC Intel N100 (16GB RAM, 512GB SSD) | ~300 | Original server (2023-2026), kept for backup |
| Printer | HP LaserJet MFP 135a | ~130 | HR printing |
| Cables | Cat6 + accessories | ~80 | Cabling |
| **Total (current hardware)** | | **~1,600** | |

**All components purchased with official invoices from EU suppliers (Amazon ES, Senetic, Bionic, Skroutz).**

**Timeline:**
- Dec 2025: Backbone switch architecture implemented.
- Jan 2026: OPNsense deployed as VM on the server.
- April 2026: DarkGhost integrated with port mirroring.
- April 2026: Server upgraded from Intel N100 to Geekom A9 Max.

---

## Network Architecture

Internet -> MikroTik Router -> TP-Link Switch -> HR / Support / Server / WiFi / VPN

- VLAN 10: HR (192.168.10.0/24)
- VLAN 20: Support (192.168.20.0/24)
- VLAN 30: Server (192.168.30.0/24)

Traffic visibility:
A SPAN (port mirroring) session is configured on the TP-Link TL-SG108E switch. All traffic between VLANs is copied to the server port where DarkGhost NDR performs real-time anomaly detection.

OPNsense VM network:
OPNsense has two virtual network interfaces:
- WAN: Bridged to the physical network (receives an IP from the main router)
- LAN: Internal network for management (OPNsense WebGUI at https://192.168.100.1)

---

## Firewall Rules

- HR -> Server: ALLOWED
- HR -> Support: DENIED
- Support -> HR: DENIED
- Support -> Server: DENIED
- VPN -> Server: ALLOWED
- VPN -> HR: ALLOWED

---

## Technologies Used

- Routing and Firewall: MikroTik RouterOS (VLAN, firewall, NAT)
- Switching: TP-Link TL-SG108E (VLAN trunking, port mirroring)
- VPN: WireGuard
- Server OS: Ubuntu Server 22.04 LTS
- Virtualization: VirtualBox (OPNsense VM)
- Database: MariaDB
- HR System: Odoo (self-hosted)
- Security: UFW, Fail2Ban, 2FA (Google Authenticator)
- Backup: Automated cron jobs + MySQL dumps
- IDS/IPS: Snort 3 (low-memory mode), OPNsense + Zenarmor
- NDR: DarkGhost NDR – anomaly detection, port scan, TTL spoofing, lateral movement
- SQL Injection Detection: SnortML (TensorFlow + Scapy + Flask)
- SIEM: Wazuh

---

## Security Detection Layers

| Layer | Tool | Detection Type | Where It Runs |
|-------|------|----------------|---------------|
| Network IDS | Snort 3 | Signature-based (known attacks) – low-memory mode | Ubuntu (native) |
| NGFW / IPS | OPNsense + Zenarmor | Layer 7 filtering, application control | VirtualBox VM on same server |
| NDR | DarkGhost | Behavioral anomalies, zero-day, port scan, spoofing | Ubuntu (native) |
| Web App | SQL Injection Detector | SQL injection in HTTP traffic | Ubuntu (native) |
| SIEM | Wazuh | Centralized logs, correlation, alerts | Ubuntu (native) |

---

## Services and Access

| Service | Access | Port | Runs on |
|---------|--------|------|---------|
| Wazuh Dashboard | https://192.168.30.10 | 443 | Ubuntu (native) |
| DarkGhost NDR | http://192.168.30.10:8081 | 8081 | Ubuntu (native) |
| SQL Detector | http://192.168.30.10:8082 | 8082 | Ubuntu (native) |
| OPNsense WebGUI | https://192.168.100.1 | 443 | VirtualBox VM |
| Odoo HR | https://odoo.office.local | 8069 | Ubuntu (native) |

---

## Setup Guides

The complete step-by-step documentation is available in the setup-guides/ folder:

1. Hardware Setup
2. Router Configuration
3. Switch and VLAN Configuration
4. Port Mirroring for NDR
5. WiFi Setup (Ubiquiti)
6. Server Installation (Ubuntu)
7. Odoo Installation and HR Configuration
8. WireGuard Client Setup
9. 2FA and Backup
10. IDS Setup (Snort 3) – low-memory mode
11. Wazuh SIEM Setup
12. OPNsense + Zenarmor NGFW Setup (as VM)
13. DarkGhost NDR Setup
14. SQL Injection Detector Setup (SnortML)

---

## Migration Notes (from N100 to Geekom A9 Max)

When upgrading from the old Intel N100 server (2023-2026) to the new Geekom A9 Max:

1. **Exported all VirtualBox VMs** as .ova files from the old server
2. **Installed Ubuntu 22.04 LTS** on the new Geekom
3. **Enabled SVM Mode** in BIOS (AMD virtualization, equivalent to Intel VT-x)
4. **Imported all .ova files** into VirtualBox on the new server
5. **Reconfigured static IPs** for the Ubuntu host and all VMs (took extra time due to driver differences)
6. **Reinstalled necessary packages** (scapy, flask, tensorflow, etc.) in the Python virtual environments

Total migration time was approximately 2-3 days due to driver configuration and IP reassignment.

---

## Configuration Files

All configuration files are available in the configs/ folder:

- configs/mikrotik/router-config.rsc – Full MikroTik configuration
- configs/mikrotik/firewall-rules.rsc – Firewall rules only
- configs/mikrotik/wireguard-config.rsc – WireGuard server config
- configs/server/ufw-rules.sh – UFW setup script
- configs/server/fail2ban-config.sh – Fail2Ban configuration
- configs/server/backup-script.sh – Automated backup script
- configs/switch/port-mirroring.txt – TP-Link port mirroring configuration
- configs/snort/low-memory.conf – Snort low-memory mode settings

---

## Quick Reference

For daily operations and troubleshooting, see the CHEATSHEET.md.

---

## Key Security Implementations

### Network and Infrastructure

| Measure | Implementation |
|---------|----------------|
| Network Segmentation | VLANs separate HR, Support, Server – no lateral movement without explicit rules |
| Firewall Rules | MikroTik firewall blocks all inter-VLAN traffic except HR -> Server and VPN -> internal |
| VPN-Only Server Access | Odoo server is not exposed to internet – accessible only via WireGuard VPN or HR VLAN |
| WireGuard VPN | Key-based authentication, unique keys per user, IP tracking |
| Server Hardening | UFW firewall (allow only HR and VPN subnets), automatic security updates |
| Fail2Ban | Blocks brute-force attacks on SSH and Odoo |
| Intrusion Detection | Snort 3 IDS (low-memory mode) monitors traffic and logs alerts |
| Next-Generation Firewall | OPNsense VM + Zenarmor for Layer 7 filtering, application control, IPS |
| NDR | DarkGhost analyzes mirrored traffic for behavioral anomalies, port scans, and spoofing |
| SQL Injection Detection | SnortML detects SQL injection in real-time using TensorFlow |
| SIEM | Wazuh centralizes logs from server, OPNsense, Snort, and DarkGhost |
| Traffic Visibility | SPAN (port mirroring) on TP-Link switch sends all inter-VLAN traffic to DarkGhost |
| Backup | Daily automated database backups, 30-day retention |

### Operational and Access Control

| Measure | Implementation |
|---------|----------------|
| Zoho 2FA | Two-factor authentication for all Zoho accounts |
| IP-Based Verification | Zoho remembers trusted devices/IPs for 30 days – new IP triggers 2FA |
| User Roles | Owners (full access), Support (limited, no withdrawals), HR (server access only) |
| Withdrawal Protection | 7-21 day delay, daily review, manual approval by owners only |
| Password Policy | 12+ characters, unique, changed quarterly |
| WireGuard Key Management | Unique keys per user, spreadsheet tracking, immediate revocation on departure |
| Incident Response | Documented runbook for crypto breaches, suspicious logins, withdrawals |
| Offboarding Process | All accounts disabled immediately when employee leaves |
| Data Breach Monitoring | Google alerts for leaked credentials – immediate password reset |

---

## Why OPNsense as VM on the Same Server

Running OPNsense as a virtual machine on the same Ubuntu server allows:
- No extra hardware – the Geekom A9 Max is powerful enough (12-core AMD CPU, 32GB RAM)
- Centralized management – all security tools on one physical box
- Cost effective – no need to buy a separate firewall appliance
- Easy backups – the entire VM can be backed up and restored

The server has enough resources to run all services simultaneously:
- 12 CPU cores – more than sufficient for OPNsense + Ubuntu services
- 32GB RAM – allocated: 8GB to OPNsense VM, 24GB to Ubuntu
- 1TB SSD – enough for logs, alerts, and VM storage (upgradeable to 2TB)

---

## Lessons Learned

- VLAN filtering on MikroTik requires bridge VLAN filtering enabled – I initially missed this and spent hours troubleshooting.
- WireGuard setup is simple but key management must be organized – I created a spreadsheet for client keys.
- Odoo permissions are granular – I created two roles: HR Manager (full access) and HR Viewer (no salary data).
- 2FA in Odoo must be enabled per user – Not a global setting, so I had to configure each user manually.
- Running OPNsense as a VM on the existing server is possible but requires careful resource allocation. On the Geekom, I allocated 8GB RAM to OPNsense and left 24GB for Ubuntu.
- Snort can be set to low-memory mode to coexist with other services – I used detect engine profile to reduce RAM usage.
- Port mirroring (SPAN) is essential for NDR – Without it, DarkGhost only sees traffic to/from the server, not inter-VLAN traffic.
- **Server migration takes time** – Exporting VMs as .ova is fast, but reconfiguring IPs and drivers on the new hardware can take 2-3 days.

---

## Future Improvements

I am still learning, so I don't know exactly what comes next. Here's what I plan to explore:

What I Know I Want to Learn:
- Complete my certifications – Security+ and Network+ are my priority right now
- Understand monitoring tools – I've heard about tools that show network activity, but I need to learn them first
- Add offsite backup – Right now backups are local. I want to add cloud backup (Google Drive) for extra safety

How This Will Grow:
As I learn more, I will add new features to this network and document them here. This repository will evolve with my knowledge.

This is a learning project. I build what I learn.

---

## About Author

Ilie Lucian
Technical Department Manager with 10+ years in IT infrastructure, networking, and hardware.
SEC1 Certified (TryHackMe). Currently pursuing Security+ and Network+ certifications.

---

## Current Learning Path

I am actively building my cybersecurity knowledge while working full-time. This project is part of my hands-on learning journey.

Completed:
- TryHackMe Pre Security
- TryHackMe SEC0
- TryHackMe SEC1
- This project – full network infrastructure with VLANs, VPN, IDS, SIEM, NGFW, NDR, and SQL injection detection
- Server migration from Intel N100 to Geekom A9 Max (2023-2026)

In Progress:
- Network+ (CompTIA) – 50% completed
- Security+ (CompTIA) – started

Next Steps (Next 6 Months):
- Complete Security+ and Network+ certifications
- Start Cloud Security (AWS / Azure fundamentals)
- Document more operational procedures
- Upgrade server storage to 2TB if needed

Why I Built This:
I've been working in IT infrastructure for 10+ years, managing networks, hardware, and teams. Recently, I realized that what I was already doing (firewalls, VLANs, VPNs, incident response) has a name: cybersecurity. Now I'm formalizing my knowledge through certifications and documenting real projects to demonstrate my skills.

This repository is a living document of my cybersecurity journey.

---

## License

This project is licensed under the MIT License – feel free to use and adapt for your own infrastructure.
