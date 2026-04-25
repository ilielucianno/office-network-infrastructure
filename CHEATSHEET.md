# Security & System Commands Cheatsheet

Quick reference for daily operations and monitoring.

---

## DarkGhost NDR

| Action | Command |
|--------|---------|
| Check DarkGhost dashboard | Open browser: `http://SERVER_IP:8081` |
| Check DarkGhost process | `ps aux \| grep -E "python.*darkghost"` |
| View live DarkGhost alerts | `sudo tail -f /var/log/darkghost/alerts.log` |
| View recent alerts (JSON) | `curl -s http://localhost:8081/api/data \| jq '.alerts[-5:]'` |
| Check packet count | `curl -s http://localhost:8081/api/data \| jq '.stats.total_packets'` |
| Start DarkGhost dashboard | `cd ~/darkghost && source venv/bin/activate && python3 dashboard.py` |
| Start DarkGhost main engine | `sudo /home/user/darkghost/venv/bin/python3 /home/user/darkghost/main.py` |
| Reset DarkGhost baseline | `rm ~/darkghost/baseline.json` |
| DarkGhost log file | `/var/log/darkghost/alerts.log` |

### What DarkGhost Detects

| Detection | Risk Level | Example |
|-----------|------------|---------|
| Port scan | CRITICAL | 10+ ports scanned in short time |
| Sensitive port (SSH, RDP, 4444) | HIGH | Device uses SSH for first time |
| Large packet (>10x normal) | HIGH | Possible data exfiltration |
| Night traffic (00:00-06:00) | MEDIUM | Unusual activity hours |
| TTL change (spoofing) | CRITICAL | MAC/IP spoofing detected |

---

## SQL Injection Detector (SnortML)

| Action | Command |
|--------|---------|
| Start ML service | `cd ~/sql-injection-detector && source venv/bin/activate && python3 ml_service.py` |
| Start SQL detector dashboard | `cd ~/sql-injection-detector && source venv/bin/activate && python3 dashboard.py` |
| Check SQL detector dashboard | Open browser: `http://SERVER_IP:8082` |
| Test SQL injection detection | `curl -X POST http://localhost:5000/predict -H "Content-Type: application/json" -d '{"payload": "1 OR 1=1"}'` |
| View SQL detector logs | `tail -f ~/sql-injection-detector/events.log` |

### What SQL Detector Detects

| Attack Type | Example | Status |
|-------------|---------|--------|
| Tautology | `1' OR '1'='1` | ✅ Blocked |
| UNION attack | `1 UNION SELECT * FROM users` | ✅ Blocked |
| Time-based | `1' AND SLEEP(5)--` | ✅ Blocked |
| Stacked queries | `1; DROP TABLE users--` | ✅ Blocked |
| URL encoded | `1%27%20OR%20%271%27=%271` | ✅ Blocked |

---

## Port Mirroring (SPAN) on TP-Link TL-SG108E

| Action | Location / Command |
|--------|---------------------|
| Access switch web UI | `http://192.168.0.1` (or configured IP) |
| Default credentials | admin / (no password) |
| Enable port mirroring | Monitoring → Port Mirror → Enable |
| Mirroring Port (Destination) | Port 8 (server connected here) |
| Mirrored Ports (Source) | Port 1 (trunk port with all VLANs) |
| Mirror Mode | Both (TX and RX) |
| Verify mirroring works | `sudo tcpdump -i eth0 -c 10` (should see traffic from HR and Support IPs) |

---

## Wazuh SIEM

| Action | Command |
|--------|---------|
| Check Wazuh status | `sudo systemctl status wazuh-manager` |
| View Wazuh logs | `sudo tail -f /var/ossec/logs/ossec.log` |
| View Wazuh alerts | `sudo tail -f /var/ossec/logs/alerts/alerts.json` |
| Check archive logs | `sudo tail -f /var/ossec/logs/archives/archives.log` |
| Restart Wazuh | `sudo systemctl restart wazuh-manager` |
| Stop Wazuh | `sudo systemctl stop wazuh-manager` |
| Start Wazuh | `sudo systemctl start wazuh-manager` |

---

## Snort IDS (Low-Memory Mode)

