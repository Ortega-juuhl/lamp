#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Function to pause for a specified duration
pause() {
    sleep $1
}

# Update package lists
sudo apt update

# Install Apache
sudo apt install -y apache2
pause 10
sudo systemctl enable apache2.service
pause 5

# Install OpenSSH server
sudo apt install -y openssh-server
pause 10

# Configure UFW
sudo ufw enable
pause 5
sudo ufw allow from 10.0.0.0/8 to any port 3306
pause 5
sudo ufw allow in on eth0 to any port 80
pause 5
sudo ufw allow 'Apache Full'
pause 5
sudo ufw allow 'OpenSSH'
pause 5
sudo ufw allow from any to any port 20,21,10000:10100 proto tcp
pause 5

# Install PHP
sudo apt install -y php
pause 10
sudo apt-get install php-mysql
pause 10
sudo apt install -y libapache2-mod-php
pause 10
sudo apt-cache search libapache2*
pause 10

# Install MariaDB
sudo apt install -y mariadb-server
pause 10
sudo systemctl start mariadb.service
pause 10

# Check MySQL status
sudo systemctl status mariadb.service || { echo "Failed to get MySQL status"; exit 1; }
pause 10
sudo systemctl status apache2 || { echo "Failed to get Apache status"; exit 1; }
pause 10
sudo systemctl status mariadb || { echo "Failed to get mariadb status"; exit 1; }
pause 10

echo "LAMP installation and configuration complete."
