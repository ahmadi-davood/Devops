#!/bin/bash

# Script: transfer_passwd.sh
# Usage: ./transfer_passwd.sh IP USERNAME PASSWORD

# Check if all arguments are provided
if [ $# -ne 3 ]; then
    echo "Usage: $0 <IP_ADDRESS> <USERNAME> <PASSWORD>"
    echo "Example: ./transfer_passwd.sh 192.168.1.100 admin password123"
    exit 1
fi

# Assign arguments to variables
IP=$1
USERNAME=$2
PASSWORD=$3
REMOTE_PATH="/home/$USERNAME/passwd_copy"
LOCAL_FILE="/etc/passwd"

echo "Checking connectivity to server: $IP"

# Check if server is pingable
if ping -c 3 -W 2 "$IP" > /dev/null 2>&1; then
    echo "Server $IP is accessible. Attempting to transfer /etc/passwd..."
    
    # Check if sshpass is installed
    if ! command -v sshpass &> /dev/null; then
        echo "Error: sshpass is not installed. Please install it first:"
        echo "Ubuntu/Debian: sudo apt-get install sshpass"
        echo "CentOS/RHEL: sudo yum install sshpass"
        exit 1
    fi
    
    # Transfer the file using sshpass and scp
    if sshpass -p "$PASSWORD" scp -o StrictHostKeyChecking=no -o ConnectTimeout=10 "$LOCAL_FILE" "$USERNAME@$IP:$REMOTE_PATH" 2>/dev/null; then
        echo "Success: /etc/passwd transferred to $USERNAME@$IP:$REMOTE_PATH"
    else
        echo "Error: Failed to transfer file. Possible reasons:"
        echo "  - SSH not enabled on the server"
        echo "  - Invalid credentials"
        echo "  - Permission denied on remote path"
        echo "  - Network issues"
    fi
    
else
    echo "Error: Server $IP is not accessible (ping failed)"
    echo "Please check:"
    echo "  - Network connectivity"
    echo "  - Server is powered on"
    echo "  - Firewall settings"
    echo "  - IP address correctness"
fi
