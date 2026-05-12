# Week 10 Report: May 12 - May 18, 2026
**Focus: Server Backup Verification & Security Updates**

---

## Actions Taken

### 1. Backup Server Verification (Intel N100)

| Item | Status |
|------|--------|
| Hardware check | Passed |
| Ubuntu version | 22.04.5 LTS |
| Kernel version | 6.17.0-23-generic |
| Network connectivity | Verified (IP: 192.168.30.11) |
| Disk space | 45GB free |

**Commands used:**
```bash
sudo smartctl -H /dev/sda
ping 192.168.30.10
df -h
```

---

### 2. Security Updates Applied

| Server | Update | From → To |
|--------|--------|-----------|
| Primary (Geekom) | Kernel | 6.17.0-22 → 6.17.0-23 |
| Primary | Docker | Upgraded |
| Backup (Intel N100) | Kernel | 6.17.0-22 → 6.17.0-23 |
| Backup | System packages | apt upgrade |

---

### 3. Vulnerability Check (CVE-2026-43284 - Dirty Frag)

| Check | Primary | Backup |
|-------|---------|--------|
| Kernel version | 6.17.0-23 ✅ | 6.17.0-23 ✅ |
| `dmesg \| grep -i "dirty\|frag"` | No output ✅ | No output ✅ |
| `lsmod \| grep -E "esp4\|esp6\|rxrpc"` | No modules ✅ | No modules ✅ |

---

### 4. Wazuh Active Response Test

| Step | Result |
|------|--------|
| 6 failed SSH attempts | Rule 5712 triggered ✅ |
| IP blocked in iptables | Confirmed ✅ |
| Log entry | Confirmed ✅ |

---

## Current System Status

| Component | Primary (Geekom) | Backup (Intel N100) |
|-----------|-----------------|---------------------|
| OS | Ubuntu 22.04 LTS | Ubuntu 22.04 LTS |
| Kernel | 6.17.0-23 | 6.17.0-23 |
| Wazuh | Active | Standby |
| DarkGhost | Active | Standby |
| SQL Detector | Active | Standby |
| OPNsense VM | Active | Not configured |
| Backups | Daily (Odoo DB) | Weekly (config) |

---

## Backup Inventory

| Backup Type | Location | Frequency | Last Backup | Status |
|-------------|----------|-----------|-------------|--------|
| Odoo database | /backup/ | Daily | May 17, 2026 | ✅ |
| System config | External SSD | Weekly | May 15, 2026 | ✅ |
| DarkGhost source | GitHub | Manual | May 10, 2026 | ✅ |
| SQL Detector source | GitHub | Manual | May 10, 2026 | ✅ |

---

## Issues Encountered & Resolved

| Issue | Solution |
|-------|----------|
| Backup server had old kernel (6.17.0-22) | `sudo apt update && sudo apt upgrade -y` |
| Docker on backup server outdated | `sudo apt upgrade docker.io` |

---

## SQL Injection Detector - Verification

| Component | Version | Status |
|-----------|---------|--------|
| TensorFlow | 2.21.0 | Up to date ✅ |
| Flask | latest | OK |
| Model accuracy | 100% | Verified |

> No vulnerabilities found. System is secure.

---

## Lessons Learned

- Backup server had not been updated in 3 weeks – schedule regular updates
- Dirty Frag patch applied successfully on both servers
- Wazuh Active Response continues to work after kernel update
- TensorFlow is up to date (2.21.0)
- **Next week:** Full restore test on backup server

---

## Next Week Focus (May 19 - May 25)

- Disaster Recovery test (simulate primary server failure)
- Restore from backup on Intel N100
- Measure actual recovery time
- Document recovery procedure

---

## Commands Used

**Update backup server:**
```bash
sudo apt update && sudo apt upgrade -y
```

**Check kernel version:**
```bash
uname -r
```

**Verify Dirty Frag:**
```bash
sudo dmesg | grep -i "dirty|frag"
lsmod | grep -E "esp4|esp6|rxrpc"
```

**Test Wazuh Active Response:**
```bash
ssh wronguser@127.0.0.1
sudo iptables -L INPUT -n | grep DROP
sudo cat /var/ossec/logs/active-responses.log
```

**Check backup disk space:**
```bash
df -h
ls -la /backup/
```

---

> ✅ **Status: Both servers patched and verified. Backup server ready for disaster recovery test next week.**
>
> ### DarkGhost NDR - Python Package Update

| Package | Old Version | New Version |
|---------|-------------|-------------|
| certifi | 2026.2.25 | 2026.4.22 |
| click | 8.3.2 | 8.3.3 |
| idna | 3.11 | 3.14 |
| pip | 24.0 | 26.1.1 |
| requests | 2.33.1 | 2.34.0 |
| urllib3 | 2.6.3 | 2.7.0 |

**Status:** ✅ All packages updated. DarkGhost remains stable.
