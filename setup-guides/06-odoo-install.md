# 06 - Odoo Installation & HR Configuration

This guide covers the installation of Odoo, MariaDB database, and the complete HR system configuration.

---

## Prerequisites

- Ubuntu Server installed and configured ([05 - Server Installation](05-server-install.md))
- Server IP: 192.168.30.10
- SSH access from HR VLAN or VPN

---

## Step 1: Install MariaDB Database

```bash
# Install MariaDB
sudo apt install mariadb-server -y

# Secure installation
sudo mysql_secure_installation
Follow prompts:

Enter current password for root: Enter (no password yet)

Switch to unix_socket authentication? N

Change root password? Y (set a strong password)

Remove anonymous users? Y

Disallow root login remotely? Y

Remove test database? Y

Reload privilege tables? Y

Step 2: Create Odoo Database User
bash
# Login to MariaDB
sudo mysql -u root -p

# Create database for Odoo
CREATE DATABASE odoo_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

# Create user for Odoo
CREATE USER 'odoo'@'localhost' IDENTIFIED BY 'odoo_secure_password';

# Grant privileges
GRANT ALL PRIVILEGES ON odoo_db.* TO 'odoo'@'localhost';

# Exit
EXIT;
Step 3: Install Odoo 16 (Community Edition)
bash
# Update system
sudo apt update

# Install dependencies
sudo apt install python3-pip python3-dev python3-venv \
    build-essential libssl-dev libffi-dev \
    libxml2-dev libxslt1-dev libjpeg-dev \
    libpq-dev libldap2-dev libsasl2-dev \
    node-less npm -y

# Install wkhtmltopdf (for PDF reports)
wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-2/wkhtmltox_0.12.6.1-2.jammy_amd64.deb
sudo dpkg -i wkhtmltox_0.12.6.1-2.jammy_amd64.deb
sudo apt install -f -y

# Add Odoo system user
sudo adduser --system --home=/opt/odoo --group odoo

# Install Odoo from source
sudo git clone --branch 16.0 --depth 1 https://www.github.com/odoo/odoo /opt/odoo/odoo

# Install Python requirements
sudo pip3 install -r /opt/odoo/odoo/requirements.txt

# Create Odoo configuration file
sudo nano /etc/odoo.conf
Add to /etc/odoo.conf:

ini
[options]
admin_passwd = master_password_here
db_host = localhost
db_port = 3306
db_user = odoo
db_password = odoo_secure_password
db_name = odoo_db
addons_path = /opt/odoo/odoo/addons
logfile = /var/log/odoo/odoo.log
log_level = info
Step 4: Set Permissions
bash
# Create log directory
sudo mkdir -p /var/log/odoo
sudo chown odoo:odoo /var/log/odoo

# Set permissions for Odoo directories
sudo chown -R odoo:odoo /opt/odoo
sudo chmod 755 /opt/odoo

# Set config file permissions
sudo chown odoo:odoo /etc/odoo.conf
sudo chmod 640 /etc/odoo.conf
Step 5: Create Odoo Systemd Service
bash
sudo nano /etc/systemd/system/odoo.service
Add:

ini
[Unit]
Description=Odoo 16
After=network.target mariadb.service

[Service]
Type=simple
User=odoo
Group=odoo
ExecStart=/usr/bin/python3 /opt/odoo/odoo/odoo-bin -c /etc/odoo.conf
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
Enable and start Odoo:

bash
sudo systemctl daemon-reload
sudo systemctl enable odoo
sudo systemctl start odoo

# Check status
sudo systemctl status odoo
Step 6: Access Odoo
Open browser to: http://192.168.30.10:8069

First-time setup:

Database Name: odoo_db

Email: admin@company.com

Password: your_admin_password

Master Password: the one from /etc/odoo.conf

Step 7: Install Required Modules
After logging in:

Go to Apps

Remove the "Apps" filter

Install these modules:

Module	Purpose
Employees	HR employee management
Contacts	Company contacts
Discuss	Internal chat
HR Recruitment	Job applications
HR Attendance	Track attendance (optional)
Leaves	Vacation management
Payroll	Salary management (requires localization)
Step 8: Configure HR Structure
Create Departments
Go to Employees → Departments → Create

Add:

HR

Support

Management

Add Employee Fields (Custom Fields)
Enable Developer Mode:

Settings → Activate Developer Mode

Add custom fields to Employee form:

Field Name	Type	Purpose
CNP / ID	Text	National ID
Contract Type	Selection	Full-time / Part-time
Start Date	Date	Hire date
End Date	Date	Termination date
Gross Salary	Float	Monthly salary
IBAN	Text	Bank account
Emergency Contact	Text	Contact person
Step 9: Create User Roles
Role: HR Manager
Settings → Users → Create

Fill details

Access Rights:

HR: Manager

Contacts: Manager

Enable 2FA (see next section)

Role: HR Viewer (Limited)
Settings → Users → Create

Access Rights:

HR: User (read-only)

Salary field: hidden (configure later)

Step 10: Configure 2FA (Two-Factor Authentication)
For each user:

Edit user in Settings → Users

Check Two-Factor Authentication

User will be prompted for QR code on next login

For existing users:

User logs in

QR code appears

Scan with Google Authenticator or Microsoft Authenticator

Step 11: Restrict Access to Salary Data
To hide salary from HR Viewer role:

Settings → Technical → Security → Record Rules

Create new rule for Employee model

Domain: [('user_id','=',user.id)] (or custom logic)

Apply to HR Viewer group

Step 12: Configure Backup for Odoo Database
Create backup script:

bash
sudo nano /root/backup_odoo.sh
Add:

bash
#!/bin/bash
BACKUP_DIR="/backup"
DATE=$(date +%Y%m%d_%H%M%S)

# Backup database
mysqldump -u odoo -p'odoo_secure_password' odoo_db > $BACKUP_DIR/odoo_$DATE.sql

# Compress
gzip $BACKUP_DIR/odoo_$DATE.sql

# Keep last 30 days
find $BACKUP_DIR -name "odoo_*.sql.gz" -mtime +30 -delete
Make executable and add to cron:

bash
sudo chmod +x /root/backup_odoo.sh
sudo crontab -e
Add:

text
0 2 * * * /root/backup_odoo.sh
Step 13: Test Odoo
From HR VLAN:
Open browser: http://192.168.30.10:8069

Login with HR user

Should see employee list

From VPN (remote):
Connect to WireGuard

Same URL: http://192.168.30.10:8069

Should work

From Support VLAN:
Should NOT be able to access (firewall blocks)

Verification Checklist
Odoo accessible at http://192.168.30.10:8069

Login works with admin user

Employees module installed

Custom fields added (CNP, salary, etc.)

HR Manager and HR Viewer roles created

2FA configured for HR users

Salary data hidden from Viewer role

Backup script configured and tested

Odoo service running: sudo systemctl status odoo

Common Issues & Solutions
Issue	Solution
Odoo won't start	Check logs: sudo tail -f /var/log/odoo/odoo.log
Database connection error	Verify MariaDB is running: sudo systemctl status mariadb
Port 8069 not accessible	Check UFW rules: sudo ufw status
2FA not working	Ensure user has email configured in Odoo
Odoo slow	Increase RAM if possible (16GB recommended for many users)
Next Steps
Proceed to 07 - WireGuard Clients to configure remote access.

Reference Files
Backup Script
UFW Rules
