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

# Run npm install on the remote server
#echo "ssh -i \"$SSH_KEY\" \"$SSH_USER@$SSH_HOST\" \"cd $PATH_REMOTE && composer install --no-dev --optimize-autoloader\""
#ssh -i "$SSH_KEY" "$SSH_USER@$SSH_HOST" "cd $PATH_REMOTE && composer install --no-dev --optimize-autoloader"
ssh -i "$SSH_KEY" "$SSH_USER@$SSH_HOST" "which composer"
ssh -i "$SSH_KEY" "$SSH_USER@$SSH_HOST" "which php"
ssh -i "$SSH_KEY" "$SSH_USER@$SSH_HOST" "/usr/local/bin/composer install --working-dir=$PATH_REMOTE --no-dev --optimize-autoloader"
ssh -i "$SSH_KEY" "$SSH_USER@$SSH_HOST" "bash --login -c '/usr/local/bin/composer status'"
ssh -i "$SSH_KEY" "$SSH_USER@$SSH_HOST" "bash --login -c '/usr/local/bin/composer status'"
