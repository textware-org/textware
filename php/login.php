<?php

require_once __DIR__ . '/config.php';
require_once __DIR__ . '/src/Auth.php';
global $DB_PATH;
global $title;
global $htmlContent;

$title = 'Logowanie';

session_start();

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $username = $_POST['username'];
    $password = $_POST['password'];

    $auth = new Auth($DB_PATH);
    $error = "Nieprawidłowy login lub hasło";

    if ($auth->login($username, $password)) {
        $_SESSION['logged_in'] = true;
        $_SESSION['username'] = $username;
        header('Location: edit.php');
        exit;
    }
}
?>

<!DOCTYPE html>
<html lang="pl">
<head>
    <?php require_once __DIR__ . '/head.php'; ?>
</head>
<body class="flex items-center justify-center min-h-screen bg-gray-100">
<div class="container">
    <div class="tophead">
        <h1><?php echo $title; ?></h1>
    </div>
    <div class="content">
        <?php if (isset($error)): ?>
            <p style="color: red;"><?php echo $error; ?></p>
        <?php endif; ?>
    </div>
    <div class="content">
        <form method="POST">
            <div class="form-group">
                <label for="username">Login:</label>
                <input type="text" id="username" name="username" required><br>
                <label for="password">Hasło:</label>
                <input type="password" id="password" name="password" required><br>
            </div>
            <div class="footer menu">
                <input type="submit" value="Zaloguj">
            </div>
        </form>
    </div>
</div>
</body>
</html>