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
pause 3
sudo systemctl enable apache2.service
pause 3
sudo systemctl status apache2 || { echo "Failed to get Apache status"; exit 1; }
pause 3

# Configure UFW
sudo ufw enable
pause 3
sudo ufw allow from 10.0.0.0/8 to any port 3306
pause 3
sudo ufw allow in on eth0 to any port 80
pause 3
sudo ufw allow 'Apache Full'
pause 3
sudo ufw allow 'OpenSSH'
pause 3
sudo ufw allow from any to any port 20,21,10000:10100 proto tcp
pause 3

# Install PHP
sudo apt install -y php
pause 3
sudo apt install -y libapache2-mod-php
pause 3
sudo apt-cache search libapache2*
pause 3

# Install OpenSSH server
sudo apt install -y openssh-server
pause 3
sudo nano /etc/ssh/sshd_config
pause 3

# Install MariaDB
sudo apt install -y mariadb-server
pause 3
sudo systemctl start mariadb.service
pause 3
sudo mysql_secure_installation
pause 3

# Secure MariaDB and create user/database
sudo mysql <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED WITH caching_sha2_password BY 'IMKuben1337!';
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'IMKuben1337!';
SELECT user,authentication_string,plugin,host FROM mysql.user;
CREATE USER 'alfmorten'@'localhost' IDENTIFIED WITH caching_sha2_password BY 'IMKuben1337!';
GRANT CREATE, ALTER, DROP, INSERT, UPDATE, DELETE, SELECT, REFERENCES, RELOAD on *.* TO 'alfmorten'@'localhost' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF
pause 3

# Check MySQL status
sudo systemctl status mysql.service || { echo "Failed to get MySQL status"; exit 1; }
pause 3

# Create database
mysql -u alfmorten -p'IMKuben1337!' <<EOF
CREATE DATABASE chat_system CHARACTER SET utf8;
exit
EOF

echo "LAMP installation and configuration complete."
