<?php

/**
 * Deletes one association by ID.
 */
require '../auth.php';

$auth = authorize($con);
if (!$auth) {
    lg("ERR: delete-association: authorize: '$auth'");
    return http_response_code(401);
}

function getPrm($prm, $con) {
    $val = $_GET[$prm];
    if ($val != null) {
        return mysqli_real_escape_string($con, trim($val));
    }
    else {
        lg("ERR: getPrm; prm: '$prm'");
        return false;
    }
}

$id = getPrm('id', $con);
if (!$id || strlen($id) != 36) {
    return http_response_code(400);
}

// Delete.
$sql = "UPDATE associations SET current = 0 WHERE id ='{$id}' LIMIT 1;
        UPDATE contacts SET current = 0 WHERE associationId = '{$id}';
        UPDATE images SET current = 0 WHERE associationId = '{$id}';
        UPDATE links SET current = 0 WHERE associationId = '{$id}';
        UPDATE socialmedia SET current = 0 WHERE associationId = '{$id}';";

if (mysqli_multi_query($con, $sql)) {
    do {
        if ($result = mysqli_store_result($con)) {
            while ($row = mysqli_fetch_row($result)) {
                printf("%s\n", $row[0]);
            }
            mysqli_free_result($result);
        }
    } while (mysqli_more_results($con) && mysqli_next_result($con));

    http_response_code(204);
} else {
    echo mysqli_error($con) . ": " . mysqli_error($con) . "\n";
    return http_response_code(422);
}
