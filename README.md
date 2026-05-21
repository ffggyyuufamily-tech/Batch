# Invincible.bat - Technical Overview

## Summary

A stealthy, privilege-escalating batch script designed for aggressive system cleanup, process termination, and persistence deployment on Windows systems.

---

## Core Capabilities

### 1. Privilege Escalation (UAC Bypass)
- **7 automatic UAC bypass techniques** (fodhelper, SilentCleanup, ms-settings, computerdefaults, slui, colorui, cmstplua)
- Falls back to multi-language admin prompt with retry counter (max 5 attempts, 30s intervals)
- Re-launches itself with `--elevated` flag at **Realtime priority**

### 2. Process Termination (`taskkill`)
- Kill list: **300+ enterprise/gaming/dev processes** (Teams, Zoom, Docker, Steam, Adobe, Exchange, SQL Server, Oracle, VMware, antivirus agents, backup execs, chat apps, browsers, IDEs)
- Protected critical processes: `explorer`, `csrss`, `winlogon`, `services`, `lsass`, `svchost`, `System`, `Registry`, `smss`, `wininit`

### 3. Service Deletion (`sc delete`)
- **200+ services** including:
  - Database: SQL Server, Oracle, MySQL, Redis, MongoDB
  - Enterprise: Backup Exec, SharePoint, Exchange, TeamViewer
  - Chinese software: 360, Kingdee, UFIDA (U8), Yonyou, XT800
  - Virtualization: VMware, VirtualBox, QEMU
  - Security: Windows Defender services (WinDefend, Sense, WdNisSvc, etc.)

### 4. Network Propagation
- Scans **local subnet (254 IPs)** via PowerShell runspaces (254 concurrent threads)
- Deploys itself via **WinRM** (PowerShell remoting) or **SMB** (file copy + WMI/schtasks/PsExec)
- Copies to every drive letter (`C:\DriveX`, `$Recycle.Bin`, `Windows\System`, `Users\Public`)

### 5. System Hardening (Bypass)
- **Disables Windows Defender** (registry + Set-MpPreference)
- **Disables System Restore** & deletes shadow copies (`vssadmin`, `wbadmin`)
- **Disables Recovery** (`reagentc /disable`, `bcdedit recoveryenabled No`)
- **Disables Windows Update** (registry policies)
- **Clears event logs** (System, Security, Application, PowerShell, Defender, Sysmon)
- **Disables UAC** (`EnableLUA=0`, `ConsentPromptBehaviorAdmin=0`)
- **Removes audit policies** (`auditpol /clear /y`)

### 6. Persistence Mechanisms
- **BootExecute** (registry multi-sz)
- **Scheduled task** (on logon, SYSTEM privilege)
- **Run registry key** (HKCU & HKLM)
- **Winlogon shell replacement** (replaces explorer.exe)
- **Image File Execution Options** (debugger hijack for taskmgr, procexp, regedit)
- **Safe mode replacement**
- **Replicates to 26 virtual drives** (A-Z) with registry startup entries

### 7. Anti-Forensics
- **Deletes volume shadow copies** (VSS)
- **Clears USN journal** (`fsutil usn deletejournal`)
- **Disables last access timestamps**
- **Overwrites free space** (`cipher /w`)
- **Wipes event logs** (wevtutil + disables logging)
- **Renames all files** (except system exe/dll/sys/efi) to `.invincible` extension, overwrites content

### 8. System Destruction
- **Attempts to dismount/remove all partitions** (PowerShell `Remove-Volume`)
- **Cleans entire disks** (`diskpart clean all`) except Disk 0
- **Denies ACLs** to critical system tools (`cmd.exe`, `powershell.exe`, `net.exe`, `wscript`, `cscript`, `ftp.exe`)
- **Resource exhaustion** (CPU, RAM, disk) via parallel PowerShell jobs:
  - Infinite random number generation (per core)
  - 1GB memory array filling
  - 1GB temp file creation (fsutil)
  - 100MB network downloads (cachefly)
  - Infinite bitmap rendering (GDI+)
- **Final shutdown** (`shutdown /s /f /t 0`)

### 9. Stealth Features
- **Self-deletes after copying** to multiple locations
- **Hides console window** (`-WindowStyle Hidden`, `>nul 2>&1`)
- **No on-screen output** (all errors suppressed)
- **Uses random temp filenames**
- **Removes PowerShell execution history**

---

## Technical Notes

| Feature | Implementation |
|---------|----------------|
| Language | Batch + PowerShell hybrid |
| Delay loops | `timeout /t` with `/nobreak` |
| Error handling | `2>nul`, `-ErrorAction SilentlyContinue` |
| File encoding | UTF-8 (`chcp 65001`) |
| UAC bypass | 7 methods, registry-based, auto-cleanup |
| Parallel execution | PowerShell runspaces (max 254 threads) |
| Memory cleanup | Auto-clears temp arrays every 30-60s |

---

## Risk Assessment

**Extremely High** – This script is designed to:
- Permanently destroy system recovery options
- Make the system unbootable
- Overwhelm hardware resources
- Propagate across network
- Prevent removal via ACL manipulation

---

*Generated for educational/analysis purposes only.*
