<?php

// Create SQLite database
$db = new SQLite3('../db.sqlite');

// Read and execute SQL queries
$createTablesSQL = file_get_contents(__DIR__ . '/queries/create_tables.sql');
$insertInitialDataSQL = file_get_contents(__DIR__ . '/queries/insert_initial_data.sql');

$db->exec($createTablesSQL);
$db->exec($insertInitialDataSQL);

echo "Database initialized successfully.\n";