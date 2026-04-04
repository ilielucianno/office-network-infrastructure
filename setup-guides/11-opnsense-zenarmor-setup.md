# 11 - OPNsense + Zenarmor NGFW Setup

This guide covers the installation and configuration of OPNsense with Zenarmor (Next-Generation Firewall) on a virtual machine, including integration with existing Wazuh SIEM.

---

## Overview

| Component | Purpose |
|-----------|---------|
| OPNsense | Firewall, routing, traffic inspection |
| Zenarmor | Layer 7 filtering, IDS/IPS, application control |
| Wazuh | Centralized logging and alerting |

---

## Prerequisites

- Ubuntu Server (existing infrastructure)
- VirtualBox installed
- OPNsense ISO downloaded
- At least 4GB RAM allocated to VM (2GB for low-resource testing)

---

## Step 1: Install VirtualBox on Ubuntu Server

### Install VirtualBox

``
`bash
sudo apt update
sudo apt install virtualbox virtualbox-ext-pack -y
Accept License
During installation, a license agreement appears. Use Tab to navigate to <Ok> and press Enter.

Verify Installation
bash
VBoxManage --version
Expected output: 7.0.x

Step 2: Create OPNsense Virtual Machine
Set PATH for VirtualBox (if command not found)
bash
export PATH=$PATH:/usr/lib/virtualbox
Create and Configure VM
bash
# Create VM
VBoxManage createvm --name OPNsense-Test --register

# Allocate resources
VBoxManage modifyvm OPNsense-Test --memory 4096 --cpus 2

# Create virtual hard disk (20GB)
VBoxManage createhd --filename OPNsense-Test.vdi --size 20480

# Add SATA controller
VBoxManage storagectl OPNsense-Test --name SATA --add sata

# Attach hard disk
VBoxManage storageattach OPNsense-Test --storagectl SATA --port 0 --device 0 --type hdd --medium OPNsense-Test.vdi

# Attach OPNsense ISO (replace path with your actual ISO location)
VBoxManage storageattach OPNsense-Test --storagectl SATA --port 1 --device 0 --type dvddrive --medium /path/to/OPNsense.iso

# Configure network (NAT for WAN, Host-Only for LAN)
VBoxManage modifyvm OPNsense-Test --nic1 nat
VBoxManage modifyvm OPNsense-Test --nic2 hostonly
Troubleshooting: Invalid UUID or filename
If you get "Invalid UUID or filename" error when attaching ISO:

bash
# Remove SATA controller
VBoxManage storagectl OPNsense-Test --name SATA --remove

# Recreate SATA controller
VBoxManage storagectl OPNsense-Test --name SATA --add sata

# Reattach hard disk and ISO
VBoxManage storageattach OPNsense-Test --storagectl SATA --port 0 --device 0 --type hdd --medium OPNsense-Test.vdi
VBoxManage storageattach OPNsense-Test --storagectl SATA --port 1 --device 0 --type dvddrive --medium /path/to/OPNsense.iso
Step 3: Install OPNsense
Start VM with VRDP for Remote Access
bash
# Enable VRDP
VBoxManage modifyvm OPNsense-Test --vrde on
VBoxManage modifyvm OPNsense-Test --vrdeport 3390

# Start VM in headless mode
VBoxManage startvm OPNsense-Test --type headless
Connect via Remote Desktop
From your laptop (Windows: mstsc), connect to:

text
SERVER_IP:3390
Installation Steps
Login with username installer and password opnsense

Choose ZFS as filesystem

Select the virtual disk (e.g., vtbd0)

Set root password (choose a strong password)

Wait for installation to complete

Select Reboot

Remove ISO Before Reboot
In terminal on the server:

bash
VBoxManage storageattach OPNsense-Test --storagectl SATA --port 1 --device 0 --type dvddrive --medium none
Step 4: Initial OPNsense Configuration
After reboot, in the console:
Assign interfaces:

LAGGs? n

VLANs? n

WAN: vtnet0 (NAT)

LAN: vtnet1 (Host-Only)

Set interface IP addresses:

LAN IP: 192.168.100.1/24

Gateway: none

WAN: DHCP (receives IP from VirtualBox)

Access WebGUI
From your browser: https://192.168.100.1

Login: root / your password

Step 5: Install Zenarmor
Update System
In WebGUI: System → Firmware → Status → Check for updates → Update

Install Plugin
System → Firmware → Plugins → search os-sunnyvalley → click Install

Run Setup Wizard
Zenarmor → Setup Wizard

Setting	Value
Database	MongoDB
Deployment Mode	Routed Mode (L3 Mode) with "emulated netmap driver"
Interfaces	LAN (vtnet1)
License	Free
Verify Status
Zenarmor → Dashboard should show:

Engine Status: Running

Reporting Database: Running

Step 6: Configure Low-Resource Mode for Zenarmor
If you have limited RAM (e.g., 2GB allocated to VM):

bash
# SSH into OPNsense or use console
# Reduce MongoDB memory limit
echo 'storage:
  engine: wiredTiger
  wiredTiger:
    engineConfig:
      cacheSizeGB: 0.5' | sudo tee -a /usr/local/etc/mongodb.conf

# Restart MongoDB
sudo service mongodb restart
Step 7: Integrate with Wazuh (Syslog)
On OPNsense WebGUI:
System → Settings → Logging

Setting	Value
Send logs to remote syslog server	✅ Enabled
IP Address	WAZUH_SERVER_IP
Port	514
Transport	UDP
On Wazuh Server:
Add syslog listener to /var/ossec/etc/ossec.conf:

xml
<remote>
  <connection>syslog</connection>
  <port>514</port>
  <protocol>udp</protocol>
  <allowed-ips>192.168.100.0/24</allowed-ips>
</remote>
Restart Wazuh:

bash
sudo systemctl restart wazuh-manager
Verify Logs
bash
sudo tail -f /var/ossec/logs/archives/archives.log | grep -i opnsense
Step 8: Snort Low-Mode Configuration (Optional)
If keeping Snort as a secondary layer, reduce its resource usage:

Edit Snort Configuration
bash
sudo nano /etc/snort/snort.lua
Add Low-Memory Settings
lua
detection = {
    search_method = "lowmem",
    max_queue_events = 5
}
Disable Expensive Preprocessors
lua
http_inspect = { enabled = false }
normalize = { enabled = false }
sensitive_data = { enabled = false }
Create Minimal Custom Rules
bash
sudo nano /etc/snort/rules/local.rules
Add:

lua
alert tcp $HOME_NET 22 -> any any (msg:"SSH login attempt"; sid:1000001; rev:1;)
alert tcp any any -> $HOME_NET 1:65535 (msg:"Port scan"; threshold:type both, track by_src, count 20, seconds 10; sid:1000002; rev:1;)
alert icmp any any -> $HOME_NET any (msg:"Large ICMP packet"; dsize:>1000; sid:1000003; rev:1;)
Update Rule Files
In snort.lua:

lua
rule_files = {
    '/etc/snort/rules/local.rules'
}
Test and Restart Snort
bash
# Test configuration
sudo -u snort snort -c /etc/snort/snort.lua -T

# If test passes, restart
sudo systemctl restart snort
Troubleshooting: Snort Won't Start
If Snort fails to start after changes:

bash
# Check status
sudo systemctl status snort

# View error logs
sudo journalctl -u snort -n 50

# Common fix: full restart
sudo systemctl stop snort
sudo systemctl disable snort
sudo systemctl enable snort
sudo systemctl start snort
Step 9: Security Hardening - What Changed
Security Improvements
Area	Before	After
Traffic inspection	Snort (server only)	Zenarmor (all traffic)
Application control	❌ No	✅ Yes (block social media, etc.)
Malware filtering	❌ No	✅ Yes
Centralized logging	Wazuh (server logs)	Wazuh + OPNsense logs
Defense in depth	Single layer	Multiple layers
New Risks Introduced
Risk	Mitigation
WebGUI exposed	Bind only to LAN/MGMT interfaces
Default password	Change to strong password
2FA not enabled	Enable TOTP in System → Settings → Authentication
Verification Checklist
WebGUI not accessible from WAN

Root password changed from default

2FA enabled for WebGUI access

Firewall rules on WAN: only allow WireGuard (port 13231)

Wazuh receiving syslog from OPNsense

Zenarmor engine running

Snort running in low-memory mode (if kept)

Step 10: Resource Verification
Check VM Resource Usage
bash
VBoxManage showvminfo OPNsense-Test | grep -E "Memory|CPU"
Check System Resources on Server
bash
free -h
top -n 1 | head -10
Expected Results
Component	RAM Usage
OPNsense VM	2-4 GB
Zenarmor	~500 MB
Snort (low mode)	100-200 MB
Wazuh	~1-2 GB
Odoo	~1-2 GB
Step 11: Testing the Setup
Test Zenarmor Blocking
In Zenarmor → Policies → Default → App Controls

Block "Social Media"

Try to access facebook.com from HR VLAN

Should be blocked

Test Alert in Wazuh
bash
# On OPNsense console, generate a test
echo "test" | logger -p local0.info
Check Wazuh dashboard for the event.

Test Snort (if kept)
bash
# From another machine, run a port scan
nmap -p 22 OPNsense_LAN_IP
Check Snort alerts:

bash
sudo tail -f /var/log/snort/alert.txt
Common Issues & Solutions
Issue	Solution
VBoxManage: command not found	Add to PATH: export PATH=$PATH:/usr/lib/virtualbox
Invalid UUID or filename	Remove and recreate SATA controller
Cannot connect to VM console	Enable VRDP: VBoxManage modifyvm OPNsense-Test --vrde on
Zenarmor slow with 2GB RAM	Upgrade VM to 4GB or enable low-memory mode
Snort won't restart	Full cycle: stop → disable → enable → start
No logs in Wazuh	Check IP address and firewall (port 514)
Files Modified/Added
File	Purpose
/etc/snort/snort.lua	Snort low-memory configuration
/etc/snort/rules/local.rules	Custom Snort rules
/var/ossec/etc/ossec.conf	Wazuh syslog listener
Next Steps
Deploy to production hardware (dedicated mini PC)

Add more Zenarmor policies (GeoIP blocking, malware categories)

Set up OPNsense backups (System → Configuration → Backups)

Schedule regular updates (System → Firmware → Settings → Automatic updates)


