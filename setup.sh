#!/bin/zsh

# Check if SaltStack is already installed
if command -v salt-call >/dev/null 2>&1; then
    echo "SaltStack is already installed."
else
    echo "SaltStack is not installed. Proceeding with installation..."
    
    # Install SaltStack
    curl -L https://bootstrap.saltproject.io -o install_salt.sh
    sudo sh install_salt.sh -P
fi

# Clone the Git repository
git clone https://github.com/jnichols35/salt-demo /tmp/salt-demo

# Define the destination directory for the SaltStack files
salt_dir="/opt/srv/salt-demo"
minion_file="/tmp/salt-demo/minion"
salt_minion_config="/etc/salt/minion"

# Create the directory if it doesn't exist
if [ ! -d "$salt_dir" ]; then
  mkdir -p "$salt_dir"
fi

# Copy the .sls files to the destination directory
cp -r /tmp/salt-demo/srv/salt-demo/* "$salt_dir"

# Update the minion configuration file
cp -f "$minion_file" "$salt_minion_config"

# Deploy Installomator Script
curl -o /opt/Installomator/Installomator.sh https://raw.githubusercontent.com/Installomator/Installomator/main/Installomator.sh
chmod +x /opt/Installomator/Installomator.sh

# Restart the Salt minion service
sudo launchctl stop com.saltstack.salt.minion
sudo launchctl start com.saltstack.salt.minion