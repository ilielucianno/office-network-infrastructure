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
