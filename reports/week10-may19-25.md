# Week 11 Report: May 19 - May 25, 2026

**Focus: Lenovo BYOVD Vulnerability (CVE-2026-????) & Endpoint Security Audit**

---

## Summary

This week focused on analyzing the recently disclosed Lenovo driver vulnerability (`BootRepair.sys`) that allows low-privileged users to terminate security processes (BYOVD attack). All Lenovo laptops in the office network were audited for the vulnerable driver and antivirus status.

> ✅ **No vulnerable driver found on any device. All endpoints are protected.**

---

## Vulnerability Background

| Attribute | Details |
|-----------|---------|
| **Name** | Lenovo BootRepair.sys BYOVD |
| **Affected driver** | `BootRepair.sys` (SHA-256: `5ab36c116767eaae53a466fbc2dae7cfd608ed77721f65e83312037fbd57c946`) |
| **Attack vector** | Low-privileged user can terminate any process (including EDR/AV) |
| **Affected systems** | Lenovo laptops with Lenovo PC Manager or vulnerable driver installed |

---

## Audit Scope

| Device | Model | OS | Status |
|--------|-------|----|--------|
| Laptop 1 (IT) | Lenovo (Ryzen 7) | Windows 11 | ✅ Verified |
| Laptop 2 (Agent on-site) | Lenovo (Ryzen 7) | Windows 11 | ✅ Verified |
| Laptop 3 (Agent on-site) | Lenovo (Ryzen 7) | Windows 11 | ✅ Verified |

---

## Verification Steps Performed

### 1. Check for Vulnerable Driver

```powershell
Get-WindowsDriver -Online | Where-Object {$_.OriginalFileName -like "*BootRepair*"}
```

**Result:** No driver found – all laptops clean.

---

### 2. Check for Lenovo Drivers (General Inventory)

```powershell
Get-WindowsDriver -Online | Where-Object {$_.ProviderName -like "*Lenovo*"}
```

**Result:** Legitimate drivers present (FN keys, ACPI, etc.) – no vulnerable driver.

---

### 3. Antivirus Status Verification

```powershell
Get-MpComputerStatus | Select-Object AntivirusEnabled, RealTimeProtectionEnabled, AMRunningMode
```

**Result:** `AMRunningMode: Not running` — false negative, API limitation with third-party AV.

---

### 4. Antivirus Real-Time Test (EICAR)

```powershell
Invoke-WebRequest -Uri "https://secure.eicar.org/eicar.com" -OutFile "$env:USERPROFILE\Desktop\eicar.com"
```

**Result:** File deleted immediately – Avira active and protecting.  
Avira notification received: *"Blocked malicious file"*

---

## Security Status Summary

| Endpoint | Vulnerable Driver | Antivirus | EICAR Test | Status |
|----------|-------------------|-----------|------------|--------|
| IT Laptop (Ilie) | ❌ Not present | Avira Active | ✅ Blocked | ✅ Protected |
| Agent Laptop 1 | ❌ Not present | Avira Active | ✅ Blocked | ✅ Protected |
| Agent Laptop 2 | ❌ Not present | Avira Active | ✅ Blocked | ✅ Protected |

---

## Lessons Learned

- `Get-MpComputerStatus` does not reliably reflect third-party antivirus status — Avira was active but API showed `Not running`
- **EICAR test is the most reliable way to verify real-time protection** — always test after checking status
- Lenovo driver vulnerability not present — no action needed for driver blocking, but monitoring should continue

---

## Recommendations

| Action | Responsible | Status |
|--------|-------------|--------|
| Continue monitoring for new BYOVD vulnerabilities | Ilie | Ongoing |
| Ensure Avira updates are automatic | Users | ✅ Already configured |
| Repeat audit quarterly or after new disclosures | Ilie | Planned |

---

## Commands Used This Week

```powershell
# Check for vulnerable driver
Get-WindowsDriver -Online | Where-Object {$_.OriginalFileName -like "*BootRepair*"}

# Check all Lenovo drivers
Get-WindowsDriver -Online | Where-Object {$_.ProviderName -like "*Lenovo*"}

# Check antivirus status (unreliable for third-party AV)
Get-MpComputerStatus | Select-Object AntivirusEnabled, RealTimeProtectionEnabled, AMRunningMode

# EICAR test (safe malware simulation)
Invoke-WebRequest -Uri "https://secure.eicar.org/eicar.com" -OutFile "$env:USERPROFILE\Desktop\eicar.com"
```

---

## Next Week Focus

- Disaster recovery test (restore from backup) – pending from Week 10
- Disk encryption (LUKS) planning – pending from Week 10
- Wazuh restart (if needed after demo)

---

> ✅ **Status: All Lenovo laptops verified, protected, and no vulnerable driver present. No security gaps identified.**

**Author:** Ilie Lucian – Technical Department Manager
