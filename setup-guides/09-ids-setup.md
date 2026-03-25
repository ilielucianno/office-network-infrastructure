# 09 - Intrusion Detection System (Snort) Setup
    UPDATE ++++++ Intrusion Detection System (Snort 3) Setup +++++++++

This guide covers the installation and configuration of Snort 3 as an Intrusion Detection System (IDS) on the Ubuntu server. Snort monitors network traffic for suspicious activity and logs alerts.

---

## Prerequisites

- Ubuntu Server installed and configured ([05 - Server Installation](05-server-install.md))
- Server IP: 192.168.30.10
- SSH access from HR VLAN or VPN
- Internet connection for downloading rules

---

## Why Snort 3

| Feature | Benefit |
|---------|---------|
| Real-time traffic analysis | Detects attacks as they happen |
| Protocol analysis | Identifies malicious patterns |
| Content matching | Catches known exploits |
| Community rules | Regular updates for new threats |

Since our server is not exposed to the internet, Snort monitors internal traffic between VLANs (HR → Server) and VPN traffic.

---

## Step 1: Install Dependencies

sudo apt update
sudo apt upgrade -y
sudo apt install -y build-essential libpcap-dev libpcre3-dev \
    libdumbnet-dev bison flex libnghttp2-dev zlib1g-dev \
    libssl-dev liblzma-dev libmnl-dev cmake git
Step 2: Download and Install Snort 3
bash
cd /opt
sudo git clone https://github.com/snort3/snort3.git
cd snort3
Build and install:

bash
./configure_cmake.sh --prefix=/usr/local --enable-tcmalloc
cd build
make -j$(nproc)
sudo make install
Verify installation:

bash
snort -V
Expected output: Snort 3.x.x version information.

Step 3: Create Snort Directories
bash
sudo mkdir -p /etc/snort
sudo mkdir -p /etc/snort/rules
sudo mkdir -p /var/log/snort
sudo mkdir -p /usr/local/lib/snort_dynamicrules
Step 4: Download Community Rules
bash
cd /tmp
wget https://www.snort.org/downloads/community/community-rules.tar.gz
sudo tar -xzf community-rules.tar.gz -C /etc/snort/rules
sudo mv /etc/snort/rules/community-rules /etc/snort/rules/community.rules
Step 5: Create Snort Configuration File
bash
sudo nano /etc/snort/snort.lua
Add:

lua
-- Snort 3 Configuration
-- Monitors traffic on eth0 interface

-- Define network variables
HOME_NET = '192.168.30.0/24'
EXTERNAL_NET = '!$HOME_NET'

-- Define interfaces to monitor
ips = {
    interface = 'eth0',
    promiscuous = true,
    alert = {
        file = '/var/log/snort/alert.txt'
    }
}

-- Enable packet logging
packets = {
    log = {
        file = '/var/log/snort/packets.log'
    }
}

-- Load rules
rule_files = {
    '/etc/snort/rules/community.rules'
}

-- Enable HTTP inspection
http_inspect = {
    enabled = true
}

-- Enable SSH inspection
ssh = {
    enabled = true
}
Step 6: Create Custom Rules
bash
sudo nano /etc/snort/rules/custom.rules
Add rules specific to your environment:

text
# Detect multiple failed SSH attempts (brute force)
alert tcp $HOME_NET any -> $HOME_NET 22 (msg:"Multiple SSH failures"; flow:to_server; threshold:type both, track by_src, count 5, seconds 60; sid:1000001; rev:1;)

# Detect port scans
alert tcp any any -> $HOME_NET 1:65535 (msg:"Port scan detected"; flags:S,12; threshold:type both, track by_src, count 20, seconds 10; sid:1000002; rev:1;)

# Detect suspicious ICMP traffic
alert icmp any any -> $HOME_NET any (msg:"Large ICMP packet"; dsize:>1000; sid:1000003; rev:1;)

