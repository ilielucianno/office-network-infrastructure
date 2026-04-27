# Week 1 Report: March 2 - March 7, 2026

## Focus: Network Reconnaissance & Detection

### Tests Performed
- Port scanning with `nmap` against the server VLAN
- ICMP sweeps across HR and Support VLANs
- ARP spoofing simulation

### Issues Encountered
- Initial firewall rules were too permissive (some inter-VLAN traffic was allowed)
- Snort IDS needed tuning to reduce false positives

### Solutions Implemented
- Hardened MikroTik firewall rules on inter-VLAN traffic
- Configured Snort community rules and custom rules for port scan detection

### Status
✅ Firewall hardening completed. Snort detects port scans reliably.

### Commands Used

nmap -sS -p 1-1000 192.168.30.10
snort -c /etc/snort/snort.lua -T

