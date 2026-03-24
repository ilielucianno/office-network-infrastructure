# 08 - 2FA & Backup (Final Security Hardening)

This guide covers the final security measures: Two-Factor Authentication for Odoo, automated backups, and system monitoring.

---

## Prerequisites

- Odoo installed and configured ([06 - Odoo Installation](06-odoo-install.md))
- All users created in Odoo
- Backup directory `/backup` created

---

## Part 1: Two-Factor Authentication (2FA) in Odoo

### Step 1.1: Enable 2FA for Users

1. Log into Odoo as **admin**
2. Go to **Settings → Users → Users**
3. For each user (especially HR and admin):
   - Click on the user
   - Check **Two-Factor Authentication**
   - Click **Save**

### Step 1.2: User Setup

When user logs in next time:

1. Enter username and password
2. QR code appears
3. User scans with authenticator app:
   - **Google Authenticator** (Android/iOS)
   - **Microsoft Authenticator** (Android/iOS)
   - **Authy** (Android/iOS/Desktop)
4. Enter the 6-digit code
5. Login completes

**Important:** Users must save backup codes (displayed during setup) in case they lose their phone.

### Step 1.3: Enforce 2FA for All Users

To require 2FA for specific groups:

1. Go to **Settings → Technical → Security → Two-Factor Authentication**
2. Create a new policy
3. Set:
   - **User Group:** HR
   - **Enforced:** Yes

### Step 1.4: Reset 2FA for a User

If user loses phone:

1. Go to **Settings → Users → Users**
2. Open the user
3. Uncheck **Two-Factor Authentication**
4. Save
5. User logs in and sets up 2FA again

---

## Part 2: Automated Backups

### Step 2.1: Database Backup Script

Create the main backup script:

