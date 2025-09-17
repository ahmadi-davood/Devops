# /etc/systemd/system/user-backup@.service
[Unit]
Description=Backup home directory for user %i on logout
After=user@%i.service

[Service]
Type=oneshot
User=%i
ExecStart=/usr/local/bin/backup_home_on_logout.sh

[Install]
WantedBy=multi-user.target