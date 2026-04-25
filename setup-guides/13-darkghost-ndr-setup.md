# 13 - DarkGhost NDR Setup

This guide covers the installation and configuration of DarkGhost NDR (Network Detection & Response) on the Ubuntu server. DarkGhost monitors mirrored network traffic for behavioral anomalies, port scans, TTL spoofing, and lateral movement between VLANs.

DarkGhost is an open-source alternative to Darktrace – it learns normal behavior per device and generates anomaly scores (0-1) when deviations occur.

---

## Prerequisites

- Ubuntu Server installed and configured (05 - Server Installation)
- Server IP: 192.168.30.10
- Port mirroring configured on the switch (see configs/switch/port-mirroring.txt)
- Python 3.10 or later

---

## Why DarkGhost

| Feature | Benefit |
|---------|---------|
| Baseline learning | Learns normal behavior per device automatically |
| Anomaly scoring | Score from 0.0 (normal) to 1.0 (critical) |
| TTL fingerprinting | Detects MAC/IP spoofing (Windows=128, Linux=64) |
| Port scan detection | Identifies rapid connection attempts |
| Lateral movement detection | Sees inter-VLAN traffic via port mirroring |
| Live dashboard | Web interface with real-time alerts |

---

## Step 1: Install Dependencies

sudo apt update
sudo apt install -y python3 python3-pip python3-venv git

---

## Step 2: Create Project Directory

mkdir -p ~/darkghost
cd ~/darkghost

---

## Step 3: Create Virtual Environment

python3 -m venv venv
source venv/bin/activate
pip install scapy flask requests

---

## Step 4: Create Main Engine File (main.py)

nano main.py

Add the DarkGhost main engine code (available in the project repository or contact the author).

---

## Step 5: Create Dashboard File (dashboard.py)

nano dashboard.py

Add the DarkGhost dashboard code (available in the project repository or contact the author).

---

## Step 6: Create Alert Engine File (alert_engine.py)

nano alert_engine.py

Add the alert engine code (available in the project repository or contact the author).

---

## Step 7: Create Log Directory for Wazuh Integration

sudo mkdir -p /var/log/darkghost
sudo touch /var/log/darkghost/alerts.log
sudo chmod 666 /var/log/darkghost/alerts.log

---

## Step 8: Start DarkGhost

Terminal 1 (Dashboard):

cd ~/darkghost && source venv/bin/activate && python3 dashboard.py

Terminal 2 (Main Engine):

cd ~/darkghost && source venv/bin/activate && sudo python3 main.py

---

## Step 9: Access DarkGhost Dashboard

Open browser and navigate to:

http://SERVER_IP:8081

You should see:
- Monitored devices with OS detection
- Live alerts with anomaly scores
- Packet counters

---

## Step 10: Verify Port Mirroring Works

On the server, run:

sudo tcpdump -i eth0 -c 10

If port mirroring is configured correctly, you will see traffic from multiple IPs (HR VLAN: 192.168.10.x, Support VLAN: 192.168.20.x).

If you only see traffic from the server itself, port mirroring is not working.

---

## What DarkGhost Detects

| Detection | Risk Level | Score | Example |
|-----------|------------|-------|---------|
| Port scan | CRITICAL | 0.90 | 10+ ports scanned in short time |
| Sensitive port (SSH, RDP, 4444) | HIGH | 0.78 | Device uses SSH for first time |
| Large packet (>10x normal) | HIGH | 0.60 | Possible data exfiltration |
| Night traffic (00:00-06:00) | MEDIUM | 0.70 | Unusual activity hours |
| TTL change (spoofing) | CRITICAL | 0.92 | MAC/IP spoofing detected |

---

## Alert Example

{
  "timestamp": "2026-04-25T10:30:00",
  "src_ip": "192.168.20.50",
  "dst_ip": "192.168.10.100",
  "protocol": "TCP",
  "port": 22,
  "anomaly_score": 0.78,
  "risk": "HIGH",
  "attack": true,
  "reason": "Sensitive port: 22 (SSH) from device that never used SSH"
}

---

## Integration with Wazuh

DarkGhost writes all alerts to /var/log/darkghost/alerts.log. Wazuh is configured to monitor this file, so all DarkGhost alerts appear in the Wazuh dashboard alongside other security events.

---

## Verification Checklist

- DarkGhost dashboard accessible at http://SERVER_IP:8081
- Devices appear in the dashboard with correct OS detection
- Alerts logged to /var/log/darkghost/alerts.log
- Port mirroring verified (tcpdump shows inter-VLAN traffic)
- Wazuh receives DarkGhost alerts (if integrated)

---

## Common Issues

| Issue | Solution |
|-------|----------|
| No devices in dashboard | Check port mirroring, verify interface name in main.py |
| DarkGhost not capturing traffic | Run tcpdump -i eth0 to see if traffic arrives |
| High false positives | Allow 24-48 hours for baseline to stabilize |
| Dashboard not accessible | Check firewall: sudo ufw allow 8081 |

---

## Next Steps

- Integrate DarkGhost alerts with Wazuh SIEM
- Create custom anomaly detection rules
- Adjust sensitivity thresholds based on your network

---

## Related Documentation

- Port Mirroring Configuration: ../configs/switch/port-mirroring.txt
- Snort IDS Setup: 09-ids-setup.md
- Wazuh SIEM Setup: 10-wazuh-setup.md
