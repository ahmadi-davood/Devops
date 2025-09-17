# Edit crontab
crontab -e

# Run every 30 minutes
*/30 * * * * /path/to/ping_monitor.sh /path/to/ip_list.txt

# Run every hour
0 * * * * /path/to/ping_monitor.sh /path/to/ip_list.txt