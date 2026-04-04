# Security & System Commands Cheatsheet

Quick reference for daily operations and monitoring.

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

## Snort IDS

| Action | Command |
|--------|---------|
| Check Snort status | `sudo systemctl status snort` |
| View live Snort alerts | `sudo tail -f /var/log/snort/alert.txt` |
| View Snort logs | `sudo tail -f /var/log/snort/packets.log` |
| Restart Snort | `sudo systemctl restart snort` |
| Stop Snort | `sudo systemctl stop snort` |
| Start Snort | `sudo systemctl start snort` |
| Test Snort configuration | `sudo -u snort snort -c /etc/snort/snort.lua -T` |

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
- [ ] OPNsense VM running: `VBoxManage showvminfo OPNsense-Test | grep State`
- [ ] New alerts in Wazuh: `sudo tail -10 /var/ossec/logs/alerts/alerts.json`
- [ ] No suspicious users: `who`
- [ ] Recent backup verified: `ls -la /backup/`

---

## Weekly Security Checklist

- [ ] System updates: `sudo apt update && sudo apt upgrade -y`
- [ ] Snort rule updates (manual or script)
- [ ] Check Zenarmor logs for unexpected blocks
- [ ] Check disk space: `df -h`
- [ ] Check RAM usage: `free -h`

---

## Emergency Recovery

| Problem | Action |
|---------|--------|
| Server down | Physical connection, reboot, check `systemctl status` |
| Odoo down | `sudo systemctl restart odoo` |
| Wazuh down | `sudo systemctl restart wazuh-manager` |
| Snort down | `sudo systemctl restart snort` |
| OPNsense VM down | `VBoxManage startvm OPNsense-Test --type headless` |
| VPN down | Check MikroTik router, restart WireGuard |
