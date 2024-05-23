<?php
/**
 * Returns settings of the map.
 */
require 'database.php';

$mapSettings = [];

$sql = "SELECT center_latitude, center_longitude, zoom_level
        FROM
            `map_settings`
        WHERE
            map_settings.current = 1";

if ($result = mysqli_query($con, $sql)) {
    $i = 0;
    while ($row = mysqli_fetch_assoc($result)) {
        $mapSettings[$i]['center_latitude'] = $row['center_latitude'];
        $mapSettings[$i]['center_longitude'] = $row['center_longitude'];
        $mapSettings[$i]['zoom_level'] = $row['zoom_level'];
        $i++;
    }
    echo json_encode($mapSettings);
} else {
    http_response_code(404);
}
