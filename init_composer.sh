#!/bin/bash

# Check if Composer is installed
if ! [ -x "$(command -v composer)" ]; then
  echo 'Composer is not installed. Installing now...'
  EXPECTED_CHECKSUM="$(php -r 'copy("https://composer.github.io/installer.sig", "php://stdout");')"
  php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
  ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"

  if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]
  then
      >&2 echo 'ERROR: Invalid installer checksum'
      rm composer-setup.php
      exit 1
  fi

  php composer-setup.php --quiet
  RESULT=$?
  rm composer-setup.php
  if [ $RESULT -ne 0 ]; then
    echo "Failed to install Composer"
    exit 1
  fi
  mv composer.phar /usr/local/bin/composer
  echo "Composer installed successfully"
else
  echo 'Composer is already installed'
fi

# Initialize Composer project if composer.json doesn't exist
if [ ! -f "composer.json" ]; then
  echo "Initializing Composer project..."
  composer init --no-interaction
fi

# Install required packages
echo "Installing required packages..."
#composer require erusev/parsedown vlucas/phpdotenv

echo "Composer initialization complete!"