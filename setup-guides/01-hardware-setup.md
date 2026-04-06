# 01 - Hardware Setup

This guide covers the physical installation and cabling of all network components.

Last updated: **April 6, 2026**

---

## Prerequisites

- All hardware from the [Hardware List](../docs/hardware-list.md)
- Cat6 Ethernet cables (various lengths)
- Cable ties for management
- Phillips screwdriver (for wall mounting)

---

## Step 1: Position the Router

The MikroTik hAP ac² placed near the internet entry point (ISP modem).

**Connections:**
- **ether1** → ISP modem (WAN)
- **ether2** → Backbone Switch (TL-SG108E)
- **ether3-5** → spare (not used in new setup)

**Power:** Use the included power adapter.

---

## Step 2: Position the Backbone Switch

The TP-Link TL-SG108E is the central backbone switch for all wired connections. Placed near the router.

**Port Mapping:**

| Port | Connected Device | Cable Type |
|------|------------------|------------|
| Port 1 | Router (ether2) | Cat6 (short) |
| Port 2 | Server | Cat6 |
| Port 3 | WiFi AP (Ubiquiti UniFi) | Cat6 |
| Port 4 | HR Room Switch (TL-SG105) | Cat6 (long) |
| Port 5 | Consultancy Room Switch (TL-SG105) | Cat6 (long) |
| Port 6-8 | Spare (future expansion) | - |

**Power:** Connect to a reliable power source (UPS recommended).

---

## Step 3: Position the HR Room Switch

The TP-Link TL-SG105 is placed in the HR room (shared with Accountant).

**Port Mapping:**

| Port | Connected Device |
|------|------------------|
| Port 1 | Cable from Backbone Switch (Port 4) |
| Port 2 | HR PC1 |
| Port 3 | HR PC2 |
| Port 4 | HR Printer |
| Port 5 | Spare |

**Power:** Standard power adapter (included).

---

## Step 4: Position the Consultancy Room Switch

The TP-Link TL-SG105 is placed in the Consultancy room (shared with IT).

**Port Mapping:**

| Port | Connected Device |
|------|------------------|
| Port 1 | Cable from Backbone Switch (Port 5) |
| Port 2 | IT Laptop |
| Port 3 | Consultancy Laptop 1 |
| Port 4 | Consultancy Laptop 2 |
| Port 5 | Spare |

**Power:** Standard power adapter (included).

---

## Step 5: Position the Server

The Intel N100 mini PC placed in a secure location (locked cabinet).

**Connections:**
- Ethernet cable from server to **Backbone Switch Port 2**
- Power adapter

**Initial Access:**
- Connect a monitor and keyboard for initial setup

---

## Step 6: Position the WiFi Access Point

The Ubiquiti UniFi 6 Plus placed in a central location for optimal coverage.

**Mounting Options:**
- Ceiling mount (my setup)

**Connection:**
- Ethernet cable from AP to **Backbone Switch Port 3**

**PoE (Power over Ethernet):**
- The UniFi 6 Plus supports PoE
- Ensure the switch provides PoE, or use the included PoE injector

---

## Step 7: Position HR Workstations

Each HR workstation (PC) connects to the HR Room Switch.

**Connection:**
- Ethernet cable from PC to HR Room Switch (Ports 2-3)
- Power

---

## Step 8: Position HR Printer

The HP LaserJet MFP 135a connects to the HR VLAN.

**Connection:**
- Ethernet cable from printer to **HR Room Switch Port 4**
- Power

**Note:** The printer IP should be static or DHCP-reserved for consistent access.

---

## Step 9: Position Consultancy & IT Laptops

Laptops connect to the Consultancy Room Switch.

**Connection:**
- Ethernet cable from laptop docking station to Consultancy Room Switch (Ports 2-4)

**Wireless alternative:**
- Connect to the **Office-Support** or **Office-HR** SSID (configured later)

---

## Step 10: Cable Management

**Best Practices:**
- Use cable ties to bundle cables
- Label both ends of each cable with the device name or port number
- Keep power cables separate from data cables (to reduce interference)
- Leave slack for future reconfiguration

---

## Step 11: Power On Sequence

1. **Router** – wait 2 minutes for boot
2. **Backbone Switch (TL-SG108E)** – wait 1 minute
3. **Room Switches (TL-SG105)** – wait 30 seconds
4. **Server** – wait for OS to load
5. **WiFi AP** – wait for LED to indicate ready
6. **Workstations & Laptops**

---

## Step 12: Initial Verification

**Check LEDs:**
- Router: WAN LED should be solid/flashing (internet connectivity)
- Backbone Switch: Port LEDs should be green (link established)
- Room Switches: Port LEDs should be green
- Server: Power LED on
- WiFi AP: White LED (ready)

**If a device has no link:**
- Check cable connections
- Try a different cable
- Verify the switch port is not disabled

---

## Installation Notes (April 6, 2026)

### New Hardware Added

| Component | Model | Vendor | Purpose |
|-----------|-------|--------|---------|
| Backbone Switch | TP-Link TL-SG108E | Senetic (ordered) | Central 8-port managed switch |
| HR Room Switch | TP-Link TL-SG105 | Bionic (Nicosia) | 5-port unmanaged switch |
| Consultancy Room Switch | TP-Link TL-SG105 | Bionic (Nicosia) | 5-port unmanaged switch |

### New Topology

Internet → Router → Backbone Switch (TL-SG108E)

From backbone switch:
- Port 2 → Server
- Port 3 → WiFi AP
- Port 4 → HR Room Switch → HR PCs + Printer
- Port 5 → Consultancy Room Switch → IT + Consultancy Laptops

### Cable Issues Resolved

- Two faulty Cat6 cables were identified (too short)
- Both were replaced with new Cat6 cables
- All connections working properly after replacement

### Configuration Changes

| Device | Changes Made |
|--------|--------------|
| MikroTik Router | None needed – router only sees the backbone switch |
| TP-Link TL-SG108E | Default configuration – works immediately |
| TP-Link TL-SG105 | No configuration needed – plug-and-play |

### Benefits Achieved

- Router ports no longer overloaded
- Each room can be expanded independently
- Cleaner cable management
- Professional star topology
- Future VLAN-ready (on TL-SG108E)

---

## Next Steps

Proceed to [02 - Router Configuration](02-router-config.md) to configure the MikroTik router.

---

## Troubleshooting

| Problem | Possible Solution |
|---------|-------------------|
| No internet on router | Check ISP modem, reboot both devices |
| Switch port not working | Try a different cable, check port status |
| Server not detected | Verify cable, check link light on switch |
| WiFi AP not powering | Check PoE injector or switch PoE capability |
| No link to room switch | Check both ends of long Cat6 cable |
