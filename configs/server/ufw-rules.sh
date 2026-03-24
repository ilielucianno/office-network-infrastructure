#!/bin/bash
# UFW Configuration Script for Ubuntu Server
# Purpose: Allow only HR VLAN and VPN subnet to access server

# Reset UFW to defaults
sudo ufw --force reset

# Default policies
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Allow SSH from HR VLAN only
sudo ufw allow from 192.168.10.0/24 to any port 22 proto tcp comment "SSH from HR"

# Allow SSH from VPN subnet
sudo ufw allow from 10.10.10.0/24 to any port 22 proto tcp comment "SSH from VPN"

# Allow HTTP (Odoo) from HR VLAN
sudo ufw allow from 192.168.10.0/24 to any port 8069 proto tcp comment "Odoo from HR"

# Allow HTTP (Odoo) from VPN subnet
sudo ufw allow from 10.10.10.0/24 to any port 8069 proto tcp comment "Odoo from VPN"

# Allow HTTPS if configured later
# sudo ufw allow from 192.168.10.0/24 to any port 443 proto tcp
# sudo ufw allow from 10.10.10.0/24 to any port 443 proto tcp

# Enable logging (optional)
sudo ufw logging on

# Enable UFW
sudo ufw --force enable

# Show status
sudo ufw status verbose
