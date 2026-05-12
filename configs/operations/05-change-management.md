# Change Management Policy

## Purpose

This document describes how changes to production systems are proposed, tested, approved, and implemented. The goal is to prevent unverified changes from causing downtime or security issues.

---

## Scope

This policy applies to changes affecting:

- Server configuration (Ubuntu, firewall rules, VLANs)
- Security tools (Wazuh, DarkGhost, Snort, OPNsense)
- Critical applications (Odoo, Zoho integrations)
- Network equipment (MikroTik router, TP-Link switches)

---

## Change Workflow

| Step | Action | Who |
|------|--------|-----|
| 1 | Identify needed change | Ilie / Owner |
| 2 | Test in home lab environment | Ilie |
| 3 | Document test results | Ilie |
| 4 | Present to Owners (David, Gabriel) | Ilie |
| 5 | Owners approve or reject | Owners |
| 6 | If approved → implement in production | Ilie |
| 7 | Document implementation (commit to GitHub) | Ilie |
| 8 | Monitor for issues (24-48 hours) | Ilie |

---

## Testing Environment

- **Home lab:** Same configuration as production, running on VirtualBox
- **Test coverage:** Firewall rules, VLAN changes, security tool updates, kernel updates
- **Rollback plan:** Revert to previous configuration or restore from backup

---

## Approval Levels

| Change Type | Requires Approval From |
|-------------|------------------------|
| Security updates (unattended-upgrades) | None (automatic) |
| Kernel updates (security patches) | None (after testing) |
| New firewall rules | Owners |
| New security tools | Owners |
| VPN access for new users | Ilie (tech lead) |
| Major infrastructure changes (€500+) | Owners |

---

## Emergency Changes

In case of an active security incident or system outage:

1. Immediate action can be taken without prior approval
2. Owners must be notified within 1 hour
3. Documentation and post-incident review required within 24 hours

---

## Documentation

Every change is documented through:

- **GitHub commits** – with clear description of what was changed and why
- **Weekly reports** – major changes are summarized in the weekly report

---

## Change Log

| Date | Change | Author | Approved By |
|------|--------|--------|--------------|
| May 12, 2026 | Kernel update (6.17.0-22 → 6.17.0-23) | Ilie | (auto-security) |
| May 12, 2026 | auditd installation for GDPR compliance | Ilie | Owners |
| May 12, 2026 | Unattended-upgrades enabled | Ilie | Owners |

---

## Review

This policy is reviewed annually or after any major incident.

**Last reviewed:** May 12, 2026  
**Next review:** May 2027

---

## Author

**Ilie Lucian** – Technical Department Manager
