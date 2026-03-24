# 04 - WiFi Setup (Ubiquiti UniFi 6 Plus)

This guide covers the configuration of the Ubiquiti UniFi 6 Plus access point with separate SSIDs for HR and Support VLANs.

---

## Prerequisites

- UniFi 6 Plus AP connected to switch (Port 10)
- PoE power (switch PoE or included injector)
- Router and switch already configured
- Computer on the same network (HR VLAN recommended for management)

---

## Step 1: Install UniFi Network Controller

The controller can be installed on the server (Ubuntu) or on a laptop for initial setup.

### Option A: Install on Server (Ubuntu)

```bash
# Add Ubiquiti repository
echo 'deb https://www.ui.com/downloads/unifi/debian stable ubiquiti' | sudo tee /etc/apt/sources.list.d/100-ubnt-unifi.list
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv 06E85760C0A52C50

# Update and install
sudo apt update
sudo apt install unifi -y

# Check status
sudo systemctl status unifi
Access controller at: https://192.168.30.10:8443

Option B: Install on Laptop (Windows/Mac)
Download UniFi Network Controller from ui.com

Install and launch

Controller runs locally at https://localhost:8443

Step 2: Adopt the Access Point
Open UniFi Network Controller in browser

Complete initial setup (create admin account)

The AP should appear under Devices

Click Adopt

Wait for adoption (status changes to "Connected")

If AP not detected:

Ensure AP is powered and connected to switch

Check switch port is in trunk mode (VLAN 10,20)

Verify AP and controller are on same network (VLAN 10)

Step 3: Create WiFi Networks (SSIDs)
HR WiFi
Go to Settings → WiFi

Click Create New WiFi Network

Configure:

Setting	Value
Name (SSID)	Office-HR
Password	your_secure_password_hr
Network	VLAN 10 (HR)
Security	WPA2/WPA3 Personal
Support WiFi
Click Create New WiFi Network

Configure:

Setting	Value
Name (SSID)	Office-Support
Password	your_secure_password_support
Network	VLAN 20 (Support)
Security	WPA2/WPA3 Personal
Step 4: Verify VLAN Tagging
On the switch, confirm that the AP port (Port 10) is configured as a trunk carrying VLAN 10 and 20:

bash
# In MikroTik switch terminal
/interface bridge vlan print where vlan-ids=10,20
Expected: tagged=ether10 appears in both VLANs.

Step 5: Test WiFi
From a laptop:
Connect to Office-HR SSID

Check IP address: should be 192.168.10.x

Ping HR gateway: ping 192.168.10.1 → SUCCESS

Ping Server: ping 192.168.30.10 → SUCCESS

From a laptop:
Connect to Office-Support SSID

Check IP address: should be 192.168.20.x

Ping Support gateway: ping 192.168.20.1 → SUCCESS

Ping Server: ping 192.168.30.10 → FAIL (expected)

Step 6: Optional Settings
Guest Network (If needed)
If you need a separate guest network:

Create VLAN 40 on router and switch

Create new SSID "Office-Guest"

Assign to VLAN 40

Apply firewall rules: guest → internet only, no internal access

Band Steering
Enable for better performance:

Settings → WiFi → Edit SSID → Advanced

Enable Band Steering (prefer 5GHz)

Minimum RSSI
Set to -70 dBm to prevent sticky clients:

Settings → WiFi → Edit SSID → Advanced → Minimum RSSI

Step 7: Security Recommendations
Setting	Recommendation
WiFi Encryption	WPA3 if all devices support it, otherwise WPA2/WPA3 mixed
PMF (Protected Management Frames)	Required for WPA3, optional for WPA2
Hide SSID	Not recommended (doesn't improve security, causes connection issues)
MAC Filtering	Not recommended (easily bypassed, high maintenance)
Guest Isolation	Enable for guest networks
Step 8: Backup Configuration
In UniFi Controller:

Go to Settings → System → Backup

Click Download Backup

Save file to secure location

Common Issues & Solutions
Issue	Solution
AP not adopting	Ensure controller and AP on same VLAN (VLAN 10). Check port trunk configuration.
WiFi devices get wrong IP	Check VLAN mapping on AP port. AP should be on trunk with both VLANs.
Slow WiFi	Check channel interference. Use DFS channels if available.
Clients disconnecting	Check minimum RSSI settings. Move AP to better location.
Cannot access controller	Ensure port 8443 is not blocked by firewall.
Quick Troubleshooting
Check AP Status in UniFi Controller:
Devices → AP should show "Connected"

Clients → Shows connected devices and their IPs

Check Switch Port for AP:
bash

# On MikroTik switch
/interface bridge port print where interface=ether10
/interface bridge vlan print where vlan-ids=10,20
Next Steps
Proceed to 05 - Server Installation to set up the Ubuntu server.

Reference
UniFi Network Controller Documentation

Ubiquiti VLAN Configuration Guide
## Step 3.5: Enable Client Isolation on Support WiFi

For additional security, enable client isolation on the Support network:

1. In UniFi Controller, go to **Settings → WiFi**
2. Edit the **Company-Support** SSID
3. Click **Advanced**
4. Enable **Client Device Isolation**
5. Save

**What this does:** Laptops on Support WiFi cannot see each other. Even if one device is compromised, it cannot attack other devices on the same network.
