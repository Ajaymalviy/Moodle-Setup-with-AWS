#!/bin/bash
#shebang for bash

# Variables which we use
DB_NAME="moodle"
DB_USER="moodleuser"
DB_PASS="password" #you can change according to you.
MOODLE_DIR="/var/www/html/moodle"
MOODLE_DATA_DIR="/var/www/moodledata"
PHP_VERSION="7.4"

# Update your system 
echo "Updating the system..."
sudo apt update -y && sudo apt upgrade -y

# Install Apache 
echo "Installing Apache..."
sudo apt install apache2 -y

# Start and enable Apache server
echo "Starting Apache service..."
sudo systemctl start apache2
sudo systemctl enable apache2

# Install MySQL
echo "Installing MySQL..."
sudo apt install mysql-server 

# Secure MySQL installation
echo "Securing MySQL installation..."
sudo mysql_secure_installation

# Create Moodle database and user
echo "Creating Moodle database and user..."
sudo mysql -u root -p <<MYSQL_SCRIPT
CREATE DATABASE $DB_NAME DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASS';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';
FLUSH PRIVILEGES;
EXIT;
MYSQL_SCRIPT

# Install PHP and required extensions
echo "Installing PHP and required extensions..."
sudo apt install php libapache2-mod-php php-mysql php-xmlrpc php-intl php-soap php-xml php-gd php-cli php-curl php-zip php-mbstring -y

# Restart Apache to apply changes
echo "Restarting Apache..."
sudo systemctl restart apache2

# Download Moodle
echo "Downloading Moodle..."
cd /var/www/html
sudo git clone -b MOODLE_401_STABLE git://git.moodle.org/moodle.git

# Set permissions for the Moodle directory
echo "Setting permissions for Moodle directory..."
sudo chown -R www-data:www-data $MOODLE_DIR
sudo chmod -R 755 $MOODLE_DIR

# Create Moodle data directory
echo "Creating Moodle data directory..."
sudo mkdir $MOODLE_DATA_DIR
sudo chown -R www-data:www-data $MOODLE_DATA_DIR
sudo chmod -R 770 $MOODLE_DATA_DIR

# Configure Moodle
echo "Configuring Moodle..."
sudo cp $MOODLE_DIR/config-dist.php $MOODLE_DIR/config.php
sudo bash -c "cat <<EOT > $MOODLE_DIR/config.php
<?php
\$CFG->dbtype    = 'mysqli';
\$CFG->dblibrary = 'native';
\$CFG->dbhost    = 'localhost';
\$CFG->dbname    = '$DB_NAME';
\$CFG->dbuser    = '$DB_USER';
\$CFG->dbpass    = '$DB_PASS';
\$CFG->wwwroot   = 'http://your-server-ip/moodle';  // Replace with your server's IP or domain
\$CFG->dataroot  = '$MOODLE_DATA_DIR';
\$CFG->admin     = 'admin';
\$CFG->directorypermissions = 0777;
require_once(__DIR__ . '/lib/setup.php');
EOT"

# Enable HTTPS (optional)
echo "Setting up UFW for firewall (optional)..."
sudo ufw allow 'Apache Full'

echo "Installation complete! Please navigate to http://your-server-ip/moodle to finish the setup."

