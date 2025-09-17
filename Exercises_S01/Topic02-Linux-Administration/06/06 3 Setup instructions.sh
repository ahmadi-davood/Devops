# Make the script executable
sudo chmod +x /usr/local/bin/backup_home_on_logout.sh

# Create backup directory with proper permissions
sudo mkdir -p /home/backups
sudo chmod 755 /home/backups

# Enable the service for your user (replace 'yourusername' with actual username)
sudo systemctl enable user-backup@yourusername.service

# Start the service
sudo systemctl start user-backup@yourusername.service