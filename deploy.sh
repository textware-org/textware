#!/bin/bash
CONFIG=".env.prod"
CURRENT_FILE="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"

files () {
  for item in $(ls .env.*)
  do
      echo "./$CURRENT_FILE $item"
  done
}

((!$#)) && \
echo No arguments supplied! && \
echo examples: && \
files && \
exit 1

CONFIG=$1

# Load environment variables
if [ -f $CONFIG ]; then
    export $(cat $CONFIG | grep -v '#' | awk '/=/ {print $1}')
else
    echo "$CONFIG file not found"
    exit 1
fi

# Check if required variables are set
if [ -z "$SSH_HOST" ] || [ -z "$SSH_USER" ] || [ -z "$SSH_KEY" ] || [ -z "$PATH_REMOTE" ]; then
    echo "Missing required environment variables. Please check your $CONFIG file."
    exit 1
fi

# Create a temporary directory for the files to be transferred
TEMP_DIR=$(mktemp -d)

# Copy necessary files to the temporary directory
cp -r php/* "$TEMP_DIR"
#cp .env "$TEMP_DIR"
#cp db.sqlite "$TEMP_DIR"
#cp php/*.php "$TEMP_DIR"

# Sync the files to the remote server
rsync -avz -e "ssh -i $SSH_KEY" --delete \
    "$TEMP_DIR/" \
    "$SSH_USER@$SSH_HOST:$PATH_REMOTE"

scp -i "$SSH_KEY" "php/.env" "$SSH_USER@$SSH_HOST:$PATH_REMOTE/.env"
#scp -i "$SSH_KEY" "db.sqlite" "$SSH_USER@$SSH_HOST:$PATH_REMOTE/../db.sqlite"


# Remove the temporary directory
rm -rf "$TEMP_DIR/src"
rm -rf "$TEMP_DIR/*.php"
rm -rf "$TEMP_DIR/vendor"

# Run composer install on the remote server
ssh -i "$SSH_KEY" "$SSH_USER@$SSH_HOST" "cd $PATH_REMOTE && composer install --no-dev --optimize-autoloader"


# Set correct permissions on the remote server
ssh -i "$SSH_KEY" "$SSH_USER@$SSH_HOST" "cd $PATH_REMOTE && \
    chmod 644 .env && \
    find . -type d -exec chmod 755 {} \; && \
    find . -type f -exec chmod 644 {} \; && \
    chmod 755 *.php"

ssh -i "$SSH_KEY" "$SSH_USER@$SSH_HOST" "cd $PATH_REMOTE && \
    chown -R $FS_USER:$FS_GROUP ."

# Move Sqlite
#ssh -i "$SSH_KEY" "$SSH_USER@$SSH_HOST" "mv $PATH_REMOTE/db.sqlite ../db.sqlite"
#chmod 644 ../db.sqlite .env && \

echo "Deployment completed successfully!"