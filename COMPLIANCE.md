# Compliance & Security Framework

## Overview

This document outlines the security controls implemented to meet regulatory requirements for companies operating in Cyprus/EU. The infrastructure serves a consulting & accounting company (Turtle Cove Consultancy Ltd) providing B2B services to online gambling operators.

**Applicable regulations:** GDPR (mandatory), SOC 2 (recommended), ISO 27001 (guidance).

---

## GDPR Compliance (General Data Protection Regulation)

### Status: Partial Implementation - In Progress

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

## SOC 2 Trust Services Criteria (Guidance)

| Criteria | Implementation | Status |
|----------|----------------|--------|
| CC6.1 – Logical access controls | VLAN segmentation, firewall rules, WireGuard VPN | ✅ |
| CC6.8 – Data encryption (transit) | TLS, WireGuard | ✅ |
| CC7.1 – Monitoring & detection | Wazuh SIEM, DarkGhost NDR, Snort IDS | ✅ |
| CC7.2 – Incident response | Runbook documented | 🟢 Drafted |
| CC7.4 – Vulnerability management | Unattended upgrades, kernel patching | ✅ |
| CC8.1 – Change management | Manual review, GitHub documentation | 🟢 Partial |

---

## ISO 27001 Alignment (Annex A Controls)

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

## Compliance Checklist (Weekly Review)

| Task | Frequency | Last Run | Status |
|------|-----------|----------|--------|
| Review auditd logs | Weekly | May 12, 2026 | ✅ |
| Check Wazuh for new alerts | Daily | May 12, 2026 | ✅ |
| Verify backup integrity | Weekly | May 12, 2026 | ✅ |
| Review DarkGhost anomalies | Daily | May 12, 2026 | ✅ |
| Test unattended upgrades | Weekly | May 12, 2026 | ✅ |

---

## Incident Response Procedures

Runbook documents (internal, not public):

- Crypto phishing incident response
- Suspicious login investigation
- Withdrawal approval escalation
- Data breach notification (72-hour timeline)

---

## Next Steps (May 19 - May 30, 2026)

| Week | Task | Standard |
|------|------|----------|
| 12 | Password policy enforcement (login.defs) | ISO 27001 A.9.4.3 |
| 12 | SSH hardening (disable password login) | SOC 2 CC6.1 |
| 12 | GDPR records of processing register | GDPR Art. 30 |
| 13 | Disk encryption (LUKS) | GDPR Art. 32 |
| 13 | Disaster recovery test (full restore) | ISO 27001 A.17.1.1 |

---

## Author

**Ilie Lucian** – Technical Department Manager  
Last updated: May 12, 2026

> This document is a living document and will be updated as compliance requirements evolve.
