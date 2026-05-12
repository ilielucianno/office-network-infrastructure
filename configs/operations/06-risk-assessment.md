# Risk Assessment

## Overview

This document summarizes the annual risk assessment performed for the IT infrastructure and security controls. The assessment identifies potential threats, evaluates their impact, and documents existing mitigations.

**Date of assessment:** May 12, 2026  
**Next review:** May 2027  
**Participants:** Ilie Lucian (Tech Lead), Owners (David, Gabriel)

---

## Risk Assessment Methodology

For each identified risk, we evaluate:

| Factor | Scale |
|--------|-------|
| **Likelihood** | Rare / Unlikely / Possible / Likely / Almost Certain |
| **Impact** | Low / Medium / High / Critical |
| **Risk level** | Low (1-4) / Medium (5-8) / High (9-12) |

**Risk score formula:** Likelihood (1-5) × Impact (1-4) = Score (1-20)

---

## Risk Register

### 1. Unauthorized Access to Server

| Attribute | Value |
|-----------|-------|
| **Threat** | Attacker gains SSH access to server (brute-force, stolen key) |
| **Likelihood** | Unlikely (2) |
| **Impact** | Critical (4) |
| **Risk score** | 8 (Medium-High) |

**Existing controls:**
- SSH key-based authentication only (password login disabled)
- Fail2Ban blocks IP after 3 failed attempts
- WireGuard VPN required for remote access
- Wazuh monitors failed logins and triggers Active Response

**Mitigation status:** ✅ Adequately controlled

---

### 2. Data Breach (GDPR)

| Attribute | Value |
|-----------|-------|
| **Threat** | Employee or HR data exposed (leak, theft, ransomware) |
| **Likelihood** | Unlikely (2) |
| **Impact** | Critical (4) |
| **Risk score** | 8 (Medium-High) |

**Existing controls:**
- Firewall and VLAN isolation
- Encrypted backups (external SSD)
- auditd monitors access to sensitive files
- Daily backups with 30-day retention
- Zoho breach monitoring (Google alerts)

**Mitigation status:** ✅ Partially controlled (disk encryption pending)

**Planned improvements:**
- Disk encryption (LUKS) – due May 30, 2026

---

### 3. Ransomware / Malware

| Attribute | Value |
|-----------|-------|
| **Threat** | Malware infects server or workstations |
| **Likelihood** | Rare (1) |
| **Impact** | Critical (4) |
| **Risk score** | 4 (Low-Medium) |

**Existing controls:**
- No direct internet exposure (server behind firewall)
- Users have limited permissions
- Backup available for restore
- Unattended security updates

**Mitigation status:** ✅ Adequately controlled

---

### 4. Phishing Attack (User Compromise)

| Attribute | Value |
|-----------|-------|
| **Threat** | User clicks malicious link, enters credentials |
| **Likelihood** | Possible (3) |
| **Impact** | Medium (2) |
| **Risk score** | 6 (Medium) |

**Existing controls:**
- 2FA mandatory for all Zoho accounts
- IP verification (unrecognized IP triggers 2FA)
- Withdrawal delays (7-21 days) with manual approval
- Regular phishing training (every 2-3 months)

**Mitigation status:** ✅ Adequately controlled

---

### 5. Hardware Failure (Server / Router)

| Attribute | Value |
|-----------|-------|
| **Threat** | SSD failure, power supply failure, router dies |
| **Likelihood** | Unlikely (2) |
| **Impact** | High (3) |
| **Risk score** | 6 (Medium) |

**Existing controls:**
- Daily backups (database) and weekly backups (system)
- Backup server (Intel N100) available for failover
- Router backup configuration saved
- External HDD for offsite backup

**Mitigation status:** ✅ Adequately controlled

**Planned improvements:**
- Disaster recovery test (restore from backup) – due May 31, 2026

---

### 6. Network Attack (DDoS, Port Scan, Lateral Movement)

| Attribute | Value |
|-----------|-------|
| **Threat** | External or internal attacker attempts to exploit network |
| **Likelihood** | Rare (1) |
| **Impact** | Medium (2) |
| **Risk score** | 2 (Low) |

**Existing controls:**
- VLAN isolation (HR, Support, Server)
- Firewall rules block inter-VLAN traffic by default
- DarkGhost NDR detects port scans and lateral movement
- OPNsense + Zenarmor for Layer 7 filtering
- Snort IDS for signature-based detection

**Mitigation status:** ✅ Adequately controlled

---

### 7. Zero-Day Vulnerability (Software / Kernel)

| Attribute | Value |
|-----------|-------|
| **Threat** | Unknown exploit in Ubuntu, Docker, or applications |
| **Likelihood** | Rare (1) |
| **Impact** | Critical (4) |
| **Risk score** | 4 (Low-Medium) |

**Existing controls:**
- Unattended-upgrades for security patches
- Kernel updates applied within 24 hours of release
- Wazuh monitors for CVE vulnerabilities
- DarkGhost detects behavioral anomalies (zero-day ready)

**Mitigation status:** ✅ Adequately controlled

**Recent example:** Dirty Frag (CVE-2026-43284) patched within 8 hours of disclosure.

---

## Risk Matrix Summary

| Risk | Likelihood (1-5) | Impact (1-4) | Score (1-20) | Level | Status |
|------|------------------|--------------|---------------|-------|--------|
| Unauthorized server access | 2 | 4 | 8 | Medium-High | ✅ Controlled |
| Data breach (GDPR) | 2 | 4 | 8 | Medium-High | 🟡 Partial (encryption pending) |
| Ransomware / malware | 1 | 4 | 4 | Low-Medium | ✅ Controlled |
| Phishing attack | 3 | 2 | 6 | Medium | ✅ Controlled |
| Hardware failure | 2 | 3 | 6 | Medium | ✅ Controlled |
| Network attack | 1 | 2 | 2 | Low | ✅ Controlled |
| Zero-day vulnerability | 1 | 4 | 4 | Low-Medium | ✅ Controlled |

---

## Action Plan

| Risk | Action | Due Date | Responsible |
|------|--------|----------|-------------|
| Data breach | Implement disk encryption (LUKS) | May 30, 2026 | Ilie |
| Hardware failure | Perform disaster recovery test (restore from backup) | May 31, 2026 | Ilie |
| All risks | Annual review | May 2027 | Ilie + Owners |

---

## Approval

| Role | Name | Signature | Date |
|------|------|-----------|------|
| Tech Lead | Ilie Lucian | (approved) | May 12, 2026 |
| Owner | Owner 1 (France) | (verbal approval) | May 12, 2026 |
| Owner | Owner 2 (Israel) | (verbal approval) | May 12, 2026 |

---

**Status:** ✅ Risk assessment documented. All critical risks have existing controls. Two improvements planned (encryption + DR test).

**Next review:** May 2027
