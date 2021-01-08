<?php
/**
 * Returns the list of activity options
 */
require '../database.php';

$activity_options = [];

$sql = "SELECT label, value FROM `activities_options` ORDER BY value";

if ($result = mysqli_query($con, $sql)) {
    $i = 0;
    while ($row = mysqli_fetch_assoc($result)) {
        $activity_options[$i]['label'] = $row['label'];
        $activity_options[$i]['value'] = intval($row['value']);
        $i++;
    }
    echo json_encode($activity_options);
} else {
    echo mysqli_error($con) . ": " . mysqli_error($con) . "\n";
    http_response_code(404);
}