# Detect HTTP request to Odoo from unauthorized VLAN
alert tcp !192.168.10.0/24 any -> $HOME_NET 8069 (msg:"Odoo access from unauthorized network"; sid:1000004; rev:1;)

# Detect SSH from non-HR VLAN
alert tcp !192.168.10.0/24 any -> $HOME_NET 22 (msg:"SSH access from unauthorized network"; sid:1000005; rev:1;)
Update configuration to include custom rules:

bash
sudo nano /etc/snort/snort.lua
Add custom.rules after community.rules:

lua
rule_files = {
    '/etc/snort/rules/community.rules',
    '/etc/snort/rules/custom.rules'
}
Step 7: Test Configuration
bash
snort -c /etc/snort/snort.lua -T
Expected output: "Snort successfully validated the configuration."

Step 8: Create Systemd Service
bash
sudo nano /etc/systemd/system/snort.service
Add:

ini
[Unit]
Description=Snort 3 Intrusion Detection System
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/snort -c /etc/snort/snort.lua -i eth0 -A alert -l /var/log/snort
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
Enable and start Snort:

bash
sudo systemctl daemon-reload
sudo systemctl enable snort
sudo systemctl start snort
sudo systemctl status snort
Step 9: Test Snort
Generate a test alert
From another machine on HR VLAN:

bash
# Simulate port scan (triggers rule sid:1000002)
nmap -p 1-100 192.168.30.10
Check alerts
bash
# View live alerts
sudo tail -f /var/log/snort/alert.txt

# View packet logs
sudo tail -f /var/log/snort/packets.log
Step 10: Configure Log Rotation
bash
sudo nano /etc/logrotate.d/snort
Add:

