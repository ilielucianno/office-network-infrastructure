# Incident Response Runbook

This document describes step-by-step what to do when different types of security incidents occur. Think of it as a "fire drill" guide.

---

## Before an Incident

**Keep these ready:**
- List of all accounts with access
- Backup codes for 2FA (stored securely)
- Phone numbers of all owners
- Link to Zoho admin panel
- Access to withdrawal list

---

## Incident Type 1: Suspicious Zoho Login

### Signs
- You receive "New login detected" email
- User reports they couldn't log in
- Someone sees activity they didn't do

### Actions

| Step | Action | Time |
|------|--------|------|
| 1 | Check who received the alert | Immediate |
| 2 | If it's a user, call them to verify if they tried to log in | 1 minute |
| 3 | If they didn't log in, change password immediately | 2 minutes |
| 4 | Reset 2FA for that account | 3 minutes |
| 5 | Review recent activity in Zoho for suspicious actions | 5 minutes |
| 6 | Check if any withdrawals were requested | 5 minutes |
| 7 | Cancel any suspicious withdrawals | 10 minutes |
| 8 | Document what happened (date, time, account, actions) | 15 minutes |

---

## Incident Type 2: Withdrawal Attempt (Suspicious)

### Signs
- Large withdrawal request
- Request from unusual player
- Multiple requests from same IP

### Actions

| Step | Action | Time |
|------|--------|------|
| 1 | Check withdrawal list (daily) | 5 minutes |
| 2 | Identify suspicious request | 1 minute |
| 3 | Cancel the withdrawal | 1 minute |
| 4 | Investigate which support agent processed it | 5 minutes |
| 5 | Check if that agent's account is compromised | 5 minutes |
| 6 | If compromised, change password and reset 2FA | 5 minutes |
| 7 | Review all withdrawals from last 24 hours | 10 minutes |

---

## Incident Type 3: Network / Router Issue

### Signs
- No internet in office
- Cannot access server
- Cannot connect to VPN

### Actions

| Step | Action | Time |
|------|--------|------|
| 1 | Check router power and lights | 1 minute |
| 2 | Reboot router (unplug, wait 30 sec, plug back) | 2 minutes |
| 3 | Wait 2-3 minutes for boot | 3 minutes |
| 4 | Check if internet returns | 1 minute |
| 5 | If not, check ISP modem | 2 minutes |
| 6 | Reboot ISP modem if needed | 3 minutes |
| 7 | If still down, call ISP | 5 minutes |

---

## Incident Type 4: Server Not Accessible

### Signs
- Cannot reach Odoo (192.168.30.10:8069)
- Cannot SSH to server

### Actions

| Step | Action | Time |
|------|--------|------|
| 1 | Check server power LED | 1 minute |
| 2 | Check network cable to switch | 1 minute |
| 3 | Ping server: `ping 192.168.30.10` | 1 minute |
| 4 | If no ping, connect monitor and keyboard directly | 5 minutes |
| 5 | Check if server is frozen (reboot if needed) | 3 minutes |
| 6 | After reboot, check Odoo service: `sudo systemctl status odoo` | 2 minutes |
| 7 | Check logs: `sudo tail -f /var/log/odoo/odoo.log` | 2 minutes |

---

## Incident Type 5: Phishing / Email Scam (Like Crypto Incident)

### Signs
- User clicked a suspicious link
- User entered credentials somewhere
- User says "I did something and now..."

### Actions

| Step | Action | Time |
|------|--------|------|
| 1 | Stay calm — you have time | - |
| 2 | Ask user exactly what they did | 1 minute |
| 3 | If they entered credentials, change passwords immediately | 2 minutes |
| 4 | If they entered a seed phrase (crypto), move funds NOW | 15 seconds |
| 5 | Review recent activity on compromised account | 5 minutes |
| 6 | Revoke any suspicious sessions | 2 minutes |
| 7 | Document what happened and share with team | 10 minutes |
| 8 | Plan training to prevent recurrence | Next day |

---

## After Any Incident

| Task | When |
|------|------|
| Write what happened (date, time, cause, actions) | Same day |
| Review what went well and what could be better | Next day |
| Update this runbook if needed | Next day |
| Train team on what happened (if relevant) | Within a week |

---

## Contact List

| Role | Name | Phone |
|------|------|-------|
| Owner / IT | Ilie | +357 95572559 |
| Owner | Owner 2 (France) | [phone] |
| Owner | Owner 2 (Israel) | [phone] |

---

## Emergency Quick Reference

| Problem | First Action |
|---------|--------------|
| Suspicious Zoho login | Call user, change password |
| Suspicious withdrawal | Cancel immediately |
| No internet | Reboot router |
| Server down | Check power and cables |
| User clicked phishing | Change passwords, check activity |

---

## Keep This Document Updated

- Update when you add new services
- Update when team changes
- Practice the steps sometimes (like a drill)
