markdown# Compliance & Security Framework
## Office Network Infrastructure 
### Cyprus / EU – May 2026

**Author:** Ilie Lucian – Technical Department Manager  
**Last updated:** May 15, 2026  


---

## Overview

This document outlines the security controls and license compliance implemented to meet regulatory requirements for companies operating in Cyprus/EU. The infrastructure serves a consulting & accounting company (Turtle Cove Consultancy Ltd) providing B2B services to online gambling operators.

**Applicable regulations:** GDPR (mandatory), SOC 2 (recommended), ISO 27001 (guidance).

---

## Section 1 – GDPR Compliance (General Data Protection Regulation)

**Status:** Partial Implementation – In Progress

| Requirement | Implementation | Status | Due Date |
|-------------|----------------|--------|----------|
| Art. 32 – Security of processing | Firewall, VPN, IDS/IPS, SIEM, NDR | ✅ Implemented | Complete |
| Art. 32 – Encryption at rest | LUKS / eCryptfs | 🔴 Pending | May 30, 2026 |
| Art. 30 – Records of processing | Internal documentation | 🔴 Pending | May 23, 2026 |
| Art. 33 – Breach notification (72h) | Incident response runbook | 🟢 Drafted | Complete |
| Access logging (who accessed what) | `auditd` | ✅ Implemented | May 12, 2026 |
| Data retention policy | Backup retention (30 days) | ✅ Implemented | Complete |

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

## Section 2 – SOC 2 Trust Services Criteria (Guidance)

| Criteria | Implementation | Status |
|----------|----------------|--------|
| CC6.1 – Logical access controls | VLAN segmentation, firewall rules, WireGuard VPN | ✅ |
| CC6.8 – Data encryption (transit) | TLS, WireGuard | ✅ |
| CC7.1 – Monitoring & detection | Wazuh SIEM, DarkGhost NDR, Snort IDS | ✅ |
| CC7.2 – Incident response | Runbook documented | 🟢 Drafted |
| CC7.4 – Vulnerability management | Unattended upgrades, kernel patching | ✅ |
| CC8.1 – Change management | Manual review, GitHub documentation | 🟢 Partial |

---

## Section 3 – ISO 27001 Alignment (Annex A Controls)

| Control | Implementation | Status |
|---------|----------------|--------|
| A.9.2.1 – User registration | WireGuard key management (spreadsheet) | ✅ |
| A.9.4.2 – Secure log-on | SSH keys, 2FA for Odoo | ✅ |
| A.12.4.1 – Event logging | Wazuh SIEM, auditd | ✅ |
| A.12.4.3 – Administrator logs | Wazuh + auditd | ✅ |
| A.12.5.1 – Installation of software | Manual review, no unauthorized software | 🟢 Partial |
| A.12.6.1 – Management of vulnerabilities | Unattended upgrades, CVE monitoring | ✅ |
| A.16.1.5 – Response to incidents | Incident response runbook | 🟢 Drafted |
| A.17.1.1 – Planning information security continuity | Backup daily, offsite backup pending | 🟢 Partial |

---

## Section 4 – Software License Compliance (Open Source & Commercial)

**Status:** ✅ Fully Compliant – May 2026

This section documents all software used in production and confirms compliance with their respective licenses. All software is used legally, either through open-source licenses that permit commercial use, commercial purchases, or internal development.

### 4.1 Operating System & Virtualization

| Software | Version | License | Compliance Status |
|----------|---------|---------|-------------------|
| Ubuntu Server | 22.04 LTS | GPLv2 | ✅ Permitted for commercial use |
| VirtualBox | – | GPLv2 | ✅ Permitted for commercial use |

### 4.2 Network & Firewall

| Software | Version | License | Compliance Status |
|----------|---------|---------|-------------------|
| MikroTik RouterOS | – | Commercial (included with hardware) | ✅ Purchased with router – invoice on file |
| OPNsense | – | BSD 2-Clause | ✅ Permitted for commercial use |
| Zenarmor (free tier) | – | Free tier (proprietary) | ✅ Permitted – no payment required, no cloud data transmission |
| WireGuard | – | GPLv2 | ✅ Permitted for commercial use |

### 4.3 Security Stack (IDS, IPS, SIEM, NDR, SOAR)

| Software | Version | License | Compliance Status |
|----------|---------|---------|-------------------|
| Snort 3 | – | GPLv2 | ✅ Permitted for commercial use |
| Wazuh SIEM | 4.x | GPLv2 | ✅ Permitted for commercial use |
| DarkGhost NDR | – | Proprietary (internal development) | ✅ Company-owned code. Developed internally by Ilie Lucian. |
| SnortML | – | Proprietary (internal development) | ✅ Company-owned code. Developed internally by Ilie Lucian. |
| Shuffle SOAR | – | Apache 2.0 | ✅ Permitted for commercial use |
| Fail2Ban | – | GPLv2 | ✅ Permitted |
| auditd | – | GPLv2 | ✅ Permitted |

### 4.4 Web Applications & Libraries

| Software | Version | License | Compliance Status |
|----------|---------|---------|-------------------|
| Odoo (Community) | – | LGPL | ✅ Permitted for commercial use |
| Zoho CRM | – | Commercial SaaS | ✅ Paid subscription – contract in place |
| Python | – | PSF License | ✅ Permitted |
| TensorFlow | – | Apache 2.0 | ✅ Permitted |
| Scapy | – | GPLv2 | ✅ Permitted |
| Flask | – | BSD | ✅ Permitted |

