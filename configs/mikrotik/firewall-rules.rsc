# MikroTik Firewall Rules
# Purpose: Inter-VLAN isolation and security policies
# Apply after basic router configuration

# ============================================
# CLEAR EXISTING FILTER RULES (OPTIONAL)
# ============================================
# /ip firewall filter remove [find]

# ============================================
# DEFAULT FORWARD POLICY
# ============================================
/ip firewall filter
add chain=forward action=accept comment="Default accept (specific blocks below)"

# ============================================
# BLOCK RULES (LATERAL MOVEMENT PREVENTION)
# ============================================

# Block Support (VLAN 20) → HR (VLAN 10)
add chain=forward action=drop src-address=192.168.20.0/24 dst-address=192.168.10.0/24 \
    comment="Block Support → HR"

# Block Support (VLAN 20) → Server (VLAN 30)
add chain=forward action=drop src-address=192.168.20.0/24 dst-address=192.168.30.0/24 \
    comment="Block Support → Server"

# Block HR (VLAN 10) → Support (VLAN 20)
add chain=forward action=drop src-address=192.168.10.0/24 dst-address=192.168.20.0/24 \
    comment="Block HR → Support"

# ============================================
# ALLOW RULES (LEGITIMATE TRAFFIC)
# ============================================

# Allow HR → Server
add chain=forward action=accept src-address=192.168.10.0/24 dst-address=192.168.30.0/24 \
    comment="Allow HR → Server"

# Allow all internet traffic
add chain=forward action=accept out-interface=ether1 comment="Allow internet access"

# Allow established/related connections
add chain=forward action=accept connection-state=established,related comment="Allow established"

# ============================================
# INPUT CHAIN (PROTECT ROUTER ITSELF)
# ============================================

# Allow established connections to router
add chain=input action=accept connection-state=established,related

# Allow ICMP (ping) from LAN
add chain=input action=accept protocol=icmp in-interface=bridge1

# Allow Winbox from LAN
add chain=input action=accept protocol=tcp dst-port=8291 in-interface=bridge1

# Allow SSH from LAN
add chain=input action=accept protocol=tcp dst-port=22 in-interface=bridge1

# Allow WireGuard
add chain=input action=accept protocol=udp dst-port=13231

# Drop everything else to router
add chain=input action=drop comment="Drop all other input"

# ============================================
# VERIFICATION
# ============================================
# /ip firewall filter print
# /ip firewall filter print where chain=forward
