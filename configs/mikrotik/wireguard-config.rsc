# MikroTik WireGuard VPN Configuration
# Purpose: Secure remote access for employees

# ============================================
# CREATE WIREGUARD INTERFACE
# ============================================

/interface wireguard
add name=wg0 listen-port=13231

# ============================================
# ASSIGN IP TO VPN INTERFACE
# ============================================

/ip address
add address=10.10.10.1/24 interface=wg0

# ============================================
# GENERATE KEYS (RUN THIS AND SAVE OUTPUT)
# ============================================
# /interface wireguard print
# 
# Example output:
# Flags: X - disabled, R - running
# 0  R  name="wg0" public-key="SERVER_PUBLIC_KEY_HERE" ...
#
# Save the public key - you'll need it for clients

# ============================================
# ADD VPN CLIENTS (PEERS)
# ============================================
# For each remote user, create a peer entry
# Replace PUBLIC_KEY with client's public key
# Each client gets a unique IP in 10.10.10.0/24

# Example client 1 (Admin)
/interface wireguard peers
add interface=wg0 \
    public-key="CLIENT_PUBLIC_KEY_1" \
    allowed-address=10.10.10.2/32 \
    comment="Admin - Ilie"

# Example client 2 (Support Agent)
/interface wireguard peers
add interface=wg0 \
    public-key="CLIENT_PUBLIC_KEY_2" \
    allowed-address=10.10.10.3/32 \
    comment="Support Agent - Name"

# Example client 3 (Support Agent)
/interface wireguard peers
add interface=wg0 \
    public-key="CLIENT_PUBLIC_KEY_3" \
    allowed-address=10.10.10.4/32 \
    comment="Support Agent - Name"

# ============================================
# ADD DNS FOR VPN CLIENTS (OPTIONAL)
# ============================================
# /ip dns set servers=1.1.1.1,8.8.8.8 allow-remote-requests=yes

# ============================================
# VERIFICATION COMMANDS
# ============================================
# Check WireGuard interface status:
# /interface wireguard print
# 
# Check active peers:
# /interface wireguard peers print
# 
# Check handshake status:
# /interface wireguard peers print where interface=wg0
