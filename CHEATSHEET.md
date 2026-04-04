# Security & System Commands Cheatsheet

Quick reference for daily operations and monitoring.

---

## Wazuh SIEM

| Acțiune | Comandă |
|---------|---------|
| Verifici status Wazuh | `sudo systemctl status wazuh-manager` |
| Vezi log-uri Wazuh | `sudo tail -f /var/ossec/logs/ossec.log` |
| Vezi alerte Wazuh | `sudo tail -f /var/ossec/logs/alerts/alerts.json` |
| Verifici arhive logs | `sudo tail -f /var/ossec/logs/archives/archives.log` |
| Restartezi Wazuh | `sudo systemctl restart wazuh-manager` |
| Oprești Wazuh | `sudo systemctl stop wazuh-manager` |
| Pornești Wazuh | `sudo systemctl start wazuh-manager` |

---

## Snort IDS

| Acțiune | Comandă |
|---------|---------|
| Verifici status Snort | `sudo systemctl status snort` |
| Vezi alerte live Snort | `sudo tail -f /var/log/snort/alert.txt` |
| Vezi log-uri Snort | `sudo tail -f /var/log/snort/packets.log` |
| Restartezi Snort | `sudo systemctl restart snort` |
| Oprești Snort | `sudo systemctl stop snort` |
| Pornești Snort | `sudo systemctl start snort` |
| Testezi configurație Snort | `sudo -u snort snort -c /etc/snort/snort.lua -T` |

---

## Odoo HR System

| Acțiune | Comandă |
|---------|---------|
| Verifici status Odoo | `sudo systemctl status odoo` |
| Vezi log-uri Odoo | `sudo tail -f /var/log/odoo/odoo.log` |
| Restartezi Odoo | `sudo systemctl restart odoo` |
| Oprești Odoo | `sudo systemctl stop odoo` |
| Pornești Odoo | `sudo systemctl start odoo` |

---

## Firewall (UFW)

| Acțiune | Comandă |
|---------|---------|
| Verifici status UFW | `sudo ufw status` |
| Verifici reguli UFW numerotate | `sudo ufw status numbered` |
| Activezi UFW | `sudo ufw enable` |
| Dezactivezi UFW | `sudo ufw disable` |
| Permite port (ex: SSH) | `sudo ufw allow 22/tcp` |
| Permite de la o rețea specifică | `sudo ufw allow from 192.168.10.0/24 to any port 22` |

---

## OPNsense + Zenarmor (VM)

| Acțiune | Comandă (pe serverul Ubuntu) |
|---------|------------------------------|
| Pornești VM-ul | `VBoxManage startvm OPNsense-Test --type headless` |
| Oprești VM-ul | `VBoxManage controlvm OPNsense-Test poweroff` |
| Verifici status VM | `VBoxManage showvminfo OPNsense-Test \| grep State` |
| Activezi VRDP | `VBoxManage modifyvm OPNsense-Test --vrde on` |
| Conectare RDP | `mstsc` (Windows) → `SERVER_IP:3390` |

### În OPNsense WebGUI (https://192.168.100.1)

| Acțiune | Locație |
|---------|---------|
| Status Zenarmor | Zenarmor → Dashboard |
| Blocare aplicații | Zenarmor → Policies → App Controls |
| Verifică logs | Zenarmor → Reports → Live Sessions |
| Configurare syslog | System → Settings → Logging |
| Firewall rules | Firewall → Rules → WAN / LAN |

---

## VPN WireGuard (MikroTik)

| Acțiune | Comandă (în WinBox Terminal) |
|---------|------------------------------|
| Verifici status WireGuard | `/interface wireguard print` |
| Verifici clienți conectați | `/interface wireguard peers print where interface=wg0` |
| Adaugi client nou | `/interface wireguard peers add interface=wg0 public-key="KEY" allowed-address=10.10.10.X/32` |
| Ștergi client | `/interface wireguard peers remove X` |

---

## Server General

| Acțiune | Comandă |
|---------|---------|
| Vezi cine e conectat | `who` |
| Vezi utilizatori conectați | `w` |
| Vezi procese active | `top` sau `htop` |
| Vezi memorie utilizată | `free -h` |
| Vezi spațiu disc | `df -h` |
| Vezi IP-ul serverului | `ip addr show` |
| Verifici conexiune internet | `ping google.com` |
| Verifici porturi ascultătoare | `sudo netstat -tulpn` |

---

## Backup & Restore

| Acțiune | Comandă |
|---------|---------|
| Backup Odoo database | `sudo /root/backup.sh` |
| Verifici backup-uri | `ls -la /backup/` |
| Verifici log backup | `tail -20 /var/log/backup.log` |

---

## Networking (Testare)

| Acțiune | Comandă |
|---------|---------|
| Port scan (de pe alt PC) | `nmap -p 1-100 IP_TINTEI` |
| Test ping | `ping IP_ADDRESS` |
| Verifici rută | `traceroute IP_ADDRESS` |
| Verifici DNS | `nslookup google.com` |

---

## OPNsense VM Management (pe server)

| Acțiune | Comandă |
|---------|---------|
| Listare VM-uri | `VBoxManage list vms` |
| Modificare RAM | `VBoxManage modifyvm OPNsense-Test --memory 4096` |
| Modificare CPU | `VBoxManage modifyvm OPNsense-Test --cpus 2` |
| Conectare la consolă (RDP) | `mstsc /v:SERVER_IP:3390` |

---

## Quick Troubleshooting

| Problemă | Comenzi de verificat |
|----------|---------------------|
| Wazuh nu primește logs | `sudo tcpdump -i any port 514` (verifică syslog) |
| Snort nu pornește | `sudo journalctl -u snort -n 50` |
| Odoo nu răspunde | `sudo systemctl status odoo` + `sudo tail -f /var/log/odoo/odoo.log` |
| VM OPNsense nu pornește | `VBoxManage showvminfo OPNsense-Test` |
| Zenarmor nu rulează | Verifică în WebGUI: Zenarmor → Dashboard |

---

## Security Checklist (Verificări zilnice)

- [ ] Wazuh activ: `sudo systemctl status wazuh-manager`
- [ ] Snort activ: `sudo systemctl status snort`
- [ ] Odoo activ: `sudo systemctl status odoo`
- [ ] OPNsense VM rulează: `VBoxManage showvminfo OPNsense-Test | grep State`
- [ ] Alerte noi în Wazuh: `sudo tail -10 /var/ossec/logs/alerts/alerts.json`
- [ ] Niciun utilizator suspect: `who`
- [ ] Backup recent verificat: `ls -la /backup/`

---

## Security Checklist (Verificări săptămânale)

- [ ] Update-uri sistem: `sudo apt update && sudo apt upgrade -y`
- [ ] Update-uri Snort reguli: (manual sau script)
- [ ] Verifică logs Zenarmor pentru blocări neașteptate
- [ ] Verifică spațiul pe disc: `df -h`
- [ ] Verifică RAM utilizată: `free -h`

---

## Emergency Recovery

| Problemă | Acțiune |
|----------|---------|
| Server down | Conectare fizică, reboot, verifică `systemctl status` |
| Odoo down | `sudo systemctl restart odoo` |
| Wazuh down | `sudo systemctl restart wazuh-manager` |
| Snort down | `sudo systemctl restart snort` |
| VM OPNsense down | `VBoxManage startvm OPNsense-Test --type headless` |
| VPN down | Verifică router MikroTik, repornește WireGuard |
