# Office Network Infrastructure with VLAN Segmentation & VPN Access

## Overview

This project documents the complete setup of a secure office network for a small company (3 HR offices + 10-15 remote support agents). The infrastructure is built on a budget of under €1000 and implements enterprise-grade security practices including VLAN isolation, firewall rules, VPN access, and a self-hosted HR management system.

**The business operates online casinos (branded separately, no connection to this infrastructure).** All financial operations (withdrawals, bonuses) are protected by additional layers: 2FA on Zoho, IP verification, 7-21 day withdrawal delays, and manual approval by owners.

---

## Key features:

  * **Network segmentation** — HR, Support, Server completely isolated with VLANs
  * **Full VLAN isolation** — MikroTik router + switch with strict firewall rules
  * **WireGuard VPN** — key-based authentication, unique keys per user
  * **Self-hosted Odoo HR system** — employee database with 2FA
  * **Automated backups** — daily database backups, 30-day retention
  * **Security hardening** — UFW, Fail2Ban, Snort 3 IDS with community rules (low-memory mode)
  * **Operational security** — 2FA on Zoho, withdrawal delays, manual approvals
  * **Odoo Accounting** — invoices, payments, VAT reports for Cyprus
  * **Separate WiFi** — HR + Accountant on VLAN 10, Support on VLAN 20 with client isolation
  * **SIEM monitoring** — Wazuh centralizes logs from server, router, and Snort with email alerts
  * **NGFW** — OPNsense + Zenarmor for Layer 7 filtering and application control (added April 2026)
  * **NDR (Network Detection & Response)** — DarkGhost NDR monitors mirrored traffic for anomalies, port scans, TTL spoofing, and behavioral deviations (added May 2026)
  * **SQL Injection Detection** — Real-time SQL injection detection using TensorFlow + Scapy + Flask (open-source Zenarmor alternative)

---

## Hardware List

| Component | Model | Price (€) | Notes |
|-----------|-------|-----------|-------|
| Router | MikroTik hAP ac² | ~65 | Firewall, VPN, VLAN routing |
| **Backbone Switch** | **TP-Link TL-SG108E** | **~30** | **8-port managed switch (April 2026)** |
| **HR Room Switch** | **TP-Link TL-SG105** | **~18** | **5-port unmanaged (April 2026)** |
| **Consultancy Switch** | **TP-Link TL-SG105** | **~18** | **5-port unmanaged (April 2026)** |
| WiFi AP | Ubiquiti UniFi 6 Plus | ~110 | Wireless access |
| Server | Mini PC Intel N100 / 16GB / 512GB SSD | ~300 | Odoo, Wazuh, Snort (low-memory), DarkGhost NDR, SQL Injection Detector |
| Printer | HP LaserJet MFP 135a | ~130 | HR printing |
| Cables | Cat6 + accessories | ~80 | Cabling |
| **Total** | **~750-800** | | |

All components purchased with official invoices from Cyprus suppliers (Senetic, Bionic, Skroutz).

**Network topology updated April 6, 2026** – New backbone switch architecture implemented.  
**NDR integration updated May 2026** – DarkGhost deployed with port mirroring.  
**Snort configured in low-memory mode** to run alongside other services.

---

## Network Architecture

Internet → MikroTik Router → TP-Link Switch → HR / Support / Server / WiFi / VPN

  * VLAN 10: HR (192.168.10.0/24)
  * VLAN 20: Support (192.168.20.0/24)
  * VLAN 30: Server (192.168.30.0/24)

**Traffic visibility:**  
A SPAN (port mirroring) session is configured on the TP-Link TL-SG108E switch. All traffic between VLANs is copied to the server port where DarkGhost NDR performs real-time anomaly detection.

---

## Firewall Rules

  * HR → Server: ALLOWED
  * HR → Support: DENIED
  * Support → HR: DENIED
  * Support → Server: DENIED
  * VPN → Server: ALLOWED
  * VPN → HR: ALLOWED

---

## Technologies Used

  * **Routing & Firewall:** MikroTik RouterOS (VLAN, firewall, NAT)
  * **Switching:** TP-Link TL-SG108E (VLAN trunking, port mirroring)
  * **VPN:** WireGuard
  * **Server OS:** Ubuntu Server 22.04 LTS
  * **Database:** MariaDB
  * **HR System:** Odoo (self-hosted)
  * **Security:** UFW, Fail2Ban, 2FA (Google Authenticator)
  * **Backup:** Automated cron jobs + MySQL dumps
  * **IDS/IPS:** Snort 3 (low-memory mode, added January 2026), OPNsense + Zenarmor (added April 2026)
  * **NDR:** DarkGhost NDR (added May 2026) – anomaly detection, port scan, TTL spoofing
  * **SQL Injection Detection:** SnortML (TensorFlow + Scapy + Flask) – real-time SQLi detection
  * **SIEM:** Wazuh (added January 2026)

