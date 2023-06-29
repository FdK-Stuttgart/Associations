<?php
/**
 * Creates an association.
 */
require '../auth.php';

$auth = authorize($con);
if (!$auth) {
    lg("ERR: create-association: authorize: '$auth'");
    return http_response_code(401);
}

$postdata = file_get_contents("php://input");

if (isset($postdata) && !empty($postdata)) {
    $associations = json_decode($postdata);
    lg("INF: Inserting ".count($associations)." associations...");
    foreach ($associations as $association) {
        // Validate.
        if (trim($association->id) == null
            || strlen(trim($association->id)) != 36
            || trim($association->name) == ''
            || $association->name == null
            || $association->lat == null
            || $association->lng == null) {
            return http_response_code(400);
        }

        // Sanitize.
        $id = mysqli_real_escape_string($con, trim($association->id));
        $name = mysqli_real_escape_string($con, trim($association->name));
        $shortName = mysqli_real_escape_string($con, trim($association->shortName));
        $lat = mysqli_real_escape_string($con, trim($association->lat));
        $lng = mysqli_real_escape_string($con, trim($association->lng));
        $addressLine1 = mysqli_real_escape_string($con, trim($association->addressLine1));
        $addressLine2 = mysqli_real_escape_string($con, trim($association->addressLine2));
        $addressLine3 = mysqli_real_escape_string($con, trim($association->addressLine3));
        $street = mysqli_real_escape_string($con, trim($association->street));
        $postcode = mysqli_real_escape_string($con, trim($association->postcode));
        $city = mysqli_real_escape_string($con, trim($association->city));
        $country = mysqli_real_escape_string($con, trim($association->country));
        $goals_format = mysqli_real_escape_string($con, trim($association->goals->format));
        $goals_text = mysqli_real_escape_string($con, trim($association->goals->text));
        $activities_format = mysqli_real_escape_string($con, trim($association->activities->format));
        $activities_text = mysqli_real_escape_string($con, trim($association->activities->text));
        $activityList = json_encode($association->activityList, JSON_UNESCAPED_UNICODE);
        $districtList = json_encode($association->districtList, JSON_UNESCAPED_UNICODE);

        $contacts = $association->contacts;
        $links = $association->links;
        $socialMedia = $association->socialMedia;
        $images = $association->images;

        // Update.
        $sql = "INSERT INTO associations SET id = '$id',
                                       name = '$name',
                                       shortName = '$shortName',
                                       lat = $lat,
                                       lng = $lng,
                                       addressLine1 = '$addressLine1',
                                       addressLine2 = '$addressLine2',
                                       addressLine3 = '$addressLine3',
                                       street = '$street',
                                       postcode = '$postcode',
                                       city = '$city',
                                       country = '$country',
                                       goals_format = '$goals_format',
                                       goals_text = '$goals_text',
                                       activities_format = '$activities_format',
                                       activities_text = '$activities_text',
                                       districtList = '$districtList',
                                       activityList = '$activityList',
                                       current = 1
                ON DUPLICATE KEY UPDATE
                                       name = '$name',
                                       shortName = '$shortName',
                                       lat = $lat,
                                       lng = $lng,
                                       addressLine1 = '$addressLine1',
                                       addressLine2 = '$addressLine2',
                                       addressLine3 = '$addressLine3',
                                       street = '$street',
                                       postcode = '$postcode',
                                       city = '$city',
                                       country = '$country',
                                       goals_format = '$goals_format',
                                       goals_text = '$goals_text',
                                       activities_format = '$activities_format',
                                       activities_text = '$activities_text',
                                       districtList = '$districtList',
                                       activityList = '$activityList',
                                       current = 1;";

        $sql .= "\n\nUPDATE contacts SET current = 0 WHERE associationId = '$id';";

        if ($contacts != null) {
            $index = 0;
            foreach ($contacts as $i => $contact) {
                $contactId = mysqli_real_escape_string($con, trim($contact->id));
                $contactName = mysqli_real_escape_string($con, trim($contact->name));
                $poBox = mysqli_real_escape_string($con, trim($contact->poBox));
                $phone = mysqli_real_escape_string($con, trim($contact->phone));
                $mail = mysqli_real_escape_string($con, trim($contact->mail));
                $fax = mysqli_real_escape_string($con, trim($contact->fax));
                $associationId = $id;

                $sql .= "\n\nINSERT INTO contacts SET id = '$contactId',
                                 name = '$contactName',
                                 poBox = '$poBox',
                                 phone = '$phone',
                                 mail = '$mail',
                              fax = '$fax',
                                 associationId = '$id',
                                 orderIndex = $index,
                                 current = 1
                         ON DUPLICATE KEY UPDATE
                                 name = '$contactName',
                                 poBox = '$poBox',
                                 phone = '$phone',
                                 mail = '$mail',
                              fax = '$fax',
                                 associationId = '$id',
                                 orderIndex = $index,
                                 current = 1;";

                $index++;
            }
        }

        $sql .= "\n\nUPDATE images SET current = 0 WHERE associationId = '$id';";

        if ($images != null) {
            $index = 0;
            foreach ($images as $i => $image) {
                $imageId = mysqli_real_escape_string($con, trim($image->id));
                $url = mysqli_real_escape_string($con, trim($image->url));
                $altText = mysqli_real_escape_string($con, trim($image->altText));
                $associationId = $id;

                $sql .= "\n\nINSERT INTO images SET id = '$imageId',
                                        url = '$url',
                                        altText = '$altText',
                                        associationId = '$id',
                                        orderIndex = $index,
                                        current = 1
                         ON DUPLICATE KEY UPDATE
                                        url = '$url',
                                        altText = '$altText',
                                        associationId = '$id',
                                        orderIndex = $index,
                                        current = 1;";

                $index++;
            }
        }

        $sql .= "\n\nUPDATE links SET current = 0 WHERE associationId = '$id';";

        if ($links != null) {
            $index = 0;
            foreach ($links as $i => $link) {
                $linkId = mysqli_real_escape_string($con, trim($link->id));
                $url = mysqli_real_escape_string($con, trim($link->url));
                $linkText = mysqli_real_escape_string($con, trim($link->linkText));
                $associationId = $id;

                $sql .= "\n\nINSERT INTO links SET id = '$linkId',
                                       url = '$url',
                                       linkText = '$linkText',
                                       associationId = '$id',
                                       orderIndex = $index,
                                       current = 1
                          ON DUPLICATE KEY UPDATE
                                       url = '$url',
                                       linkText = '$linkText',
                                       associationId = '$id',
                                       orderIndex = $index,
                                       current = 1;";
                $index++;
            }
        }

        $sql .= "\n\nUPDATE socialmedia SET current = 0 WHERE associationId = '$id';";

        if ($socialMedia != null) {
            $index = 0;
            foreach ($socialMedia as $i => $socialMediaEntry) {
                $socialMediaId = mysqli_real_escape_string($con, trim($socialMediaEntry->id));
                $platform = mysqli_real_escape_string($con, trim($socialMediaEntry->platform));
                $url = mysqli_real_escape_string($con, trim($socialMediaEntry->url));
                $linkText = mysqli_real_escape_string($con, trim($socialMediaEntry->linkText));
                $associationId = $id;

                $sql .= "\n\nINSERT INTO socialmedia SET id = '$socialMediaId',
                                              platform = '$platform',
                                              url = '$url',
                                              linkText = '$linkText',
                                              associationId = '$id',
                                              orderIndex = $index,
                                              current = 1
                          ON DUPLICATE KEY UPDATE
                                              platform = '$platform',
                                              url = '$url',
                                              linkText = '$linkText',
                                              associationId = '$id',
                                              orderIndex = $index,
                                              current = 1;";
                $index++;
            }
        }

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
    }
    lg("DBG: Importing ".$associations." associations... done");
}
