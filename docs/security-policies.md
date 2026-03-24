# Security Policies

This document outlines the security policies implemented in the office network infrastructure.

---

## Overview

The security architecture follows the **principle of least privilege** and **network segmentation**. No system is accessible unless explicitly required.

---

## 1. Network Segmentation (VLAN Isolation)

| VLAN | Name | Access Rules |
|------|------|--------------|
| 10 | HR | Can access Server (VLAN 30). Cannot access Support (VLAN 20). |
| 20 | Support | Internet only. Cannot access HR or Server. |
| 30 | Server | Accessible only from HR VLAN and VPN. Not exposed to internet. |

**Why:** If an attacker compromises a Support laptop, they cannot reach HR data or the server.

---

## 2. Firewall Rules

### MikroTik RouterOS
Block all inter-VLAN traffic by default
/ip firewall filter add chain=forward action=drop

Allow specific flows
add chain=forward action=accept src-address=192.168.10.0/24 dst-address=192.168.30.0/24 # HR → Server
add chain=forward action=accept src-address=10.10.10.0/24 dst-address=192.168.30.0/24 # VPN → Server
add chain=forward action=accept src-address=10.10.10.0/24 dst-address=192.168.10.0/24 # VPN → HR
add chain=forward action=accept out-interface=ether1 # Internet access

text

### Server Firewall (UFW)
Allow only from HR VLAN and VPN subnet
sudo ufw allow from 192.168.10.0/24
sudo ufw allow from 10.10.10.0/24
sudo ufw enable

text

**Why:** Server is invisible from the internet. Only internal and VPN traffic reaches it.

---

## 3. VPN Security (WireGuard)

| Setting | Value |
|---------|-------|
| Protocol | WireGuard (UDP) |
| Port | 13231 |
| Encryption | ChaCha20Poly1305 |
| Authentication | Public/Private key pair |

**Policies:**
- Each remote user gets a unique key pair
- Keys are revoked when an employee leaves
- No password authentication – keys only

**Why:** WireGuard is lightweight, modern, and more secure than legacy VPN protocols.

---

## 4. Server Security Hardening

### Operating System (Ubuntu Server 22.04)

| Measure | Implementation |
|---------|----------------|
| Non-root user | All operations done via `odoo` user |
| SSH | Password authentication disabled, key-based only |
| Firewall | UFW with strict allow lists |
| Automatic updates | `unattended-upgrades` enabled |
| Fail2Ban | Blocks IPs after 3 failed SSH attempts |

### Fail2Ban Configuration

```bash
# /etc/fail2ban/jail.local
[sshd]
enabled = true
maxretry = 3
bantime = 3600
Why: Automated attacks are common. Fail2Ban reduces brute-force risk.

5. HR System Security (Odoo)
Measure	Implementation
2FA (Two-Factor Authentication)	Google Authenticator for all HR users
Password policy	Minimum 12 characters, complexity enforced
Session timeout	15 minutes of inactivity
User roles	HR Manager (full access), HR Viewer (restricted)
2FA Setup Steps
Enable Developer Mode in Odoo

Navigate to Settings → Users → Select user

Check "Two-Factor Authentication"

User scans QR code with authenticator app on first login

Why: 2FA prevents account takeover even if passwords are compromised.

6. Access Control Matrix
User Type	HR VLAN	Support VLAN	Server	Odoo	Internet
HR Staff	✅	❌	✅	✅	✅
Support Staff	❌	✅	❌	❌	✅
Remote Agents (VPN)	❌	❌	✅ (Odoo only)	✅	via own ISP
Admin (VPN)	✅	✅	✅	✅	✅
7. Backup Policy
Backup Type	Frequency	Location	Retention
Database (MariaDB)	Daily at 2:00 AM	External HDD	30 days
Odoo filestore	Weekly	External HDD	4 weeks
Full system backup	Monthly	External HDD + Cloud	3 months
Backup Script
bash
#!/bin/bash
# /root/backup.sh
mysqldump -u root -p'password' odoo_db > /backup/odoo_$(date +%Y%m%d).sql
find /backup -name "odoo_*.sql" -mtime +30 -delete
Why: Data loss recovery is critical for HR records.

8. Incident Response Plan
Phishing / Credential Theft (like the crypto incident)
Immediate: Change passwords, revoke sessions

Containment: Isolate affected system (disable account)

Analysis: Review logs, determine scope

Recovery: Restore from clean backup if needed

Post-incident: Update training, review policies

Suspicious Network Activity
Check firewall logs on MikroTik

Review VPN connection logs

Check server auth logs (/var/log/auth.log)

Block source IP if malicious

9. Security Checklist (Implemented)
VLAN segmentation between departments

Firewall rules blocking lateral movement

Server not exposed to internet

WireGuard VPN with key-based auth

2FA on Odoo HR system

UFW on server with strict allow rules

Fail2Ban on server

Automatic security updates

Daily database backups

Password policy enforced

10. Future Security Improvements
Priority	Improvement	Reason
High	Centralized logging (ELK or Wazuh)	Better visibility into security events
Medium	Network monitoring (Zabbix)	Detect anomalies
Medium	Cloud backup (AWS S3 / Google Drive)	Offsite redundancy
Low	SIEM integration	Compliance and advanced detection
References
MikroTik Firewall Best Practices

WireGuard Security

Ubuntu Security Hardening

Odoo Security Documentation
