# Check if SaltStack is already installed
if (Get-Command salt-call -ErrorAction SilentlyContinue) {
    Write-Host "SaltStack is already installed."
}
else {
    Write-Host "SaltStack is not installed. Proceeding with installation..."

    # Install SaltStack
    Invoke-WebRequest -Uri "https://bootstrap.saltproject.io" -OutFile "install_salt.ps1"
    Set-ExecutionPolicy Bypass -Scope Process -Force
    .\install_salt.ps1 -P
}

# Install Git
if (Get-Command choco.exe -ErrorAction SilentlyContinue) {
    Write-Host "Chocolatey is installed. Installing Git."
    choco install git -y
}
else {
    Write-Host "Chocolatey is not installed. Installing Git via Winget."
    winget install -e --id Git.Git
}

# Clone the Git repository
git clone https://github.com/jnichols35/salt-demo C:\temp\salt-demo

# Define the destination directory for the SaltStack files
$salt_dir = "C:\opt\srv\salt-demo"
$minion_file = "C:\temp\salt-demo\minion"
$salt_minion_config = "C:\salt\conf\minion"

# Create the directory if it doesn't exist
if (-not (Test-Path $salt_dir)) {
    New-Item -ItemType Directory -Path $salt_dir -Force | Out-Null
}

# Copy the .sls files to the destination directory
Copy-Item -Recurse -Path "C:\temp\salt-demo\srv\salt-demo\*" -Destination $salt_dir -Force

# Update the minion configuration file
Copy-Item -Force -Path $minion_file -Destination $salt_minion_config

# Restart the Salt minion service
Restart-Service salt-minion