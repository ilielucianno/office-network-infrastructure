# Week 6 Report: April 6 - April 11, 2026

## Focus: DarkGhost NDR Initial Setup

### Tests Performed
- Baseline learning without any attacks (24-hour run)
- Port scan detection against server
- Large packet detection (data exfiltration simulation)

### Issues Encountered
- DarkGhost only saw traffic to/from server, not inter-VLAN traffic
- Baseline needed 48 hours to stabilize

### Solutions Implemented
- Identified need for port mirroring on TP-Link switch
- Allowed DarkGhost to run for 48 hours before evaluation

### Status
✅ DarkGhost deployed in monitoring mode. Baseline building.

### DarkGhost Detection Rules
| Anomaly | Score | Risk |
|---------|-------|------|
| New protocol | 0.7 | HIGH |
| Sensitive port (22,4444,3389) | 0.9 | CRITICAL |
| New destination | 0.4 | MEDIUM |
| Night traffic (00:00-06:00) | 0.7 | HIGH |
| Large packet (>5000 bytes) | 0.6 | MEDIUM |

### Next Steps
- Implement port mirroring for inter-VLAN traffic visibility
- Integrate DarkGhost with Wazuh SIEM
