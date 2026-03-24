# Office Network Infrastructure with VLAN Segmentation & VPN Access

## Overview

This project documents the complete setup of a secure office network for a small company (3 HR offices + 12 remote support agents). The infrastructure is built on a budget of under €1000 and implements enterprise-grade security practices including VLAN isolation, firewall rules, VPN access, and a self-hosted HR management system.

**Key features:**
- Network segmentation (HR / Support / Server / Management)
- Full VLAN isolation with MikroTik router and switch
- WireGuard VPN for secure remote access
- Self-hosted Odoo HR system with 2FA
- Automated backups and security hardening (Fail2Ban, UFW)

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
Internet
│
▼
[ MikroTik Router ] (VLAN tagging, Firewall, VPN)
│
▼
[ MikroTik Switch ] (VLAN-aware)
│
┌────┬────────┬────────┬────────┐
▼ ▼ ▼ ▼ ▼
HR Support Server WiFi (VPN Users)
VLAN10 VLAN20 VLAN30 SSIDs WireGuard

text

### VLAN Segmentation

| VLAN | Name | Subnet | Purpose |
|------|------|--------|---------|
| 10 | HR | 192.168.10.0/24 | HR workstations, printer |
| 20 | Support | 192.168.20.0/24 | Support laptops (no access to HR/Server) |
| 30 | Server | 192.168.30.0/24 | Odoo HR system, database |

### Firewall Rules

- HR → Server: **ALLOWED**
- HR → Support: **DENIED**
- Support → HR: **DENIED**
- Support → Server: **DENIED**
- VPN (WireGuard) → Server: **ALLOWED**
- VPN → HR: **ALLOWED** (for admin access)

---

## Technologies Used

- **Routing & Firewall:** MikroTik RouterOS (VLAN, firewall, NAT)
- **Switching:** MikroTik SwitchOS (VLAN trunking)
- **VPN:** WireGuard
- **Server OS:** Ubuntu Server 22.04 LTS
- **Database:** MariaDB
- **HR System:** Odoo (self-hosted)
- **Security:** UFW, Fail2Ban, 2FA (Google Authenticator)
- **Backup:** Automated cron jobs + MySQL dumps

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

### 1. Network Isolation
- VLANs prevent unauthorized lateral movement
- Support team cannot access HR data or server

### 2. VPN-Only Server Access
- Odoo server is **not exposed to the internet**
- Accessible only via WireGuard VPN or from HR VLAN

### 3. 2FA for HR Users
- Google Authenticator required for all HR accounts

### 4. Automated Backups
- Daily database backups to external drive

### 5. Fail2Ban
- Blocks brute-force attacks on SSH and Odoo

---

## Lessons Learned

- **VLAN filtering on MikroTik requires bridge VLAN filtering enabled** – I initially missed this and spent hours troubleshooting.
- **WireGuard setup is simple but key management must be organized** – I created a spreadsheet for client keys.
- **Odoo permissions are granular** – I created two roles: HR Manager (full access) and HR Viewer (no salary data).
- **2FA in Odoo must be enabled per user** – Not a global setting, so I had to configure each user manually.

---

## Future Improvements

- Migrate to cloud backup (Google Drive / AWS S3)
- Implement SIEM logging (ELK stack or Wazuh)
- Add network monitoring (Zabbix or PRTG)
- Deploy a second server for high availability

---

## Author

**Ilie Lucian**  
Technical Department Manager with 10+ years in IT infrastructure, networking, and hardware. Currently pursuing certifications in cybersecurity (TryHackMe SEC1, Security+, Network+).

---

## License

This project is licensed under the MIT License – feel free to use and adapt for your own infrastructure.
