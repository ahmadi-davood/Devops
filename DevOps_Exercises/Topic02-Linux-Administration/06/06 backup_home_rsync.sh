#!/bin/bash
# /usr/local/bin/backup_home_rsync.sh

USERNAME=$(whoami)
BACKUP_BASE="/home/backups/$USERNAME"
CURRENT_BACKUP="$BACKUP_BASE/current"
LOG_FILE="/var/log/user_backups.log"
RETENTION_DAYS=7

# Log function
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $USERNAME - $1" | sudo tee -a "$LOG_FILE"
}

# Create directories
sudo mkdir -p "$BACKUP_BASE"
sudo chown "$USERNAME:$USERNAME" "$BACKUP_BASE"

log "Starting incremental backup using rsync..."

# Create hardlink-based backup using rsync
rsync -av --delete \
    --exclude='.cache/' \
    --exclude='.tmp/' \
    --exclude='*.tmp' \
    --exclude='temp/' \
    --exclude='.thumbnails/' \
    --exclude='.local/share/Trash/' \
    --link-dest="$CURRENT_BACKUP" \
    "/home/$USERNAME/" "$BACKUP_BASE/backup-$(date +%Y%m%d_%H%M%S)/"

# Update current symlink
ln -sfn "$BACKUP_BASE/backup-$(date +%Y%m%d_%H%M%S)" "$CURRENT_BACKUP"

log "Incremental backup completed"

# Clean up old backups
find "$BACKUP_BASE" -name "backup-*" -type d -mtime +$RETENTION_DAYS -exec rm -rf {} \;