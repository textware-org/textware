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



# Set correct permissions on the remote server
ssh -i "$SSH_KEY" "$SSH_USER@$SSH_HOST" "cd $PATH_REMOTE && \
    chmod 644 .env && \
    find . -type d -exec chmod 755 {} \; && \
    find . -type f -exec chmod 644 {} \; && \
    chmod 755 *.php"

# Remove the temporary directory
#rm -rf "$TEMP_DIR/src"

#rm -rf "$TEMP_DIR/*.php"
ssh -i "$SSH_KEY" "$SSH_USER@$SSH_HOST" "cd $PATH_REMOTE && \
    chown -R $FS_USER:$FS_GROUP ."

ssh -i "$SSH_KEY" "$SSH_USER@$SSH_HOST" "cd $PATH_REMOTE/../ && \
    chown $FS_USER:$FS_GROUP db.sqlite"
