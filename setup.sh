#!/bin/zsh

# Check if SaltStack is already installed
if [ -f /etc/salt/minion ] || [ -f "C:\salt\conf\minion" ]; then
    echo "SaltStack is already installed."
else
    echo "SaltStack is not installed. Proceeding with installation..."
    
    # Install SaltStack
    curl -L https://bootstrap.saltproject.io -o install_salt.sh
    sudo sh install_salt.sh -P

# Clone the Git repository
git clone https://github.com/jnichols35/salt-demo /tmp/salt-demo

# Define the destination directory for the SaltStack files
salt_dir="/opt/srv/salt-demo"

# Copy the .sls files to the destination directory
cp -r /tmp/salt-demo/* "$salt_dir"

# Update the minion configuration file
minion_conf="/etc/salt/minion"
echo "file_roots:" >> "$minion_conf"
echo "  base:" >> "$minion_conf"
echo "    - $salt_dir" >> "$minion_conf"

# Deploy Installomator Script
curl -o /opt/Installomator/Installomator.sh https://raw.githubusercontent.com/Installomator/Installomator/main/Installomator.sh
chmod +x /opt/Installomator/Installomator.sh

# Restart the Salt minion service
systemctl restart salt-minion