# Hardware List

This document lists all hardware components used in the office network infrastructure project. All items were purchased in Cyprus with official invoices (VAT included).

Last updated: **April 6, 2026**

---

## Components

| Component | Model | Quantity | Price (€) | Purpose | Purchase Date | Vendor |
|-----------|-------|----------|-----------|---------|---------------|--------|
| Router | MikroTik hAP ac² | 1 | ~65 | Main router, firewall, VPN server, VLAN routing | November 2025 | Senetic / Skroutz |
| **Switch (Backbone)** | **TP-Link TL-SG108E** | **1** | **~30** | **8-port managed switch, central backbone, VLAN support** | **April 6, 2026** | **Senetic (ordered)** |
| **Switch (HR Room)** | **TP-Link TL-SG105** | **1** | **~18** | **5-port unmanaged switch for HR + Accountant room** | **April 6, 2026** | **Bionic (Nicosia)** |
| **Switch (Consultancy Room)** | **TP-Link TL-SG105** | **1** | **~18** | **5-port unmanaged switch for Consultancy + IT room** | **April 6, 2026** | **Bionic (Nicosia)** |
| Switch (Legacy - replaced) | MikroTik CRS326-24G-2S+RM | 1 | ~200 | 24-port managed switch (no longer in use - replaced by TP-Link setup) | November 2025 | Senetic |
| WiFi AP | Ubiquiti UniFi 6 Plus | 1 | ~110 | Wireless access for laptops, separate SSIDs per VLAN | November 2025 | Senetic / Skroutz |
| Server | Mini PC Intel N100 / 16GB RAM / 512GB SSD | 1 | ~300 | Self-hosted Odoo HR system, MariaDB database | November 2025 | Senetic / Skroutz |
| Printer | HP LaserJet MFP 135a | 1 | ~130 | HR department printer (scan + print) | November 2025 | Skroutz |
| Cables | Cat6 Ethernet cables + connectors + power strips | Set | ~80 | Physical cabling for all workstations | November 2025 | Amazon / Local |

---

## New Network Architecture (April 6, 2026)

The network has been restructured with a proper backbone switch:
ISP → MikroTik Router → TP-Link TL-SG108E (Backbone) → TP-Link TL-SG105 (HR Room)
→ TP-Link TL-SG105 (Consultancy Room)
→ Server (direct)
→ WiFi AP (direct)

text

**Benefits of the new setup:**
- Router ports are no longer overloaded
- Each room has its own switch (easier to expand)
- Better cable management
- Professional star topology

---

## Where to Purchase (Cyprus)

All components can be ordered from these suppliers with official invoices:

- **Senetic** – Fast delivery to Cyprus, official invoices (used for TL-SG108E)
- **Bionic** – Local store in Nicosia, walk-in purchase (used for TL-SG105 switches)
- **Skroutz** – Good for local delivery
- **Amazon** – Some components available

---

## Notes

- The backbone switch (TL-SG108E) is **managed** – supports VLANs for future expansion
- The room switches (TL-SG105) are **unmanaged** – plug-and-play, no configuration needed
- Two faulty Cat6 cables were replaced during installation (they were too short)
- All switches are fanless (silent) and can be placed on desk or mounted on wall – no rack needed
