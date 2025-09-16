#!/bin/bash

# Script: ping_monitor.sh
# Usage: ./ping_monitor.sh [ip_list_file]

# Configuration
IP_LIST_FILE="${1:-ip_list.txt}"  # Default file: ip_list.txt
LOG_DIR="/var/log/ping_monitor"
PING_COUNT=3
PING_TIMEOUT=2

# Create log directory if it doesn't exist
sudo mkdir -p "$LOG_DIR"
sudo chmod 755 "$LOG_DIR"

# Get current date and hostname
CURRENT_DATE=$(date +%Y-%m-%d)
HOSTNAME=$(hostname)
LOG_FILE="$LOG_DIR/ping_results_${HOSTNAME}_${CURRENT_DATE}.log"

# Function to log messages
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# Function to ping a host and return result
ping_host() {
    local ip=$1
    if ping -c $PING_COUNT -W $PING_TIMEOUT "$ip" > /dev/null 2>&1; then
        echo "SUCCESS"
    else
        echo "FAILED"
    fi
}

# Check if IP list file exists
if [ ! -f "$IP_LIST_FILE" ]; then
    echo "Error: IP list file '$IP_LIST_FILE' not found!"
    echo "Create a file with one IP per line, e.g.:"
    echo "8.8.8.8"
    echo "1.1.1.1"
    echo "192.168.1.1"
    exit 1
fi

# Read IP list, remove comments and empty lines
IP_LIST=$(grep -v '^#' "$IP_LIST_FILE" | grep -v '^$' | tr -d '\r')

# Check if we have any IPs to ping
if [ -z "$IP_LIST" ]; then
    log "ERROR: No valid IP addresses found in $IP_LIST_FILE"
    exit 1
fi

# Start monitoring
log "=== PING MONITOR STARTED ==="
log "Hostname: $HOSTNAME"
log "IP list file: $IP_LIST_FILE"
log "Total IPs to check: $(echo "$IP_LIST" | wc -l)"
log ""

# Ping each IP sequentially
SUCCESS_COUNT=0
FAILED_COUNT=0

while IFS= read -r ip; do
    if [ -n "$ip" ]; then
        log "Pinging: $ip"
        result=$(ping_host "$ip")
        
        if [ "$result" = "SUCCESS" ]; then
            log "✓ $ip - REACHABLE"
            ((SUCCESS_COUNT++))
        else
            log "✗ $ip - UNREACHABLE"
            ((FAILED_COUNT++))
        fi
        
        log ""  # Empty line for readability
    fi
done <<< "$IP_LIST"

# Summary
log "=== MONITORING SUMMARY ==="
log "Successful pings: $SUCCESS_COUNT"
log "Failed pings: $FAILED_COUNT"
log "Total IPs checked: $((SUCCESS_COUNT + FAILED_COUNT))"
log "Success rate: $((SUCCESS_COUNT * 100 / (SUCCESS_COUNT + FAILED_COUNT)))%"
log "=== PING MONITOR COMPLETED ==="

echo "Results saved to: $LOG_FILE"

