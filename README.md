markdown# Office Network Infrastructure

**Secure office network with VLAN segmentation, WireGuard VPN, and self-hosted Odoo HR system.**

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

---

## Overview

This project documents a complete, production-ready office network for a small company (3 HR offices + 10-15 remote support agents). It implements enterprise-grade security on a budget of ~€1,600.

- **VLAN isolation** – HR, Support, Server completely separated
- **WireGuard VPN** – key-based, unique keys per user
- **Full security stack** – IDS, NGFW, NDR, SIEM, SOAR
- **Self-hosted Odoo** – HR system with 2FA
- **Automated backups** – daily local + weekly external encrypted

> The business operates online casinos (branded separately, no connection to this infrastructure). Financial operations are protected by 2FA, IP verification, withdrawal delays, and manual approval by owners.

---

## Network Architecture

```text
Internet → MikroTik Router → TP-Link Switch → HR / Support / Server / WiFi / VPN
```

| VLAN | Name | Subnet | Purpose |
|------|------|--------|---------|
| 10 | HR | 192.168.10.0/24 | HR, Accounting, WiFi |
| 20 | Support | 192.168.20.0/24 | Remote agents, office support |
| 30 | Server | 192.168.30.0/24 | Ubuntu server with all security tools |

### Firewall Rules

| Source | Destination | Action |
|--------|-------------|--------|
| HR | Server | ALLOWED |
| HR | Support | DENIED |
| Support | HR | DENIED |
| Support | Server | DENIED |
| VPN | Server | ALLOWED |
| VPN | HR | ALLOWED |

### Traffic Visibility

A **SPAN session (port mirroring)** on the TP-Link switch copies all inter-VLAN traffic to the server, enabling DarkGhost NDR to detect lateral movement, port scans, and behavioral anomalies — including traffic that never touches the server directly.

---

## Hardware (Total ~€1,600)

| Component | Model | Cost | Notes |
|-----------|-------|------|-------|
| Router | MikroTik hAP ac² | ~€65 | Firewall, VPN, VLAN routing |
| Backbone Switch | TP-Link TL-SG108E (managed) | ~€30 | 8-port, SPAN/port mirroring |
| Access Switches | 2× TP-Link TL-SG105 (unmanaged) | ~€36 | HR room + Consultancy |
| WiFi AP | Ubiquiti UniFi 6 Plus | ~€110 | Wireless access |
| **Main Server** | **Geekom A9 Max (AMD Ryzen AI 9, 32GB RAM, 1TB SSD)** | **~€1,140** | All services |
| Backup Server | Mini PC Intel N100 (on standby) | ~€300 | Disaster recovery |
| Printer | HP LaserJet MFP 135a | ~€130 | HR printing |
| Cables | Cat6 + accessories | ~€80 | Cabling |

> **Server Upgrade History:** Started on Intel N100 (2023–2026), migrated to Geekom A9 Max (April 2026) for more RAM and CPU to run OPNsense VM alongside all other services. See [docs/migration-notes.md](docs/migration-notes.md).

All components purchased with official invoices from EU suppliers (Amazon ES, Senetic, Bionic, Skroutz).

---

## Security Stack (7 Detection Layers)

| Layer | Tool | Detection Type | Runs on |
|-------|------|----------------|---------|
| NGFW / IPS | OPNsense + Zenarmor | Layer 7 filtering, app control | VirtualBox VM |
| Network IDS | Snort 3 | Signature-based (low-memory mode) | Ubuntu native |
| NDR | DarkGhost | Behavioral anomalies, zero-day, port scans | Ubuntu native |
| Web App | SnortML (TensorFlow) | SQL injection – real-time ML | Ubuntu native |
| SIEM | Wazuh | Log centralization, correlation, alerts | Ubuntu native |
| Active Response | Wazuh + iptables | Automatic SSH brute-force blocking | Ubuntu native |
| SOAR | Shuffle | Alert automation, webhooks | Docker |

### Custom-Built Security Tools

**DarkGhost NDR** – Anomaly-based behavioral detection system inspired by Darktrace. Monitors all network traffic via SPAN port mirroring, builds behavioral baselines per IP/device, and detects port scans, lateral movement, and unusual connection patterns. Real-time alerts via Flask dashboard.

