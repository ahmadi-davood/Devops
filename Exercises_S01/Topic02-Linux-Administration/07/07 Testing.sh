#!/bin/bash
# Quick ping test
IP_FILE="ip_list.txt"
LOG_FILE="ping_results_$(hostname -s)_$(date +%Y%m%d).log"

echo "Ping results - $(date)" > "$LOG_FILE"
echo "Hostname: $(hostname)" >> "$LOG_FILE"
echo "==================================" >> "$LOG_FILE"

grep -v '^#' "$IP_FILE" | grep -v '^$' | while read ip; do
    if ping -c 2 -W 1 "$ip" >/dev/null 2>&1; then
        echo "$(date '+%H:%M:%S') - ✓ $ip" | tee -a "$LOG_FILE"
    else
        echo "$(date '+%H:%M:%S') - ✗ $ip" | tee -a "$LOG_FILE"
    fi
done