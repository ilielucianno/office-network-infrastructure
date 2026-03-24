# 02 - Router Configuration (MikroTik)

This guide covers the configuration of the MikroTik hAP ac² router.

---

## Prerequisites

- Router powered on and connected to ISP modem
- Computer connected to router via Ethernet (ether2-5)
- WinBox or web browser access to router
- [Full configuration file](../configs/mikrotik/router-config.rsc) ready

---

## Step 1: Connect to the Router

### Option A: WinBox (Recommended)

1. Download WinBox from [mikrotik.com](https://mikrotik.com/download)
2. Open WinBox
3. In **Neighbors** tab, find your router (usually shows MAC address)
4. Click to connect
5. Login: `admin` (no password by default)

### Option B: Web Interface

1. Open browser to `192.168.88.1` (default MikroTik IP)
2. Login: `admin` (no password)

---

## Step 2: Reset to Factory Defaults (Clean Start)

In WinBox Terminal:
/system reset-configuration no-defaults=yes skip-backup=yes

text

**Wait for router to reboot (about 2 minutes).**

After reboot, reconnect via WinBox (MAC address again, as IP is not yet assigned).

---

## Step 3: Apply Full Configuration

### Method A: Copy-Paste (Recommended)

1. Open **Terminal** in WinBox
2. Copy the entire content of [`router-config.rsc`](../configs/mikrotik/router-config.rsc)
3. Paste into Terminal
4. Press Enter

### Method B: Import File

1. Upload the `.rsc` file to router via **Files**
2. In Terminal: `/import router-config.rsc`

---

## Step 4: Verify Configuration

Run these commands and check the output:

### Check Interfaces
/interface print

text
Expected: `ether1` (WAN), `bridge1`, `vlan10-hr`, `vlan20-support`, `vlan30-server`, `wg0`

### Check IP Addresses
/ip address print

text
Expected:
- `192.168.10.1/24` (vlan10-hr)
- `192.168.20.1/24` (vlan20-support)
- `192.168.30.1/24` (vlan30-server)
- `10.10.10.1/24` (wg0)
- DHCP client on ether1

### Check DHCP Servers
/ip dhcp-server print

text
Expected: `dhcp-hr` and `dhcp-support` both running

### Check Firewall Rules
/ip firewall filter print

text
Expected: Block rules, allow rules (see [firewall-rules.rsc](../configs/mikrotik/firewall-rules.rsc))

---

## Step 5: Configure Internet (WAN)

If your ISP uses DHCP (most common), no additional steps are needed.

**Check internet connectivity:**
/ping 8.8.8.8

text

If ping fails:
1. Check cable from ether1 to ISP modem
2. Reboot ISP modem
3. Run `/ip dhcp-client print` to see if IP was assigned

---

## Step 6: Set Admin Password

**Important!** Change the default password:
/user set admin password="your_strong_password_here"

text

---

## Step 7: Backup Configuration

Save your working configuration:
/export file=router-config-working

text

The file will appear in **Files** – download it for safekeeping.

---

## Step 8: Test VLAN Connectivity

### From a computer connected to switch:

1. Set static IP temporarily to test each VLAN:

| VLAN | IP | Gateway |
|------|-----|---------|
| HR | 192.168.10.50 | 192.168.10.1 |
| Support | 192.168.20.50 | 192.168.20.1 |

2. Ping the gateway:
ping 192.168.10.1 # on HR VLAN
ping 192.168.20.1 # on Support VLAN

text

If pings fail, check:
- VLAN assignments on switch
- Bridge VLAN filtering status

---

## Step 9: Configure WireGuard VPN (Detailed)

### Generate Server Keys

In Terminal:
/interface wireguard print

text
Copy the **public-key** – you'll need this for clients.

### Add Client Peers

For each remote user, generate a key pair on their device first, then add:
/interface wireguard peers
add interface=wg0 public-key="CLIENT_PUBLIC_KEY" allowed-address=10.10.10.2/32

text

**Repeat for each user**, incrementing IP: 10.10.10.2, 10.10.10.3, etc.

### Verify Peers
/interface wireguard peers print where interface=wg0

text

---

## Step 10: Test VPN

1. Configure a client (laptop or phone) with WireGuard
2. Connect to VPN
3. Ping the server:
ping 192.168.30.10

text

If ping works, VPN is functional.

---

## Verification Checklist

- [ ] Router has internet access (ping 8.8.8.8)
- [ ] VLAN 10 gateway responds (192.168.10.1)
- [ ] VLAN 20 gateway responds (192.168.20.1)
- [ ] VLAN 30 gateway responds (192.168.30.1)
- [ ] DHCP assigns IPs on VLAN 10 and 20
- [ ] Firewall blocks Support → HR (test with ping)
- [ ] Firewall blocks Support → Server (test with ping)
- [ ] Firewall allows HR → Server (test with ping)
- [ ] WireGuard interface is running
- [ ] Admin password changed

---

## Common Issues & Solutions

| Issue | Solution |
|-------|----------|
| No internet | Check ether1 cable, reboot ISP modem, verify DHCP client |
| VLAN gateways not pinging | Bridge VLAN filtering may be off: `/interface bridge set bridge1 vlan-filtering=yes` |
| DHCP not assigning IPs | Check DHCP server is running: `/ip dhcp-server print` |
| WireGuard not connecting | Verify port 13231 is open in firewall, check client config |
| Can't reach server from HR | Check HR → Server firewall rule is present |

---

## Next Steps

Proceed to [03 - Switch & VLAN Configuration](03-switch-vlan.md) to configure the MikroTik switch.

---

## Reference Files

- [Full Router Config](../configs/mikrotik/router-config.rsc)
- [Firewall Rules Only](../configs/mikrotik/firewall-rules.rsc)
- [WireGuard Config Only](../configs/mikrotik/wireguard-config.rsc)
