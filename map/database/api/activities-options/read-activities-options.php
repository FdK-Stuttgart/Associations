<?php
/**
 * Returns the list of activity options
 */
require '../database.php';

$activity_options = [];

$sql = "SELECT 	activities.value AS value, 
                activities.label AS label, 
                activities.category AS category, 
                upper.label AS categoryLabel,
                activities.orderIndex AS orderIndex
        FROM activities 
            LEFT JOIN activities AS upper 
                ON activities.category = upper.value
        ORDER BY orderIndex, categoryLabel, label";

if ($result = mysqli_query($con, $sql)) {
    $i = 0;
    while ($row = mysqli_fetch_assoc($result)) {
        $activity_options[$i]['label'] = $row['label'];
        $activity_options[$i]['value'] = $row['value'];
		$activity_options[$i]['category'] = $row['category'];
        $activity_options[$i]['categoryLabel'] = $row['categoryLabel'];
        $activity_options[$i]['orderIndex'] = intval($row['orderIndex']);
        $i++;
    }
    echo json_encode($activity_options);
} else {
    echo mysqli_error($con) . ": " . mysqli_error($con) . "\n";
    http_response_code(404);
}