| Action | Command |
|--------|---------|
| Check Snort status | `sudo systemctl status snort` |
| View live Snort alerts | `sudo tail -f /var/log/snort/alert.txt` |
| View Snort logs | `sudo tail -f /var/log/snort/packets.log` |
| Restart Snort | `sudo systemctl restart snort` |
| Stop Snort | `sudo systemctl stop snort` |
| Start Snort | `sudo systemctl start snort` |
| Test Snort configuration | `sudo -u snort snort -c /etc/snort/snort.lua -T` |
| **Low-memory settings** | `detect` engine profile in `snort.lua` |

### Snort Low-Memory Configuration

| Setting | Value |
|---------|-------|
| Engine profile | `detect` (instead of `max`) |
| Hyperscan mode | disabled |
| Packet pool size | reduced to 256 |
| Flow cache limit | reduced to 10000 |

---

## Odoo HR System

| Action | Command |
|--------|---------|
| Check Odoo status | `sudo systemctl status odoo` |
| View Odoo logs | `sudo tail -f /var/log/odoo/odoo.log` |
| Restart Odoo | `sudo systemctl restart odoo` |
| Stop Odoo | `sudo systemctl stop odoo` |
| Start Odoo | `sudo systemctl start odoo` |

---

## Firewall (UFW)

| Action | Command |
|--------|---------|
| Check UFW status | `sudo ufw status` |
| Check numbered UFW rules | `sudo ufw status numbered` |
| Enable UFW | `sudo ufw enable` |
| Disable UFW | `sudo ufw disable` |
| Allow port (e.g., SSH) | `sudo ufw allow 22/tcp` |
| Allow from specific network | `sudo ufw allow from 192.168.10.0/24 to any port 22` |

---

## OPNsense + Zenarmor (VM)

| Action | Command (on Ubuntu server) |
|--------|---------------------------|
| Start VM | `VBoxManage startvm OPNsense-Test --type headless` |
| Stop VM | `VBoxManage controlvm OPNsense-Test poweroff` |
| Check VM status | `VBoxManage showvminfo OPNsense-Test \| grep State` |
| Enable VRDP | `VBoxManage modifyvm OPNsense-Test --vrde on` |
| RDP connection | `mstsc` (Windows) → `SERVER_IP:3390` |

### In OPNsense WebGUI (https://192.168.100.1)

| Action | Location |
|--------|----------|
| Zenarmor status | Zenarmor → Dashboard |
| Block applications | Zenarmor → Policies → App Controls |
| Check logs | Zenarmor → Reports → Live Sessions |
| Configure syslog | System → Settings → Logging |
| Firewall rules | Firewall → Rules → WAN / LAN |

---

## VPN WireGuard (MikroTik)

| Action | Command (in WinBox Terminal) |
|--------|-----------------------------|
| Check WireGuard status | `/interface wireguard print` |
| Check connected clients | `/interface wireguard peers print where interface=wg0` |
| Add new client | `/interface wireguard peers add interface=wg0 public-key="KEY" allowed-address=10.10.10.X/32` |
| Remove client | `/interface wireguard peers remove X` |

---

## General Server

| Action | Command |
|--------|---------|
| See who is logged in | `who` |
| See logged in users | `w` |
| View active processes | `top` or `htop` |
| View memory usage | `free -h` |
| View disk space | `df -h` |
| View server IP | `ip addr show` |
| Check internet connection | `ping google.com` |
| Check listening ports | `sudo netstat -tulpn` |

---

## Backup & Restore

| Action | Command |
|--------|---------|
| Backup Odoo database | `sudo /root/backup.sh` |
| Check backups | `ls -la /backup/` |
| Check backup log | `tail -20 /var/log/backup.log` |

---

## Networking (Testing)

| Action | Command |
|--------|---------|
| Port scan (from another PC) | `nmap -p 1-100 TARGET_IP` |
| Ping test | `ping IP_ADDRESS` |
| Check route | `traceroute IP_ADDRESS` |
| Check DNS | `nslookup google.com` |
| Verify DarkGhost sees inter-VLAN traffic | `sudo tcpdump -i eth0 -c 10` (look for HR/Support IPs) |

---

## OPNsense VM Management (on server)

| Action | Command |
|--------|---------|
| List VMs | `VBoxManage list vms` |
| Change RAM | `VBoxManage modifyvm OPNsense-Test --memory 4096` |
| Change CPU | `VBoxManage modifyvm OPNsense-Test --cpus 2` |
| Connect to console (RDP) | `mstsc /v:SERVER_IP:3390` |

