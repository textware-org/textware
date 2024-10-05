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
[ -z "$PATH_REMOTE" ] && echo "PATH_REMOTE can't be empty" exit 1

# Create a temporary directory for the files to be transferred
#TEMP_DIR=$(mktemp -d)

# Copy necessary files to the temporary directory
#cp -r $PATH_LOCAL/* "$TEMP_DIR"
#cp .env "$TEMP_DIR"
#cp db.sqlite "$TEMP_DIR"
#cp php/*.php "$TEMP_DIR"



# To remove non-hidden files and folders in the current directory
#ssh -i "$SSH_KEY" "$SSH_USER@$SSH_HOST" "find /var/www/vhosts/researcher.pl/httpdocs/ -maxdepth 1 -type d ! -name '.*' -exec rm -rf {} +"
ssh -i "$SSH_KEY" "$SSH_USER@$SSH_HOST" "find $PATH_REMOTE/* -maxdepth 1 -type d ! -name '.*' -exec rm -rf {} +"
ssh -i "$SSH_KEY" "$SSH_USER@$SSH_HOST" "find $PATH_REMOTE/* -maxdepth 1 -type f ! -name '.*' -exec rm -f {} +"

# Sync the files to the remote server
rsync -avz -e "ssh -i $SSH_KEY" --delete \
    "$PATH_LOCAL/" \
    "$SSH_USER@$SSH_HOST:$PATH_REMOTE"
# Copy files to the remote server
#rsync -avz -e "ssh -i $SSH_KEY" --delete \
#    "$PATH_LOCAL/" \
#scp -i "$SSH_KEY" "$PATH_LOCAL/" "$SSH_USER@$SSH_HOST:$PATH_REMOTE"
scp -i "$SSH_KEY" "$PATH_LOCAL/.env" "$SSH_USER@$SSH_HOST:$PATH_REMOTE/.env"
#bash ./database/init.sh

#scp -i "$SSH_KEY" "db.sqlite" "$SSH_USER@$SSH_HOST:$PATH_REMOTE/../db.sqlite"
#ssh -i "$SSH_KEY" "$SSH_USER@$SSH_HOST" "cd $PATH_REMOTE/../ && chown $FS_USER:$FS_GROUP db.sqlite"



# Set correct permissions on the remote server
ssh -i "$SSH_KEY" "$SSH_USER@$SSH_HOST" "find $PATH_REMOTE -type d -exec chmod 755 {} \;"
ssh -i "$SSH_KEY" "$SSH_USER@$SSH_HOST" "find $PATH_REMOTE -type f -exec chmod 644 {} \;"
ssh -i "$SSH_KEY" "$SSH_USER@$SSH_HOST" "find $PATH_REMOTE -type f -name "*.php" -exec chmod 755 {} \;"
#ssh -i "$SSH_KEY" "$SSH_USER@$SSH_HOST" "cd $PATH_REMOTE && chmod -R 755 *.php"

# Remove the temporary directory
#rm -rf "$TEMP_DIR/src"

#rm -rf "$TEMP_DIR/*.php"
ssh -i "$SSH_KEY" "$SSH_USER@$SSH_HOST" "chown -R $FS_USER:$FS_GROUP $PATH_REMOTE"

# Run npm install on the remote server
ssh -i "$SSH_KEY" "$SSH_USER@$SSH_HOST" "composer install --working-dir=$PATH_REMOTE --no-dev --optimize-autoloader"
echo "composer install --working-dir=$PATH_REMOTE --no-dev --optimize-autoloader"

# Move Sqlite
#ssh -i "$SSH_KEY" "$SSH_USER@$SSH_HOST" "mv $PATH_REMOTE/db.sqlite ../db.sqlite"
#chmod 644 ../db.sqlite .env && \

echo "Deployment completed successfully!"