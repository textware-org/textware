#!/bin/bash

# Load environment variables
set -a
source ../.env.db
set +a

((!$#)) && echo No arguments supplied! && exit 1

DB_PATH=$1
#DB_PATH="../../db.sqlite"
rm $DB_PATH
# Create SQLite database
sqlite3 $DB_PATH < queries/create_tables.sql

# Hash the password
HASHED_PASSWORD=$(echo -n "$DB_PASSWORD" | sha256sum | awk '{print $1}')

# Insert initial data
sqlite3 $DB_PATH <<EOF
INSERT OR IGNORE INTO users (username, password) VALUES ('$DB_USER', '$HASHED_PASSWORD');
INSERT INTO content (markdown) VALUES ('# Welcome to Markdown Editor

This is your initial content. You can edit this in the editor.');
INSERT INTO metadata (title, description) VALUES ('My Markdown Site', 'A simple markdown editor and publisher');
EOF

echo "Database initialized successfully."