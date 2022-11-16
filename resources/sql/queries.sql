-- Place your queries here. Docs available https://www.hugsql.org/

-- :name create-user! :! :n
-- :doc creates a new user record
INSERT INTO users
(id, first_name, last_name, email, pass)
VALUES (:id, :first_name, :last_name, :email, :pass)

-- :name update-user! :! :n
-- :doc updates an existing user record
UPDATE users
SET first_name = :first_name, last_name = :last_name, email = :email
WHERE id = :id

-- :name get-user :? :1
-- :doc retrieves a user record given the id
SELECT * FROM users
WHERE id = :id

-- :name delete-user! :! :n
-- :doc deletes a user record given the id
DELETE FROM users
WHERE id = :id



-- :name read-districts-options :n
-- :doc read districts options
SELECT
  districts.value AS value,
  districts.label AS label,
  districts.category AS category,
  upper.label AS categoryLabel,
  districts.orderIndex AS orderIndex
FROM associations.districts
     LEFT JOIN associations.districts AS upper
         ON districts.category = upper.value
WHERE districts.current = 1
ORDER BY orderIndex, categoryLabel, label



-- :name read-associations :n
-- :doc read all associations
SELECT
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
  associations
LEFT JOIN(
  SELECT * FROM images WHERE images.current = 1
) AS images ON images.associationId = associations.id
LEFT JOIN(
    SELECT * FROM associations.links WHERE links.current = 1
) AS links ON links.associationId = associations.id
LEFT JOIN(
  SELECT * FROM socialmedia WHERE socialmedia.current = 1
) AS socialmedia ON socialmedia.associationId = associations.id
LEFT JOIN(
    SELECT * FROM contacts WHERE contacts.current = 1
) AS contacts ON contacts.associationId = associations.id
WHERE associations.current = 1
  -- When the select is changed evaluate `(reset)` in the REPL of clj
  -- -M:dev:nrepl
-- AND
--       (
--         0 = 1
--       -- The map is focused on 'Forum der Kulturen Stuttgart' so it must by always
--       -- selected, otherwise the map won't work.
--         OR associations.id in ('293b0f91-f109-4b74-ab91-a265834e0897')
--         OR associations.name like 'Afro%'
--       )
ORDER BY associationId


-- :name get-messages :? :
-- :doc restart `lein run` to see changes; select * from activities where label in ('Ausstellungen', 'Turniere')
select * from activities row limit 3

-- ########################################################################################
-- See map/database/api/associations/create-all-associations.php
-- ########################################################################################

-- :name insert-association :! :n
-- :doc create a new association
INSERT INTO associations SET
    id = :id,
    name = :name,
    shortName = :shortName,
    lat = :lat,
    lng = :lng,
    addressLine1 = :addressLine1,
    addressLine2 = :addressLine2,
    addressLine3 = :addressLine3,
    street = :street,
    postcode = :postcode,
    city = :city,
    country = :country,
    goals_format = :goals_format,
    goals_text = :goals_text,
    activities_format = :activities_format,
    activities_text = :activities_text,
    districtList = :districtList,
    activityList = :activityList,
    current = 1
ON DUPLICATE KEY UPDATE
    name = :name,
    shortName = :shortName,
    lat = :lat,
    lng = :lng,
    addressLine1 = :addressLine1,
    addressLine2 = :addressLine2,
    addressLine3 = :addressLine3,
    street = :street,
    postcode = :postcode,
    city = :city,
    country = :country,
    goals_format = :goals_format,
    goals_text = :goals_text,
    activities_format = :activities_format,
    activities_text = :activities_text,
    districtList = :districtList,
    activityList = :activityList,
    current = 1


-- :name update-contact :! :n
-- :doc update contact
UPDATE contacts SET current = 0 WHERE associationId = :id


-- :name insert-contact :! :n
-- :doc insert a new contact
INSERT INTO contacts SET id = :contactId,
    name = :contactName,
    poBox = :poBox,
    phone = :phone,
    mail = :mail,
    fax = :fax,
    associationId = :id,
    orderIndex = :index,
    current = 1
ON DUPLICATE KEY UPDATE
    name = :contactName,
    poBox = :poBox,
    phone = :phone,
    mail = :mail,
    fax = :fax,
    associationId = :id,
    orderIndex = :index,
    current = 1

-- :name update-image :! :n
-- :doc update image
UPDATE images SET current = 0 WHERE associationId = :id

-- :name insert-image :! :n
-- :doc insert a new image
INSERT INTO images SET id = :imageId,
    url = :url,
    altText = :altText,
    associationId = :id,
    orderIndex = :index,
    current = 1
ON DUPLICATE KEY UPDATE
    url = :url,
    altText = :altText,
    associationId = :id,
    orderIndex = :index,
    current = 1

-- :name update-link :! :n
-- :doc update link
UPDATE links SET current = 0 WHERE associationId = :id


-- :name insert-link :! :n
-- :doc insert a new link
INSERT INTO links SET id = :linkId,
    url = :url,
    linkText = :linkText,
    associationId = :id,
    orderIndex = :index,
    current = 1
ON DUPLICATE KEY UPDATE
    url = :url,
    linkText = :linkText,
    associationId = :id,
    orderIndex = :index,
    current = 1

-- :name update-socialmedia :! :n
-- :doc update socialmedia
UPDATE socialmedia SET current = 0 WHERE associationId = :id


-- :name insert-socialmedia :! :n
-- :doc insert a new socialmedia
INSERT INTO socialmedia SET id = :socialMediaId,
    platform = :platform,
    url = :url,
    linkText = :linkText,
    associationId = :id,
    orderIndex = :index,
    current = 1
ON DUPLICATE KEY UPDATE
    platform = :platform,
    url = :url,
    linkText = :linkText,
    associationId = :id,
    orderIndex = :index,
    current = 1
