# Backup Procedures

This document describes what data we back up and how to restore it.

---

## What We Back Up

| Data | Location | Frequency | Method |
|------|----------|-----------|--------|
| Odoo database | Server | Daily | MySQL dump |
| Odoo files | Server | Weekly | Tar archive |
| Zoho data | Cloud | Monthly | Manual export |
| Router config | MikroTik | After changes | Export file |
| Switch config | MikroTik | After changes | Export file |

---

## Backup Locations

| Location | Purpose | Retention |
|----------|---------|-----------|
| Server `/backup/` | Local copies | 30 days |
| External HDD | Physical backup | 90 days |
| Google Drive (future) | Cloud backup | Unlimited |

---

## How to Restore

### Restore Odoo Database

1. Stop Odoo:
```bash
sudo systemctl stop odoo
Find latest backup:

bash
ls -la /backup/odoo_*.sql.gz
Restore database:

bash
gunzip -c /backup/odoo_20260324.sql.gz | sudo mysql -u odoo -p odoo_db
Start Odoo:

bash
sudo systemctl start odoo
Test login: http://192.168.30.10:8069

Restore Router Configuration
Connect to router via WinBox

Go to Files

Upload the saved .rsc file

Open Terminal

Run:

text
/import router-config-working.rsc
Restore Switch Configuration
Connect to switch via WinBox

Go to Files

Upload the saved .rsc file

Open Terminal

Run:

text
/import switch-config-working.rsc
Backup Verification
Check	How	Frequency
Backup file exists	ls -la /backup/	Daily
File size not zero	ls -lh /backup/	Daily
Can restore	Test restore on spare machine	Monthly
Manual Backup: Zoho Data
Log in to Zoho as admin

Go to Settings → Data Administration → Export

Select all modules

Click Export

Download the ZIP file

Save to external drive (and optionally cloud)

Emergency Recovery Steps
If Server Dies Completely
Get new hardware

Install Ubuntu Server (see 05-server-install.md)

Restore database from backup (steps above)

Restore Odoo filestore (if needed)

Restart services

If Router Dies Completely
Get new MikroTik router

Connect to WinBox

Import saved configuration (steps above)

Verify VLANs, firewall, VPN

Backup Schedule
Time	Task
2:00 AM	Database backup
Sunday 3:00 AM	Full system backup (optional)
Monthly	Manual Zoho export
