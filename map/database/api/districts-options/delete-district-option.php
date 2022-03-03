<?php

/**
 * Deletes one district option by value.
 */
require '../auth.php';

$value = $_GET['value'] != null && strlen(trim($_GET['value'])) == 36 ? mysqli_real_escape_string($con, trim($_GET['value'])) : false;

if (!$value) {
    return http_response_code(400);
}

// Delete.
$sql = "UPDATE districts SET current = 0 WHERE value ='{$value}' LIMIT 1";

if (mysqli_query($con, $sql)) {
    http_response_code(204);
} else {
    return http_response_code(422);
}