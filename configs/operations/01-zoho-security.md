# Zoho Security & Access Control

This document describes how we secure access to Zoho CRM (our main business tool) and the procedures we follow to prevent unauthorized access.

---

## Overview

Zoho is our central platform for:
- Managing customer support
- Tracking player accounts
- Handling bonuses and promotions
- Viewing withdrawal requests

**Key principle:** Even if someone steals a password, they cannot access Zoho without additional verification.

---

## Security Measures Implemented

### 1. Two-Factor Authentication (2FA)

| Setting | Value |
|---------|-------|
| Status | Enabled for all users |
| Method | Google Authenticator / Microsoft Authenticator |
| Backup codes | Saved for each user (stored securely) |

**How it works:**
- User enters username and password
- App asks for 6-digit code from authenticator app
- Without the code, login is blocked

---

### 2. IP-Based Verification

| Setting | Value |
|---------|-------|
| Status | Enabled |
| Trusted devices | Remembers device + IP for 30 days |
| New IP detection | Requires 2FA again |

**How it works:**
- If you log in from your usual office IP, 2FA is not requested again for 30 days
- If someone tries to log in from a different IP, Zoho asks for 2FA immediately
- This blocks attackers even if they have the password and 2FA code (if they don't have the trusted device)

---

### 3. User Roles & Permissions

| Role | Access Level | What They Can Do |
|------|--------------|------------------|
| **Owner** | Full access | Approve withdrawals, view all data, manage users |
| **Support Agents** | Limited | View player accounts, add free bonuses, activate coupons |
| **Finance** | Restricted | Cannot withdraw money, cannot see real money balances |

**What Support CANNOT do:**
- Approve withdrawals
- See real money transactions
- Change user permissions
- Access financial reports

---

### 4. Withdrawal Protection

| Protection | How It Works |
|------------|--------------|
| **Delay period** | Withdrawals take 7-21 working days to process |
| **Daily review** | We check withdrawal list every day |
| **Manual approval** | Only owners can approve withdrawals |
| **Cancel option** | If suspicious, we cancel the withdrawal |

**Why this matters:**
Even if an attacker gains access to Zoho, they cannot withdraw money immediately. We have time to notice, investigate, and cancel.

---

### 5. Monitoring & Alerts

| Alert Type | What Triggers It | Action |
|------------|------------------|--------|
| Google Data Breach Alert | Password appears in leaked database | Change password immediately |
| Unusual Login | Login from new IP or device | Verify with user, force password change |
| Suspicious Activity | Multiple failed logins, unusual actions | Lock account, investigate |

---

## What Happened in the Zoho Breach (Example)

**Incident:** Someone gained access to a Zoho account (password leaked in data breach).

**What they tried:**
- Added bonus money to a player account
- Attempted to withdraw money

**Why it failed:**
1. Withdrawal approval requires manual check by owners
2. We check withdrawal list daily
3. We saw the suspicious withdrawal and cancelled it
4. Changed password, enforced 2FA reset

**Lesson:** Multiple layers of protection (delays, manual review, daily review) stopped the attack.

---

## Best Practices for Users

| Rule | Why |
|------|-----|
| Never share your password | Even with colleagues |
| Use a unique password for Zoho | Not the same as other accounts |
| Keep your phone with authenticator app | Without it, you cannot log in |
| Report suspicious activity immediately | Time is critical |

---

## Emergency Procedures

### If You Suspect an Account Is Compromised

1. **Immediately:** Tell an owner (Owner 1 France or Owner 2 Israel)
2. **Change password** in Zoho
3. **Reset 2FA** for that user
4. **Review recent activity** for suspicious actions
5. **Cancel any pending withdrawals** that seem suspicious
6. **Notify affected users** if necessary

---

## Regular Checks

| Task | Frequency | Who |
|------|-----------|-----|
| Review user accounts | Monthly | Owner |
| Check withdrawal list | Daily | Owner |
| Verify 2FA is enabled | Weekly | Owner |
| Update passwords | Quarterly | All users |

---

## Summary

| Layer | Protection |
|-------|------------|
| Password | Strong, unique |
| 2FA | Google Authenticator |
| IP Verification | Blocks unknown locations |
| Roles | Support cannot withdraw |
| Delays | 7-21 days for withdrawals |
| Manual Review | Owners check daily |
| Alerts | Google breach notifications |

**Result:** Even if an attacker gets past one layer, multiple others block them.
