<?php
/**
 * Returns the list of district options
 */
require '../database.php';

$district_options = [];

$sql = "SELECT 	districts.value AS value, 
                districts.label AS label, 
                districts.category AS category, 
                upper.label AS categoryLabel 
        FROM districts 
            LEFT JOIN districts AS upper 
                ON districts.category = upper.value
        ORDER BY categoryLabel, label";

if ($result = mysqli_query($con, $sql)) {
    $i = 0;
    while ($row = mysqli_fetch_assoc($result)) {
        $district_options[$i]['label'] = $row['label'];
        $district_options[$i]['value'] = $row['value'];
		$district_options[$i]['category'] = $row['category'];
        $district_options[$i]['categoryLabel'] = $row['categoryLabel'];
        $i++;
    }
    echo json_encode($district_options);
} else {
    echo mysqli_error($con) . ": " . mysqli_error($con) . "\n";
    http_response_code(404);
}