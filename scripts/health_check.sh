#!/bin/bash
# ==============================================================================
# System Health & Resource Monitor
# Purpose: Operational check for disk, memory, CPU load, and critical services.
# Supports both native Linux servers and Git Bash on Windows.
# ==============================================================================

echo "=========================================================="
echo "          SYSTEM HEALTH CHECK REPORT ($(date))            "
echo "=========================================================="

# 1. Hostname & Uptime
echo -e "\n[1] SYSTEM UPTIME & LOAD AVERAGE:"
if command -v uptime >/dev/null 2>&1; then
    uptime
else
    # Fallback for Windows / Git Bash environment
    powershell.exe -NoProfile -Command "(Get-CimInstance Win32_OperatingSystem).LastBootUpTime | ForEach-Object { 'Last System Boot: ' + \$_ }"
fi

# 2. Memory Utilization
echo -e "\n[2] MEMORY UTILIZATION (RAM):"
if command -v free >/dev/null 2>&1; then
    free -h
else
    # Fallback for Windows / Git Bash environment
    powershell.exe -NoProfile -Command "\$os = Get-CimInstance Win32_OperatingSystem; [PSCustomObject]@{ Total_GB = [math]::Round(\$os.TotalVisibleMemorySize/1MB, 2); Free_GB = [math]::Round(\$os.FreePhysicalMemory/1MB, 2) } | Format-Table -AutoSize"
fi

# 3. Disk Space Usage
echo -e "\n[3] DISK USAGE SUMMARY:"
df -h --output=source,size,used,avail,pcent,target -x tmpfs -x devtmpfs 2>/dev/null || df -h

# 4. Top Active Processes
echo -e "\n[4] TOP ACTIVE PROCESSES:"
ps aux | head -n 6 | awk '{print $1, $2, $3, $4, $11}'

# 5. Network Connectivity Check
echo -e "\n[5] NETWORK CONNECTIVITY (DNS/Internet):"
if ping -n 1 8.8.8.8 > /dev/null 2>&1 || ping -c 1 8.8.8.8 > /dev/null 2>&1; then
    echo "✅ Internet / Gateway connectivity: OK"
else
    echo "❌ Gateway unreachable. Check network interface / route."
fi

echo -e "\n=========================================================="
echo "                   HEALTH CHECK COMPLETE                  "
echo "=========================================================="