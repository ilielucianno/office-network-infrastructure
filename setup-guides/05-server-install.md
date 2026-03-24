# 05 - Server Installation (Ubuntu Server)

This guide covers the installation and initial configuration of the Ubuntu Server that will host the Odoo HR system and MariaDB database.

---

## Prerequisites

- Mini PC (Intel N100) or similar hardware
- Monitor and keyboard for initial setup (or remote console if available)
- Ethernet cable connected to Switch Port 9 (VLAN 30)
- USB drive with Ubuntu Server 22.04 LTS installer
- Router already configured ([02 - Router Config](02-router-config.md))

---

## Step 1: Download Ubuntu Server ISO

1. Go to [ubuntu.com/download/server](https://ubuntu.com/download/server)
2. Download **Ubuntu Server 22.04.5 LTS** (or newer LTS version)
3. Create bootable USB drive using:
   - **Rufus** (Windows)
   - **Etcher** (Windows/Mac/Linux)
   - `dd` command (Linux)

---

## Step 2: BIOS Configuration

1. Connect monitor, keyboard, and USB drive to server
2. Power on and enter BIOS (usually F2, F10, or DEL)
3. Set boot order: USB first
4. Enable **VT-x / VT-d** (Virtualization) if planning to run VMs later
5. Save and exit

---

## Step 3: Install Ubuntu Server

1. Boot from USB drive
2. Select language: **English**
3. Keyboard layout: **English (US)**
4. Installation type: **Ubuntu Server**
5. Network configuration:

| Setting | Value |
|---------|-------|
| IP Address | 192.168.30.10 (static) |
| Netmask | 255.255.255.0 |
| Gateway | 192.168.30.1 |
| DNS | 1.1.1.1, 8.8.8.8 |

**Important:** Use static IP (not DHCP) for server.

6. Proxy: leave blank
7. Mirror: keep default
8. Storage: **Use Entire Disk** (default)
9. Confirm changes
10. Profile setup:

| Setting | Value |
|---------|-------|
| Name | odoo (or your name) |
| Server name | hr-server |
| Username | odoo |
| Password | strong_password_here |

11. SSH: **Install OpenSSH Server** (check box)
12. Featured server snaps: skip for now
13. Wait for installation to complete
14. Remove USB drive and reboot

---

## Step 4: First Login

```bash
login: odoo
password: your_password
Step 5: Set Static IP (If Not Set During Install)
If you used DHCP during install, change to static:

bash
sudo nano /etc/netplan/00-installer-config.yaml
Edit to look like:

yaml
network:
  version: 2
  ethernets:
    enp1s0:
      addresses:
        - 192.168.30.10/24
      routes:
        - to: default
          via: 192.168.30.1
      nameservers:
        addresses: [1.1.1.1, 8.8.8.8]
Apply changes:

bash
sudo netplan apply
Step 6: Update System
bash
sudo apt update
sudo apt upgrade -y
sudo apt autoremove -y
Step 7: Configure Firewall (UFW)
bash
# Install UFW
sudo apt install ufw -y

# Allow SSH from HR VLAN and VPN only
sudo ufw allow from 192.168.10.0/24 to any port 22 proto tcp
sudo ufw allow from 10.10.10.0/24 to any port 22 proto tcp

# Allow Odoo from HR VLAN and VPN only
sudo ufw allow from 192.168.10.0/24 to any port 8069 proto tcp
sudo ufw allow from 10.10.10.0/24 to any port 8069 proto tcp

# Enable UFW
sudo ufw --force enable

# Check status
sudo ufw status verbose
Step 8: Configure Automatic Security Updates
bash
sudo apt install unattended-upgrades -y
sudo dpkg-reconfigure --priority=low unattended-upgrades
Select Yes to enable automatic updates.

Step 9: Change SSH Port (Optional Security)
If you want to reduce SSH scanning:

bash
sudo nano /etc/ssh/sshd_config
Find and change:

text
Port 22
# to
Port 2222
Then update UFW:

bash
sudo ufw allow from 192.168.10.0/24 to any port 2222 proto tcp
sudo ufw allow from 10.10.10.0/24 to any port 2222 proto tcp
sudo ufw delete allow 22
sudo ufw reload
Restart SSH:

bash
sudo systemctl restart sshd
Important: Keep a terminal open until you verify the new port works.

Step 10: Create Backup Directory
bash
sudo mkdir -p /backup
sudo chmod 750 /backup
Step 11: Verify Network Connectivity
bash
# Ping gateway (router)
ping 192.168.30.1

# Ping HR VLAN gateway
ping 192.168.10.1

# Ping external (internet)
ping 8.8.8.8
All should succeed.

Step 12: System Information Check
bash
# Check IP address
ip addr show

# Check memory
free -h

# Check disk space
df -h

# Check system time
timedatectl
Step 13: Reboot
bash
sudo reboot
After reboot, SSH back in to confirm everything is working:

bash
ssh odoo@192.168.30.10 -p 2222  # if you changed SSH port
Verification Checklist
Server has static IP: 192.168.30.10

Can ping gateway (192.168.30.1)
Can ping HR VLAN (192.168.10.1)

Can ping internet (8.8.8.8)

UFW is active with correct rules

Automatic updates enabled

SSH accessible from HR VLAN and VPN only

/backup directory created

Common Issues & Solutions
Issue	Solution
Server gets DHCP IP	Check netplan config and apply again: sudo netplan apply
Cannot ping HR VLAN	Check router firewall allows HR → Server
UFW blocks SSH	Connect via console, check sudo ufw status
Time wrong	Set timezone: sudo timedatectl set-timezone Europe/Nicosia
Next Steps
Proceed to 06 - Odoo Installation to set up the HR management system.

Reference Files
UFW Rules Script

Fail2Ban Config Script
Backup Script
