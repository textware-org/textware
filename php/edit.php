<?php

require_once __DIR__ . '/config.php';
require_once __DIR__ . '/src/Auth.php';
require_once __DIR__ . '/src/Database.php';
global $DB_PATH;

session_start();

if (!isset($_SESSION['logged_in']) || $_SESSION['logged_in'] !== true) {
    header('Location: login.php');
    exit;
}

$db = new Database($DB_PATH);

$error = null;
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $newContent = $_POST['markdown'];
    $error = "Failed to save content. Please try again.";

    if ($db->saveContent($newContent)) {
        header('Location: edit.php');
        exit;
    }
}

$content = $db->getContent();
?>

<!DOCTYPE html>
<html lang="pl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edytor Markdown</title>
</head>
<body>
    <h1>Edytor Markdown</h1>
    <?php if ($error): ?>
        <p style="color: red;"><?php echo htmlspecialchars($error); ?></p>
    <?php endif; ?>
    <form action="edit.php" method="POST">
        <textarea name="markdown" rows="20" cols="80"><?php echo htmlspecialchars($content); ?></textarea>
        <br>
        <input type="submit" value="Zapisz">
    </form>
    <a href="index.php">Powrót do podglądu</a>
</body>
</html>