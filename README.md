# Office Network Infrastructure

**Secure office network with VLAN segmentation, WireGuard VPN, and self-hosted Odoo HR system.**

---

## 📌 Overview

This project documents a complete, production-ready office network for a small company (3 HR offices + 10-15 remote support agents). It implements **enterprise-grade security** on a budget of ~€1,600.

- **VLAN isolation** – HR, Support, Server completely separated
- **WireGuard VPN** – key-based, unique keys per user
- **Full security stack** – IDS, NGFW, NDR, SIEM, SOAR
- **Self-hosted Odoo** – HR system with 2FA
- **Automated backups** – daily, 30-day retention

> The business operates online casinos (branded separately). Financial operations are protected by 2FA, IP verification, withdrawal delays, and manual approval.

---

## 🏗️ Network Architecture

Internet → MikroTik Router → TP-Link Switch → HR / Support / Server / WiFi / VPN


| VLAN | Name | Subnet | Purpose |
|------|------|--------|---------|
| 10 | HR | 192.168.10.0/24 | HR, Accounting, WiFi |
| 20 | Support | 192.168.20.0/24 | Remote agents, office support |
| 30 | Server | 192.168.30.0/24 | Ubuntu server with all security tools |

### Firewall Rules

| Source | Destination | Action |
|--------|-------------|--------|
| HR | Server | ✅ ALLOWED |
| HR | Support | ❌ DENIED |
| Support | HR | ❌ DENIED |
| Support | Server | ❌ DENIED |
| VPN | Server | ✅ ALLOWED |
| VPN | HR | ✅ ALLOWED |

### Traffic Visibility (DarkGhost NDR)

A **SPAN session (port mirroring)** on the TP-Link switch copies all inter-VLAN traffic to the server, enabling DarkGhost to detect lateral movement, port scans, and behavioral anomalies.

---

## 🖥️ Hardware (Total ~€1,600)

| Component | Model | Cost |
|-----------|-------|------|
| Router | MikroTik hAP ac² | ~€65 |
| Backbone Switch | TP-Link TL-SG108E (managed) | ~€30 |
| Access Switches | 2× TP-Link TL-SG105 (unmanaged) | ~€36 |
| WiFi AP | Ubiquiti UniFi 6 Plus | ~€110 |
| **Main Server** | **Geekom A9 Max (AMD Ryzen AI 9, 32GB RAM, 1TB SSD)** | **~€1,140** |
| Backup Server | Mini PC Intel N100 (retired, kept for spare) | ~€300 |
| Printer | HP LaserJet MFP 135a | ~€130 |
| Cables | Cat6 + accessories | ~€80 |

> **Server Upgrade History:** Started on Intel N100 (2023–2026), migrated to Geekom A9 Max (April 2026) for more RAM and CPU to run OPNsense VM alongside other services. See [docs/migration-notes.md](docs/migration-notes.md).

---

## 🔒 Security Stack (7 Detection Layers)

| Layer | Tool | Detection Type | Runs on |
|-------|------|----------------|---------|
| **NGFW / IPS** | OPNsense + Zenarmor | Layer 7 filtering, app control | VirtualBox VM |
| **Network IDS** | Snort 3 | Signature-based (low-memory mode) | Ubuntu native |
| **NDR** | DarkGhost | Behavioral anomalies, zero-day, port scans | Ubuntu native |
| **Web App** | SnortML (TensorFlow) | SQL injection (real-time) | Ubuntu native |
| **SIEM** | Wazuh | Log centralization, correlation, alerts | Ubuntu native |
| **Active Response** | Wazuh + iptables | Automatic SSH brute-force blocking | Ubuntu native |
| **SOAR** | Shuffle | Alert automation, webhooks | Docker |

### Service Access URLs (Geekom A9 Max)

| Service | URL | Port |
|---------|-----|------|
| Wazuh Dashboard | `https://192.168.30.10` | 443 |
| DarkGhost NDR | `http://192.168.30.10:8081` | 8081 |
| SQL Detector | `http://192.168.30.10:8082` | 8082 |
| OPNsense WebGUI | `https://192.168.100.1` | 443 |
| Odoo HR | `https://odoo.office.local` | 8069 |
| Shuffle SOAR | `https://192.168.30.10:3443` | 3443 |

---

## ⚙️ Key Configuration Files

| File | Purpose |
|------|---------|
| `configs/mikrotik/router-config.rsc` | Full MikroTik config (VLANs, DHCP, firewall, WireGuard) |
| `configs/mikrotik/firewall-rules.rsc` | Firewall rules only |
| `configs/mikrotik/wireguard-config.rsc` | WireGuard server config |
| `configs/server/ufw-rules.sh` | UFW setup script |
| `configs/server/fail2ban-config.sh` | Fail2Ban configuration |
| `configs/server/backup-script.sh` | Automated daily backup script |
| `configs/switch/port-mirroring.txt` | TP-Link SPAN configuration |

---

## 🚀 Quick Start

1. **Clone the repository**
```bash
   git clone https://github.com/ilielucianno/office-network-infrastructure.git
```

2. **Follow the setup guides** in `setup-guides/` (start with `01-hardware-setup.md`)

3. **Daily operations** – see `CHEATSHEET.md`

4. **Troubleshooting** – check `PENDING-TASKS.md`

---

## 🛡️ Why This Architecture Works

| Threat | Mitigation |
|--------|------------|
| Compromised support laptop | VLAN isolation – cannot reach HR or Server |
| Brute-force SSH attack | Fail2Ban + Wazuh Active Response (auto-block) |
| Zero-day or unusual behavior | DarkGhost NDR behavioral baseline |
| SQL injection on web apps | SnortML (TensorFlow) real-time detection |
| Phishing / compromised Zoho | 2FA + IP verification + 7–21 day withdrawal delay |
| Malware / malicious website | OPNsense + Zenarmor Layer 7 filtering |

---

## 📚 Lessons Learned

- VLAN filtering on MikroTik requires **bridge VLAN filtering** enabled
- Port mirroring (SPAN) is essential for NDR – otherwise DarkGhost only sees server traffic
- Snort 3 can run in **low-memory mode** to coexist with other services
- Server migration (N100 → Geekom) took 2–3 days due to IP and driver reconfiguration
- Wazuh 4.x active response scripts require **JSON parsing** (no positional arguments)

---

## 🔜 Future Improvements

- Complete Security+ and Network+ certifications
- Offsite backups (Google Drive / cloud)
- Complete Shuffle SOAR workflows (automated incident response)
- Upgrade server storage to 2TB if needed

---

## 👤 Author

**Ilie Lucian** – Technical Department Manager (10+ years)  
SEC1 Certified (TryHackMe) · Currently: Security+ & Network+  
📧 Contact via GitHub

---

## 📄 License

MIT License – free to use and adapt for your own infrastructure.

---

## ⭐ Acknowledgments

This is a living document of my cybersecurity journey. Built from real-world experience managing network security for a 15-person IT team.

*Last updated: May 2026*
