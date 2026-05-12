# Pending Tasks - Technical & Compliance

## Overview

This document tracks pending security and compliance tasks for the office network infrastructure. Tasks are prioritized by deadline and impact.

**Last updated:** May 12, 2026  
**Next review:** May 19, 2026

---

## Task Summary

| Task | Deadline | Priority | Status |
|------|----------|----------|--------|
| GDPR Art. 30 – Records of Processing | May 23, 2026 | 🔴 High | Not started |
| Disk encryption (LUKS) | May 30, 2026 | 🔴 High | Not started |
| Disaster recovery test (restore from backup) | May 31, 2026 | 🟡 Medium | Not started |

---

## Task Details

### 1. GDPR Art. 30 – Records of Processing

**Description:** Complete the official GDPR "Record of Processing Activities" form from the Cyprus Commissioner for Personal Data Protection.

**Why needed:** Legal requirement for any company processing personal data in the EU.

**Steps:**
1. Download form from www.dataprotection.gov.cy
2. Fill in company details (Turtle Cove Consultancy Ltd)
3. List all data processing activities:
   - Employee data (HR, salaries, contracts)
   - Accounting data (invoices, payments, VAT)
   - Zoho CRM data (customer support)
4. Document data retention periods
5. Save completed form (PDF) and keep on file

**Deadline:** May 23, 2026

**Responsible:** Ilie Lucian

---

### 2. Disk Encryption (LUKS)

**Description:** Encrypt the Ubuntu host disk on the physical server at the office (Geekom A9 Max). This protects all data (including OPNsense and Windows VMs) in case of physical theft.

**Why needed:** GDPR Article 32 – "Security of processing" – requires encryption for stored personal data.

**Method:** Reinstall Ubuntu with LUKS encryption (full disk encryption).

**Prerequisites:**
- Full backup of server (see Backup Procedures)
- External disk for backup storage
- Scheduled weekend downtime (approximately 4-6 hours)

**Steps:**
1. Full backup to external SSD (`/etc`, `/home`, `/var/lib/docker`, VirtualBox VMs)
2. Boot from Ubuntu Live USB
3. Install Ubuntu with "Encrypt the new Ubuntu installation for security"
4. Set strong encryption password (store in Standard Notes)
5. Restore backup and VMs
6. Verify all services operational

**Deadline:** May 30, 2026

**Responsible:** Ilie Lucian

---

### 3. Disaster Recovery Test (Restore from Backup)

**Description:** Simulate complete server failure and test the ability to restore from backup on the backup server (Intel N100).

**Why needed:** A backup that cannot be restored is not a backup. Testing ensures recovery is actually possible.

**Steps:**
1. Take primary server offline
2. Restore latest backup to backup server
3. Start all services (Wazuh, DarkGhost, SQL Detector, OPNsense VM)
4. Measure recovery time
5. Document any issues
6. Restore primary server back online

**Expected recovery time:** 30-45 minutes

**Deadline:** May 31, 2026

**Responsible:** Ilie Lucian

---

## Completed Tasks (May 12, 2026)

| Task | Completion Date |
|------|-----------------|
| auditd installation | May 12, 2026 |
| Unattended-upgrades enabled | May 12, 2026 |
| Dirty Frag kernel patch (6.17.0-23) | May 12, 2026 |
| DarkGhost Python packages update | May 12, 2026 |
| Risk assessment documented | May 12, 2026 |
| Security awareness training documented | May 12, 2026 |
| Change management policy documented | May 12, 2026 |

---

## Notes

- All passwords for encryption and critical systems are stored in Standard Notes (master password protected)
- Backup server (Intel N100) is available for disaster recovery testing
- Offsite backup (Google Drive) is planned for Q3 2026

---

## Author

**Ilie Lucian** – Technical Department Manager

*This document will be updated weekly.*
