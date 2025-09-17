#!/bin/bash
# Script: /usr/local/bin/backup_home_on_logout.sh

# Configuration
USERNAME=$(whoami)
BACKUP_DIR="/home/backups/$USERNAME"
LOG_FILE="/var/log/user_backups.log"
RETENTION_DAYS=7  # Keep backups for 7 days

# Log function
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $USERNAME - $1" | sudo tee -a "$LOG_FILE"
}

# Create backup directory if it doesn't exist
sudo mkdir -p "$BACKUP_DIR"
sudo chown "$USERNAME:$USERNAME" "$BACKUP_DIR"

# Get timestamp for backup filename
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/${USERNAME}_home_backup_${TIMESTAMP}.tar.gz"

log "Starting backup of $USERNAME's home directory..."

# Create backup (exclude temporary files and cache)
tar -czf "$BACKUP_FILE" \
    --exclude=".cache/*" \
    --exclude=".tmp/*" \
    --exclude="*.tmp" \
    --exclude="temp/*" \
    --exclude=".thumbnails/*" \
    --exclude=".local/share/Trash/*" \
    -C "/home" "$USERNAME" 2>/dev/null

if [ $? -eq 0 ]; then
    BACKUP_SIZE=$(du -h "$BACKUP_FILE" | cut -f1)
    log "SUCCESS: Backup created: $BACKUP_FILE ($BACKUP_SIZE)"
else
    log "ERROR: Backup failed for $USERNAME"
    exit 1
fi

# Clean up old backups
log "Cleaning up backups older than $RETENTION_DAYS days..."
find "$BACKUP_DIR" -name "${USERNAME}_home_backup_*.tar.gz" -type f -mtime +$RETENTION_DAYS -delete

# List remaining backups
BACKUP_COUNT=$(find "$BACKUP_DIR" -name "${USERNAME}_home_backup_*.tar.gz" -type f | wc -l)
log "Backup completed. Total backups retained: $BACKUP_COUNT"

