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

Add Ubiquiti repository and install:
echo 'deb https://www.ui.com/downloads/unifi/debian stable ubiquiti' | sudo tee /etc/apt/sources.list.d/100-ubnt-unifi.list
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv 06E85760C0A52C50
sudo apt update
sudo apt install unifi -y

text

Access controller at: https://192.168.30.10:8443

### Option B: Install on Laptop (Windows/Mac)

1. Download UniFi Network Controller from ui.com
2. Install and launch
3. Controller runs locally at https://localhost:8443

---

## Step 2: Adopt the Access Point

1. Open UniFi Network Controller in browser
2. Complete initial setup (create admin account)
3. The AP should appear under Devices
4. Click Adopt
5. Wait for adoption (status changes to Connected)

If AP not detected:
- Ensure AP is powered and connected to switch
- Check switch port is in trunk mode (VLAN 10, 20)
- Verify AP and controller are on same network (VLAN 10)

---

## Step 3: Create Networks (VLANs)

1. Go to Settings → Networks
2. Click Create New Network

### Network 1: HR
- Name: HR-Network
- VLAN ID: 10
- Gateway: 192.168.10.1 (your router)
- Purpose: Corporate

### Network 2: Support
- Name: Support-Network
- VLAN ID: 20
- Gateway: 192.168.20.1 (your router)
- Purpose: Corporate

---

## Step 4: Create WiFi Networks (SSIDs)

### WiFi HR
1. Settings → WiFi → Create New WiFi Network
2. Configure:
- Name (SSID): Company-HR
- Password: strong_password_hr
- Network: HR-Network
- Security: WPA2/WPA3 Personal

### WiFi Support
1. Create New WiFi Network
2. Configure:
- Name (SSID): Company-Support
- Password: strong_password_support
- Network: Support-Network
- Security: WPA2/WPA3 Personal

---

## Step 5: Enable Client Isolation on Support WiFi

For additional security, enable client isolation on the Support network:

1. In UniFi Controller, go to Settings → WiFi
2. Edit the Company-Support SSID
3. Click Advanced
4. Enable Client Device Isolation
5. Save

What this does: Laptops on Support WiFi cannot see each other. Even if one device is compromised, it cannot attack other devices on the same network.

---

## Step 6: Verify VLAN Tagging

On the switch, confirm that the AP port (Port 10) is configured as a trunk carrying VLAN 10 and 20:

In MikroTik switch terminal:
/interface bridge vlan print where vlan-ids=10,20

text

Expected: tagged=ether10 appears in both VLANs.

---

## Step 7: Test WiFi

### From a laptop on Company-HR:
- Check IP address: should be 192.168.10.x
- Ping HR gateway: ping 192.168.10.1 (SUCCESS)
- Ping Server: ping 192.168.30.10 (SUCCESS)

### From a laptop on Company-Support:
- Check IP address: should be 192.168.20.x
- Ping Support gateway: ping 192.168.20.1 (SUCCESS)
- Ping Server: ping 192.168.30.10 (FAIL - expected)

---

## Step 8: Security Recommendations

| Setting | Recommendation |
|---------|----------------|
| WiFi Encryption | WPA3 if all devices support it, otherwise WPA2/WPA3 mixed |
| Hide SSID | Not recommended (doesn't improve security) |
| MAC Filtering | Not recommended (easily bypassed) |
| Client Isolation | Enable on guest and support networks |

---

## Step 9: Backup Configuration

In UniFi Controller:
1. Settings → System → Backup
2. Click Download Backup
3. Save file to secure location

---

## Common Issues & Solutions

| Issue | Solution |
|-------|----------|
| AP not adopting | Ensure controller and AP on same VLAN (VLAN 10). Check port trunk configuration. |
| WiFi devices get wrong IP | Check VLAN mapping on AP port. AP should be on trunk with both VLANs. |
| Clients cannot reach server from HR WiFi | Check router firewall allows HR → Server |
| Clients can reach server from Support WiFi | Check firewall rule blocking Support → Server |
