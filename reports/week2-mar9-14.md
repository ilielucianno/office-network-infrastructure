# Week 2 Report: March 9 - March 14, 2026

## Focus: VLAN Isolation & Access Control

### Tests Performed
- Lateral movement attempts from Support VLAN to HR VLAN
- SSH brute-force simulation against server
- Unauthorized access attempts to Odoo HR system

### Issues Encountered
- Some devices were still communicating across VLANs due to misconfigured VLAN trunking
- Odoo default permissions allowed HR staff to see salary data

### Solutions Implemented
- Reconfigured TP-Link switch VLAN trunking (bridge VLAN filtering)
- Created granular Odoo roles: HR Manager (full access) and HR Viewer (no salary data)
- Enabled 2FA for Odoo users

### Status
✅ VLAN isolation now working. Odoo permissions fixed.

### Commands Used

# Verify VLAN isolation
ping 192.168.10.1   # from Support VLAN - should fail
ping 192.168.30.10  # from HR VLAN - should succeed