**SnortML** – ML-powered SQL injection detector built with TensorFlow + Scapy + Flask. Real-time packet inspection, model accuracy 100%, TensorFlow 2.21.0.

Both tools are publicly available on GitHub: [ilielucianno](https://github.com/ilielucianno)

### Service Access URLs

| Service | URL | Port |
|---------|-----|------|
| Wazuh Dashboard | `https://192.168.30.10` | 443 |
| DarkGhost NDR | `http://192.168.30.10:8081` | 8081 |
| SQL Detector | `http://192.168.30.10:8082` | 8082 |
| OPNsense WebGUI | `https://192.168.100.1` | 443 |
| Odoo HR | `https://odoo.office.local` | 8069 |
| Shuffle SOAR | `https://192.168.30.10:3443` | 3443 |

---

## Security Implementation

### Network & Infrastructure

| Measure | Implementation |
|---------|----------------|
| Network Segmentation | VLANs separate HR, Support, Server |
| Firewall Rules | MikroTik blocks all inter-VLAN traffic except explicit allow rules |
| VPN-Only Server Access | Odoo not exposed to internet — WireGuard VPN or HR VLAN only |
| WireGuard VPN | Key-based authentication, unique keys per user |
| Server Hardening | UFW firewall, automatic security updates |
| Fail2Ban | Blocks brute-force on SSH and Odoo |
| Intrusion Detection | Snort 3 IDS (signature) + DarkGhost NDR (behavioral) |
| NGFW | OPNsense + Zenarmor — Layer 7 filtering, IPS |
| SIEM | Wazuh — log centralization, active response, email alerts |
| Audit Logging | auditd monitors `/etc/passwd`, `/etc/shadow`, `/home` |
| Backup | Daily local + weekly external encrypted |

### Operational & Access Control

| Measure | Implementation |
|---------|----------------|
| Zoho 2FA | Two-factor authentication for all accounts |
| IP-Based Verification | New IP triggers 2FA |
| User Roles | Owners (full), Support (limited, no withdrawals), HR (server only) |
| Withdrawal Protection | 7–21 day delay, manual approval by owners only |
| Password Policy | 12+ characters, unique, changed quarterly |
| WireGuard Key Management | Unique keys per user, spreadsheet tracking, immediate revocation |
| Incident Response | Documented runbook, tested |
| Offboarding | All accounts disabled immediately on departure |

### Physical Security

| Measure | Status |
|---------|--------|
| First door – card access | Implemented |
| Second door – code access | Implemented |
| Cameras (hall, entrance, outside, inside) | Implemented |
| Separate server room | Implemented |
| Guest area isolated (separate ISP) | Implemented |
| Server room access – technical department only | Implemented |

---

## Threat Mitigation Summary

| Threat | Mitigation |
|--------|------------|
| Compromised support laptop | VLAN isolation – cannot reach HR or Server |
| Brute-force SSH attack | Fail2Ban + Wazuh Active Response |
| Zero-day or unusual behavior | DarkGhost NDR behavioral baseline |
| SQL injection on web apps | SnortML real-time ML detection |
| Phishing / compromised Zoho | 2FA + IP verification + withdrawal delay |
| Malware / malicious website | OPNsense + Zenarmor Layer 7 filtering |
| Lateral movement between VLANs | SPAN mirroring → DarkGhost detects instantly |

---

## Repository Structure

```text
office-network-infrastructure/
├── configs/
│   ├── mikrotik/          # RouterOS configs (router, firewall, WireGuard)
│   ├── server/            # UFW, Fail2Ban, backup script
│   ├── switch/            # Port mirroring config
│   └── operations/        # Security policies, incident runbook
├── docs/                  # Documentation (hardware, migration, diagrams)
├── reports/               # Weekly progress reports
├── setup-guides/          # Step-by-step setup guides
├── CHEATSHEET.md          # Daily operations and troubleshooting
├── COMPLIANCE.md          # GDPR / SOC 2 / ISO 27001 compliance
├── PENDING-TASKS.md       # Ongoing improvements
└── RESPONSIBILITIES.md    # Role definitions
```

---

## Key Configuration Files

| File | Purpose |
|------|---------|
| `configs/mikrotik/router-config.rsc` | Full MikroTik config (VLANs, DHCP, firewall, WireGuard) |
| `configs/mikrotik/firewall-rules.rsc` | Firewall rules only |
| `configs/mikrotik/wireguard-config.rsc` | WireGuard server config |
| `configs/server/ufw-rules.sh` | UFW setup script |
| `configs/server/fail2ban-config.sh` | Fail2Ban configuration |
| `configs/server/backup-script.sh` | Automated daily backup script |
| `configs/switch/port-mirroring.txt` | TP-Link SPAN configuration |

---

## Quick Start

1. Clone the repository

```bash
git clone https://github.com/ilielucianno/office-network-infrastructure.git
```

2. Follow the setup guides in `setup-guides/` — start with `01-hardware-setup.md`
3. Daily operations — see `CHEATSHEET.md`
4. Compliance status — see `COMPLIANCE.md`

---

## Setup Guides

| # | Guide |
|---|-------|
| 01 | [Hardware Setup](setup-guides/01-hardware-setup.md) |
| 02 | [Router Configuration](setup-guides/02-router-config.md) |
| 03 | [Switch & VLAN Configuration](setup-guides/03-switch-vlan.md) |
| 04 | [WiFi Setup (Ubiquiti)](setup-guides/04-wifi-setup.md) |
| 05 | [Server Installation (Ubuntu)](setup-guides/05-server-install.md) |
| 06 | [Odoo Installation & HR Configuration](setup-guides/06-odoo-install.md) |
| 07 | [WireGuard Client Setup](setup-guides/07-wireguard-clients.md) |
| 08 | [2FA & Backup](setup-guides/08-2fa-backup.md) |
| 09 | [IDS Setup (Snort 3)](setup-guides/09-ids-setup.md) |
| 10 | [Wazuh SIEM Setup](setup-guides/10-wazuh-siem.md) |
| 11 | [OPNsense + Zenarmor NGFW Setup](setup-guides/11-opnsense-zenarmor-setup.md) |

---

## Current System Status (May 2026)

| Component | Primary (Geekom A9 Max) | Backup (Intel N100) |
|-----------|------------------------|---------------------|
| OS | Ubuntu 22.04 LTS | Ubuntu 22.04 LTS |
| Kernel | 6.17.0-23 | 6.17.0-23 |
| Wazuh | Active | Standby |
| DarkGhost NDR | Active | Standby |
| SnortML | Active | Standby |
| Snort 3 IDS | Active | Standby |
| OPNsense VM | Active | Not configured |
| Odoo HR | Active | Standby |
| Backups | Daily (Odoo DB) | Weekly (config files) |

---

## Lessons Learned

- VLAN filtering on MikroTik requires **bridge VLAN filtering** enabled
- Port mirroring (SPAN) is essential for NDR — without it, DarkGhost only sees traffic destined for the server
- Snort 3 runs in low-memory mode to coexist with Wazuh and other services
- Server migration (N100 → Geekom) took 2–3 days due to IP reconfiguration and driver differences
- Wazuh 4.x active response scripts require JSON parsing — positional arguments no longer work
- Two OpenSearch instances simultaneously (Wazuh Indexer + Shuffle) on 8GB RAM causes OOM — run alternately
- VirtualBox Guest Additions version must match the VirtualBox host version exactly
- WireGuard key management must be organized from day one

---

## Future Improvements

- Complete Security+ and Network+ certifications (in progress)
- Offsite backups (Google Drive) — optional
- Complete Shuffle SOAR automated workflows
- Disaster recovery fully documented (tested May 2026, RTO < 1h)

---

## Author

**Ilie Lucian** – Technical Department Manager (10+ years)  
SEC1 Certified (TryHackMe) · Currently: Security+ & Network+  
GitHub: [ilielucianno](https://github.com/ilielucianno)

Built from real-world experience managing network security, servers, and IT infrastructure — without a formal degree. This repository is a living document of my cybersecurity journey.

---

## License

MIT License – free to use and adapt for your own infrastructure.

*Last updated: May 2026*