```bash
sudo nano /root/backup.sh
Add:

bash
#!/bin/bash
# Odoo Database Backup Script
# Runs daily at 2:00 AM

BACKUP_DIR="/backup"
DB_NAME="odoo_db"
DB_USER="odoo"
DB_PASS="odoo_secure_password"
DATE=$(date +%Y%m%d_%H%M%S)
RETENTION_DAYS=30

# Create backup directory if not exists
mkdir -p $BACKUP_DIR

# Backup database
mysqldump -u $DB_USER -p$DB_PASS $DB_NAME > $BACKUP_DIR/odoo_$DATE.sql

# Check if backup succeeded
if [ $? -eq 0 ]; then
    # Compress
    gzip $BACKUP_DIR/odoo_$DATE.sql
    echo "$(date): Backup successful - odoo_$DATE.sql.gz" >> /var/log/backup.log
else
    echo "$(date): Backup FAILED" >> /var/log/backup.log
    exit 1
fi

# Remove old backups
find $BACKUP_DIR -name "odoo_*.sql.gz" -mtime +$RETENTION_DAYS -delete

echo "$(date): Old backups cleaned (retention: $RETENTION_DAYS days)" >> /var/log/backup.log
Make executable:

bash
sudo chmod +x /root/backup.sh
Step 2.2: Odoo Filestore Backup
Add filestore backup to script:

bash
sudo nano /root/backup.sh
Add after database backup:

bash
# Backup Odoo filestore
FILESTORE_PATH="/opt/odoo/.local/share/Odoo/filestore/odoo_db"
if [ -d "$FILESTORE_PATH" ]; then
    tar -czf $BACKUP_DIR/filestore_$DATE.tar.gz $FILESTORE_PATH
    echo "$(date): Filestore backup completed" >> /var/log/backup.log
fi
Step 2.3: Schedule Backups with Cron
bash
sudo crontab -e
Add:

bash
# Daily database backup at 2:00 AM
0 2 * * * /root/backup.sh

# Weekly full system backup (optional) on Sunday at 3:00 AM
0 3 * * 0 tar -czf /backup/system_$(date +\%Y\%m\%d).tar.gz /etc /opt/odoo
Step 2.4: External Backup (Critical)
Option A: External HDD

Mount external drive:

bash
# Create mount point
sudo mkdir /mnt/backup_drive

# Find drive
lsblk

# Mount (example: /dev/sdb1)
sudo mount /dev/sdb1 /mnt/backup_drive

# Add to fstab for auto-mount
echo "/dev/sdb1 /mnt/backup_drive ext4 defaults 0 0" | sudo tee -a /etc/fstab
Modify backup script to sync:

bash
# Add to /root/backup.sh
rsync -av $BACKUP_DIR/ /mnt/backup_drive/backup/
Option B: Cloud Backup (rclone)

Install rclone:

bash
sudo apt install rclone -y
sudo rclone config
Configure Google Drive or other cloud storage, then add to backup script:

bash
# Sync to cloud
rclone sync $BACKUP_DIR/ google_drive:backup/
Part 3: Fail2Ban (Brute-Force Protection)
Step 3.1: Install Fail2Ban
bash
sudo apt install fail2ban -y
Step 3.2: Configure SSH Protection
bash
sudo nano /etc/fail2ban/jail.local
Add:

ini
[DEFAULT]
bantime = 3600
findtime = 600
maxretry = 5

[sshd]
enabled = true
port = 2222
filter = sshd
logpath = /var/log/auth.log
maxretry = 3
bantime = 3600
Step 3.3: Configure Odoo Protection
Create Odoo filter:

bash
sudo nano /etc/fail2ban/filter.d/odoo.conf
Add:

ini
[Definition]
failregex = ^.*Failed login attempt.*from <HOST>.*$
ignoreregex =
Add to jail.local:

ini
[odoo]
enabled = true
port = 8069
filter = odoo
logpath = /var/log/odoo/odoo.log
maxretry = 5
bantime = 1800
Step 3.4: Restart Fail2Ban
bash
sudo systemctl restart fail2ban
sudo systemctl enable fail2ban

# Check status
sudo fail2ban-client status
sudo fail2ban-client status sshd
Part 4: System Monitoring
Step 4.1: Check Logs Regularly
bash
# Odoo logs
sudo tail -f /var/log/odoo/odoo.log

# Auth logs
sudo tail -f /var/log/auth.log

# System logs
sudo tail -f /var/log/syslog

# Backup logs
sudo tail -f /var/log/backup.log
Step 4.2: Monitor Disk Space
bash
# Check disk usage
df -h

# Monitor backup directory size
du -sh /backup
Set up alert for low disk space (optional):

bash
# Add to crontab (daily at 8 AM)
0 8 * * * df -h | grep -E '/dev/sda|/dev/sdb' | awk '{if ($5+0 > 80) print "Warning: " $1 " is " $5 " full"}' | mail -s "Disk Alert" admin@company.com
Part 5: Security Audit Checklist
Security Measure	Status	Verified
2FA enabled for all HR users	☐	☐
2FA enabled for admin	☐	☐
Daily database backups running	☐	☐
External backup configured	☐	☐
Fail2Ban active	☐	☐
UFW active with correct rules	☐	☐
Automatic security updates	☐	☐
SSH key-based auth only	☐	☐
Root login disabled	☐	☐
Odoo master password changed	☐	☐
Step 6: Disaster Recovery Plan
Restore Database from Backup
bash
# Stop Odoo
sudo systemctl stop odoo

# Restore database
mysql -u odoo -p odoo_db < /backup/odoo_20260324.sql

# Restart Odoo
sudo systemctl start odoo
Restore Filestore
bash
# Extract backup
tar -xzf /backup/filestore_20260324.tar.gz -C /

# Set permissions
sudo chown -R odoo:odoo /opt/odoo/.local/share/Odoo
Full System Recovery
Reinstall Ubuntu Server

Restore configuration files from /backup/system_*.tar.gz

Restore database

Restart services

Step 7: Monthly Maintenance Tasks
Task	Frequency	Command
Check backup integrity	Monthly	gzip -t /backup/odoo_*.sql.gz
Update system	Monthly	sudo apt update && sudo apt upgrade -y
Check logs for errors	Monthly	sudo grep -i error /var/log/odoo/odoo.log
Verify 2FA still active	Monthly	Check users in Odoo
Test restore from backup	Quarterly	Restore to test environment
Update passwords	Quarterly	Change master password
Final Verification
Run these checks:

bash
# Check Fail2Ban
sudo fail2ban-client status

# Check backup logs
tail -20 /var/log/backup.log

# Check UFW status
sudo ufw status verbose

# Check Odoo status
sudo systemctl status odoo

# Check disk space
df -h
Conclusion
Your network is now fully configured with:

✅ VLAN segmentation (HR / Support / Server)

✅ Firewall rules blocking lateral movement

✅ WireGuard VPN for secure remote access

✅ Odoo HR system with 2FA

✅ Automated daily backups

✅ Fail2Ban brute-force protection

✅ UFW firewall on server

✅ Automatic security updates

Next Steps
Consider adding network monitoring (Zabbix or PRTG)

Evaluate SIEM solution (Wazuh or ELK)

Plan for cloud backup as offsite redundancy

Reference Files
Backup Script

Fail2Ban Config
UFW Rules
