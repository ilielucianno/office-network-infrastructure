# Hardware List

This document lists all hardware components used in the office network infrastructure project. All items were purchased in Cyprus with official invoices (VAT included).

---

## Components

| Component | Model | Quantity | Price (€) | Purpose |
|-----------|-------|----------|-----------|---------|
| Router | MikroTik hAP ac² | 1 | ~65 | Main router, firewall, VPN server, VLAN routing |
| Switch | MikroTik CRS326-24G-2S+RM | 1 | ~200 | 24-port managed switch, VLAN trunking |
| WiFi Access Point | Ubiquiti UniFi 6 Plus | 1 | ~110 | Wireless access for laptops, separate SSIDs per VLAN |
| Server | Mini PC Intel N100 / 16GB RAM / 512GB SSD | 1 | ~300 | Self-hosted Odoo HR system, MariaDB database |
| Printer | HP LaserJet MFP 135a | 1 | ~130 | HR department printer (scan + print) |
| Cables | Cat6 Ethernet cables + connectors + power strips | Set | ~80 | Physical cabling for all workstations |
| **Total** | | | **~885–950** | |

---

## Where to Purchase (Cyprus)

All components can be ordered from these suppliers with official invoices:

- **Senetic** – Fast delivery to Cyprus
- **Skroutz** – Good for local delivery
- **Amazon** – Some components available
- **eBay** – Can request invoice from sellers

---

## Notes

- The server is a **mini PC** (Intel N100) – sufficient for 12 concurrent users running Odoo + MariaDB
- The MikroTik switch supports **VLAN filtering** – essential for network segmentation
- The Ubiquiti UniFi AP requires the **UniFi Network Controller** (can be installed on the server or on a laptop for initial setup)

---

## Alternative Options

If certain components are unavailable, these alternatives work:

| Component | Alternative |
|-----------|-------------|
| Router | MikroTik hEX (RB750Gr3) – cheaper but fewer ports |
| Switch | TP-Link TL-SG108E (8-port) – if fewer ports needed |
| WiFi | MikroTik cAP ac – can be managed from RouterOS |
| Server | Used Dell OptiPlex Micro – cheaper but check warranty |
