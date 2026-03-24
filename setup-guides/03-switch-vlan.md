# 03 - Switch & VLAN Configuration (MikroTik CRS326)

This guide covers the configuration of the MikroTik CRS326-24G-2S+RM switch to support VLAN segmentation.

---

## Prerequisites

- Switch powered on and connected to router (ether2 → Switch Port 1)
- Computer connected to the same network
- WinBox or web browser access to switch
- Router already configured ([02 - Router Configuration](02-router-config.md))

---

## Step 1: Connect to the Switch

### Option A: WinBox (Recommended)

1. Open WinBox
2. In **Neighbors** tab, find your switch (model: CRS326)
3. Click to connect
4. Login: `admin` (no password by default)

### Option B: Web Interface

1. Open browser to `192.168.88.1` (if router IP not assigned yet)
2. Login: `admin`

---

## Step 2: Set Switch IP (Optional)

To manage the switch from the main network, assign an IP on VLAN 10:
/ip address
add address=192.168.10.2/24 interface=bridge

text

Now you can access the switch via `192.168.10.2` from HR VLAN.

---

## Step 3: Configure VLAN-Aware Bridge

### Create Bridge with VLAN Filtering
/interface bridge
add name=bridge1 vlan-filtering=yes

text

### Add All Ports to Bridge
/interface bridge port
add bridge=bridge1 interface=ether1
add bridge=bridge1 interface=ether2
add bridge=bridge1 interface=ether3
add bridge=bridge1 interface=ether4
add bridge=bridge1 interface=ether5
add bridge=bridge1 interface=ether6
add bridge=bridge1 interface=ether7
add bridge=bridge1 interface=ether8
add bridge=bridge1 interface=ether9
add bridge=bridge1 interface=ether10

text

---

## Step 4: Configure VLANs on Bridge

### Create VLAN Interfaces
/interface vlan
add name=vlan10-hr vlan-id=10 interface=bridge1
add name=vlan20-support vlan-id=20 interface=bridge1
add name=vlan30-server vlan-id=30 interface=bridge1

text

### Assign VLANs to Bridge Ports

**Port 1 (Trunk to Router):** Carries all VLANs
/interface bridge vlan
add bridge=bridge1 vlan-ids=10,20,30 tagged=ether1,ether2,bridge1

text

**Ports 2-5 (HR VLAN - Access Ports):**
/interface bridge vlan
add bridge=bridge1 vlan-ids=10 tagged=ether2,bridge1
/interface bridge port
set [find where interface=ether2] pvid=10
set [find where interface=ether3] pvid=10
set [find where interface=ether4] pvid=10
set [find where interface=ether5] pvid=10

text

**Ports 6-8 (Support VLAN - Access Ports):**
/interface bridge vlan
add bridge=bridge1 vlan-ids=20 tagged=ether6,bridge1
/interface bridge port
set [find where interface=ether6] pvid=20
set [find where interface=ether7] pvid=20
set [find where interface=ether8] pvid=20

text

**Port 9 (Server VLAN - Access Port):**
/interface bridge vlan
add bridge=bridge1 vlan-ids=30 tagged=ether9,bridge1
/interface bridge port
set [find where interface=ether9] pvid=30

text

**Port 10 (WiFi AP - Trunk for Multiple SSIDs):**
/interface bridge vlan
add bridge=bridge1 vlan-ids=10,20 tagged=ether10,bridge1
/interface bridge port
set [find where interface=ether10] pvid=10

text

---

## Step 5: Verify VLAN Configuration

### Check Bridge VLAN Table
/interface bridge vlan print

text

Expected output:
- VLAN 10: tagged ports: ether1, ether2, ether10, bridge1; untagged: ether3, ether4, ether5
- VLAN 20: tagged ports: ether1, ether6, ether10, bridge1; untagged: ether7, ether8
- VLAN 30: tagged ports: ether1, ether9, bridge1

### Check Port PVIDs
/interface bridge port print

text

Verify each port has the correct PVID.

---

## Step 6: Test VLAN Isolation

### From HR PC (connected to Port 2):
- Ping HR gateway: `ping 192.168.10.1` → **SUCCESS**
- Ping Support gateway: `ping 192.168.20.1` → **FAIL** (expected)
- Ping Server: `ping 192.168.30.10` → **SUCCESS**

### From Support Laptop (connected to Port 6):
- Ping Support gateway: `ping 192.168.20.1` → **SUCCESS**
- Ping HR gateway: `ping 192.168.10.1` → **FAIL** (expected)
- Ping Server: `ping 192.168.30.10` → **FAIL** (expected)

### From Server (connected to Port 9):
- Ping HR gateway: `ping 192.168.10.1` → **SUCCESS**
- Ping Support gateway: `ping 192.168.20.1` → **FAIL** (expected)

---

## Step 7: Save Configuration
/export file=switch-config-working

text

Download the file from **Files** for backup.

---

## Step 8: Port Mapping Summary

| Port | Connected Device | VLAN | PVID | Purpose |
|------|------------------|------|------|---------|
| 1 | Router (ether2) | Trunk | - | Carries VLAN 10,20,30 |
| 2 | HR PC1 | 10 | 10 | HR workstation |
| 3 | HR PC2 | 10 | 10 | HR workstation |
| 4 | HR PC3 | 10 | 10 | HR workstation (if present) |
| 5 | HR Printer | 10 | 10 | HR printer |
| 6 | Support Laptop 1 | 20 | 20 | Support team |
| 7 | Support Laptop 2 | 20 | 20 | Support team |
| 8 | Support Laptop 3 | 20 | 20 | Support team |
| 9 | Server | 30 | 30 | Odoo + MariaDB |
| 10 | WiFi AP | Trunk | 10 | Carries SSIDs for VLAN 10 and 20 |
| 11-24 | Spare | - | 1 | Future expansion |

---

## Common Issues & Solutions

| Issue | Solution |
|-------|----------|
| Device gets wrong VLAN | Check PVID: `/interface bridge port print where interface=etherX` |
| VLAN traffic not passing | Verify bridge VLAN filtering: `/interface bridge print` (should show vlan-filtering=yes) |
| HR cannot reach server | Check router firewall rules, verify server is on VLAN 30 |
| WiFi AP not getting VLAN tags | Ensure port is tagged in bridge VLAN table for VLAN 10 and 20 |
| Can't access switch from network | Set static IP on bridge interface in the management subnet |

---

## Quick Troubleshooting Commands

```bash
# Show bridge VLAN table
/interface bridge vlan print

# Show port PVIDs
/interface bridge port print

# Show VLAN interfaces
/interface vlan print

# Show MAC addresses learned on a specific VLAN
/interface bridge host print where vlan-id=10

# Ping test from switch to router
/ping 192.168.10.1
Next Steps
Proceed to 04 - WiFi Setup to configure the Ubiquiti UniFi access point.

Reference Files
Full Router Config

Firewall Rules
