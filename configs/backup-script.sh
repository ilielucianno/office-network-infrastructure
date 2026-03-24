#!/bin/bash
# Database Backup Script
# Purpose: Daily backup of MariaDB (Odoo database)
# Location: /root/backup.sh
# Schedule: Run via cron at 2:00 AM

# Configuration
DB_USER="root"
DB_PASSWORD="your_secure_password_here"
DB_NAME="odoo_db"
BACKUP_DIR="/backup"
RETENTION_DAYS=30

# Create backup directory if it doesn't exist
mkdir -p $BACKUP_DIR

# Create backup filename with date
DATE=$(date +%Y%m%d)
BACKUP_FILE="$BACKUP_DIR/odoo_$DATE.sql"

# Perform the backup
mysqldump -u $DB_USER -p$DB_PASSWORD $DB_NAME > $BACKUP_FILE

# Check if backup was successful
if [ $? -eq 0 ]; then
    echo "$(date): Backup successful: $BACKUP_FILE" >> /var/log/backup.log
    
    # Compress the backup
    gzip $BACKUP_FILE
    echo "$(date): Compressed: $BACKUP_FILE.gz" >> /var/log/backup.log
else
    echo "$(date): Backup FAILED for $DB_NAME" >> /var/log/backup.log
    exit 1
fi

# Remove backups older than RETENTION_DAYS
find $BACKUP_DIR -name "odoo_*.sql.gz" -mtime +$RETENTION_DAYS -delete

# Optional: Sync to external HDD
# rsync -av $BACKUP_DIR/ /mnt/external_hdd/backup/

# Optional: Sync to cloud (requires rclone configured)
# rclone sync $BACKUP_DIR/ google_drive:backup/

echo "$(date): Cleanup completed. Backups older than $RETENTION_DAYS days removed." >> /var/log/backup.log
