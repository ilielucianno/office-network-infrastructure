# Week 7 Report: April 13 - April 18, 2026

## Focus: DarkGhost Anomaly Detection & Wazuh Integration

### Tests Performed
- Lateral movement detection (HR ↔ Support VLAN traffic)
- SSH connection from workstation that never used SSH
- TTL spoofing simulation (MAC/IP cloning)

### Issues Encountered
- DarkGhost could not see inter-VLAN traffic without port mirroring
- Wazuh not receiving DarkGhost alerts

### Solutions Implemented
- Configured SPAN (port mirroring) on TP-Link TL-SG108E switch
  - Source port: Port 1 (trunk with all VLANs)
  - Destination port: Port 8 (server)
  - Mirror Mode: Both (TX and RX)
- Created `/var/log/darkghost/alerts.log` file
- Configured Wazuh `localfile` to read alerts.log
- Updated DarkGhost `main.py` to write alerts to Wazuh log file

### Status
✅ DarkGhost can now detect lateral movement between VLANs. Wazuh receives all DarkGhost alerts.

### Wazuh Configuration for DarkGhost

<localfile>
  <log_format>json</log_format>
  <location>/var/log/darkghost/alerts.log</location>
</localfile>
