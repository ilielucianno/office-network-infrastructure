# Accounts & Access Policy

This document defines who has access to what and how accounts are managed.

---

## User Roles Summary

| Role | Who | Access Level |
|------|-----|--------------|
| **Owner** | Ilie, Owner 1, Owner 2 | Full access to everything |
| **HR / Admin** | Server, Odoo, HR data |
| **Support Agent** | 12 agents | Zoho (limited), VPN,|
| **No Access** | External contractors | Nothing |

---

## Account Types

### 1. Zoho Accounts

| Role | Access | 2FA |
|------|--------|-----|
| Owners | Full control | ✅ Required |
| Support Agents | Limited (no withdrawals) | ✅ Required |

**Rules:**
- Every user has their own account — no shared accounts
- 2FA is mandatory for everyone
- Passwords must be unique (not used elsewhere)
- Accounts are disabled when someone leaves

---

### 2. WireGuard VPN Accounts

| User | IP | Access |
|------|-----|--------|
| Ilie | 10.10.10.2 | Full network access |
| Support Agents | 10.10.10.3 - 10.10.10.14 | Odoo only (192.168.30.10) |

**Rules:**
- Each agent has unique key
- Keys are revoked when agent leaves
- Spreadsheet tracks keys and IPs

---

### 3. Server / Odoo Accounts

| Role | Access |
|------|--------|
| Admin | Full Odoo access, server SSH |
| HR | Odoo employee data |
| Support | None (cannot access server) |

**Rules:**
- SSH is key-based only (no passwords)
- Odoo has 2FA for all users

---

## Onboarding (New Employee)

| Step | Action | Who |
|------|--------|-----|
| 1 | Create Zoho account with 2FA | Owner |
| 2 | Add to correct role (Support / HR) | Owner |
| 3 | Generate WireGuard key and config | Owner |
| 4 | Send config file securely | Owner |
| 5 | Train on security basics | Owner |
| 6 | Test access | Owner |

---

## Offboarding (Employee Leaves)

| Step | Action |
|------|--------|
| 1 | Disable Zoho account immediately |
| 2 | Remove WireGuard key from router |
| 3 | Disable Odoo account (where case) |
| 4 | Change any shared passwords they knew |
| 5 | Collect company devices (laptop, phone) |
| 6 | Document that access was removed |

---

## Password Policy

| Requirement | Value |
|-------------|-------|
| Minimum length | 12 characters |
| Complexity | Uppercase, lowercase, numbers, symbols |
| Unique | Never reuse passwords |
| Change frequency | Every 6 months (or after any incident) |
| Storage | Use a password manager (Bitwarden, 1Password) |

**Never:**
- Share passwords via email, SMS, or chat
- Write passwords on paper at desk
- Use same password for work and personal accounts

---

## 2FA Policy

| Rule | Explanation |
|------|-------------|
| All accounts must have 2FA | No exceptions |
| Use authenticator app (not SMS) | SMS can be intercepted |
| Save backup codes | In case phone is lost |
| Reconfigure if phone changes | New QR code |

---

## Access Review

| Review | Frequency | Who |
|--------|-----------|-----|
| Zoho users list | Monthly | Owner |
| WireGuard keys list | Monthly | Owner |
| Odoo users list | Monthly | Owner |
| Withdrawal permissions | Weekly | Owner |

---

## Quick Reference

| Question | Answer |
|----------|--------|
| Who can approve withdrawals? | Only owners (Ilie, Owner 1, Owner 2) |
| Who can access server? | Only Ilie |
| Who has 2FA? | Everyone |
| What happens when someone leaves? | All accounts disabled immediately |
| Where are passwords stored? | Password manager (any) |