---

## Quick Troubleshooting

| Problem | Commands to check |
|---------|-------------------|
| Wazuh not receiving logs | `sudo tcpdump -i any port 514` (check syslog) |
| Snort won't start | `sudo journalctl -u snort -n 50` |
| Odoo not responding | `sudo systemctl status odoo` + `sudo tail -f /var/log/odoo/odoo.log` |
| OPNsense VM won't start | `VBoxManage showvminfo OPNsense-Test` |
| Zenarmor not running | Check WebGUI: Zenarmor → Dashboard |
| DarkGhost no traffic | Verify port mirroring: `sudo tcpdump -i eth0 -c 10` |
| DarkGhost not alerting | Check baseline: `ls -la ~/darkghost/baseline.json` |
| SQL detector not responding | `curl http://localhost:5000/health` |
| Snort high memory usage | Check `detect` profile is enabled |

---

## Endpoint Security (Laptops)

| Action | Command / Method |
|--------|------------------|
| Check Windows Security | `Get-MpComputerStatus` (PowerShell) |
| Check Windows Firewall | `Get-NetFirewallProfile` (PowerShell) |
| Check Avira status | Open Avira Free → Security → Status |
| Check last scans | Windows Security → Protection history |
| Run quick scan (Windows) | `Start-MpScan -ScanType QuickScan` |
| Update Avira definitions | Automatic update (check in app) |

---

## Daily Security Checklist

- [ ] Wazuh active: `sudo systemctl status wazuh-manager`
- [ ] Snort active: `sudo systemctl status snort`
- [ ] Odoo active: `sudo systemctl status odoo`
- [ ] DarkGhost active: check `http://SERVER_IP:8081`
- [ ] SQL Detector active: check `http://SERVER_IP:8082`
- [ ] OPNsense VM running: `VBoxManage showvminfo OPNsense-Test | grep State`
- [ ] New alerts in Wazuh: `sudo tail -10 /var/ossec/logs/alerts/alerts.json`
- [ ] New alerts in DarkGhost: `sudo tail -10 /var/log/darkghost/alerts.log`
- [ ] No suspicious users: `who`
- [ ] Recent backup verified: `ls -la /backup/`

---

## Weekly Security Checklist

- [ ] System updates: `sudo apt update && sudo apt upgrade -y`
- [ ] Snort rule updates (manual or script)
- [ ] Check Zenarmor logs for unexpected blocks
- [ ] Check DarkGhost anomaly statistics
- [ ] Check SQL detector detection logs
- [ ] Check disk space: `df -h`
- [ ] Check RAM usage (Snort low-memory confirmed): `free -h`

---

## Emergency Recovery

| Problem | Action |
|---------|--------|
| Server down | Physical connection, reboot, check `systemctl status` |
| Odoo down | `sudo systemctl restart odoo` |
| Wazuh down | `sudo systemctl restart wazuh-manager` |
| Snort down | `sudo systemctl restart snort` |
| DarkGhost down | Restart dashboard and main engine (see DarkGhost section) |
| SQL Detector down | Restart ML service and dashboard (see SQL Detector section) |
| OPNsense VM down | `VBoxManage startvm OPNsense-Test --type headless` |
| VPN down | Check MikroTik router, restart WireGuard |
| No DarkGhost traffic | Check port mirroring on TP-Link switch |
| High Snort memory | Revert to `detect` profile in `snort.lua` |

---

## Quick Service Restart (All at Once)

# Stop all
sudo systemctl stop wazuh-manager snort odoo
pkill -f "python.*darkghost"
pkill -f "python.*ml_service"
pkill -f "python.*sql.*dashboard"

# Start in order
sudo systemctl start wazuh-manager
sudo systemctl start snort
sudo systemctl start odoo

# Start DarkGhost (two terminals)
cd ~/darkghost && source venv/bin/activate && python3 dashboard.py
sudo /home/user/darkghost/venv/bin/python3 /home/user/darkghost/main.py

# Start SQL Detector (two terminals)
cd ~/sql-injection-detector && source venv/bin/activate && python3 ml_service.py
cd ~/sql-injection-detector && source venv/bin/activate && python3 dashboard.py

