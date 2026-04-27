# Week 5 Report: March 30 - April 4, 2026

## Focus: OPNsense + Zenarmor NGFW

### Tests Performed
- Layer 7 application filtering (blocking social media, streaming)
- Geo-IP blocking (block non-Cyprus traffic for specific VLANs)
- IPS effectiveness against known attack patterns

### Issues Encountered
- OPNsense VM required additional RAM (first allocated 2GB, too low)
- Zenarmor plugin required kernel module updates

### Solutions Implemented
- Increased OPNsense VM RAM to 4GB
- Updated FreeBSD kernel modules for Zenarmor
- Created Zenarmor policies: HR (allow all), Support (block entertainment)

### Status
✅ OPNsense + Zenarmor fully operational as NGFW.

### Zenarmor Policies
| VLAN | Policy | Blocked Categories |
|------|--------|---------------------|
| HR (10) | Allow all | None |
| Support (20) | Restricted | Social media, Streaming, Gaming |
| Server (30) | Monitoring only | None |

### Next Steps
- Begin DarkGhost NDR development
- Implement baseline learning for anomaly detection
