<?php

require_once __DIR__ . '/../vendor/autoload.php';

use Dotenv\Dotenv;

class Publisher
{
    public function publish()
    {
        $dotenv = Dotenv\Dotenv::createImmutable(__DIR__ . '/..');
        $dotenv->load();

        $ssh_host = $_ENV['SSH_HOST'];
        $ssh_user = $_ENV['SSH_USER'];
        $ssh_key = $_ENV['SSH_KEY'];
        $remote_path = $_ENV['REMOTE_PATH'];

        $command = "scp -i $ssh_key -r ../public/* $ssh_user@$ssh_host:$remote_path";
        exec($command, $output, $return_var);

        if ($return_var === 0) {
            echo "Publikacja zakończona sukcesem.";
        } else {
            echo "Błąd podczas publikacji: " . implode("\n", $output);
        }
    }
}