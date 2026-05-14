# ============================================
# MikroTik RouterOS Configuration - COMPLETE
# Device: hAP ac²
# Purpose: VLAN segmentation, DHCP for all VLANs, WireGuard VPN
# Updated: May 2026
# 
# ⚠️ REPLACE placeholders before using:
#    <WAN_INTERFACE> - your WAN port (usually ether1)
#    <VPN_PORT> - your WireGuard port
#    <VPN_SUBNET> - VPN subnet (e.g., 10.10.10.0)
# ============================================

# ============================================
# BRIDGE WITH VLAN FILTERING
# ============================================

/interface bridge
add name=bridge1 vlan-filtering=yes

/interface bridge port
add bridge=bridge1 interface=ether2 pvid=10
add bridge=bridge1 interface=ether3 pvid=20
add bridge=bridge1 interface=ether4 pvid=30
add bridge=bridge1 interface=ether5 pvid=10

# Port trunk to main switch
/interface bridge port
set [find interface=ether2] frame-types=admit-only-vlan-tagged

# ============================================
# VLAN DEFINITIONS
# ============================================

/interface bridge vlan
add bridge=bridge1 vlan-id=10 tagged=bridge1,ether2 untagged=ether3,ether5
add bridge=bridge1 vlan-id=20 tagged=bridge1,ether2 untagged=ether4
add bridge=bridge1 vlan-id=30 tagged=bridge1,ether2

# ============================================
# VLAN INTERFACES
# ============================================

/interface vlan
add name=vlan10-hr vlan-id=10 interface=bridge1
add name=vlan20-support vlan-id=20 interface=bridge1
add name=vlan30-server vlan-id=30 interface=bridge1

# ============================================
# IP ADDRESSES (GATEWAYS)
# ============================================

/ip address
add address=192.168.10.1/24 interface=vlan10-hr
add address=192.168.20.1/24 interface=vlan20-support
add address=192.168.30.1/24 interface=vlan30-server

# ============================================
# DHCP POOLS (ALL 3 VLANS)
# ============================================

/ip pool
add name=pool-hr ranges=192.168.10.100-192.168.10.200
add name=pool-support ranges=192.168.20.100-192.168.20.200
add name=pool-server ranges=192.168.30.100-192.168.30.200

# ============================================
# DHCP SERVERS (ALL 3 VLANS)
# ============================================

/ip dhcp-server
add name=dhcp-hr interface=vlan10-hr address-pool=pool-hr disabled=no
add name=dhcp-support interface=vlan20-support address-pool=pool-support disabled=no
add name=dhcp-server interface=vlan30-server address-pool=pool-server disabled=no

/ip dhcp-server network
add address=192.168.10.0/24 gateway=192.168.10.1 dns-server=1.1.1.1,8.8.8.8
add address=192.168.20.0/24 gateway=192.168.20.1 dns-server=1.1.1.1,8.8.8.8
add address=192.168.30.0/24 gateway=192.168.30.1 dns-server=1.1.1.1,8.8.8.8

# ============================================
# WAN (DHCP CLIENT)
# ============================================

/ip dhcp-client
add interface=<WAN_INTERFACE> disabled=no

# ============================================
# NAT MASQUERADE
# ============================================

/ip firewall nat
add chain=srcnat out-interface=<WAN_INTERFACE> action=masquerade

# ============================================
# FIREWALL FILTER RULES
# ============================================

/ip firewall filter
set [find default-action=accept] action=drop

add chain=forward connection-state=established,related action=accept

# Inter-VLAN blocking
add chain=forward src-address=192.168.20.0/24 dst-address=192.168.10.0/24 action=drop
add chain=forward src-address=192.168.20.0/24 dst-address=192.168.30.0/24 action=drop
add chain=forward src-address=192.168.10.0/24 dst-address=192.168.20.0/24 action=drop

# Allowed rules
add chain=forward src-address=192.168.10.0/24 dst-address=192.168.30.0/24 action=accept
add chain=forward out-interface=<WAN_INTERFACE> action=accept
add chain=forward in-interface=bridge1 out-interface=bridge1 action=accept

# ============================================
# WIREGUARD VPN (KEYS REMOVED FOR PUBLIC REPO)
# ============================================

/interface wireguard
add name=wg0 listen-port=<VPN_PORT>

/ip address
add address=<VPN_SUBNET>.1/24 interface=wg0

/ip firewall filter
add chain=input protocol=udp dst-port=<VPN_PORT> action=accept
add chain=forward src-address=<VPN_SUBNET>/24 action=accept
add chain=forward src-address=<VPN_SUBNET>/24 dst-address=192.168.30.0/24 action=accept
add chain=forward src-address=<VPN_SUBNET>/24 dst-address=192.168.10.0/24 action=accept

# ============================================
# EXAMPLE PEER (CLIENT) - REPLACE WITH ACTUAL KEYS
# ============================================
# /interface wireguard peers
# add interface=wg0 public-key="<CLIENT_PUBLIC_KEY>" allowed-address=<VPN_SUBNET>.2/32