### 4.5 Custom Internal Tools – Copyright Notice

| Tool | Copyright Owner | Proof of Authorship |
|------|----------------|---------------------|
| DarkGhost NDR | Ilie Lucian (developed internally for the company) | Source code on company laptop + GitHub commit history |
| SnortML | Ilie Lucian (developed internally for the company) | Source code on company laptop + GitHub commit history |

> **Note on Copyright:** Under Romanian, Cypriot, and EU law (Berne Convention), copyright is automatic upon creation. No registration is required. The source code on company laptop and GitHub commit history serve as sufficient proof of authorship.

### 4.6 Summary – License Compliance by Category

| Category | Commercial (Paid) | Open-Source (Permissive) | Proprietary (Internal) |
|----------|-------------------|--------------------------|------------------------|
| Operating Systems | 0 | 2 | 0 |
| Network & Firewall | 1 (RouterOS) | 4 | 0 |
| Security Stack | 0 | 6 | 2 |
| Web Apps & Libraries | 1 (Zoho) | 6 | 0 |
| **TOTAL** | **2** | **18** | **2** |

### 4.7 License Compliance Declaration

> *To the best of my knowledge, all software listed above is used in compliance with its respective license terms. No unlicensed commercial software is present in production. All open-source software is used under GPLv2, BSD, Apache 2.0, LGPL, or PSF licenses – all of which permit commercial use without payment. Custom internal tools (DarkGhost NDR, SnortML) are company-owned code developed internally.*

---

## Section 5 – Compliance Checklist (Weekly Review)

| Task | Frequency | Last Run | Status |
|------|-----------|----------|--------|
| Review auditd logs | Weekly | May 12, 2026 | ✅ |
| Check Wazuh for new alerts | Daily | May 12, 2026 | ✅ |
| Verify backup integrity | Weekly | May 12, 2026 | ✅ |
| Review DarkGhost anomalies | Daily | May 12, 2026 | ✅ |
| Test unattended upgrades | Weekly | May 12, 2026 | ✅ |

---

## Section 6 – Incident Response Procedures

Runbook documents (internal, not public):

- Crypto phishing incident response
- Suspicious login investigation
- Withdrawal approval escalation
- Data breach notification (72-hour timeline)

---

## Section 7 – Hardware Inventory (Commercial Purchases)

All hardware purchased legally with invoices from Cyprus suppliers (Senetic, Bionic, Skroutz).

| Component | Model | Vendor | Invoice Status |
|-----------|-------|--------|----------------|
| Router | MikroTik hAP ac² | MikroTik / Senetic | ✅ On file |
| Backbone Switch | TP-Link TL-SG108E | TP-Link / Bionic | ✅ On file |
| Access Switches | 2× TP-Link TL-SG105 | TP-Link / Bionic | ✅ On file |
| WiFi AP | Ubiquiti UniFi 6 Plus | Ubiquiti / Skroutz | ✅ On file |
| Main Server | Geekom A9 Max | Geekom | ✅ On file |
| Backup Server | Mini PC Intel N100 | – | ✅ Retired hardware, company owned |
| Printer | HP LaserJet MFP 135a | HP | ✅ On file |
| Cables | Cat6 | – | ✅ On file |

---

## Section 8 – Next Steps (May 19 – May 30, 2026)

| Week | Task | Standard |
|------|------|----------|
| 12 | Password policy enforcement (login.defs) | ISO 27001 A.9.4.3 |
| 12 | SSH hardening (disable password login) | SOC 2 CC6.1 |
| 12 | GDPR records of processing register | GDPR Art. 30 |
| 13 | Disk encryption (LUKS) | GDPR Art. 32 |
| 13 | Disaster recovery test (full restore) | ISO 27001 A.17.1.1 |

---

## Section 9 – Audit Q&A Preparation

| Potential Question | Answer |
|--------------------|--------|
| "Did you pay for a Wazuh license?" | No. We use the open-source version, which is fully functional for our needs and complies with GPLv2 – it permits commercial use without payment. |
| "Is DarkGhost developed internally?" | Yes. It is proprietary software developed internally. The company owns the usage rights. Source code is versioned on GitHub. |
| "What license do you have for Zenarmor?" | We use the free tier. It does not send data to the cloud and is permitted for commercial use without payment. |
| "How do you manage security risk in custom tools?" | Custom tools run in isolation on a dedicated server, are monitored via Wazuh SIEM, and code is versioned on GitHub. Any changes require testing before deployment. |
| "Do you have proof of copyright for DarkGhost?" | Yes. The source code exists on company laptop and GitHub with commit history dating back to initial development. Under EU law, copyright is automatic upon creation – no registration is required. |

---

## Section 10 – Document Version History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | May 12, 2026 | Ilie Lucian | Initial document |
| 1.1 | May 15, 2026 | Ilie Lucian | Added Software License Compliance section, Copyright notice, Audit Q&A |

---

> **Declaration:** To the best of my knowledge, all information in this document is accurate and complete. All security controls and compliance measures are implemented as described.

**Signed,**  
Ilie Lucian  
Technical Department Manager  
May 15, 2026