text
/var/log/snort/*.log
/var/log/snort/*.txt
{
    daily
    missingok
    rotate 30
    compress
    notifempty
    create 644 root root
    sharedscripts
    postrotate
        systemctl reload snort > /dev/null 2>&1 || true
    endscript
}
Step 11: Daily Alert Summary (Optional)
Create a script to check for critical alerts:

bash
sudo nano /root/check_snort_alerts.sh
Add:

bash
#!/bin/bash
ALERTS=$(sudo grep -c "alert" /var/log/snort/alert.txt 2>/dev/null || echo 0)
if [ $ALERTS -gt 10 ]; then
    echo "WARNING: $ALERTS alerts in last 24 hours"
fi
Make executable:

bash
sudo chmod +x /root/check_snort_alerts.sh
Add to crontab:

bash
sudo crontab -e
Add:

bash
# Daily Snort alert check at 7 AM
0 7 * * * /root/check_snort_alerts.sh
Verification Checklist
Snort installed: snort -V shows version 3.x

Configuration validated: snort -c /etc/snort/snort.lua -T

Snort service running: sudo systemctl status snort

Community rules loaded

Custom rules created

Alerts logging to /var/log/snort/alert.txt

Log rotation configured

Common Issues & Solutions
Issue	Solution
Snort won't start	Check config: snort -c /etc/snort/snort.lua -T
No alerts	Verify interface name: ip link show (should be eth0)
Rules not loading	Check path in snort.lua: cat /etc/snort/snort.lua | grep rule_files
Permission errors	Fix ownership: sudo chown -R root:root /etc/snort
Next Steps
Integrate Snort alerts with Wazuh SIEM for centralized monitoring

Add more custom rules based on your network patterns

Schedule monthly rule updates



===================================== under this line was actions for previous version of snort (updated to snort 3 with comunity rulkes up from this line) ========================================================================================



This guide covers the installation and configuration of Snort as an Intrusion Detection System (IDS) on the Ubuntu server. Snort monitors network traffic for suspicious activity and logs alerts.

---

## Prerequisites

- Ubuntu Server installed and configured ([05 - Server Installation](05-server-install.md))
- Server IP: 192.168.30.10
- SSH access from HR VLAN or VPN
- Internet connection for downloading rules

---

## Why Snort?

| Feature | Benefit |
|---------|---------|
| Real-time traffic analysis | Detects attacks as they happen |
| Protocol analysis | Identifies malicious patterns |
| Content matching | Catches known exploits |
| Community rules | Regular updates for new threats |

Since our server is not exposed to the internet, Snort will monitor internal traffic between VLANs (HR → Server) and VPN traffic.

---

## Step 1: Install Snort

```bash
# Update system
sudo apt update
sudo apt upgrade -y

# Install dependencies
sudo apt install -y build-essential libpcap-dev libpcre3-dev \
    libdumbnet-dev bison flex libnghttp2-dev zlib1g-dev \
    libssl-dev liblzma-dev libmnl-dev

# Download Snort 3 (latest stable)
cd /opt
sudo git clone https://github.com/snort3/snort3.git
cd snort3

# Configure and install
sudo ./configure_cmake.sh --prefix=/usr/local --enable-tcmalloc
cd build
sudo make -j$(nproc)
sudo make install

# Verify installation
snort -V
Expected output: Snort version information.

Step 2: Create Snort Directories
bash
# Create directory structure
sudo mkdir -p /etc/snort
sudo mkdir -p /etc/snort/rules
sudo mkdir -p /etc/snort/preproc_rules
sudo mkdir -p /usr/local/lib/snort_dynamicrules
sudo mkdir -p /var/log/snort
sudo mkdir -p /var/log/snort/archived_logs

# Set permissions
sudo chmod -R 755 /etc/snort
sudo chmod -R 755 /var/log/snort
Step 3: Download Community Rules
bash
# Download Snort Community Rules
cd /tmp
wget https://www.snort.org/downloads/community/community-rules.tar.gz
sudo tar -xzf community-rules.tar.gz -C /etc/snort/rules

# Rename the rules file
sudo mv /etc/snort/rules/community-rules /etc/snort/rules/community.rules

# Download latest emerging threats rules (optional)
wget https://rules.emergingthreats.net/open/snort-3.0.8.0/emerging.rules.tar.gz
sudo tar -xzf emerging.rules.tar.gz -C /etc/snort/rules
Step 4: Configure Snort
Create main configuration file:

bash
sudo nano /etc/snort/snort.lua
Add:

lua
-- Snort 3 Configuration
-- Monitors traffic on eth0 interface

-- Define network variables
HOME_NET = '192.168.30.0/24'
EXTERNAL_NET = '!$HOME_NET'

-- Define interfaces to monitor
ips = {
    -- Monitor traffic on eth0 (server interface)
    -- This captures all traffic to/from server
    interface = 'eth0',
    
    -- Enable promiscuous mode
    promiscuous = true,
    
    -- Log alerts
    alert = {
        file = '/var/log/snort/alert.txt'
    }
}

-- Enable packet logging
packets = {
    log = {
        file = '/var/log/snort/packets.log'
    }
}

-- Load rules
rule_files = {
    '/etc/snort/rules/community.rules',
    '/etc/snort/rules/emerging.rules'
}

-- Enable HTTP inspection
http_inspect = {
    enabled = true
}

-- Enable SSH inspection
ssh = {
    enabled = true
}
Step 5: Create Custom Rules for Your Network
Create custom rules file:

bash
sudo nano /etc/snort/rules/custom.rules
Add rules specific to your environment:

bash
# Detect multiple failed SSH attempts (brute force)
alert tcp $HOME_NET any -> $HOME_NET 22 (msg:"Multiple SSH failures"; flow:to_server; threshold:type both, track by_src, count 5, seconds 60; sid:1000001; rev:1;)

# Detect port scans
alert tcp any any -> $HOME_NET 1:65535 (msg:"Port scan detected"; flags:S,12; threshold:type both, track by_src, count 20, seconds 10; sid:1000002; rev:1;)

# Detect suspicious ICMP traffic
alert icmp any any -> $HOME_NET any (msg:"Large ICMP packet"; dsize:>1000; sid:1000003; rev:1;)

# Detect HTTP request to Odoo from unauthorized VLAN
alert tcp !192.168.10.0/24 any -> $HOME_NET 8069 (msg:"Odoo access from unauthorized network"; sid:1000004; rev:1;)

# Detect SSH from non-HR VLAN
alert tcp !192.168.10.0/24 any -> $HOME_NET 22 (msg:"SSH access from unauthorized network"; sid:1000005; rev:1;)
Add custom rules to configuration:

bash
sudo nano /etc/snort/snort.lua
Add after other rule files:

lua
rule_files = {
    '/etc/snort/rules/community.rules',
    '/etc/snort/rules/emerging.rules',
    '/etc/snort/rules/custom.rules'
}
Step 6: Create Snort Systemd Service
bash
sudo nano /etc/systemd/system/snort.service
Add:

ini
[Unit]
Description=Snort Intrusion Detection System
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/snort -c /etc/snort/snort.lua -i eth0 -A alert -l /var/log/snort
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
Enable and start Snort:

bash
sudo systemctl daemon-reload
sudo systemctl enable snort
sudo systemctl start snort

# Check status
sudo systemctl status snort
Step 7: Test Snort
Generate test alert
From another machine on HR VLAN:

bash
# Simulate port scan (will trigger rule sid:1000002)
nmap -p 1-100 192.168.30.10
Check alerts
bash
# View live alerts
sudo tail -f /var/log/snort/alert.txt

# View packet logs
sudo tail -f /var/log/snort/packets.log
Step 8: Configure Log Rotation
bash
sudo nano /etc/logrotate.d/snort
Add:

text
/var/log/snort/*.log
/var/log/snort/*.txt
{
    daily
    missingok
    rotate 30
    compress
    notifempty
    create 644 root root
    sharedscripts
    postrotate
        systemctl reload snort > /dev/null 2>&1 || true
    endscript
}
Step 9: Set Up Daily Log Review (Optional)
Create a script to check for critical alerts:

bash
sudo nano /root/check_snort_alerts.sh
Add:

bash
#!/bin/bash
# Daily Snort alert check
ALERTS=$(sudo grep -c "alert" /var/log/snort/alert.txt | tail -1)

if [ $ALERTS -gt 10 ]; then
    echo "WARNING: $ALERTS alerts in last 24 hours" | mail -s "Snort Alert Summary" admin@company.com
fi
Make executable and add to cron:

bash
sudo chmod +x /root/check_snort_alerts.sh
sudo crontab -e
Add:

bash
# Daily Snort alert check at 7 AM
0 7 * * * /root/check_snort_alerts.sh
Step 10: Monitoring Dashboard (Optional - ELK Stack)
For a visual dashboard, you can install the ELK stack (Elasticsearch, Logstash, Kibana):

bash
# Install Elasticsearch
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
sudo apt-get install apt-transport-https
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-7.x.list
sudo apt update
sudo apt install elasticsearch logstash kibana -y

# Configure Logstash to parse Snort logs
sudo nano /etc/logstash/conf.d/snort.conf
Add Logstash configuration (advanced setup, optional).

Verification Checklist
Snort installed: snort -V

Snort service running: sudo systemctl status snort

Custom rules created in /etc/snort/rules/custom.rules

Alerts logging to /var/log/snort/alert.txt

Log rotation configured

Test alert generated successfully

Common Issues & Solutions
Issue	Solution
Snort won't start	Check config: snort -c /etc/snort/snort.lua -T
No alerts	Verify interface name: ip link show (should be eth0)
Permission errors	Fix ownership: sudo chown -R root:root /etc/snort
High CPU usage	Reduce rules loaded or increase hardware resources
Next Steps
Consider adding Zeek (formerly Bro) for more detailed network analysis

Integrate with Wazuh for full SIEM capabilities

Set up email alerts for critical signatures

Reference Files
Snort Documentation

Snort Community Rules

Emerging Threats Rules
