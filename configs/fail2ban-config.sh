#!/bin/bash
# Fail2Ban Configuration Script
# Purpose: Protect SSH from brute-force attacks

# Install Fail2Ban
sudo apt update
sudo apt install fail2ban -y

# Create local configuration file
sudo tee /etc/fail2ban/jail.local > /dev/null <<EOF
[DEFAULT]
# Ban IP for 1 hour after 5 failures
bantime = 3600
findtime = 600
maxretry = 5

# Email notifications (optional)
destemail = admin@company.com
sender = fail2ban@company.com
action = %(action_mwl)s

[sshd]
enabled = true
port = ssh
filter = sshd
logpath = /var/log/auth.log
maxretry = 3
bantime = 3600

# Optional: Protect Odoo if exposed (currently internal only)
# [odoo]
# enabled = true
# port = 8069
# filter = odoo
# logpath = /var/log/odoo/odoo.log
# maxretry = 5
EOF

# Create custom Odoo filter (if needed later)
# sudo tee /etc/fail2ban/filter.d/odoo.conf > /dev/null <<EOF
# [Definition]
# failregex = ^.*Failed login attempt.*from <HOST>.*$
# ignoreregex =
# EOF

# Restart Fail2Ban
sudo systemctl restart fail2ban
sudo systemctl enable fail2ban

# Check status
sudo fail2ban-client status
sudo fail2ban-client status sshd
