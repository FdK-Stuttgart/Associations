<?php
/**
 * Creates or updates the activity options.
 */
require '../database.php';

$postdata = file_get_contents("php://input");

function endsWith($haystack, $needle)
{
    $length = strlen($needle);
    if (!$length) {
        return true;
    }
    return substr($haystack, -$length) === $needle;
}

if (isset($postdata) && !empty($postdata)) {
    $request = json_decode($postdata);

    // Update.
    $sql = "DELETE FROM activities_options; 

            ";

    $sql .= "INSERT INTO activities_options (value, label) VALUES";

    foreach ($request as $i => $item) {

        $label = '';
        $value = -1;

        foreach ($item as $k => $v) {
            if ($k == 'label') {
                $label = $v;
            }

            if ($k == 'value') {
                $value = $v;
            }
        }
        if ($label != '' && $value != -1) {
            $value = intval($value);
            $label = mysqli_real_escape_string($con, trim($label));
            $sql .= "($value, '$label'),";
            continue;
        }
        $sql .= "('$label', $value),";
    }

    if (endsWith($sql, ',')) {
        $sql = substr($sql, 0, -1);
        $sql .= ';';
    }

    if (mysqli_multi_query($con, $sql)) {
        do {

            if ($result = mysqli_store_result($con)) {
                while ($row = mysqli_fetch_row($result)) {
                    printf("%s\n", $row[0]);
                }
                mysqli_free_result($result);
            }

            if (mysqli_more_results($con)) {
                printf("-----------------\n");
            }
        } while (mysqli_next_result($con));

        http_response_code(204);

    } else {

        echo $sql;

        echo mysqli_error($con) . ": " . mysqli_error($con) . "\n";
        return http_response_code(422);

    }
}