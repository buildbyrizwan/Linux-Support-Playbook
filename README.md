# Linux Production Support Playbook & Shell Toolkit

## 🛠 Included Automation Scripts

- **`scripts/health_check.sh`**: One-command diagnostic script that audits CPU load average, RAM consumption, disk threshold capacity (>85%), top memory-consuming processes, and network reachability.
- **`scripts/log_parser.sh`**: High-performance log parsing utility using `grep`, `awk`, and `sort` to aggregate error codes and find recurring production issues.

---

## 📌 Production Incident Triage Cheatsheet

### Step 1: File Inspection & Real-Time Monitoring
```bash
tail -f /var/log/app.log             # Monitor log file in real time
tail -n 100 /var/log/app.log        # View the last 100 entries
grep -i "Exception" app.log         # Case-insensitive pattern search
grep -rn "ERROR" /var/log/apps/     # Recursive search with line numbers
less +F /var/log/syslog             # Interactive paginated viewer
```

### Step 2: Process & Memory Management
```bash
ps aux | grep java                  # Locate specific service PID
top -b -n 1 | head -n 20            # CPU and memory usage snapshot
kill -15 <PID>                      # Graceful shutdown (SIGTERM)
kill -9 <PID>                       # Force terminate unresponsive process (SIGKILL)
lsof -i :8080                       # Identify process listening on port 8080
netstat -tulpn                      # Active listening ports and sockets
```

### Step 3: Service Lifecycle Management (systemd)
```bash
sudo systemctl status nginx         # Check running status of a service
sudo systemctl restart nginx        # Restart service after config changes
sudo systemctl enable nginx         # Enable service on system boot
journalctl -u nginx -n 50 --no-pager# View recent 50 systemd logs for a service
```

### Step 4: Permissions & Ownership
```bash
chmod 755 script.sh                 # Read/Write/Execute for owner, Read/Execute for others
chmod +x script.sh                  # Grant execute permissions
chown appuser:appgroup /opt/app     # Change owner and primary group recursively (-R)
```

---

## 🚀 How to Run the Scripts

### Step 5: Make Scripts Executable
```bash
chmod +x scripts/health_check.sh scripts/log_parser.sh
```

### Step 6: Execute Health Check
```bash
./scripts/health_check.sh
```

### Step 7: Parse Application Logs
```bash
./scripts/log_parser.sh /path/to/logfile.log
```