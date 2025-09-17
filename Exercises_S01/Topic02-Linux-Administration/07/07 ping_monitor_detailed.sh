#!/bin/bash

# Enhanced version with detailed ping statistics
# Usage: ./ping_monitor_detailed.sh [ip_list_file]

IP_LIST_FILE="${1:-ip_list.txt}"
LOG_DIR="/var/log/ping_monitor"
PING_COUNT=4
PING_TIMEOUT=1

# Create log directory
mkdir -p "$LOG_DIR"

# Get current date and hostname
CURRENT_DATE=$(date +%Y-%m-%d)
HOSTNAME=$(hostname -s)
LOG_FILE="$LOG_DIR/ping_detailed_${HOSTNAME}_${CURRENT_DATE}.log"

# Function to get detailed ping statistics
ping_detailed() {
    local ip=$1
    local result
    
    result=$(ping -c $PING_COUNT -W $PING_TIMEOUT "$ip" 2>&1)
    
    if [ $? -eq 0 ]; then
        # Extract packet loss and timing information
        local packet_loss=$(echo "$result" | grep "packet loss" | awk '{print $6}')
        local avg_time=$(echo "$result" | grep "rtt" | awk -F'/' '{print $5}' | cut -d'.' -f1)
        echo "SUCCESS|$packet_loss|${avg_time}ms"
    else
        echo "FAILED|100%|N/A"
    fi
}

# Log function
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# Main execution
echo "Ping Monitor - Host: $HOSTNAME - Date: $CURRENT_DATE" | tee "$LOG_FILE"
echo "==============================================" | tee -a "$LOG_FILE"

# Check IP file
if [ ! -f "$IP_LIST_FILE" ]; then
    log "ERROR: IP list file not found: $IP_LIST_FILE"
    exit 1
fi

# Read IPs
IP_LIST=$(grep -vE '^#|^$' "$IP_LIST_FILE" | tr -d '\r')
TOTAL_IPS=$(echo "$IP_LIST" | wc -l)

log "Starting ping monitoring for $TOTAL_IPS IP addresses..."
log ""

SUCCESS=0
FAILED=0

while IFS= read -r ip; do
    [ -z "$ip" ] && continue
    
    log "Testing: $ip"
    result=$(ping_detailed "$ip")
    
    status=$(echo "$result" | cut -d'|' -f1)
    packet_loss=$(echo "$result" | cut -d'|' -f2)
    response_time=$(echo "$result" | cut -d'|' -f3)
    
    if [ "$status" = "SUCCESS" ]; then
        log "✓ REACHABLE - Packet Loss: $packet_loss - Avg RTT: $response_time"
        ((SUCCESS++))
    else
        log "✗ UNREACHABLE - Packet Loss: $packet_loss"
        ((FAILED++))
    fi
    
    log "----------------------------------------------"
    
done <<< "$IP_LIST"

# Final summary
log ""
log "FINAL SUMMARY:"
log "Successful pings: $SUCCESS"
log "Failed pings: $FAILED"
log "Total IPs tested: $TOTAL_IPS"
log "Success rate: $((SUCCESS * 100 / TOTAL_IPS))%"
log ""
log "Log file: $LOG_FILE"

# Also show summary on console
echo ""
echo "=== Quick Summary ==="
echo "Successful: $SUCCESS"
echo "Failed: $FAILED"
echo "Log file: $LOG_FILE"