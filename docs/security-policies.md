# Security Policies

This document outlines the security policies implemented in the office network infrastructure.

---

## Overview

The security architecture follows the principle of least privilege and network segmentation. No system is accessible unless explicitly required.

---

## 1. Network Segmentation (VLAN Isolation)

| VLAN | Name | Subnet | Access Rules |
|------|------|--------|--------------|
| 10 | HR | 192.168.10.0/24 | Can access Server (VLAN 30). Cannot access Support (VLAN 20). |
| 20 | Support | 192.168.20.0/24 | Internet only. Cannot access HR or Server. |
| 30 | Server | 192.168.30.0/24 | Accessible only from HR VLAN and VPN. Not exposed to internet. |

**Why:** If an attacker compromises a Support laptop, they cannot reach HR data or the server.

---

## 2. Wireless Security

| SSID | VLAN | Users | Isolation |
|------|------|-------|-----------|
| Company-HR | 10 | HR staff, Accountant | No isolation (trusted users) |
| Company-Support | 20 | Support agents | Client Device Isolation enabled |

**Client Device Isolation:** Laptops on Support WiFi cannot communicate with each other. This prevents lateral movement if one device is compromised.

---

## 3. Firewall Rules

### MikroTik RouterOS

Block all inter-VLAN traffic by default, then allow specific flows:
- HR → Server: ALLOWED
- VPN → Server: ALLOWED
- VPN → HR: ALLOWED
- Internet access: ALLOWED for all

### Server Firewall (UFW)

Allow only from HR VLAN and VPN subnet:
- SSH: only from 192.168.10.0/24 and 10.10.10.0/24
- Odoo (port 8069): only from 192.168.10.0/24 and 10.10.10.0/24

**Why:** Server is invisible from the internet. Only internal and VPN traffic reaches it.

---

## 4. VPN Security (WireGuard)

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
- Each client has a unique IP in 10.10.10.0/24 for tracking

---

## 5. Server Security Hardening

### Operating System (Ubuntu Server 22.04)

| Measure | Implementation |
|---------|----------------|
| Non-root user | All operations done via odoo user |
| SSH | Key-based authentication only |
| Firewall | UFW with strict allow lists (HR and VPN only) |
| Automatic updates | unattended-upgrades enabled |
| Fail2Ban | Blocks IPs after 3 failed SSH attempts |
| Snort 3 IDS | Intrusion detection system with community rules + custom rules for SSH, port scans, and unauthorized access |
| Wazuh SIEM | Centralized log collection, analysis, and email alerts for high-severity events |

---

## 6. Endpoint Security

All company laptops and workstations are protected with multiple layers of antivirus protection:

| Device Type | Protection | Status |
|-------------|------------|--------|
| Windows Laptops | Windows Security (built-in) | Enabled |
| Windows Laptops | Avira Free (additional layer) | Installed |
| Updates | Windows Update automatic | Configured |

### Policy

- Windows Security real-time protection is enabled on all devices
- Avira Free provides an additional scanning layer
- Automatic updates are enabled for Windows and antivirus definitions
- Users are not allowed to disable antivirus or firewall
- Regular full scans are scheduled weekly

### Why Two Antivirus Solutions

Windows Security provides baseline protection. Avira Free adds:
- Additional signature database
- Behavior-based detection
- Second opinion on suspicious files

Running two antivirus solutions is acceptable when one is the built-in Windows Defender and the second is a lightweight scanner without real-time conflicts.

---

## 7. Odoo Security

| Measure | Implementation |
|---------|----------------|
| 2FA (Two-Factor Authentication) | Google Authenticator for all users |
| Password policy | Minimum 12 characters, complexity enforced |
| Session timeout | 15 minutes of inactivity |
| User roles | HR Manager, Accountant, Admin |

### Odoo Roles

| Role | Access |
|------|--------|
| HR Manager | Employee data, contracts, salaries |
| Accountant | Invoices, payments, VAT reports, bank accounts |
| Admin | Full access, user management |

---

## 8. Access Control Matrix

| User Type | HR VLAN | Support VLAN | Server | Odoo | Internet |
|-----------|---------|--------------|--------|------|----------|
| HR Staff | YES | NO | YES | YES | YES |
| Accountant | YES | NO | YES | YES (Accounting) | YES |
| Support Staff | NO | YES | NO | NO | YES |
| Remote Agents (VPN) | NO | NO | YES (Odoo only) | YES | via own ISP |
| Admin (VPN) | YES | YES | YES | YES | YES |

---

## 9. Backup Policy

| Backup Type | Frequency | Location | Retention |
|-------------|-----------|----------|-----------|
| Database (MariaDB) | Daily at 2:00 AM | External HDD | 30 days |
| Odoo filestore | Weekly | External HDD | 4 weeks |
| Router/Switch config | After changes | Local storage | Permanent |

**Why:** Data loss recovery is critical for HR records and accounting data.

---

## 10. Incident Response Plan

### Phishing / Credential Theft

1. Immediate: Change passwords, revoke sessions
2. Containment: Isolate affected system (disable account)
3. Analysis: Review logs, determine scope
4. Recovery: Restore from clean backup if needed
5. Post-incident: Update training, review policies

### Withdrawal Protection

- Withdrawals have 7-21 day delay
- Daily review of withdrawal list
- Manual approval by owners only
- Suspicious withdrawals cancelled immediately

---

## 11. Security Checklist (Implemented)

- [x] VLAN segmentation between departments
- [x] Firewall rules blocking lateral movement
- [x] Server not exposed to internet
- [x] WireGuard VPN with key-based auth
- [x] 2FA on Odoo HR system
- [x] 2FA on Zoho CRM
- [x] UFW on server with strict allow rules
- [x] Fail2Ban on server
- [x] Snort 3 IDS monitoring
- [x] Wazuh SIEM monitoring
- [x] Endpoint antivirus (Windows Security + Avira)
- [x] Automatic security updates
- [x] Daily database backups
- [x] WiFi client isolation on Support network
- [x] Accountant role with limited access
