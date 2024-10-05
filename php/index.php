<?php

require_once __DIR__ . '/config.php';
require_once __DIR__ . '/src/Database.php';
require_once __DIR__ . '/src/Markdown.php';
global $DB_PATH;
global $title;
global $htmlContent;

//var_dump($DB_PATH);
session_start();

$db = new Database($DB_PATH);
$markdown = new Markdown();
$content = $db->getContent();
$htmlContent = $markdown->parse($content);

?>

<!DOCTYPE html>
<html lang="pl">
<head>
    <?php require_once __DIR__ . '/head.php'; ?>
</head>
<body>

<!--<div class="tophead">-->
<!--    <h1>--><?php //echo $title; ?><!--</h1>-->
<!--</div>-->
<div class="content">
    <div class="markdown">
        <?php echo $htmlContent; ?>
    </div>
</div>
<?php
// var_dump($_SESSION);

if (isset($_SESSION['logged_in']) && $_SESSION['logged_in'] === true): ?>
    <div class="footer menu">
        <a href="edit.php">Edytuj treść</a> |
        <a href="meta.php">Edytuj metadane</a> |
    </div>
    <div class="footer menu">
        <a href="logout.php">Wyloguj się</a>
    </div>
<?php else: ?>
    <div class="footer menu">
        <a href="login.php">Zaloguj się</a>
    </div>
<?php endif; ?>
</body>
</html>