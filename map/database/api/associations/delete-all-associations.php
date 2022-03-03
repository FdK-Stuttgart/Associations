<?php

/**
 * Deletes i.e. deactivates all associations.
 */
require '../database.php';

$auth = authorize($con);
if (!$auth) {
    $log_file = "/var/log/php-server.log";
    error_log("delete-all-associations Not authorized \n", 3, $log_file);
    return http_response_code(401);
}

$sql = "UPDATE associations SET current = 0;";

if (mysqli_query($con, $sql)) {
    http_response_code(204);
} else {
    return http_response_code(422);
}
