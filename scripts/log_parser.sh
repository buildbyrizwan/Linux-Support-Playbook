#!/bin/bash
# ==============================================================================
# Production Log Analyzer & Error Aggregator
# Purpose: Parse application/server log files for ERROR and WARN levels.
# ==============================================================================

LOG_FILE=$1

if [ -z "$LOG_FILE" ]; then
    echo "Usage: ./log_parser.sh <path_to_logfile>"
    echo "Example: ./log_parser.sh /var/log/syslog"
    exit 1
fi

if [ ! -f "$LOG_FILE" ]; then
    echo "Error: File '$LOG_FILE' does not exist."
    exit 1
fi

echo "=========================================================="
echo " Analyzing Log: $LOG_FILE"
echo "=========================================================="

TOTAL_LINES=$(wc -l < "$LOG_FILE")
ERROR_COUNT=$(grep -ci "ERROR" "$LOG_FILE")
WARN_COUNT=$(grep -ci "WARN" "$LOG_FILE")
FATAL_COUNT=$(grep -ci "FATAL" "$LOG_FILE")

echo "Total Log Entries Scanned : $TOTAL_LINES"
echo "Fatal Exceptions          : $FATAL_COUNT"
echo "Errors Found              : $ERROR_COUNT"
echo "Warnings Logged           : $WARN_COUNT"

echo -e "\n--- Top 5 Most Frequent Error Messages ---"
grep -i "ERROR" "$LOG_FILE" | awk -F "ERROR" '{print $2}' | sort | uniq -c | sort -nr | head -n 5

echo "=========================================================="

