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

# Set configuration file path from command line argument, if provided.
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
    echo "Missing required environment variables: $SSH_HOST,$SSH_USER,$SSH_KEY,$PATH_REMOTE Please check your $CONFIG file."
    exit 1
fi

# Clear existing sessions**:
ssh-add -D

echo "ssh-copy-id -i $SSH_KEY $SSH_USER@$SSH_HOST"
echo "ssh -i $SSH_KEY $SSH_USER@$SSH_HOST"
#ssh-copy-id -i "$SSH_KEY" "$SSH_USER@$SSH_HOST"
#ssh -i "$SSH_KEY" "$SSH_USER@$SSH_HOST"

# Append the configuration to ~/.ssh/config
echo -e "\nHost $hostname" >> ~/.ssh/config
echo "    IdentityFile $private_key" >> ~/.ssh/config

Host softreck.dev
	IdentityFile ~/.ssh/id_rsa
	IdentitiesOnly yes
