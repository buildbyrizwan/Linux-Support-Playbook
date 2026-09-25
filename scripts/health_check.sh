#!/bin/bash
# ==============================================================================
# System Health & Resource Monitor
# Purpose: Quick operational check for disk, memory, CPU load, and critical services.
# ==============================================================================

echo "=========================================================="
echo "          SYSTEM HEALTH CHECK REPORT ($(date))            "
echo "=========================================================="

# 1. Hostname & Uptime
echo -e "\n[1] SYSTEM UPTIME & LOAD AVERAGE:"
uptime

# 2. Memory Utilization
echo -e "\n[2] MEMORY UTILIZATION (RAM):"
free -h

# 3. Disk Space Usage (Root filesystem threshold alert at 85%)
echo -e "\n[3] DISK USAGE SUMMARY:"
df -h --output=source,size,used,avail,pcent,target -x tmpfs -x devtmpfs

DISK_USAGE=$(df / | grep / | awk '{ print $5 }' | sed 's/%//g')
if [ "$DISK_USAGE" -gt 85 ]; then
    echo "⚠️ ALERT: Root partition usage is critical: ${DISK_USAGE}%"
else
    echo "✅ Root partition usage normal: ${DISK_USAGE}%"
fi

# 4. Top 5 Memory Consuming Processes
echo -e "\n[4] TOP 5 MEMORY-INTENSIVE PROCESSES:"
ps aux --sort=-%mem | head -n 6 | awk '{print $1, $2, $3, $4, $11}'

# 5. Network Connectivity Check
echo -e "\n[5] NETWORK CONNECTIVITY (DNS/Internet):"
if ping -c 1 8.8.8.8 > /dev/null 2>&1; then
    echo "✅ Internet / Gateway connectivity: OK"
else
    echo "❌ Gateway unreachable. Check network interface / route."
fi

echo -e "\n=========================================================="
echo "                   HEALTH CHECK COMPLETE                  "
echo "=========================================================="