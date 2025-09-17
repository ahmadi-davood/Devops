# ~/.bash_logout
#!/bin/bash

# Backup configuration
BACKUP_DIR="/home/backups/$USER"
RETENTION_DAYS=7
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/${USER}_home_backup_${TIMESTAMP}.tar.gz"

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Only run backup if we're not in a SSH session (to avoid backup on every SSH logout)
if [ -z "$SSH_CLIENT" ] && [ -z "$SSH_TTY" ]; then
    echo "Creating backup of your home directory..."
    
    # Create backup (exclude large cache directories)
    tar -czf "$BACKUP_FILE" \
        --exclude=".cache/*" \
        --exclude=".tmp/*" \
        --exclude="*.tmp" \
        --exclude="temp/*" \
        --exclude=".thumbnails/*" \
        --exclude=".local/share/Trash/*" \
        --exclude="Downloads/*" \
        -C "/home" "$USER" 2>/dev/null
    
    if [ $? -eq 0 ]; then
        BACKUP_SIZE=$(du -h "$BACKUP_FILE" | cut -f1)
        echo "Backup created: $BACKUP_FILE ($BACKUP_SIZE)"
        
        # Clean up old backups
        find "$BACKUP_DIR" -name "${USER}_home_backup_*.tar.gz" -type f -mtime +$RETENTION_DAYS -delete
    else
        echo "Backup failed!"
    fi
fi