---

## Security Detection Layers

| Layer | Tool | Detection Type |
|-------|------|----------------|
| **Network IDS** | Snort 3 | Signature-based (known attacks) – low-memory mode |
| **NGFW / IPS** | OPNsense + Zenarmor | Layer 7 filtering, application control |
| **NDR** | DarkGhost | Behavioral anomalies, zero-day, port scan, spoofing |
| **Web App** | SQL Injection Detector (SnortML) | SQL injection in HTTP traffic |
| **SIEM** | Wazuh | Centralized logs, correlation, alerts |

---

## Setup Guides

The complete step-by-step documentation is available in the `setup-guides/` folder:

  1. Hardware Setup
  2. Router Configuration
  3. Switch & VLAN Configuration
  4. Port Mirroring for NDR (new)
  5. WiFi Setup (Ubiquiti)
  6. Server Installation (Ubuntu)
  7. Odoo Installation & HR Configuration
  8. WireGuard Client Setup
  9. 2FA & Backup
  10. IDS Setup (Snort 3) – low-memory mode
  11. Wazuh SIEM Setup
  12. OPNsense + Zenarmor NGFW Setup
  13. DarkGhost NDR Setup (new)
  14. SQL Injection Detector Setup (SnortML)

---

## Configuration Files

All configuration files are available in the `configs/` folder:

  * `configs/mikrotik/router-config.rsc` – Full MikroTik configuration
  * `configs/mikrotik/firewall-rules.rsc` – Firewall rules only
  * `configs/mikrotik/wireguard-config.rsc` – WireGuard server config
  * `configs/server/ufw-rules.sh` – UFW setup script
  * `configs/server/fail2ban-config.sh` – Fail2Ban configuration
  * `configs/server/backup-script.sh` – Automated backup script
  * `configs/switch/port-mirroring.txt` – TP-Link port mirroring configuration (new)
  * `configs/snort/low-memory.conf` – Snort low-memory mode settings

---

## Quick Reference

For daily operations and troubleshooting, see the [CHEATSHEET.md](CHEATSHEET.md).

---

## Key Security Implementations

### Network & Infrastructure

| Measure | Implementation |
|---------|----------------|
| **Network Segmentation** | VLANs separate HR, Support, Server — no lateral movement without explicit rules |
| **Firewall Rules** | MikroTik firewall blocks all inter-VLAN traffic except HR → Server and VPN → internal |
| **VPN-Only Server Access** | Odoo server is not exposed to internet — accessible only via WireGuard VPN or HR VLAN |
| **WireGuard VPN** | Key-based authentication, unique keys per user, IP tracking |
| **Server Hardening** | UFW firewall (allow only HR and VPN subnets), automatic security updates |
| **Fail2Ban** | Blocks brute-force attacks on SSH and Odoo |
| **Intrusion Detection** | Snort 3 IDS (low-memory mode) monitors traffic and logs alerts |
| **Next-Generation Firewall** | OPNsense + Zenarmor for Layer 7 filtering, application control, IPS |
| **NDR (Network Detection & Response)** | DarkGhost analyzes mirrored traffic for behavioral anomalies, port scans, and spoofing |
| **SQL Injection Detection** | SnortML detects SQL injection in real-time using TensorFlow |
| **SIEM** | Wazuh centralizes logs from server, OPNsense, Snort, and DarkGhost with email alerts |
| **Traffic Visibility** | SPAN (port mirroring) on TP-Link switch sends all inter-VLAN traffic to DarkGhost |
| **Backup** | Daily automated database backups, 30-day retention |

### Operational & Access Control

| Measure | Implementation |
|---------|----------------|
| **Zoho 2FA** | Two-factor authentication for all Zoho accounts |
| **IP-Based Verification** | Zoho remembers trusted devices/IPs for 30 days — new IP triggers 2FA |
| **User Roles** | Owners (full access), Support (limited, no withdrawals), HR (server access only) |
| **Withdrawal Protection** | 7-21 day delay, daily review, manual approval by owners only |
| **Password Policy** | 12+ characters, unique, changed quarterly |
| **WireGuard Key Management** | Unique keys per user, spreadsheet tracking, immediate revocation on departure |
| **Incident Response** | Documented runbook for crypto breaches, suspicious logins, withdrawals |
| **Offboarding Process** | All accounts disabled immediately when employee leaves |
| **Data Breach Monitoring** | Google alerts for leaked credentials — immediate password reset |

### Security Architecture Overview

**External Layer (Internet):**

  * Casino websites (Malta/Curacao licenses) — no connection to company infrastructure
  * Zoho CRM (cloud) — protected by 2FA and IP verification

