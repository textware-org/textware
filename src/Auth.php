<?php
require_once __DIR__ . '/../vendor/autoload.php';

use Dotenv\Dotenv;

class Auth {
    private $db;
    private $DB_PATH;

    public function __construct($DB_PATH) {
        $this->DB_PATH = $DB_PATH;
        try {
            #echo($this->DB_PATH);
            if (!file_exists($this->DB_PATH)) {
                file_put_contents($this->DB_PATH, '');
                chmod($this->DB_PATH, 0666);
            }
            $this->db = new SQLite3($this->DB_PATH, SQLITE3_OPEN_READWRITE | SQLITE3_OPEN_CREATE);
            $this->db->enableExceptions(true);
        } catch (Exception $e) {
            if ($_ENV['DEBUG'] === 'true') {
                error_log("Database connection failed: " . $e->getMessage());
                error_log("Database path: " . $this->DB_PATH);
                error_log("File permissions: " . substr(sprintf('%o', fileperms($this->DB_PATH)), -4));
                error_log("Current user: " . exec('whoami'));
                die("Database connection failed: " . $e->getMessage());
            } else {
                die("Database connection failed. Please check the error log.");
            }
        }
    }

    public function login($username, $password) {
        var_dump($username, $password);
        $db = new SQLite3($this->DB_PATH);
        $stmt = $db->prepare('SELECT * FROM users WHERE username = :username AND password = :password');
        $stmt->bindValue(':username', $username, SQLITE3_TEXT);
        $stmt->bindValue(':password', hash('sha256', $password), SQLITE3_TEXT);
        $result = $stmt->execute();
        $user = $result->fetchArray(SQLITE3_ASSOC);
        return $user !== false;
    }
}