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
    $title = $_POST['title'];
    $description = $_POST['description'];
    if ($db->saveMetadata($title, $description)) {
        header('Location: index.php');
        exit;
    } else {
        $error = "Failed to save metadata. Please try again.";
    }
}

$metadata = $db->getMetadata();
?>

<!DOCTYPE html>
<html lang="pl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edycja metadanych</title>
</head>
<body>
    <h1>Edycja metadanych</h1>
    <?php if ($error): ?>
        <p style="color: red;"><?php echo htmlspecialchars($error); ?></p>
    <?php endif; ?>
    <form method="POST">
        <label for="title">Tytuł:</label>
        <input type="text" id="title" name="title" value="<?php echo htmlspecialchars($metadata['title']); ?>" required><br>
        <label for="description">Opis:</label>
        <textarea id="description" name="description" rows="4" cols="50" required><?php echo htmlspecialchars($metadata['description']); ?></textarea><br>
        <input type="submit" value="Zapisz metadane">
    </form>
    <a href="index.php">Powrót do edytora</a>
</body>
</html>