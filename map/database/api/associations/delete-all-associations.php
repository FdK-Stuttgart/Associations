<?php

/**
 * Deletes i.e. deactivates all associations.
 */
require '../auth.php';

// $auth = authorize($con);
// if (!$auth) {
//     lg("ERR: delete-all-associations: authorize: '$auth'");
//     return http_response_code(401);
// }

$sql = "UPDATE associations SET current = 0;";

if (mysqli_query($con, $sql)) {
    http_response_code(204);
} else {
    return http_response_code(422);
}
