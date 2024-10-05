<?php

require_once __DIR__ . '/config.php';
require_once __DIR__ . '/src/Auth.php';
require_once __DIR__ . '/src/Database.php';
global $DB_PATH;
global $title;
global $htmlContent;
$title = 'Edytor Markdown';

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
    <?php require_once __DIR__ . '/head.php'; ?>
</head>
<body>
<div class="tophead">
    <h1><?php echo $title; ?></h1>
</div>
<div class="content">
    <?php if ($error): ?>
        <p style="color: red;"><?php echo htmlspecialchars($error); ?></p>
    <?php endif; ?>
</div>
<div class="content">

    <form action="edit.php" method="POST">
        <div class="form-group">
            <textarea name="markdown" rows="20" cols="80"><?php echo htmlspecialchars($content); ?></textarea>
        </div>
        <div class="form-group">
            <input type="submit" value="Zapisz">
        </div>
    </form>
</div>
<div class="footer menu">
    <a href="edit.php">Edytuj treść</a> |
    <a href="meta.php">Edytuj metadane</a> |
    <a href="index.php">Powrót do podglądu</a>
</div>

<div class="footer menu">
    <a href="logout.php">Wyloguj się</a>
</div>
</body>
</html>