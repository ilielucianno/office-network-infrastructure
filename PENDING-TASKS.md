# Pending Tasks - Technical & Compliance

## Overview

This document tracks pending security and compliance tasks for the office network infrastructure. Tasks are prioritized by deadline and impact.

**Last updated:** May 22, 2026  
**Next review:** May 29, 2026

---

## Task Summary

| Task | Deadline | Priority | Status |
|------|----------|----------|--------|
| Disaster recovery test (restore from backup) | May 31, 2026 | 🟡 Medium | Completed (tested, <1h) |
| Offsite backup (Google Drive) | Q3 2026 | 🟢 Low | Optional – not mandatory |

---

## Task Details

### 1. Disaster Recovery Test (Restore from Backup)

**Description:** Simulate complete server failure and test the ability to restore from backup on the backup server (Intel N100).

**Why needed:** A backup that cannot be restored is not a backup. Testing ensures recovery is actually possible.

**Result:** ✅ Tested – recovery completed in under 1 hour. All services operational after restore.

**Responsible:** Ilie Lucian

### 2. Offsite Backup (Google Drive)

**Description:** Optional cloud backup for additional redundancy.

**Status:** Not started – not required for compliance. Local + external encrypted backups are sufficient.

**Responsible:** Ilie Lucian (if decided)

---

## Completed Tasks (May 12-22, 2026)

| Task | Completion Date |
|------|-----------------|
| auditd installation | May 12, 2026 |
| Unattended-upgrades enabled | May 12, 2026 |
| Dirty Frag kernel patch (6.17.0-23) | May 12, 2026 |
| DarkGhost Python packages update | May 12, 2026 |
| Risk assessment documented | May 12, 2026 |
| Security awareness training documented | May 12, 2026 |
| Change management policy documented | May 12, 2026 |
| GDPR Art. 30 – Records of Processing | Handled by accounting/HR |
| Lenovo BYOVD vulnerability audit (3 laptops) | May 22, 2026 |
| Physical security documented | May 22, 2026 |
| Disaster recovery test (restore from backup) | May 22, 2026 |

---

## Cancelled / Not Needed Tasks

| Task | Reason |
|------|--------|
| Disk encryption (LUKS) | Physical security sufficient (card + code + cameras + server room), remote access requirement prevents LUKS, backups already encrypted |

---

## Notes

- All passwords for critical systems are stored in Standard Notes (master password protected)
- Backup server (Intel N100) is available – tested, recovery <1h
- Offsite backup (Google Drive) is optional – not required for compliance
- GDPR Art. 30 (Records of Processing) is the responsibility of accounting/HR, not IT

---

## Author

**Ilie Lucian** – Technical Department Manager


