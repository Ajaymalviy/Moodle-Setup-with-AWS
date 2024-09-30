# Moodle Setup on Ubuntu

## Introduction
This guide provides a comprehensive walkthrough for setting up Moodle, a popular Learning Management System (LMS), on an Ubuntu server. We will cover essential steps, including installing Apache, MySQL, and PHP, configuring Moodle, and finalizing the installation through a web interface. This guide is designed for educators and administrators looking to create a robust online learning environment, regardless of their technical expertise.

## Prerequisites
Before setting up Moodle, you will need the following:
- A cloud instance (e.g., AWS EC2, Google Cloud, Azure) with:
  - CPU: At least 1 vCPU
  - RAM: At least 1 GB
  - Storage: At least 20 GB of General Purpose (SSD) volume.
- SSH access to your server using the private key associated with your instance.
- Basic knowledge of Linux commands, such as navigating the filesystem and using the package manager.

## Required Software
You will need to install the following software components to ensure Moodle runs smoothly:
- Apache or Nginx for the web server.
- PHP 7.4 or later with required extensions.
- MySQL or MariaDB for the relational database.

## Installation Steps

### Step 1: Update Your System
Update your system's package list:
```bash
sudo apt update
```
### Step 2: Install Apache Web Server
Install Apache:
```bash
sudo apt install apache2
```
### Step 3: Start and Enable Apache Services

Start Apache and ensure it runs on boot:
``` bash 
sudo systemctl start apache2
sudo systemctl enable apache2
sudo systemctl status apache2
````
### Step 4: Install MySQL Database
Install MySQL:
```bash
sudo apt install mysql-server
```
Secure the MySQL installation:
```bash
sudo mysql_secure_installation
```
### Step 5: Create Moodle Database and User
Log in to MySQL as the root user:
```bash
sudo mysql -u root -p
```
Run the following SQL queries to create a Moodle database and user:
```mysql
CREATE DATABASE moodle DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'moodleuser'@'localhost' IDENTIFIED BY 'password';  -- Replace with your strong password
GRANT ALL PRIVILEGES ON moodle.* TO 'moodleuser'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```
### Step 6: Install PHP and Required Extensions
Install PHP and required extensions:
```bash 
sudo apt install php libapache2-mod-php php-mysql php-xmlrpc php-intl php-soap php-xml php-gd php-cli php-curl php-zip php-mbstring
```
Restart Apache to apply changes:
```bash
sudo systemctl restart apache2
```
### Step 7: Download and Set Up Moodle
Download the latest version of Moodle from the Moodle download page or clone the Git repository:
## 🔗 Link
[[moodle]](https://download.moodle.org/?)

or 

```bash 
cd /var/www/html
sudo git clone -b MOODLE_401_STABLE git://git.moodle.org/moodle.git
```

Set permissions for the Moodle directory:

```bash 
sudo chown -R www-data:www-data /var/www/html/moodle
sudo chmod -R 755 /var/www/html/moodle
```
Create a data directory for Moodle:
```bash
sudo mkdir /var/www/moodledata
sudo chown -R www-data:www-data /var/www/moodledata
sudo chmod -R 770 /var/www/moodledata
```
### Step 8: Configure Moodle
Copy the sample configuration file:
```bash
sudo cp /var/www/html/moodle/config-dist.php /var/www/html/moodle/config.php
```
Edit the configuration file:
```bash
sudo nano /var/www/html/moodle/config.php
```

Update the following key settings:
   - Database information
   - Web root URL (replace http://example.com/moodle with your server's IP or domain)
   - Data directory path

### Step 9: Finalize the Installation via Web Browser
Navigate to:
```arduino
http://your-server-ip/moodle
```
Follow the on-screen instructions to complete the installation

### Step 10: Secure Your Moodle Installation
- Enable HTTPS: Secure your site by installing an SSL certificate.
- Firewall Settings: Ensure only necessary ports (80 for HTTP, 443 for HTTPS) are open.

# Common Issues
- 404 Not Found Error:
Ensure the Moodle directory is correctly placed in /var/www/html, and check if Apache is running:
```bash 
sudo systemctl status apache2
```
- Database Connection Issues: Double-check your database credentials in config.php.

- PHP Version Compatibility Error: Ensure that PHP 7.4 or higher is installed. Check your PHP version with the following command:

- Missing PHP Extensions: Make sure all required PHP extensions are installed:

### Conclusion
This guide covered the step-by-step installation of Moodle on Ubuntu, from setting up Apache, MySQL, and PHP to configuring Moodle itself. You now have a powerful, open-source LMS ready for use. Enjoy exploring Moodle and enhancing your educational offerings!
