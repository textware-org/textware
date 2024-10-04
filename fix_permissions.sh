#!/bin/bash

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Set the correct permissions for the db.sqlite file
touch /var/www/html/db.sqlite
chown www-data:www-data /var/www/html/db.sqlite
chmod 666 /var/www/html/db.sqlite

# Set the correct permissions for the entire /var/www/html directory
chown -R www-data:www-data /var/www/html
find /var/www/html -type d -exec chmod 755 {} \;
find /var/www/html -type f -exec chmod 644 {} \;

echo "Permissions fixed."