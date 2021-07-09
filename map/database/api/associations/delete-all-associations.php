<?php

/**
 * Deletes one association by ID.
 */
require '../database.php';

// Delete.
$sql = "UPDATE associations SET current = 0;";

if (mysqli_query($con, $sql)) {
    http_response_code(204);
} else {
    return http_response_code(422);
}
