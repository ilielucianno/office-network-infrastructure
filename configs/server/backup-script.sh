#!/bin/bash
# ============================================
# Automated Backup Script for Office Network
# Location: configs/server/backup-script.sh
# Purpose: Backup MikroTik config, Odoo database, and server files
# Retention: 30 days
# Schedule: Daily at 2:00 AM (add to crontab)
# ============================================

# ============================================
# CONFIGURATION
# ============================================

BACKUP_BASE_DIR="/var/backups"
MIKROTIK_BACKUP_DIR="$BACKUP_BASE_DIR/mikrotik"
ODOO_BACKUP_DIR="$BACKUP_BASE_DIR/odoo"
SERVER_BACKUP_DIR="$BACKUP_BASE_DIR/server"
RETENTION_DAYS=30

# MikroTik connection details
MIKROTIK_IP="192.168.30.1"
MIKROTIK_USER="admin"
# Password is read from environment variable or .env file
MIKROTIK_PASS="${MIKROTIK_PASSWORD:-}"

# Odoo database details
ODOO_DB="odoo"
ODOO_USER="odoo"
ODOO_PASS="${ODOO_DB_PASSWORD:-}"

# Directories to backup (server configs)
SERVER_DIRS=(
    "/etc/wazuh"
    "/etc/snort"
    "/etc/ufw"
    "/etc/fail2ban"
    "/var/ossec/etc"
    "/opt/darkghost"
    "/opt/snortml"
)

# ============================================
# FUNCTIONS
# ============================================

log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

create_directories() {
    mkdir -p "$MIKROTIK_BACKUP_DIR"
    mkdir -p "$ODOO_BACKUP_DIR"
    mkdir -p "$SERVER_BACKUP_DIR"
}

# ============================================
# MIKROTIK BACKUP
# ============================================

backup_mikrotik() {
    log_message "Starting MikroTik backup..."
    
    if ! command -v sshpass &> /dev/null; then
        log_message "⚠️ sshpass not installed. Install with: sudo apt install sshpass"
        log_message "⚠️ Skipping MikroTik backup"
        return 1
    fi
    
    if [ -z "$MIKROTIK_PASS" ]; then
        log_message "⚠️ MIKROTIK_PASSWORD not set. Skipping MikroTik backup"
        log_message "   Set it with: export MIKROTIK_PASSWORD='your_password'"
        return 1
    fi
    
    DATE=$(date +%Y-%m-%d_H-%M-%S)
    BACKUP_FILE="$MIKROTIK_BACKUP_DIR/mikrotik-backup-$DATE.rsc"
    
    sshpass -p "$MIKROTIK_PASS" ssh -o StrictHostKeyChecking=no "$MIKROTIK_USER@$MIKROTIK_IP" "/export" > "$BACKUP_FILE"
    
    if [ $? -eq 0 ] && [ -s "$BACKUP_FILE" ]; then
        # Create anonymized version (remove sensitive data)
        sed -i 's/private-key="[^"]*"/private-key="<REDACTED>"/g' "$BACKUP_FILE"
        sed -i 's/public-key="[^"]*"/public-key="<REDACTED>"/g' "$BACKUP_FILE"
        sed -i 's/password="[^"]*"/password="<REDACTED>"/g' "$BACKUP_FILE"
        sed -i 's/secret="[^"]*"/secret="<REDACTED>"/g' "$BACKUP_FILE"
        
        gzip -f "$BACKUP_FILE"
        log_message "✅ MikroTik backup successful: $BACKUP_FILE.gz"
    else
        log_message "❌ MikroTik backup FAILED"
        return 1
    fi
}

# ============================================
# ODOO DATABASE BACKUP
# ============================================

backup_odoo() {
    log_message "Starting Odoo database backup..."
    
    if ! command -v pg_dump &> /dev/null; then
        log_message "⚠️ pg_dump not found. Is PostgreSQL installed?"
        log_message "⚠️ Skipping Odoo backup"
        return 1
    fi
    
    DATE=$(date +%Y-%m-%d_%H-%M-%S)
    BACKUP_FILE="$ODOO_BACKUP_DIR/odoo-db-backup-$DATE.sql"
    
    if [ -n "$ODOO_PASS" ]; then
        PGPASSWORD="$ODOO_PASS" pg_dump -U "$ODOO_USER" "$ODOO_DB" > "$BACKUP_FILE"
    else
        pg_dump -U "$ODOO_USER" "$ODOO_DB" > "$BACKUP_FILE"
    fi
    
    if [ $? -eq 0 ] && [ -s "$BACKUP_FILE" ]; then
        gzip -f "$BACKUP_FILE"
        log_message "✅ Odoo backup successful: $BACKUP_FILE.gz"
    else
        log_message "❌ Odoo backup FAILED"
        return 1
    fi
}

# ============================================
# SERVER CONFIGURATIONS BACKUP
# ============================================

backup_server_configs() {
    log_message "Starting server configurations backup..."
    
    DATE=$(date +%Y-%m-%d_%H-%M-%S)
    BACKUP_FILE="$SERVER_BACKUP_DIR/server-configs-backup-$DATE.tar.gz"
    
    # Build tar command with directories that exist
    TAR_ARGS=""
    for dir in "${SERVER_DIRS[@]}"; do
        if [ -d "$dir" ]; then
            TAR_ARGS="$TAR_ARGS $dir"
        else
            log_message "⚠️ Directory not found: $dir"
        fi
    done
    
    if [ -n "$TAR_ARGS" ]; then
        tar -czf "$BACKUP_FILE" $TAR_ARGS 2>/dev/null
        if [ $? -eq 0 ]; then
            log_message "✅ Server configs backup successful: $BACKUP_FILE"
        else
            log_message "❌ Server configs backup FAILED"
        fi
    else
        log_message "⚠️ No directories found to backup"
    fi
}

# ============================================
# CLEAN OLD BACKUPS
# ============================================

clean_old_backups() {
    log_message "Cleaning backups older than $RETENTION_DAYS days..."
    
    find "$MIKROTIK_BACKUP_DIR" -name "*.gz" -type f -mtime +$RETENTION_DAYS -delete
    find "$ODOO_BACKUP_DIR" -name "*.gz" -type f -mtime +$RETENTION_DAYS -delete
    find "$SERVER_BACKUP_DIR" -name "*.gz" -type f -mtime +$RETENTION_DAYS -delete
    
    log_message "✅ Old backups cleaned"
}

# ============================================
# SUMMARY
# ============================================

print_summary() {
    log_message "========================================="
    log_message "BACKUP SUMMARY"
    log_message "========================================="
    
    echo ""
    echo "MikroTik backups:"
    ls -la "$MIKROTIK_BACKUP_DIR" 2>/dev/null | tail -3 || echo "  No backups found"
    
    echo ""
    echo "Odoo backups:"
    ls -la "$ODOO_BACKUP_DIR" 2>/dev/null | tail -3 || echo "  No backups found"
    
    echo ""
    echo "Server configs backups:"
    ls -la "$SERVER_BACKUP_DIR" 2>/dev/null | tail -3 || echo "  No backups found"
    
    log_message "========================================="
}

# ============================================
# MAIN EXECUTION
# ============================================

main() {
    log_message "Starting automated backup process..."
    echo ""
    
    create_directories
    
    backup_mikrotik
    echo ""
    
    backup_odoo
    echo ""
    
    backup_server_configs
    echo ""
    
    clean_old_backups
    echo ""
    
    print_summary
    
    log_message "Backup process completed"
}

# Run main function
main
