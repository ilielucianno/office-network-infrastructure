# 10 - Wazuh SIEM Setup

This guide covers the installation and configuration of Wazuh (open source SIEM) on the Ubuntu server. Wazuh centralizes logs, analyzes security events, and provides a web dashboard for monitoring with email alerts.

---

## Overview

| Component | Purpose |
|-----------|---------|
| Wazuh Manager | Collects and analyzes logs from all devices |
| Wazuh Indexer | Stores logs (based on OpenSearch) |
| Wazuh Dashboard | Web interface for monitoring and alerts |

---

## Prerequisites

- Ubuntu Server installed and configured ([05 - Server Installation](05-server-install.md))
- Server IP: 192.168.30.10
- At least 4GB RAM (16GB recommended)
- Internet connection

---

## Step 1: Install Wazuh All-in-One

The easiest method is to use the official installer:

bash
cd /tmp
curl -sO https://packages.wazuh.com/4.9/wazuh-install.sh
curl -sO https://packages.wazuh.com/4.9/config.yml
Edit the configuration file:

bash
nano config.yml
Update with your server IP:

yaml
nodes:
  - name: wazuh-server
    ip: 192.168.30.10
    role: master
dashboard:
  ip: 192.168.30.10
  port: 443
indexer:
  ip: 192.168.30.10
Generate configuration files:

bash
sudo bash wazuh-install.sh --generate-config-files
Install all components:

bash
sudo bash wazuh-install.sh -a
Wait for installation to complete. Save the admin password displayed at the end.

Step 2: Verify Services
Check that all services are running:

bash
sudo systemctl status wazuh-indexer
sudo systemctl status wazuh-manager
sudo systemctl status wazuh-dashboard
All should show active (running).

Step 3: Configure Firewall
Open necessary ports:

bash
sudo ufw allow 443/tcp
sudo ufw allow 1514/tcp
sudo ufw allow 1515/tcp
sudo ufw reload
Step 4: Access Wazuh Dashboard
Open browser from HR VLAN:

text
https://192.168.30.10
Accept the security warning (certificate is self-signed).

Login with:

Username: admin

Password: the password generated during installation

Step 5: Install Wazuh Agent on Server
The server should monitor itself. In the dashboard:

Go to Agents → Deploy New Agent

Select:

Operating system: Linux

Server address: 192.168.30.10

Agent name: ubuntu-server

Run the generated command on the server:

bash
curl -s https://packages.wazuh.com/4.x/wazuh-install.sh | bash -s -- -a wazuh-server 192.168.30.10
Verify agent is connected:

In dashboard → Agents → should show "Active"

Step 6: Configure MikroTik Router to Send Logs
In WinBox terminal on the router:

bash
/system logging action
add name=wazuh remote=192.168.30.10 remote-port=514 bsd-syslog=yes target=remote

/system logging
add topics=info,!debug action=wazuh
Now Wazuh receives all router logs.

Step 7: Configure Snort Integration
Wazuh automatically reads Snort alerts from /var/log/snort/alert.txt.

Verify in dashboard:

Go to Modules → Security Events

Filter by rule.groups: snort

Step 8: Test Wazuh
Generate a test alert from router
In WinBox terminal:

bash
/log warning "Test alert from Wazuh setup"
Generate a test alert from server
bash
echo "test" | logger -p authpriv.warning
Check dashboard for new events.

Step 9: Configure Email Alerts
9.1 Install Mail Client
bash
sudo apt install ssmtp mailutils -y
9.2 Configure ssmtp (Gmail Example)
bash
sudo nano /etc/ssmtp/ssmtp.conf
Replace the content with:

text
root=your-email@gmail.com
mailhub=smtp.gmail.com:587
AuthUser=your-email@gmail.com
AuthPass=your-app-password
UseSTARTTLS=YES
UseTLS=YES
Important: For Gmail, you need an App Password:

Go to Google Account → Security → 2-Step Verification (enable if not already)

Go to App Passwords → Generate a new password for "Mail"

Use that password as AuthPass

9.3 Configure Wazuh to Send Alerts
bash
sudo nano /var/ossec/etc/ossec.conf
Find the <global> section and add or modify:

xml
<global>
  <email_notification>yes</email_notification>
  <smtp_server>smtp.gmail.com</smtp_server>
  <smtp_port>587</smtp_port>
  <email_from>wazuh@yourdomain.com</email_from>
  <email_to>your-email@gmail.com</email_to>
  <email_idsname>Wazuh</email_idsname>
</global>
Find the <alerts> section and add:

xml
<alerts>
  <email>
    <recipient>your-email@gmail.com</recipient>
    <level>10</level>
  </email>
</alerts>
Note: level 10 means alerts with severity 10 or higher will be emailed. You can change to 7 for more alerts or 12 for critical only.

9.4 Restart Wazuh
bash
sudo systemctl restart wazuh-manager
9.5 Test Email Alerts
Generate a high-severity alert:

bash
echo "Failed password for root from 192.168.1.100" | logger -p authpriv.warning
Check your email inbox (including spam folder) within 1-2 minutes.

9.6 Verify Email Configuration
Check Wazuh logs for email errors:

bash
sudo tail -f /var/ossec/logs/ossec.log | grep -i email
If you see "Email sent successfully", it's working.

Step 10: Create Custom Alert Rules (Optional)
To receive alerts for specific events:

bash
sudo nano /var/ossec/etc/rules/local_rules.xml
Add:

xml
<group name="local,custom">
  <!-- Alert on Odoo login failures -->
  <rule id="100001" level="10">
    <decoded_as>json</decoded_as>
    <field name="log_type">odoo</field>
    <match>Failed login</match>
    <description>Odoo failed login attempt</description>
  </rule>

  <!-- Alert on router configuration changes -->
  <rule id="100002" level="12">
    <decoded_as>syslog</decoded_as>
    <match>router configuration changed</match>
    <description>MikroTik configuration changed</description>
  </rule>

  <!-- Alert on VPN connections -->
  <rule id="100003" level="7">
    <decoded_as>syslog</decoded_as>
    <match>WireGuard peer</match>
    <description>VPN connection detected</description>
  </rule>
</group>
Restart Wazuh:

bash
sudo systemctl restart wazuh-manager
Test custom alert:

bash
echo "Failed login attempt for user admin" | logger -t odoo
Verification Checklist
Wazuh dashboard accessible at https://192.168.30.10

Admin login works

Wazuh agent shows "Active" in Agents

Router logs appear in dashboard

Snort alerts appear in dashboard

Email alerts received (check spam folder)

Custom rules working (optional)

Common Issues & Solutions
Issue	Solution
Dashboard not loading	Check service: sudo systemctl status wazuh-dashboard
Agent not connecting	Verify firewall: sudo ufw status
Router logs not appearing	Check MikroTik syslog configuration
No Snort alerts	Verify Snort is running: sudo systemctl status snort
No email alerts	Check spam folder, verify ssmtp config, check logs
What You Have Now
Component	Status
Wazuh Manager	Central log collection and analysis
Wazuh Indexer	Log storage (OpenSearch)
Wazuh Dashboard	Web interface
Ubuntu Server Agent	Monitors server logs, processes
MikroTik Syslog	Router logs in Wazuh
Snort Integration	IDS alerts in Wazuh
Email Alerts	Notifications for high-severity events
Next Steps
Customize alert rules for your environment

Set up weekly reports

Monitor dashboard daily for suspicious activity
