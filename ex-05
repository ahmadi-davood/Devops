#!/bin/bash

# Script: save_passwd_fields.sh
# Description: Saves first and third fields of /etc/passwd with date and manages 2-day retention

# Configuration
BACKUP_DIR="/var/log/passwd_backups"  # Change this if needed
RETENTION_DAYS=2

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Get current date for filename
CURRENT_DATE=$(date +%Y-%m-%d)
FILENAME="passwd_fields_${CURRENT_DATE}.txt"
BACKUP_PATH="${BACKUP_DIR}/${FILENAME}"

# Function to extract fields and save to file
extract_and_save() {
    echo "Extracting first and third fields from /etc/passwd..."
    
    # Check if /etc/passwd exists
    if [ ! -f "/etc/passwd" ]; then
        echo "Error: /etc/passwd file not found!"
        exit 1
    fi
    
    # Extract first (username) and third (UID) fields, skip comments and empty lines
    awk -F: '!/^#/ && !/^$/ {print $1 "," $3}' /etc/passwd > "$BACKUP_PATH"
    
    if [ $? -eq 0 ]; then
        echo "Success: Fields saved to $BACKUP_PATH"
        echo "Total entries processed: $(wc -l < "$BACKUP_PATH")"
    else
        echo "Error: Failed to extract fields"
        exit 1
    fi
}

# Function to clean up old files
cleanup_old_files() {
    echo "Cleaning up files older than $RETENTION_DAYS days..."
    
    # Find and delete files older than RETENTION_DAYS
    find "$BACKUP_DIR" -name "passwd_fields_*.txt" -type f -mtime +$RETENTION_DAYS -delete
    
    # Count remaining files
    REMAINING_FILES=$(find "$BACKUP_DIR" -name "passwd_fields_*.txt" -type f | wc -l)
    echo "Remaining backup files: $REMAINING_FILES"
}

# Function to list current backup files
list_backup_files() {
    echo "Current backup files in $BACKUP_DIR:"
    ls -la "$BACKUP_DIR"/passwd_fields_*.txt 2>/dev/null || echo "No backup files found"
}

# Main execution
echo "=== Starting /etc/passwd field backup ==="
echo "Date: $(date)"
echo "Backup directory: $BACKUP_DIR"

# Extract and save fields
extract_and_save

# Clean up old files
cleanup_old_files

# List remaining files
list_backup_files

echo "=== Backup completed successfully ==="


