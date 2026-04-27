# Week 3 Report: March 16 - March 21, 2026

## Focus: VPN Security & Remote Access

### Tests Performed
- WireGuard VPN key brute-force attempts
- VPN tunnel sniffing to test encryption
- Client authentication bypass attempts

### Issues Encountered
- No central key management system (used spreadsheet)
- WireGuard keys were not rotated regularly

### Solutions Implemented
- Created spreadsheet for WireGuard key tracking (user, IP, key, date issued, revocation date)
- Implemented key rotation policy (every 90 days)
- Enabled IP tracking per VPN user

### Status
✅ VPN access secure. Key management documented.

### Configuration Snippet

/interface wireguard peers add interface=wg0 public-key="KEY" allowed-address=10.10.10.X/32
