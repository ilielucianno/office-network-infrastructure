markdown# Compliance & Security Framework
## Office Network Infrastructure – T***** C**e Consultancy Ltd
### Cyprus / EU – May 2026

**Author:** Ilie Lucian – Technical Department Manager  
**Last updated:** May 22, 2026  

---

## Overview

This document outlines the security controls and license compliance implemented to meet regulatory requirements for companies operating in Cyprus/EU. The infrastructure serves a consulting & accounting company providing B2B services to online gambling operators.

**Applicable regulations:** GDPR (mandatory), SOC 2 (recommended), ISO 27001 (guidance).

---

## Section 1 – GDPR Compliance (General Data Protection Regulation)

**Status:** ✅ Implemented

| Requirement | Implementation | Status |
|-------------|----------------|--------|
| Art. 32 – Security of processing | Firewall, VPN, IDS/IPS, SIEM, NDR | ✅ |
| Art. 32 – Encryption at rest | Backups encrypted (daily local + weekly external), physical security (card + code + cameras + server room) | ✅ |
| Art. 30 – Records of processing | Handled by accounting/HR | ✅ |
| Art. 33 – Breach notification (72h) | Incident response runbook + tested | ✅ |
| Access logging (who accessed what) | `auditd` | ✅ |
| Data retention policy | Backup retention (30 days local, 90 days external) | ✅ |

### Auditd Configuration

**Files monitored:**
- `/etc/passwd` – user identity changes
- `/etc/shadow` – password changes
- `/home` – user data access

**Commands:**

```bash
sudo auditctl -w /etc/passwd -p wa -k identity
sudo auditctl -w /etc/shadow -p wa -k identity
sudo auditctl -w /home -p rwxa -k user_data
```

Log retention: 500MB (50MB x 10 files) – unlimited retention for GDPR compliance.

**View audit logs:**

```bash
sudo ausearch -k identity
```

### Unattended Security Updates

**Status:** ✅ Implemented (May 12, 2026)

**Configuration:**

```bash
sudo apt install unattended-upgrades -y
sudo dpkg-reconfigure --priority=low unattended-upgrades
```

**Updates applied automatically:**
- Security updates (kernel, system packages)
- Daily checks

**Verify status:**

```bash
sudo systemctl status unattended-upgrades
```

---

## Section 2 – Physical Security (Facility)

| Measure | Implementation | Status |
|---------|----------------|--------|
| First door | Card access (restricted) | ✅ |
| Second door | Code access (restricted) | ✅ |
| Cameras | Hall, entrance, outside, inside | ✅ |
| Server room | Separate room, limited access | ✅ |
| Guest area | Isolated from server room (separate ISP) | ✅ |
| Access to server room | Only Ilie + 3 IT technicians | ✅ |
| SOC1 access to server room | ❌ Denied | ✅ |

> **Risk assessment:** Physical theft or unauthorized access is very low. Disk encryption (LUKS) not required.

---

## Section 3 – SOC 2 Trust Services Criteria (Guidance)

| Criteria | Implementation | Status |
|----------|----------------|--------|
| CC6.1 – Logical access controls | VLAN segmentation, firewall rules, WireGuard VPN | ✅ |
| CC6.6 – Physical security | Card + code access, cameras, server room | ✅ |
| CC6.8 – Data encryption (transit) | TLS, WireGuard | ✅ |
| CC7.1 – Monitoring & detection | Wazuh SIEM, DarkGhost NDR, Snort IDS | ✅ |
| CC7.2 – Incident response | Runbook documented + tested | ✅ |
| CC7.4 – Vulnerability management | Unattended upgrades, kernel patching | ✅ |
| CC8.1 – Change management | Home lab testing + owner approval | ✅ |

---

## Section 4 – ISO 27001 Alignment (Annex A Controls)

| Control | Implementation | Status |
|---------|----------------|--------|
| A.9.2.1 – User registration | WireGuard key management (spreadsheet) | ✅ |
| A.9.4.2 – Secure log-on | SSH keys, 2FA for Odoo | ✅ |
| A.11.1 – Physical security perimeter | Two doors (card + code), cameras | ✅ |
| A.11.2 – Equipment security | Server room, access restricted to Ilie + 3 IT techs | ✅ |
| A.12.4.1 – Event logging | Wazuh SIEM, auditd | ✅ |
| A.12.4.3 – Administrator logs | Wazuh + auditd | ✅ |
| A.12.5.1 – Installation of software | Manual review, no unauthorized software | ✅ |
| A.12.6.1 – Management of vulnerabilities | Unattended upgrades, CVE monitoring | ✅ |
| A.16.1.5 – Response to incidents | Incident response runbook + tested | ✅ |
| A.17.1.1 – Planning information security continuity | Daily backup (local) + weekly backup (external encrypted) | ✅ |

