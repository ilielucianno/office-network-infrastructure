# 01 - Hardware Setup

This guide covers the physical installation and cabling of all network components.

---

## Prerequisites

- All hardware from the [Hardware List](../docs/hardware-list.md)
- Cat6 Ethernet cables (various lengths)
- Cable ties for management
- Phillips screwdriver (for rack mounting)
---

## Step 1: Position the Router

The MikroTik hAP ac² should be placed near the internet entry point (ISP modem).

**Connections:**
- **ether1** → ISP modem (WAN)
- **ether2** → Switch (trunk port)
- **ether3-5** → spare or direct connections

**Power:** Use the included power adapter.

---

## Step 2: Position the Switch

The MikroTik CRS326-24G-2S+RM is the central hub for all wired connections.

**Port Mapping:**

| Port | Connected Device | Cable Type |
|------|------------------|------------|
| Port 1 | Router (ether2) | Cat6 |
| Port 2 | HR PC1 | Cat6 |
| Port 3 | HR PC2 | Cat6 |
| Port 4 | HR PC3 (if present) | Cat6 |
| Port 5 | HR Printer | Cat6 |
| Port 6 | Support Laptop 1 | Cat6 |
| Port 7 | Support Laptop 2 | Cat6 |
| Port 8 | Support Laptop 3 | Cat6 |
| Port 9 | Server | Cat6 |
| Port 10-24 | Future expansion | - |

**Power:** Connect to a reliable power source (UPS recommended).

---

## Step 3: Position the Server

The Intel N100 mini PC should be placed in a secure location (locked cabinet if possible).

**Connections:**
- Ethernet cable from server to **Switch Port 9**
- Power adapter

**Initial Access:**
- Connect a monitor and keyboard for initial setup (or use IPMI if available)

---

## Step 4: Position the WiFi Access Point

The Ubiquiti UniFi 6 Plus should be placed in a central location for optimal coverage.

**Mounting Options:**
- Ceiling mount (recommended)
- Wall mount
- Desk placement

**Connection:**
- Ethernet cable from AP to **Switch Port 10** (or any free port)

**PoE (Power over Ethernet):**
- The UniFi 6 Plus supports PoE
- Ensure the switch provides PoE, or use the included PoE injector

---

## Step 5: Position HR Workstations

Each HR workstation (PC) connects directly to the switch.

**Connection:**
- Ethernet cable from PC to assigned switch port (Ports 2-4)
- Power

---

## Step 6: Position HR Printer

The HP LaserJet MFP 135a connects to the HR VLAN.

**Connection:**
- Ethernet cable from printer to **Switch Port 5**
- Power

**Note:** The printer IP should be static or DHCP-reserved for consistent access.

---

## Step 7: Position Support Laptops

Support laptops can be wired or wireless.

**Wired Connection:**
- Ethernet cable from laptop docking station to assigned switch port (Ports 6-8)

**Wireless Connection:**
- Connect to the **Office-Support** SSID (configured later)

---

## Step 8: Cable Management

**Best Practices:**
- Use cable ties to bundle cables
- Label both ends of each cable with the device name or port number
- Keep power cables separate from data cables (to reduce interference)
- Leave slack for future reconfiguration

---

## Step 9: Power On Sequence

1. **Router** – wait 2 minutes for boot
2. **Switch** – wait 1 minute
3. **Server** – wait for OS to load
4. **WiFi AP** – wait for LED to indicate ready
5. **Workstations & Printer**

---

## Step 10: Initial Verification

**Check LEDs:**
- Router: WAN LED should be solid/flashing (internet connectivity)
- Switch: Port LEDs should be green (link established)
- Server: Power LED on
- WiFi AP: White LED (ready)

**If a device has no link:**
- Check cable connections
- Try a different cable
- Verify the switch port is not disabled

---

## Update: New Switch Setup (April 6, 2026)

The network has been restructured with dedicated switches for better performance and expandability.

### New Hardware Added

| Component | Model | Vendor | Purpose |
|-----------|-------|--------|---------|
| Backbone Switch | TP-Link TL-SG108E | Senetic (ordered) | Central 8-port managed switch |
| HR Room Switch | TP-Link TL-SG105 | Bionic (Nicosia) | 5-port unmanaged switch for HR + Accountant |
| Consultancy Room Switch | TP-Link TL-SG105 | Bionic (Nicosia) | 5-port unmanaged switch for Consultancy + IT |

### New Topology

### Installation Notes

1. **Backbone Switch (TL-SG108E):**
   - Placed near the router
   - Connected via short Cat6 cable from router ether2 to switch Port 1
   - No configuration needed for basic operation (plug-and-play)

2. **Room Switches (TL-SG105):**
   - One installed in HR room, one in Consultancy room
   - Connected via long Cat6 cables from backbone switch
   - Completely unmanaged – no configuration required

3. **Cable Issues Resolved:**
   - Two faulty Cat6 cables were identified (too short)
   - Both were replaced with new Cat6 cables
   - All connections working properly after replacement

### Configuration Changes

| Device | Changes Made |
|--------|--------------|
| MikroTik Router | None needed – router only sees the backbone switch |
| TP-Link TL-SG108E | Default configuration (all ports same VLAN) – works immediately |
| TP-Link TL-SG105 | No configuration possible (unmanaged) – plug-and-play |

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
