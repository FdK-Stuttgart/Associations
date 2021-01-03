<?php

/**
 * Deletes one association by ID.
 */
require '../database.php';

$id = $_GET['id'] != null && strlen(trim($_GET['id'])) == 36 ? mysqli_real_escape_string($con, trim($_GET['id'])) : false;

if (!$id) {
    return http_response_code(400);
}

// Delete.
$sql = "DELETE FROM associations WHERE id ='{$id}' LIMIT 1";

if (mysqli_query($con, $sql)) {
    http_response_code(204);
} else {
    return http_response_code(422);
}