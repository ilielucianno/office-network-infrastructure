# Week 9 Report: April 27 - May 2, 2026

## Focus: Wazuh Active Response & Shuffle SOAR Integration

---

### Active Response Implementation

**Objective:** Automatic IP blocking for SSH brute-force attacks.

**Issues Encountered & Resolved:**

| Issue | Solution |
|-------|----------|
| Wazuh version mismatch (Manager 4.14.4 vs Indexer 4.8.2) | Updated all components to 4.14.4 |
| Missing API user `wazuh-wui` | Regenerated API users with `wazuh-passwords-tool.sh` |
| Invalid command `firewall-drop` in active response | Added `<command>` section in `ossec.conf` |
| Script not receiving data (old format vs Wazuh 4.x JSON) | Rewrote `firewall-drop.sh` to parse JSON from stdin |
| Wazuh manager timeout on restart | Created systemd override with `TimeoutStartSec=300` |

**Test Results:**
- Rule 5712 triggers on SSH brute-force
- IP address blocked in iptables
- Logs confirm IP extraction and blocking

---

### Shuffle SOAR Integration

**Objective:** Send Wazuh alerts to Shuffle for automation.

**Issues Encountered & Resolved:**

| Issue | Solution |
|-------|----------|
| Port 9200 conflict (Shuffle OpenSearch vs Wazuh Indexer) | Changed Shuffle port to 9201 |
| Webhook configuration | Added integration section in `ossec.conf` |

**Test Results:**
- Webhook receives alerts (confirmed with `curl`)
- Execution IDs generated for each call

---

### Current System Status

| Component | Status |
|-----------|--------|
| Wazuh 4.14.4 | Stable |
| DarkGhost NDR (port 8081) | Running |
| SQL Detector (port 8082) | Running |
| OPNsense + Zenarmor | Running |
| Active Response | Complete |
| Shuffle SOAR | Complete |

### Access URLs

| Service | URL |
|---------|-----|
| Wazuh Dashboard | https://192.168.2.21 |
| DarkGhost NDR | http://192.168.2.21:8081 |
| SQL Detector | http://192.168.2.21:8082 |
| OPNsense WebGUI | https://192.168.100.1 |
| Shuffle SOAR | https://192.168.2.21:3443 |

---

### Incident Response Update (SSH Brute-force)

| Step | Action |
|------|--------|
| 1 | Wazuh triggers rule 5712 (level 10) |
| 2 | Active response adds attacker IP to iptables blocklist |
| 3 | Shuffle webhook receives alert |
| 4 | Alert appears in Wazuh dashboard |

**Response times:**
- Detection: < 5 seconds
- IP blocking: < 10 seconds
- Total: ~30 seconds

---

### Lessons Learned

1. Wazuh 4.x active response scripts require JSON parsing (positional arguments no longer work)
2. Systemd timeouts need adjustment for resource-constrained VMs
3. Port conflicts are common – check existing services before deploying new containers
4. All Wazuh components must be on the same major version

---

### Commands Used


# Check active response log
sudo cat /var/ossec/logs/active-responses.log

# Check iptables blocked IPs
sudo iptables -L INPUT -n

# Remove blocked IP
sudo iptables -D INPUT -s <IP> -j DROP

Status: ✅ Active Response and Shuffle SOAR successfully implemented.

# Test Shuffle webhook
curl -k -X POST https://192.168.2.21:3443/api/v1/hooks/webhook_... -H "Content-Type: application/json" -d '{"test": "alert", "rule": "5712"}'
