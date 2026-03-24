This guide covers configuring WireGuard VPN clients for remote employees.

---

## Prerequisites

- Router configured with WireGuard server ([02 - Router Config](02-router-config.md))
- Server IP: 192.168.30.10 (accessible via VPN)
- Router public IP (static or DDNS)

---

## Step 1: Prepare Router Information

Before configuring clients, gather:

| Information | Value | Where to Find |
|-------------|-------|---------------|
| Server Public IP | Your ISP-assigned IP | `curl ifconfig.me` on router terminal |
| WireGuard Port | 13231 | From router config |
| Server Public Key | `SERVER_PUBLIC_KEY` | `/interface wireguard print` in WinBox |
| VPN Subnet | 10.10.10.0/24 | Router config |
| Internal Network | 192.168.10.0/24, 192.168.30.0/24 | Router config |

---

## Step 2: Create Client Configuration

For each remote user, generate a unique key pair and assign a unique IP.

### 2.1 Generate Client Keys

**On the client device (or using a tool):**

#### Option A: On Linux/Mac
```bash
wg genkey | tee client_private.key | wg pubkey > client_public.key
Option B: On Windows
Download WireGuard, click "Add Tunnel" → "Add Empty Tunnel", keys auto-generate.

2.2 Create Client Config File
Save as username.conf:

ini
[Interface]
PrivateKey = CLIENT_PRIVATE_KEY
Address = 10.10.10.X/24
DNS = 1.1.1.1, 8.8.8.8

[Peer]
PublicKey = SERVER_PUBLIC_KEY
Endpoint = YOUR_SERVER_IP:13231
AllowedIPs = 192.168.10.0/24, 192.168.30.0/24, 10.10.10.0/24
PersistentKeepalive = 25
Replace:

CLIENT_PRIVATE_KEY – generated private key

10.10.10.X – unique IP for this user (e.g., 10.10.10.2, 10.10.10.3, etc.)

SERVER_PUBLIC_KEY – from router

YOUR_SERVER_IP – router's public IP

Step 3: Add Client to Router
For each client, add a peer on the MikroTik router.

In WinBox Terminal:
text
/interface wireguard peers
add interface=wg0 \
    public-key="CLIENT_PUBLIC_KEY" \
    allowed-address=10.10.10.X/32 \
    comment="User Name"
Replace:

CLIENT_PUBLIC_KEY – client's public key

10.10.10.X – same IP assigned in client config

User Name – employee name for reference

Step 4: Client Installation by OS
Windows
Download from wireguard.com/install

Run installer

Open WireGuard

Click Add Tunnel → Import Tunnel from File

Select username.conf

Click Activate

macOS
Download from App Store: WireGuard

Open app

Click Import Tunnel from File

Select username.conf

Click Activate

Linux
bash
# Install
sudo apt install wireguard -y  # Debian/Ubuntu

# Copy config
sudo cp username.conf /etc/wireguard/wg0.conf

# Start
sudo systemctl start wg-quick@wg0
sudo systemctl enable wg-quick@wg0
Android
Install WireGuard from Play Store

Open app

Click + → Import from file

Select username.conf

Toggle ON

iOS
Install WireGuard from App Store

Open app

Click + → Import from file

Select username.conf

Toggle ON

Step 5: Test VPN Connection
From Client Device:
Connect to VPN

Open terminal/command prompt

Test connectivity:

bash
# Ping VPN gateway
ping 10.10.10.1

# Ping server (internal)
ping 192.168.30.10

# Ping HR VLAN gateway
ping 192.168.10.1
In Browser:
Open: http://192.168.30.10:8069 (Odoo)

If page loads, VPN is working correctly.

Step 6: Verify Connected Clients on Router
In WinBox Terminal:

bash
# Show active WireGuard peers
/interface wireguard peers print

# Show handshake status
/interface wireguard peers print where interface=wg0
Look for handshake timestamp – if recent (seconds), connection is active.

Step 7: Client Management
Remove a Client (Employee Leaves)
bash
# Find peer ID
/interface wireguard peers print where interface=wg0

# Remove by ID (e.g., 0)
/interface wireguard peers remove 0
Check Client IP Assignments
Keep a spreadsheet with:

Username	IP	Public Key	Status
John Doe	10.10.10.2	...	Active
Jane Smith	10.10.10.3	...	Active
Step 8: Troubleshooting
Problem	Solution
VPN connects but no internal access	Check AllowedIPs includes 192.168.x.x networks
Handshake fails	Verify server endpoint IP and port are correct
Slow connection	Try different WireGuard port (1337) if ISP throttles
Cannot reach server	Check router firewall allows VPN → Server traffic
Multiple clients same IP	Ensure each client has unique 10.10.10.X address
Diagnostic Commands
On Router:

bash
# Check WireGuard interface
/interface wireguard print

# Check active connections
/ip firewall connection print where protocol=udp dst-port=13231
On Client:

bash
# Linux/Mac
sudo wg show

# Windows (PowerShell as admin)
wg show
Step 9: Security Best Practices
Practice	Why
Unique keys per user	Easy to revoke access
Unique IP per user	Identify which user is connected
Use DNS 1.1.1.1	Privacy-focused DNS
Keep PersistentKeepalive	Maintains connection through NAT
Document key assignments	Track who has access
Revoke keys immediately	When employee leaves
Step 10: Sample Client Configs
Admin User (Full Access)
ini
[Interface]
PrivateKey = ADMIN_PRIVATE_KEY
Address = 10.10.10.2/24
DNS = 1.1.1.1

[Peer]
PublicKey = SERVER_PUBLIC_KEY
Endpoint = 123.123.123.123:13231
AllowedIPs = 192.168.0.0/16, 10.10.10.0/24
PersistentKeepalive = 25
Support Agent (Odoo Only)
ini
[Interface]
PrivateKey = AGENT_PRIVATE_KEY
Address = 10.10.10.10/24
DNS = 1.1.1.1

[Peer]
PublicKey = SERVER_PUBLIC_KEY
Endpoint = 123.123.123.123:13231
AllowedIPs = 192.168.30.0/24
PersistentKeepalive = 25
Verification Checklist
Each remote user has unique private key and IP

Each peer added to router with correct public key

Client can ping 10.10.10.1

Client can ping 192.168.30.10

Odoo accessible via browser

Handshake shows recent timestamp on router

Spreadsheet maintained with all clients

Next Steps
Proceed to 08 - 2FA & Backup for final security hardening.

Reference Files
WireGuard Router Config

Full Router Config
