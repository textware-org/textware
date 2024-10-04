<?php
require_once __DIR__ . '/config.php';
require_once __DIR__ . '/src/Database.php';
require_once __DIR__ . '/src/Markdown.php';
#var_dump($DB_PATH);
session_start();

$db = new Database($DB_PATH);
$markdown = new Markdown();

$content = $db->getContent();
$htmlContent = $markdown->parse($content);

// Fetch metadata
$metadata = $db->getMetadata();
$title = htmlspecialchars($metadata['title']);
$description = htmlspecialchars($metadata['description']);
?>

<!DOCTYPE html>
<html lang="pl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?php echo $title; ?></title>
    <meta name="description" content="<?php echo $description; ?>">
</head>
<body>
    <h1><?php echo $title; ?></h1>
    <div id="content">
        <?php echo $htmlContent; ?>
    </div>
    <?php
    // var_dump($_SESSION);
    
    if (isset($_SESSION['logged_in']) && $_SESSION['logged_in'] === true): ?>
        <hr>
        <a href="edit.php">Edytuj treść</a> | 
        <a href="meta.php">Edytuj metadane</a> | 
        <a href="logout.php">Wyloguj się</a>
    <?php else: ?>
        <hr>
        <a href="login.php">Zaloguj się</a>
    <?php endif; ?>
</body>
</html>