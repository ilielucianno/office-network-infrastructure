# Office Network Infrastructure with VLAN Segmentation & VPN Access

## Overview
This project documents the complete setup of a secure office network for a small company (3 HR offices + 10-15 remote support agents). The infrastructure is built on a budget of under €1000 and implements enterprise-grade security practices including VLAN isolation, firewall rules, VPN access, and a self-hosted HR management system.

**The business operates online casinos (branded separately, no connection to this infrastructure).** All financial operations (withdrawals, bonuses) are protected by additional layers: 2FA on Zoho, IP verification, 7-21 day withdrawal delays, and manual approval by owners.

## Key features:
- **Network segmentation** — HR, Support, Server completely isolated with VLANs
- **Full VLAN isolation** — MikroTik router + switch with strict firewall rules
- **WireGuard VPN** — key-based authentication, unique keys per user
- **Self-hosted Odoo HR system** — employee database with 2FA
- **Automated backups** — daily database backups, 30-day retention
- **Security hardening** — UFW, Fail2Ban, Snort 3 IDS with community rules
- **Operational security** — 2FA on Zoho, withdrawal delays, manual approvals
- **Odoo Accounting** — invoices, payments, VAT reports for Cyprus
- **Separate WiFi** — HR + Accountant on VLAN 10, Support on VLAN 20 with client isolation
- **SIEM monitoring** — Wazuh centralizes logs from server, router, and Snort with email alerts

---

## Hardware List

| Component | Model | Price (€) |
|-----------|-------|----------|
| Router | MikroTik hAP ac² | ~65 |
| Switch | MikroTik CRS326-24G-2S+RM | ~200 |
| WiFi AP | Ubiquiti UniFi 6 Plus | ~110 |
| Server | Mini PC Intel N100 / 16GB RAM / 512GB SSD | ~300 |
| Printer | HP LaserJet MFP 135a | ~130 |
| Cables | Cat6 + accessories | ~80 |
| **Total** | | **~885–950** |

All components were purchased with official invoices (VAT included) from suppliers in Cyprus.

---

## Network Architecture

Internet → MikroTik Router → MikroTik Switch → HR / Support / Server / WiFi / VPN

- VLAN 10: HR (192.168.10.0/24)
- VLAN 20: Support (192.168.20.0/24)
- VLAN 30: Server (192.168.30.0/24)

---

## Firewall Rules

- HR → Server: ALLOWED
- HR → Support: DENIED
- Support → HR: DENIED
- Support → Server: DENIED
- VPN → Server: ALLOWED
- VPN → HR: ALLOWED

---

## Technologies Used

- Routing & Firewall: MikroTik RouterOS (VLAN, firewall, NAT)
- Switching: MikroTik SwitchOS (VLAN trunking)
- VPN: WireGuard
- Server OS: Ubuntu Server 22.04 LTS
- Database: MariaDB
- HR System: Odoo (self-hosted)
- Security: UFW, Fail2Ban, 2FA (Google Authenticator)
- Backup: Automated cron jobs + MySQL dumps

---

## Setup Guides

The complete step-by-step documentation is available in the `setup-guides/` folder:

1. [Hardware Setup](setup-guides/01-hardware-setup.md)
2. [Router Configuration](setup-guides/02-router-config.md)
3. [Switch & VLAN Configuration](setup-guides/03-switch-vlan.md)
4. [WiFi Setup (Ubiquiti)](setup-guides/04-wifi-setup.md)
5. [Server Installation (Ubuntu)](setup-guides/05-server-install.md)
6. [Odoo Installation & HR Configuration](setup-guides/06-odoo-install.md)
7. [WireGuard Client Setup](setup-guides/07-wireguard-clients.md)
8. [2FA & Backup](setup-guides/08-2fa-backup.md)
9. [IDS Setup (Snort 3)](setup-guides/09-ids-setup.md)
10. [Wazuh SIEM Setup](setup-guides/10-wazuh-siem.md)
    
---

## Configuration Files

All configuration files are available in the `configs/` folder:

- `configs/mikrotik/router-config.rsc` – Full MikroTik configuration
- `configs/mikrotik/firewall-rules.rsc` – Firewall rules only
- `configs/mikrotik/wireguard-config.rsc` – WireGuard server config
- `configs/server/ufw-rules.sh` – UFW setup script
- `configs/server/fail2ban-config.sh` – Fail2Ban configuration
- `configs/server/backup-script.sh` – Automated backup script

---

## Key Security Implementations

### Network & Infrastructure

| Measure | Implementation |
|---------|----------------|
| Network Segmentation | VLANs separate HR, Support, Server — no lateral movement without explicit rules |
| Firewall Rules | MikroTik firewall blocks all inter-VLAN traffic except HR → Server and VPN → internal |
| VPN-Only Server Access | Odoo server is not exposed to internet — accessible only via WireGuard VPN or HR VLAN |
| WireGuard VPN | Key-based authentication, unique keys per user, IP tracking |
| Server Hardening | UFW firewall (allow only HR and VPN subnets), automatic security updates |
| Fail2Ban | Blocks brute-force attacks on SSH and Odoo |
| Intrusion Detection | Snort IDS monitors traffic and logs alerts |
| Backup | Daily automated database backups, 30-day retention |