**Internal Layer (Infrastructure):**

  * OPNsense NGFW (VM) — Layer 7 filtering, IPS, application control
  * MikroTik Router — VPN server, VLAN routing
  * TP-Link Switch — VLAN trunking, port isolation, port mirroring (SPAN)
  * Three isolated networks: 
    * VLAN 10 (HR) — can access server only
    * VLAN 20 (Support) — internet only, no access to HR or server
    * VLAN 30 (Server) — Odoo HR system, Wazuh, Snort (low-memory), DarkGhost NDR, SQL Injection Detector

**Remote Access:**

  * WireGuard VPN — key-based authentication
  * Remote agents can only access Odoo server, nothing else

### Why This Architecture Works

| Threat | How We Block It |
|--------|------------------|
| Attacker finds casino website | No link to company infrastructure |
| Attacker compromises Zoho password | 2FA + IP verification blocks login |
| Attacker gets into Zoho | Support roles cannot withdraw money |
| Attacker requests withdrawal | 7-21 day delay + daily review + manual approval |
| Attacker compromises support laptop | VLAN isolation — cannot reach HR or Server |
| Attacker tries to brute-force server | Fail2Ban blocks after 3 attempts |
| Attacker steals physical hardware | Server is locked, data is encrypted, backups offsite |
| Phishing attack (like crypto incident) | Quick response runbook, funds recovery procedure |
| Malware or malicious website | Zenarmor blocks at gateway (Layer 7 filtering) |
| Zero-day attack or unusual behavior | DarkGhost NDR detects anomalies via behavioral baseline |
| SQL injection on web apps | SnortML detects and blocks malicious payloads |

---

## Operations & Security Policies

Operational procedures and security policies:

  1. [Zoho Security](docs/Zoho%20Security.md)
  2. [Incident Response Runbook](docs/Incident%20Response%20Runbook.md)
  3. [Backup Procedures](docs/Backup%20Procedures.md)
  4. [Accounts & Access Policy](docs/Accounts%20%26%20Access%20Policy.md)

---

## Lessons Learned

  * VLAN filtering on MikroTik requires bridge VLAN filtering enabled – I initially missed this and spent hours troubleshooting.
  * WireGuard setup is simple but key management must be organized – I created a spreadsheet for client keys.
  * Odoo permissions are granular – I created two roles: HR Manager (full access) and HR Viewer (no salary data).
  * 2FA in Odoo must be enabled per user – Not a global setting, so I had to configure each user manually.
  * Running OPNsense as a VM on the existing server is possible but requires careful resource allocation (RAM/CPU).
  * Snort can be set to low-memory mode to coexist with other services – I used `detect` engine profile to reduce RAM usage.
  * **Port mirroring (SPAN) is essential for NDR** – Without it, DarkGhost only sees traffic to/from the server, not inter-VLAN traffic. Configuring this on the TP-Link switch was simple once I identified the correct source port (trunk port carrying all VLANs).

---

## Future Improvements

I am still learning, so I don't know exactly what comes next. Here's what I plan to explore:

### What I Know I Want to Learn

  * **Complete my certifications** — Security+ and Network+ are my priority right now
  * **Understand monitoring tools** — I've heard about tools that show network activity, but I need to learn them first
  * **Add offsite backup** — Right now backups are local. I want to add cloud backup (Google Drive) for extra safety

### How This Will Grow

As I learn more, I will add new features to this network and document them here. This repository will evolve with my knowledge.

**This is a learning project. I build what I learn.**

---

## About Author

**Ilie Lucian**  
Technical Department Manager with 10+ years in IT infrastructure, networking, and hardware.  
**SEC1 Certified** (TryHackMe). Currently pursuing Security+ and Network+ certifications.

---

## Current Learning Path

I am actively building my cybersecurity knowledge while working full-time. This project is part of my hands-on learning journey.

### Completed

  * ✅ TryHackMe Pre Security
  * ✅ TryHackMe SEC0
  * ✅ TryHackMe SEC1
  * ✅ This project — full network infrastructure with VLANs, VPN, IDS, SIEM, NGFW, NDR, and SQL injection detection

### In Progress

  * 🔄 Network+ (CompTIA) — 50% completed
  * 🔄 Security+ (CompTIA) — started

### Next Steps (Next 6 Months)

  * Complete Security+ and Network+ certifications
  * Start Cloud Security (AWS / Azure fundamentals)
  * Document more operational procedures
  * Deploy OPNsense to dedicated hardware

### Why I Built This

I've been working in IT infrastructure for 10+ years, managing networks, hardware, and teams. Recently, I realized that what I was already doing (firewalls, VLANs, VPNs, incident response) has a name: **cybersecurity**. Now I'm formalizing my knowledge through certifications and documenting real projects to demonstrate my skills.

**This repository is a living document of my cybersecurity journey.**

---

## License

This project is licensed under the MIT License – feel free to use and adapt for your own infrastructure.