---

## Section 5 – Software License Compliance (Open Source & Commercial)

**Status:** ✅ Fully Compliant – May 2026

### 5.1 Security Stack (IDS, IPS, SIEM, NDR, SOAR)

| Software | License | Compliance Status |
|----------|---------|-------------------|
| Snort 3 | GPLv2 | ✅ Permitted for commercial use |
| Wazuh SIEM | GPLv2 | ✅ Permitted for commercial use |
| DarkGhost NDR | Proprietary (internal development) | ✅ Company-owned code |
| SnortML | Proprietary (internal development) | ✅ Company-owned code |
| Shuffle SOAR | Apache 2.0 | ✅ Permitted |
| Fail2Ban | GPLv2 | ✅ Permitted |
| auditd | GPLv2 | ✅ Permitted |

### 5.2 Network & Firewall

| Software | License | Compliance Status |
|----------|---------|-------------------|
| MikroTik RouterOS | Commercial (included with hardware) | ✅ Purchased – invoice on file |
| OPNsense | BSD 2-Clause | ✅ Permitted |
| Zenarmor (free tier) | Free tier (proprietary) | ✅ Permitted – no cloud data transmission |
| WireGuard | GPLv2 | ✅ Permitted |

### 5.3 Custom Internal Tools – Copyright Notice

| Tool | Copyright Owner | Proof of Authorship |
|------|----------------|---------------------|
| DarkGhost NDR | Ilie Lucian | Source code + GitHub commit history |
| SnortML | Ilie Lucian | Source code + GitHub commit history |

> **Note:** Under Romanian, Cypriot, and EU law (Berne Convention), copyright is automatic upon creation. No registration is required.

---

## Section 6 – Hardware Inventory (Commercial Purchases)

All hardware purchased legally with invoices from Cyprus suppliers.

| Component | Model | Invoice Status |
|-----------|-------|----------------|
| Router | MikroTik hAP ac² | ✅ On file |
| Backbone Switch | TP-Link TL-SG108E | ✅ On file |
| Access Switches | 2× TP-Link TL-SG105 | ✅ On file |
| WiFi AP | Ubiquiti UniFi 6 Plus | ✅ On file |
| Main Server | Geekom A9 Max | ✅ On file |
| Backup Server | Mini PC Intel N100 | ✅ Retired, company owned |
| Printer | HP LaserJet MFP 135a | ✅ On file |

---

## Section 7 – Compliance Checklist (Weekly Review)

| Task | Frequency | Last Run | Status |
|------|-----------|----------|--------|
| Review auditd logs | Weekly | May 22, 2026 | ✅ |
| Check Wazuh for new alerts | Daily | May 22, 2026 | ✅ |
| Verify backup integrity | Weekly | May 22, 2026 | ✅ |
| Review DarkGhost anomalies | Daily | May 22, 2026 | ✅ |
| Test unattended upgrades | Weekly | May 22, 2026 | ✅ |
| Physical security check | Monthly | Scheduled for June 2026 | ✅ |

---

## Section 8 – Next Steps (May 23 – June 6, 2026)

| Week | Task |
|------|------|
| 12 | Disaster recovery test (restore from backup) – already tested, document officially |
| 12 | Offsite backup (Google Drive) – optional, not mandatory |

---

## Section 9 – Audit Q&A Preparation

| Potential Question | Answer |
|--------------------|--------|
| "Did you pay for a Wazuh license?" | No. We use the open-source version (GPLv2), which permits commercial use without payment. |
| "Is DarkGhost developed internally?" | Yes. Proprietary software developed internally. The company owns the usage rights. |
| "What license do you have for Zenarmor?" | Free tier. No cloud data transmission, permitted for commercial use. |
| "Do you have proof of copyright for DarkGhost?" | Yes. Source code on company laptop + GitHub commit history. Under EU law, copyright is automatic upon creation. |
| "Do you have disk encryption (LUKS) on server?" | No. Physical security (card + code + cameras + server room) and encrypted backups are sufficient. Remote access requirement prevents LUKS. |

---

## Section 10 – Document Version History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | May 12, 2026 | Ilie Lucian | Initial document |
| 1.1 | May 15, 2026 | Ilie Lucian | Added Software License Compliance |
| 1.2 | May 22, 2026 | Ilie Lucian | Updated: LUKS not needed, physical security documented, auditd verified, Lenovo BYOVD check completed, incident response tested, disaster recovery tested (<1h) |

---

> **Declaration:** To the best of my knowledge, all information in this document is accurate and complete. All security controls and compliance measures are implemented as described.

**Signed,**  
Ilie Lucian  
Technical Department Manager  
May 22, 2026
