# Week 10 Report: May 12 - May 18, 2026

## Focus: Server Backup Verification & Security Updates

### Summary

This week focused on verifying the backup server (Intel N100) functionality and applying security updates to both primary and backup servers. No major incidents occurred. All systems are operational.

---

### Actions Taken

#### 1. Backup Server Verification (Intel N100)

| Item | Status |
|------|--------|
| Hardware check | Passed (all components working) |
| Ubuntu version | 22.04.5 LTS (upgraded) |
| Kernel version | 6.17.0-23-generic (patched) |
| Network connectivity | Verified (IP: 192.168.30.11) |
| Disk space | 45GB free (of 512GB) |
| Last backup test | Not restored (scheduled for Week 11) |

**Commands used:**

# Check disk health
sudo smartctl -H /dev/sda

# Check network
ping 192.168.30.10

# Check disk space
df -h
2. Security Updates Applied
Primary server (Geekom A9 Max):

Kernel update: 6.17.0-22-generic → 6.17.0-23-generic (Dirty Frag patch)

Docker packages upgraded

Python packages updated (scapy, flask, tensorflow)

Backup server (Intel N100):

Kernel update: 6.17.0-22-generic → 6.17.0-23-generic

System packages updated via apt upgrade

3. Vulnerability Check (CVE-2026-43284 - Dirty Frag)
Check	Primary Server	Backup Server
Kernel version after update	6.17.0-23-generic ✅	6.17.0-23-generic ✅
dmesg | grep -i "dirty|frag"	No output ✅	No output ✅
lsmod | grep -E "esp4|esp6|rxrpc"	No modules loaded ✅	No modules loaded ✅
Verification command used:


# Dirty Frag check (manual)
uname -r && sudo dmesg | grep -i "dirty\|frag" && lsmod | grep -E "esp4|esp6|rxrpc"
4. Wazuh Active Response Test
Tested SSH brute-force detection and automatic IP blocking on both servers:

Step	Result
6 failed SSH attempts	✅ Rule 5712 triggered
IP blocked in iptables	✅ DROP 0 -- 127.0.0.1
Log entry in active-responses.log	✅ Confirmed
Test command:


ssh wronguser@127.0.0.1
# repeated 6 times
Current System Status
Component	Primary Server (Geekom)	Backup Server (Intel N100)
OS	Ubuntu 22.04 LTS	Ubuntu 22.04 LTS
Kernel	6.17.0-23-generic	6.17.0-23-generic
Wazuh	Active	Not running (standby)
DarkGhost	Active	Not running (standby)
SQL Detector	Active	Not running (standby)
OPNsense VM	Active	Not configured (standby)
Docker	Running	Installed
Backups	Daily (Odoo DB)	Weekly (system config)
Backup Inventory
Backup Type	Location	Frequency	Last Backup	Status
Odoo database	/backup/	Daily	May 17, 2026	✅
System config (/etc, /home)	External SSD	Weekly	May 15, 2026	✅
DarkGhost source	GitHub	Manual	May 10, 2026	✅
SQL Detector source	GitHub	Manual	May 10, 2026	✅
Issues Encountered & Resolved
Issue	Solution
Backup server had old kernel (6.17.0-22)	Ran sudo apt update && sudo apt upgrade -y
Docker on backup server was outdated	Upgraded via sudo apt upgrade docker.io
None else	All updates completed successfully
Verification Checklist
Backup server hardware functional

Both servers updated to kernel 6.17.0-23

No Dirty Frag indicators on either server

Wazuh Active Response working

DarkGhost dashboards accessible on primary

SQL Detector dashboards accessible on primary

All backups verified (not restored)

Documentation updated

Lessons Learned
The backup server had not been updated in 3 weeks – need to schedule regular updates for it

Dirty Frag patch was applied successfully on both servers

Wazuh Active Response continues to work after kernel update

Next week: Perform full restore test on backup server

Next Week Focus (May 19 - May 25)
Disaster Recovery test – simulate complete failure of primary server

Restore from backup on Intel N100

Measure actual recovery time

Document recovery procedure

Commands Used This Week
bash
# Update backup server
sudo apt update && sudo apt upgrade -y

# Check kernel version
uname -r

# Verify Dirty Frag
sudo dmesg | grep -i "dirty\|frag"
lsmod | grep -E "esp4|esp6|rxrpc"

# Test Wazuh Active Response
ssh wronguser@127.0.0.1
sudo iptables -L INPUT -n | grep DROP
sudo cat /var/ossec/logs/active-responses.log

# Check backup disk space
df -h

# Check backup files
ls -la /backup/
Status: ✅ Both servers patched and verified. Backup server ready for disaster recovery test next week.
