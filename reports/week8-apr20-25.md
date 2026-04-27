# Week 8 Report: April 20 - April 25, 2026

## Focus: Server Hardware Upgrade (Intel N100 → Geekom A9 Max)

### Why Upgrade
Old server (Intel N100, 16GB RAM) could not run all services simultaneously:
- Wazuh SIEM
- DarkGhost NDR
- SQL Injection Detector
- OPNsense VM
- Snort IDS
- Odoo HR System

### New Server Specifications
| Component | Old (Intel N100) | New (Geekom A9 Max) |
|-----------|------------------|----------------------|
| CPU | Intel N100 (4 cores) | AMD Ryzen AI 9 HX 370 (12 cores) |
| RAM | 16GB (not upgradeable) | 32GB DDR5 |
| Storage | 512GB SSD | 1TB NVMe (upgradeable to 2TB) |
| Cost | ~€300 | ~€1,140 |

### Migration Process
1. Exported all VirtualBox VMs as .OVA files
2. Installed Ubuntu 22.04 LTS on new Geekom
3. Enabled SVM Mode in BIOS (AMD virtualization)
4. Imported all .OVA files into VirtualBox
5. Reconfigured static IPs (network interface names changed: enp0s3 → enp1s0)
6. Reinstalled Python packages in virtual environments

### Issues Encountered & Resolved
| Issue | Solution |
|-------|----------|
| Network interface names changed | Updated `/etc/netplan/` with new interface name |
| TensorFlow recompilation | Reinstalled all Python packages (`pip install`) |
| Static IPs lost during migration | Reconfigured netplan and applied `sudo netplan apply` |

### Current Resource Allocation
| Service | RAM allocated | CPU cores |
|---------|---------------|-----------|
| Ubuntu OS (base) | 24GB | 8 |
| OPNsense VM | 8GB | 4 |

### Status
✅ Server upgraded. All security services running simultaneously without performance issues.

### Migration Time
- Estimated: 1 hour
- Actual: 2-3 days (driver configuration, IP reassignment)

### Commands Used After Migration

# Find new interface name
ip a

# Update netplan
sudo nano /etc/netplan/00-installer-config.yaml
sudo netplan apply

# Reinstall Python packages
cd ~/darkghost && source venv/bin/activate && pip install scapy flask requests
