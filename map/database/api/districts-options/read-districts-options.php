<?php
/**
 * Returns the list of district options
 */
require '../database.php';

$district_options = [];

$sql = "SELECT label, value FROM `districts_options` ORDER BY value";

if ($result = mysqli_query($con, $sql)) {
    $i = 0;
    while ($row = mysqli_fetch_assoc($result)) {
        $district_options[$i]['label'] = $row['label'];
        $district_options[$i]['value'] = intval($row['value']);
        $i++;
    }
    echo json_encode($district_options);
} else {
    echo mysqli_error($con) . ": " . mysqli_error($con) . "\n";
    http_response_code(404);
}