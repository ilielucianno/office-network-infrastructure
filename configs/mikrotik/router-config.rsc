# MikroTik RouterOS Configuration
# Device: hAP ac²
# Purpose: Office network with VLAN segmentation, firewall rules, and WireGuard VPN
# Date: March 2026

# ============================================
# STEP 1: RESET TO FACTORY DEFAULTS (CLEAN START)
# ============================================
# Run this first to start fresh:
# /system reset-configuration no-defaults=yes skip-backup=yes

# ============================================
# STEP 2: BRIDGE CONFIGURATION (VLAN-AWARE)
# ============================================

/interface bridge
add name=bridge1 vlan-filtering=yes

/interface bridge port
add bridge=bridge1 interface=ether2
add bridge=bridge1 interface=ether3
add bridge=bridge1 interface=ether4
add bridge=bridge1 interface=ether5

# ============================================
# STEP 3: VLAN INTERFACES
# ============================================

/interface vlan
add name=vlan10-hr vlan-id=10 interface=bridge1
add name=vlan20-support vlan-id=20 interface=bridge1
add name=vlan30-server vlan-id=30 interface=bridge1

# ============================================
# STEP 4: IP ADDRESSES (GATEWAYS PER VLAN)
# ============================================

/ip address
add address=192.168.10.1/24 interface=vlan10-hr
add address=192.168.20.1/24 interface=vlan20-support
add address=192.168.30.1/24 interface=vlan30-server

# ============================================
# STEP 5: DHCP POOLS
# ============================================

/ip pool
add name=pool-hr ranges=192.168.10.100-192.168.10.200
add name=pool-support ranges=192.168.20.100-192.168.20.200

# ============================================
# STEP 6: DHCP SERVERS
# ============================================

/ip dhcp-server
add name=dhcp-hr interface=vlan10-hr address-pool=pool-hr
add name=dhcp-support interface=vlan20-support address-pool=pool-support

/ip dhcp-server network
add address=192.168.10.0/24 gateway=192.168.10.1 dns-server=1.1.1.1,8.8.8.8
add address=192.168.20.0/24 gateway=192.168.20.1 dns-server=1.1.1.1,8.8.8.8

# ============================================
# STEP 7: INTERNET CONFIGURATION (WAN)
# ============================================

/ip dhcp-client
add interface=ether1 disabled=no

# ============================================
# STEP 8: NAT (MASQUERADE)
# ============================================

/ip firewall nat
add chain=srcnat out-interface=ether1 action=masquerade

# ============================================
# STEP 9: FIREWALL RULES (INTER-VLAN BLOCKING)
# ============================================

# Default forward policy: accept (we'll block specific)
/ip firewall filter
add chain=forward action=accept

# Block Support → HR
add chain=forward action=drop src-address=192.168.20.0/24 dst-address=192.168.10.0/24

# Block Support → Server
add chain=forward action=drop src-address=192.168.20.0/24 dst-address=192.168.30.0/24

# Block HR → Support
add chain=forward action=drop src-address=192.168.10.0/24 dst-address=192.168.20.0/24

# Allow HR → Server
add chain=forward action=accept src-address=192.168.10.0/24 dst-address=192.168.30.0/24

# Allow internet access for all
add chain=forward action=accept out-interface=ether1

# ============================================
# STEP 10: WIREGUARD VPN CONFIGURATION
# ============================================

# Create WireGuard interface
/interface wireguard
add name=wg0 listen-port=13231

# Assign IP for VPN server
/ip address
add address=10.10.10.1/24 interface=wg0

# Generate keys (run this command and copy the output)
# /interface wireguard print
# Save the public key for clients

# Allow VPN traffic in firewall
/ip firewall filter
add chain=input action=accept protocol=udp dst-port=13231
add chain=forward action=accept src-address=10.10.10.0/24

# Allow VPN → Server
add chain=forward action=accept src-address=10.10.10.0/24 dst-address=192.168.30.0/24

# Allow VPN → HR (for admin access)
add chain=forward action=accept src-address=10.10.10.0/24 dst-address=192.168.10.0/24

# ============================================
# STEP 11: ADD VPN CLIENT (EXAMPLE)
# ============================================
# For each remote user, add a peer with their public key
# Replace "PUBLIC_KEY_HERE" with the client's public key
# Replace "10.10.10.X" with a unique IP per client

# /interface wireguard peers
# add interface=wg0 public-key="PUBLIC_KEY_HERE" allowed-address=10.10.10.2/32

# ============================================
# STEP 12: VERIFICATION COMMANDS
# ============================================
# Check interfaces: /interface print
# Check IP addresses: /ip address print
# Check firewall rules: /ip firewall filter print
# Check WireGuard status: /interface wireguard print
# Check DHCP leases: /ip dhcp-server lease print
