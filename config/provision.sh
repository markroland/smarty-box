#!/bin/sh

####
#
# Provision a Vagrant VM
#
####

# Get Package Manager(s)

# Extra Packages for Enterprise Linux (EPEL)
rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm

# PHP, Python, Git, MySQL, Redis ...
rpm -ivh https://centos6.iuscommunity.org/ius-release.rpm

####################################################################################################

# Update all packages
yum update

####################################################################################################

# Install Apache
yum install -y httpd

# Set timezone
sed -i 's@#ServerName www.example.com:80@ServerName localhost:8080@g' /etc/httpd/conf/httpd.conf

# Add Apache to Boot
chkconfig httpd on

####################################################################################################

# Install PHP (php70u is currently dependent upon httpd 2.2)
yum install -y php70u
yum install -y php70u-cli
yum install -y php70u-json

# Set timezone
sed -i 's@;date.timezone =@date.timezone = America/Los_Angeles@g' /etc/php.ini

# Install Composer
cd /usr/local/bin
curl -sS https://getcomposer.org/installer | php
mv composer.phar composer
cd -

# Install PHPUnit
# cd /usr/local/bin
# curl -O https://phar.phpunit.de/phpunit.phar
# chmod +x phpunit.phar
# mv phpunit.phar phpunit
# cd -

# Install Pear
# cd /home/markr34
# wget http://pear.php.net/go-pear.phar
# php go-pear.phar # TODO: Automate "Enter" input
# rm go-pear.phar

# Install Phing
# pear channel-discover pear.phing.info
# pear install phing/phing

# Install Code Sniffer
# pear install PHP_CodeSniffer

# Used for phing build
# pear install HTTP_Request2

# Install PHPDoc
# pear channel-discover pear.phpdoc.org
# pear install phpdoc/phpDocumentor


####################################################################################################
# CONFIGURE PROJECT
####################################################################################################

mkdir /vagrant/logs
touch /vagrant/logs/access_log # Permissions?

# Configure Apache
touch /etc/httpd/conf/localhost.conf

echo 'NameVirtualHost *:80

<VirtualHost *:80>

  # Basic settings
  ServerName localhost
  DocumentRoot /vagrant/public_html

  # Rewrite preferences
  # RewriteEngine On
  # RewriteOptions Inherit

  # Logging
  # CustomLog /vagrant/logs/access_log "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\" http"

  # Directory-specific directives
  <Directory /vagrant/public_html>

    # Allow per-directory .htaccess
    AllowOverride All

    # Disallow certain types of requests
    <Limit DELETE>
      Order Deny,Allow
      Deny from All
    </Limit>

  </Directory>

</VirtualHost>' > /etc/httpd/conf/localhost.conf

echo '

Include /etc/httpd/conf/localhost.conf' >> /etc/httpd/conf/httpd.conf

# Install Composer
cd /vagrant
php /usr/local/bin/composer install

####################################################################################################
# START SERVICES
####################################################################################################

# Start Apache
service httpd start