### Operational & Access Control

| Measure | Implementation |
|---------|----------------|
| Zoho 2FA | Two-factor authentication for all Zoho accounts |
| IP-Based Verification | Zoho remembers trusted devices/IPs for 30 days — new IP triggers 2FA |
| User Roles | Owners (full access), Support (limited, no withdrawals), HR (server access only) |
| Withdrawal Protection | 7-21 day delay, daily review, manual approval by owners only |
| Password Policy | 12+ characters, unique, changed quarterly |
| WireGuard Key Management | Unique keys per user, spreadsheet tracking, immediate revocation on departure |
| Incident Response | Documented runbook for crypto breaches, suspicious logins, withdrawals |
| Offboarding Process | All accounts disabled immediately when employee leaves |
| Data Breach Monitoring | Google alerts for leaked credentials — immediate password reset |

### Security Architecture Overview

**External Layer (Internet):**
- Casino websites (Malta/Curacao licenses) — no connection to company infrastructure
- Zoho CRM (cloud) — protected by 2FA and IP verification

**Internal Layer (Your Infrastructure):**
- MikroTik Router — firewall, VPN server, VLAN routing
- MikroTik Switch — VLAN trunking, port isolation
- Three isolated networks:
  - VLAN 10 (HR) — can access server only
  - VLAN 20 (Support) — internet only, no access to HR or server
  - VLAN 30 (Server) — Odoo HR system, accessible only from HR and VPN

**Remote Access:**
- WireGuard VPN — key-based authentication
- Remote agents can only access Odoo server, nothing else

### Why This Architecture Works

| Threat | How We Block It |
|--------|-----------------|
| Attacker finds casino website | No link to company infrastructure |
| Attacker compromises Zoho password | 2FA + IP verification blocks login |
| Attacker gets into Zoho | Support roles cannot withdraw money |
| Attacker requests withdrawal | 7-21 day delay + daily review + manual approval |
| Attacker compromises support laptop | VLAN isolation — cannot reach HR or Server |
| Attacker tries to brute-force server | Fail2Ban blocks after 3 attempts |
| Attacker steals physical hardware | Server is locked, data is encrypted, backups offsite |
| Phishing attack (like crypto incident) | Quick response runbook, funds recovery procedure |

---
## Operations & Security Policies

Operational procedures and security policies:

1. [Zoho Security](configs/operations/01-zoho-security.md)
2. [Incident Response Runbook](configs/operations/02-incident-runbook.md)
3. [Backup Procedures](configs/operations/03-backup-procedures.md)
4. [Accounts & Access Policy](configs/operations/04-accounts-policy.md)
---   

## Lessons Learned

- VLAN filtering on MikroTik requires bridge VLAN filtering enabled – I initially missed this and spent hours troubleshooting.
- WireGuard setup is simple but key management must be organized – I created a spreadsheet for client keys.
- Odoo permissions are granular – I created two roles: HR Manager (full access) and HR Viewer (no salary data).
- 2FA in Odoo must be enabled per user – Not a global setting, so I had to configure each user manually.

---

## Future Improvements

I am still learning, so I don't know exactly what comes next. Here's what I plan to explore:

### What I Know I Want to Learn
- **Complete my certifications** — Security+ and Network+ are my priority right now
- **Understand monitoring tools** — I've heard about tools that show network activity, but I need to learn them first
- **Add offsite backup** — Right now backups are local. I want to add cloud backup (Google Drive) for extra safety

### How This Will Grow
As I learn more, I will add new features to this network and document them here. This repository will evolve with my knowledge.

**This is a learning project. I build what I learn.**

---

## About Author

**Ilie Lucian**  
Technical Department Manager with 10+ years in IT infrastructure, networking, and hardware. SEC1 CERTIFIED Currently pursuing certifications in cybersecurity  (Security+ in p5rogress, Network+).

## Current Learning Path

I am actively building my cybersecurity knowledge while working full-time. This project is part of my hands-on learning journey.

### Completed
- ✅ TryHackMe Pre Security
- ✅ TryHackMe SEC0
- ✅ This project — full network infrastructure with VLANs, VPN, IDS, and operational security
- ✅ TryHackMe SEC1
- 
### In Progress

- 🔄 Security+ (CompTIA) — started 
- 🔄 Network+ (CompTIA) -started

### Next Steps (Next 6 Months)
- Complete Security+ and Network+ certifications
- Start Cloud Security (AWS / Azure fundamentals)
- Document more operational procedures
- Add monitoring with Wazuh / Grafana

### Why I Built This
I've been working in IT infrastructure for 10+ years, managing networks, hardware, and teams. Recently, I realized that what I was already doing (firewalls, VLANs, VPNs, incident response) has a name: **cybersecurity**. Now I'm formalizing my knowledge through certifications and documenting real projects to demonstrate my skills.

**This repository is a living document of my cybersecurity journey.**

---

## License

This project is licensed under the MIT License – feel free to use and adapt for your own infrastructure.
