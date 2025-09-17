#!/bin/bash

# Simple version for cron job
BACKUP_DIR="/var/log/passwd_backups"
mkdir -p "$BACKUP_DIR"
awk -F: '!/^#/ && !/^$/ {print $1 "," $3}' /etc/passwd > "$BACKUP_DIR/passwd_fields_$(date +%Y-%m-%d).txt"
find "$BACKUP_DIR" -name "passwd_fields_*.txt" -type f -mtime +2 -delete
