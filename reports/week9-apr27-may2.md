# Week 9 Report: April 27 - May 2, 2026

## Focus: Wazuh Active Response & Shuffle SOAR Integration

### Day 1 - April 27, 2026: Active Response Implementation

**Objective:** Implement automatic IP blocking for SSH brute-force attacks.

**Tests Performed:**
- SSH brute-force simulation (6 failed password attempts from 127.0.0.1)
- Active response script execution testing
- iptables verification

**Issues Encountered & Resolved:**

1. Wazuh version mismatch - Manager 4.14.4 vs Indexer/Dashboard 4.8.2
   Solution: Updated all components to 4.14.4

2. Missing API user wazuh-wui - User not found in internal database
   Solution: Regenerated API users with wazuh-passwords-tool.sh

3. Invalid command firewall-drop in active response - Command definition missing in ossec.conf
   Solution: Added command section with executable path

4. Active response script not receiving data - Old script format (positional arguments) vs Wazuh 4.x JSON format
   Solution: Rewrote firewall-drop.sh to parse JSON from stdin

5. Wazuh manager timeout on restart - Default timeout (60s) too short for VM
   Solution: Created systemd override with TimeoutStartSec=300

**Active Response Configuration in ossec.conf:**
<active-response>
  <disabled>no</disabled>
  <command>firewall-drop</command>
  <location>local</location>
  <rules_id>5712</rules_id>
  <timeout>1800</timeout>
</active-response>

**Test Results:**
- Active Response triggers on rule 5712 (SSH brute-force)
- IP address 127.0.0.1 blocked successfully in iptables
- Logs confirm IP extraction and blocking

**Commands to verify:**
sudo iptables -L INPUT -n | grep "127.0.0.1"
sudo cat /var/ossec/logs/active-responses.log

---

### Day 2 - April 27, 2026: Shuffle SOAR Integration

**Objective:** Send Wazuh alerts to Shuffle for automation.

**Installation Steps:**
1. Installed Docker and Docker Compose
2. Cloned Shuffle repository
3. Resolved port conflict: Modified docker-compose.yml (9200 to 9201)
4. Deployed Shuffle containers
5. Created workflow and webhook

**Issues Encountered & Resolved:**

1. Port 9200 conflict - Shuffle OpenSearch vs Wazuh Indexer (both need 9200)
   Solution: Changed Shuffle OpenSearch port to 9201

2. Webhook configuration - Added integration section in ossec.conf

**Wazuh Integration in ossec.conf:**
<integration>
  <name>shuffle</name>
  <hook_url>https://192.168.2.21:3443/api/v1/hooks/webhook_a465dd55-8a02-4e9a-9b35-8ee3d91e05bc</hook_url>
  <level>10</level>
  <alert_format>json</alert_format>
</integration>

**Test Results:**
- Shuffle webhook receives alerts (confirmed with curl test)
- Execution IDs generated for each webhook call

**Test command:**
curl -k -X POST https://192.168.2.21:3443/api/v1/hooks/webhook_a465dd55-8a02-4e9a-9b35-8ee3d91e05bc -H "Content-Type: application/json" -d '{"test": "Hello from Wazuh", "rule": "5712"}'

---

### This Week Summary - What Works Now

| Capability | Status |
|------------|--------|
| Active Response (SSH brute-force) | Complete |
| Shuffle SOAR Integration | Complete |
| Wazuh 4.14.4 | Stable |
| DarkGhost NDR (port 8081) | Running |
| SQL Injection Detector (port 8082) | Running |
| OPNsense + Zenarmor | Running |

### Current Lab Access

Wazuh Dashboard: https://192.168.2.21
DarkGhost NDR: http://192.168.2.21:8081
SQL Detector: http://192.168.2.21:8082
OPNsense WebGUI: https://192.168.100.1
Shuffle SOAR: https://192.168.2.21:3443

### Incident Response Update

When SSH brute-force detected:
1. Wazuh triggers rule 5712 (level 10)
2. Active response automatically adds attacker IP to iptables blocklist
3. Shuffle webhook receives alert
4. Alert appears in Wazuh dashboard

Response times measured in lab:
- Detection: less than 5 seconds
- IP blocking: less than 10 seconds (after 6 failed attempts)
- Total time from first detection to block: approximately 30 seconds

### Lessons Learned This Week

1. Wazuh 4.x active response scripts require JSON parsing - Positional arguments no longer work
2. Systemd timeouts need adjustment - Wazuh manager needs more than 60 seconds on resource-constrained VMs
3. Port conflicts are common - Always check for existing services before deploying new containers
4. Version consistency matters - All Wazuh components must be on same major version

### Next Week Focus (May 4 - May 9, 2026)

1. Complete Shuffle workflow for automated ticket creation
2. Integrate TheHive for incident management
3. Create custom Wazuh rules for DarkGhost alerts
4. Test end-to-end SOAR playbook
5. Begin cloud security scanning (AWS/Azure)

---

Credits: Tests performed by Ilie Lucian in the office network lab environment. All implementations documented before production deployment.
