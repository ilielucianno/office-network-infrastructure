# Migration Notes: From Intel N100 to Geekom A9 Max

This document describes the step-by-step process of migrating all virtual machines and services from the old server (Intel N100, 16GB RAM) to the new server (Geekom A9 Max, 32GB RAM, AMD Ryzen AI 9 HX 370).

## Why Migration Was Needed

The old server (Intel N100, 16GB RAM) could not run all services simultaneously: Wazuh SIEM, DarkGhost NDR, SQL Injection Detector, OPNsense VM, Snort IDS, Odoo HR System. The new server has more resources (12 cores, 32GB RAM) and can handle all services without performance issues.

## What is OVA Export/Import?

OVA (Open Virtual Appliance) is a single file archive that contains a complete virtual machine: virtual hard disk(s), VM configuration (CPU, RAM, network, etc.), and everything needed to recreate the VM on another computer. Exporting a VM as .OVA creates a full backup of that VM. Importing the .OVA on another computer recreates the exact same VM.

## Step-by-Step Migration Process

### Phase 1: On the Old Server (Intel N100)

Step 1 - Stop all running VMs: In VirtualBox, for each VM, select the VM, click Machine -> Close -> Power off (or ACPI Shutdown). You cannot export a VM while it is running.

Step 2 - Export each VM as .OVA: For each VM (OPNsense, test VMs, etc.): VirtualBox -> File -> Export Appliance. Select the VM (e.g., OPNsense-Test). Format: Open Virtualization Format (OVF) 2.0. Choose a location (e.g., Desktop/export-OPNsense.ova). Click Next -> Export. VirtualBox reads the .vdi files (virtual hard disks), compresses them into a single .OVA file, and saves the VM configuration (CPU, RAM, network settings, etc.).

Step 3 - Copy the .OVA files to external storage: Copy all .OVA files to a USB drive, external SSD, or upload to cloud storage (Google Drive, etc.).

### Phase 2: On the New Server (Geekom A9 Max)

Step 4 - Install Ubuntu Server: Install Ubuntu 22.04 LTS on the new Geekom (same version as old server).

Step 5 - Enable SVM Mode in BIOS: SVM (Secure Virtual Machine) is AMD's hardware virtualization technology (equivalent to Intel VT-x). To enable it: Reboot the server and enter BIOS (usually F2, DEL, or F10 at boot). Find the virtualization setting (often under Advanced -> CPU Configuration). Set SVM Mode to Enabled. Save and exit (usually F10). Without SVM enabled, VirtualBox runs very slowly and cannot run 64-bit VMs.

Step 6 - Install VirtualBox: Run the commands:
sudo apt update
sudo apt install virtualbox -y

Step 7 - Copy .OVA files to the new server: Copy the .OVA files from the USB drive or cloud storage to a folder on the new server (e.g., ~/migration/).

Step 8 - Import each .OVA file into VirtualBox: For each .OVA file: VirtualBox -> File -> Import Appliance. Select the .OVA file (e.g., export-OPNsense.ova). Review the settings (CPU, RAM, network). Click Import. VirtualBox unpacks the .OVA archive, recreates the virtual hard disks in ~/VirtualBox VMs/, and recreates the VM with the same settings as on the old server.

Step 9 - Reconfigure network interfaces (this was the hardest part): On the old server, the network interface was named enp0s3 (Intel driver). On the new Geekom, the network interface name changed because of different hardware (Realtek driver). Ubuntu assigned a new name like enp1s0 or enp2s0. The netplan configuration file on the old server referenced enp0s3. On the new server, the interface had a different name, so the network configuration did not apply.

What was done to fix it:
ip a (to find the new network interface name, output showed: 2: enp1s0: ...)
sudo nano /etc/netplan/00-installer-config.yaml

Changed the file from:
network:
  ethernets:
    enp0s3:
      dhcp4: false
      addresses: [192.168.30.10/24]
      gateway4: 192.168.30.1

To:
network:
  ethernets:
    enp1s0:
      dhcp4: false
      addresses: [192.168.30.10/24]
      gateway4: 192.168.30.1

Then apply the changes: sudo netplan apply

This took extra time because the driver differences caused network instability before the correct configuration was found.

Step 10 - Reinstall Python packages in virtual environments: The Python virtual environments (venv) for DarkGhost and SQL Detector were copied but some packages failed due to architecture differences (even though both are x86_64). Solution: Reinstall the required packages.

For DarkGhost:
cd ~/darkghost
source venv/bin/activate
pip install scapy flask requests tensorflow numpy

For SQL Detector:
cd ~/sql-injection-detector
source venv/bin/activate
pip install flask tensorflow numpy

Step 11 - Start all services and test:
- Start the Ubuntu host services (Wazuh, Snort, Odoo)
- Start the VirtualBox VMs (OPNsense)
- Start DarkGhost and SQL Detector in their terminal windows
- Verify all dashboards are accessible:
  - Wazuh: https://192.168.30.10
  - DarkGhost: http://192.168.30.10:8081
  - SQL Detector: http://192.168.30.10:8082
  - OPNsense: https://192.168.100.1

## Why It Took 2-3 Days (Not 1 Hour)

Export .OVA: estimated 10 min per VM, actual less than 1 hour, reason smooth.
Copy files: estimated 15 min, actual less than 1 hour, reason smooth.
Install Ubuntu: estimated 20 min, actual less than 1 hour, reason smooth.
Enable SVM: estimated 2 min, actual less than 1 hour, reason smooth.
Import .OVA: estimated 10 min per VM, actual less than 1 hour, reason smooth.
Reconfigure static IPs: estimated 10 min, actual several hours or days, reason network interface names changed between servers; Realtek drivers caused instability.
Reinstall Python packages: estimated 10 min, actual several hours, reason TensorFlow required recompilation; dependency issues.
Testing and verification: estimated 30 min, actual days, reason all services needed to be tested individually and together.

The main problems were: network interface names changed (enp0s3 to enp1s0), Realtek network drivers on the Geekom required different settings, and Python virtual environments needed to be rebuilt.

## Lessons Learned for Future Migrations

1. Always note network interface names before migration (ip a on old server)
2. Take screenshots of netplan config before shutting down the old server
3. Plan for 2-3 days even for a simple migration
4. Test each service individually after migration, not all at once
5. Keep the old server running until the new one is fully verified
6. Document all static IPs in a spreadsheet before migration

## Services Running After Migration

Wazuh SIEM: https://192.168.30.10 - Working
DarkGhost NDR: http://192.168.30.10:8081 - Working
SQL Detector: http://192.168.30.10:8082 - Working
OPNsense VM: https://192.168.100.1 - Working
Odoo HR: https://odoo.office.local:8069 - Working
Snort IDS: logs to /var/log/snort/alert.txt - Working

## Conclusion

The migration was successful. The new server (Geekom A9 Max) now runs all security services simultaneously without performance issues. The old Intel N100 server is kept as a backup.

Total migration time was 2-3 days (actual work time: approximately 4-6 hours, plus troubleshooting and waiting).

Key takeaway: Server migration always takes longer than expected. Network driver differences and static IP reconfiguration are the most common sources of delay.
