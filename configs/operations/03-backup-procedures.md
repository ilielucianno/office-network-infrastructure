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
| Server /backup/ | Local copies | 30 days |
| External HDD | Physical backup | 90 days |
| Google Drive (future) | Cloud backup | Unlimited |

---

## How to Restore

### Restore Odoo Database

1. Stop Odoo:
sudo systemctl stop odoo

text

2. Find latest backup:
ls -la /backup/odoo_*.sql.gz

text

3. Restore database:
gunzip -c /backup/odoo_20260324.sql.gz | sudo mysql -u odoo -p odoo_db

text

4. Start Odoo:
sudo systemctl start odoo

text

5. Test login: http://192.168.30.10:8069

---

### Restore Router Configuration

1. Connect to router via WinBox
2. Go to Files
3. Upload the saved .rsc file
4. Open Terminal
5. Run:
/import router-config-working.rsc

text

---

### Restore Switch Configuration

1. Connect to switch via WinBox
2. Go to Files
3. Upload the saved .rsc file
4. Open Terminal
5. Run:
/import switch-config-working.rsc

text

---

## Backup Verification

| Check | How | Frequency |
|-------|-----|-----------|
| Backup file exists | ls -la /backup/ | Daily |
| File size not zero | ls -lh /backup/ | Daily |
| Can restore | Test restore on spare machine | Monthly |

---

## Manual Backup: Zoho Data

1. Log in to Zoho as admin
2. Go to Settings → Data Administration → Export
3. Select all modules
4. Click Export
5. Download the ZIP file
6. Save to external drive (and optionally cloud)

---

## Emergency Recovery Steps

### If Server Dies Completely

1. Get new hardware
2. Install Ubuntu Server
3. Restore database from backup
4. Restore Odoo filestore (if needed)
5. Restart services

### If Router Dies Completely

1. Get new MikroTik router
2. Connect to WinBox
3. Import saved configuration
4. Verify VLANs, firewall, VPN

---

## Backup Schedule

| Time | Task |
|------|------|
| 2:00 AM | Database backup |
| Sunday 3:00 AM | Full system backup (optional) |
| Monthly | Manual Zoho export |

---

## Important Notes

- Test your backups — a backup that cannot be restored is useless
- Keep one backup offsite — in case of fire or theft
- Document passwords — store in a secure place (not in this repository)
