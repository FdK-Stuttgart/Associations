<?php
/**
 * Returns the list of associations.
 */
require '../database.php';

function cmp($a, $b)
{
    return strcmp($a['orderIndex'], $b['orderIndex']);
}

$associations = [];

$sql = "SELECT
            associations.id AS associationId,
            images.id AS imageId,
            links.id AS linkId,
            socialmedia.id AS socialMediaId,
            contacts.id AS contactId,
            associations.name AS name,
            shortName,
            lat,
            lng,
            addressLine1,
            addressLine2,
            addressLine3,
            street,
            postcode,
            city,
            country,
            goals_format,
            goals_text,
            activities_format,
            activities_text,
            activityList,
            districtList,
            contacts.name AS contactName,
			poBox,
            phone,
            mail,
            fax,
            contacts.orderIndex AS contactOrderIndex,
            links.url AS linkUrl,
            links.linkText AS linkLinkText,
            links.orderIndex AS linkOrderIndex,
            socialmedia.platform AS socialMediaPlatform,
            socialmedia.url AS socialMediaUrl,
            socialmedia.linkText AS socialMediaLinkText,
            socialmedia.orderIndex AS socialMediaOrderIndex,
            images.url AS imageUrl,
            images.altText AS imageAltText,
            images.orderIndex AS imageOrderIndex
        FROM
            `associations`
        LEFT JOIN(
            SELECT
                *
            FROM
                `images`
            WHERE
                images.current = 1
        ) AS images
        ON
            `images`.`associationId` = `associations`.`id`
        LEFT JOIN(
            SELECT
                *
            FROM
                `links`
            WHERE
                links.current = 1
        ) AS links
        ON
            `links`.`associationId` = `associations`.`id`
        LEFT JOIN(
            SELECT
                *
            FROM
                `socialmedia`
            WHERE
                socialmedia.current = 1
        ) AS socialmedia
        ON
            `socialmedia`.`associationId` = `associations`.`id`
        LEFT JOIN(
            SELECT
                *
            FROM
                `contacts`
            WHERE
                contacts.current = 1
        ) AS contacts
        ON
            `contacts`.`associationId` = `associations`.`id`
        WHERE
            associations.current = 1
        ORDER BY
            associationId";

$contained = [];

if ($result = mysqli_query($con, $sql)) {
    $j = -1; // index on unique associations
    while ($row = mysqli_fetch_assoc($result)) {
        $id = $row['associationId'];

        if (!(in_array($id, $contained))) {
            $j++;
            $contained[] = $id;
            $containedImages = [];
            $containedLinks = [];
            $containedSocialMedia = [];
            $containedContacts = [];

            $associations[$j]['id'] = $id;
            $associations[$j]['name'] = $row['name'];
            $associations[$j]['shortName'] = $row['shortName'];
            $associations[$j]['lat'] = $row['lat'];
            $associations[$j]['lng'] = $row['lng'];
            $associations[$j]['addressLine1'] = $row['addressLine1'];
            $associations[$j]['addressLine2'] = $row['addressLine2'];
            $associations[$j]['addressLine3'] = $row['addressLine3'];
            $associations[$j]['street'] = $row['street'];
            $associations[$j]['postcode'] = $row['postcode'];
            $associations[$j]['city'] = $row['city'];
            $associations[$j]['country'] = $row['country'];
            $associations[$j]['activities']['format'] = $row['activities_format'];
            $associations[$j]['activities']['text'] = $row['activities_text'];
            $associations[$j]['goals']['format'] = $row['goals_format'];
            $associations[$j]['goals']['text'] = $row['goals_text'];
            unset($associations[$j]['activities_format']);
            unset($associations[$j]['activities_text']);
            unset($associations[$j]['goals_format']);
            unset($associations[$j]['goals_text']);

            $associations[$j]['activityList'] = $row['activityList'];
            $associations[$j]['districtList'] = $row['districtList'];

            $associations[$j]['images'] = array();
            $associations[$j]['links'] = array();
            $associations[$j]['socialMedia'] = array();
            $associations[$j]['contacts'] = array();
        }

        $imageId = $row['imageId'];
        $linkId = $row['linkId'];
        $socialMediaId = $row['socialMediaId'];
        $contactId = $row['contactId'];

        if ($imageId != null && !(in_array($imageId, $containedImages))) {
            $containedImages[] = $imageId;

            $image = [];
            $image['id'] = $imageId;
            $image['url'] = $row['imageUrl'];
            $image['altText'] = $row['imageAltText'];
            $image['associationId'] = $id;
            $image['orderIndex'] = $row['imageOrderIndex'];

            $associations[$j]['images'][] = $image;
        }

        usort($associations[$j]['images'], "cmp");

        if ($linkId != null && !(in_array($linkId, $containedLinks))) {
            $containedLinks[] = $linkId;

            $link = [];
            $link['id'] = $linkId;
            $link['url'] = $row['linkUrl'];
            $link['linkText'] = $row['linkLinkText'];
            $link['associationId'] = $id;
            $link['orderIndex'] = $row['linkOrderIndex'];

            $associations[$j]['links'][] = $link;
        }

        usort($associations[$j]['links'], "cmp");

        if ($socialMediaId != null && !(in_array($socialMediaId, $containedSocialMedia))) {
            $containedSocialMedia[] = $socialMediaId;

            $socialMedia = [];
            $socialMedia['id'] = $socialMediaId;
            $socialMedia['url'] = $row['socialMediaUrl'];
            $socialMedia['linkText'] = $row['socialMediaLinkText'];
            $socialMedia['platform'] = $row['socialMediaPlatform'];
            $socialMedia['associationId'] = $id;
            $socialMedia['orderIndex'] = $row['socialMediaOrderIndex'];

            $associations[$j]['socialMedia'][] = $socialMedia;
        }

        usort($associations[$j]['socialMedia'], "cmp");

        if ($contactId != null && !(in_array($contactId, $containedContacts))) {
            $containedContacts[] = $contactId;

            $contact = [];
            $contact['id'] = $contactId;
            $contact['name'] = $row['contactName'];
			$contact['poBox'] = $row['poBox'];
            $contact['phone'] = $row['phone'];
			$contact['fax'] = $row['fax'];
            $contact['mail'] = $row['mail'];
            $contact['associationId'] = $id;
            $contact['orderIndex'] = $row['contactOrderIndex'];

            $associations[$j]['contacts'][] = $contact;
        }

        usort($associations[$j]['contacts'], "cmp");
    }

    echo json_encode($associations);
} else {
    http_response_code(404);
}