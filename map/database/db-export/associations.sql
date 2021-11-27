-- phpMyAdmin SQL Dump
-- version 5.0.4
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Erstellungszeit: 27. Nov 2021 um 12:02
-- Server-Version: 10.4.17-MariaDB
-- PHP-Version: 8.0.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Datenbank: `associations`
--

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `activities`
--

CREATE TABLE `activities` (
  `value` varchar(36) NOT NULL,
  `label` varchar(512) NOT NULL,
  `category` varchar(36) DEFAULT NULL,
  `orderIndex` int(11) DEFAULT NULL,
  `current` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Daten für Tabelle `activities`
--

INSERT INTO `activities` (`value`, `label`, `category`, `orderIndex`, `current`) VALUES
('052b4738-3d8b-4ed2-9d07-6e0a8b88b565', 'Feste und Feiern', '903a624c-7655-4941-92c2-fcbce45399da', 2, 1),
('06a381ca-109c-49d1-b6fa-5019b13b9ebf', 'Ausstellungen', '903a624c-7655-4941-92c2-fcbce45399da', 2, 1),
('07dbf630-8ebc-4ee4-9587-ebac31c7bd4f', 'Turniere', 'caee8b37-8686-4f95-a270-b52d9b332ded', 5, 1),
('083ba818-b8dc-4a07-9f03-0f24d28a19aa', 'Muttersprachlicher Musikunterricht', 'a2c72a89-6869-4d2d-9f90-be717537a148', 3, 1),
('0edf9918-1e88-43a3-91aa-a1c8056baa21', 'Stammtische', '903a624c-7655-4941-92c2-fcbce45399da', 2, 1),
('14ffd7d7-7641-4634-a7dd-c4ec824b8cf6', 'Musikwerkstatt', 'a2c72a89-6869-4d2d-9f90-be717537a148', 3, 1),
('191f9550-6dc2-42ef-bd2a-2735f4f7b189', 'Afrikanische Musik', 'a2c72a89-6869-4d2d-9f90-be717537a148', 3, 1),
('19a1edf1-62b1-44d7-9c70-83f8d15c4554', 'Podcast', 'f07a5595-f036-42b6-9d41-abd39896681a', 8, 1),
('1d17d1ab-963c-4d02-a43b-77f9706327fe', 'Jazzdance', 'caee8b37-8686-4f95-a270-b52d9b332ded', 5, 1),
('1eacdec4-6689-4bb7-bff9-b2ec5259f6ac', 'Traditioneller Tanz / Volkstanz', 'caee8b37-8686-4f95-a270-b52d9b332ded', 5, 1),
('20201b37-683d-4e16-ae4f-3c89e63fa689', 'Klassische Musik', 'a2c72a89-6869-4d2d-9f90-be717537a148', 3, 1),
('22c22f18-cec2-4676-9586-370bfd06f35b', 'Soziales und Gesundheit', NULL, 4, 1),
('268e4a5c-e849-4f32-bc15-1e524e0cdefe', 'Hilfsfonds', '22c22f18-cec2-4676-9586-370bfd06f35b', 4, 1),
('278e7a85-5d3e-47a1-8dfe-971bb614e541', 'Elternkurse', 'e1e16992-62cc-4544-ada8-e8ffc02254aa', 1, 1),
('27adab7b-bae1-4562-8e1e-898a37ff4e47', 'Konferenzen', 'e1e16992-62cc-4544-ada8-e8ffc02254aa', 1, 1),
('28cb85c2-989b-413c-bbad-819db341305c', 'Notversorgung', '22c22f18-cec2-4676-9586-370bfd06f35b', 4, 1),
('2cd64db3-f049-4b8f-9d57-cbe86f7e8e52', 'Dichter- und Autorlesungen', '903a624c-7655-4941-92c2-fcbce45399da', 2, 1),
('2ce08d25-dda5-44b5-95ad-d3938bf2245f', 'Empowerment-Angebote', 'e1e16992-62cc-4544-ada8-e8ffc02254aa', 1, 1),
('2e37f150-4703-4c6e-83f2-5e258c99fbdf', 'Trommeln', 'a2c72a89-6869-4d2d-9f90-be717537a148', 3, 1),
('2ffe3540-9b42-4c60-a385-1ad316b61e60', 'Workshops', 'e1e16992-62cc-4544-ada8-e8ffc02254aa', 1, 1),
('31b8ae1d-0a6c-4f61-8ff9-3dfdbdd5276f', 'Tanzdarbietungen', '903a624c-7655-4941-92c2-fcbce45399da', 2, 1),
('329b0c66-9aa9-430c-b81d-55afa3f4286c', 'Bildungsprojekte im Ausland', '22c22f18-cec2-4676-9586-370bfd06f35b', 4, 1),
('333fa33d-34ed-4424-8d43-0b04df745bad', 'Instrumentalunterricht', 'a2c72a89-6869-4d2d-9f90-be717537a148', 3, 1),
('3371be08-fc54-4ab5-847e-43a6aedb73da', 'Lebensmittelverteilung', '22c22f18-cec2-4676-9586-370bfd06f35b', 4, 1),
('33b0cc3d-c898-4f71-974b-61c1b8607ac1', 'Partymusik', 'a2c72a89-6869-4d2d-9f90-be717537a148', 3, 1),
('34539fac-77ee-46d0-a259-fad432a87eb1', 'Veranstaltungsplanung', '77c73324-6b81-4490-94c1-c7c699d75c36', 7, 1),
('345e2349-38e4-4f75-b540-ce5271a16be5', 'Vielfalt', '903a624c-7655-4941-92c2-fcbce45399da', 2, 1),
('34c2338a-0e1a-4625-bea6-fdeb94a5d56a', 'Finanzielle Unterstützung / Förderung von Bildungsangeboten', 'e1e16992-62cc-4544-ada8-e8ffc02254aa', 1, 1),
('37366af3-b522-4a84-b6d8-18654a4af79e', 'Basketball', 'caee8b37-8686-4f95-a270-b52d9b332ded', 5, 1),
('383663f1-7d46-4abe-b865-036e0ce7999d', 'Sportveranstaltungen', 'caee8b37-8686-4f95-a270-b52d9b332ded', 5, 1),
('393be716-0bb3-4034-ad75-c4348b741e85', 'Jazz', 'a2c72a89-6869-4d2d-9f90-be717537a148', 3, 1),
('3d5da784-d4e5-4489-94f5-8de4f253a4a4', 'Gesellschaftliches', '903a624c-7655-4941-92c2-fcbce45399da', 2, 1),
('3de679fc-437e-4fdd-8c60-06f47e23b035', 'Schulveranstaltungen', 'e1e16992-62cc-4544-ada8-e8ffc02254aa', 1, 1),
('41677e42-91e2-44bb-9a52-a68c804e42fc', 'Karriereberatung', '77c73324-6b81-4490-94c1-c7c699d75c36', 7, 1),
('41a338ad-09ae-40bf-8bc2-973a65069c6c', 'Bildende Kunst', '903a624c-7655-4941-92c2-fcbce45399da', 2, 1),
('436d00b9-1c26-4806-a8d1-8f6846a28af8', 'Schulpatenschaften', 'e1e16992-62cc-4544-ada8-e8ffc02254aa', 1, 1),
('451b5a6b-f6c0-42b4-8b38-7ac7c40989ee', 'Traditionelles Essen', 'c181ee05-5662-41f8-a241-0c2001e48359', 6, 1),
('474a8ff3-34f9-4912-94b1-4c84d1304a9d', 'Filmvorführungen, Kino- und Filmfeste', '903a624c-7655-4941-92c2-fcbce45399da', 2, 1),
('4880b108-dd18-4666-a5a6-8d8bc511e18a', 'Reparatur von Instrumenten', 'a2c72a89-6869-4d2d-9f90-be717537a148', 3, 1),
('4ca75fe6-6764-4b6f-a525-abaa9bffa2cf', 'Yoga', 'caee8b37-8686-4f95-a270-b52d9b332ded', 5, 1),
('4cb40078-cd07-4ed3-ad0b-b5710418a949', 'Kinder und Jugendliche', 'e1e16992-62cc-4544-ada8-e8ffc02254aa', 1, 1),
('4d28bfd7-fdf0-46b5-88a7-39165e99a55f', 'Führungen', '903a624c-7655-4941-92c2-fcbce45399da', 2, 1),
('4fdedb59-a2ec-4ce3-a864-9f2ee54de161', 'Tanzveranstaltungen', 'caee8b37-8686-4f95-a270-b52d9b332ded', 5, 1),
('513b09ab-eb2f-4407-805b-44dffae4c4b1', 'Orchester und Ensemble', 'a2c72a89-6869-4d2d-9f90-be717537a148', 3, 1),
('5562fe36-bc8f-465b-ac18-4b5b820fc31b', 'Arbeit mit Menschen mit Behinderung', '22c22f18-cec2-4676-9586-370bfd06f35b', 4, 1),
('5cf4a2a2-30ac-491f-b9ec-3ef8920a52a9', 'Kochkurse', 'c181ee05-5662-41f8-a241-0c2001e48359', 6, 1),
('5da2a926-bafc-4cf6-a690-ebe04aae5efb', 'Sprachkurse und Sprachunterricht', 'e1e16992-62cc-4544-ada8-e8ffc02254aa', 1, 1),
('5e63b584-e7a0-468e-95ae-4efa306bf9bc', 'Tanzkurse und Tanzunterricht', 'caee8b37-8686-4f95-a270-b52d9b332ded', 5, 1),
('5e6bb978-f8a3-4945-8e1f-8a9b21866b04', 'Politik', 'e1e16992-62cc-4544-ada8-e8ffc02254aa', 1, 1),
('6232745b-ae38-4386-8ce9-38181ec03167', 'Straßenfeste', '903a624c-7655-4941-92c2-fcbce45399da', 2, 1),
('62a4abe0-70f7-487a-85ea-ccc9c953dc14', 'Jugendberatung', '77c73324-6b81-4490-94c1-c7c699d75c36', 7, 1),
('67460b3f-e0a0-4047-aeba-8d142f52de8b', 'Karneval', '903a624c-7655-4941-92c2-fcbce45399da', 2, 1),
('6c6dab40-3af5-410c-8866-af397260ab2a', 'Hörbücher', 'f07a5595-f036-42b6-9d41-abd39896681a', 8, 1),
('6d5e911b-b877-468d-9fd9-cd0d015d5170', 'Theaterveranstaltungen', '903a624c-7655-4941-92c2-fcbce45399da', 2, 1),
('71a52ead-7207-4be5-af01-43419524746d', 'Interkulturelle Begegnung', '903a624c-7655-4941-92c2-fcbce45399da', 2, 1),
('7228b82c-5b71-4da7-8e8f-0bff0eb9eed1', 'Zusammenarbeit mit Geflüchteten und Asylbewerber*innen', '22c22f18-cec2-4676-9586-370bfd06f35b', 4, 1),
('722b7ee0-b864-4fdf-9ce8-b85bb1f6c27a', 'Fingerfood', 'c181ee05-5662-41f8-a241-0c2001e48359', 6, 1),
('73dff0c6-2787-41b4-9fff-05d46457fa2c', 'Sprachförderung', 'e1e16992-62cc-4544-ada8-e8ffc02254aa', 1, 1),
('74421701-0b80-4180-b59d-59c86bb74e0f', 'Freiwilligendienste im Ausland', '22c22f18-cec2-4676-9586-370bfd06f35b', 4, 1),
('756a75d5-dce7-4e45-ad4a-961301fe3712', 'MINT', 'e1e16992-62cc-4544-ada8-e8ffc02254aa', 1, 1),
('77c73324-6b81-4490-94c1-c7c699d75c36', 'Beratung', NULL, 7, 1),
('7952ed23-dd78-4c8a-8428-b9b3d59435c4', 'Seminare', 'e1e16992-62cc-4544-ada8-e8ffc02254aa', 1, 1),
('7a414d58-c8cd-4dff-8b77-0f299f2920c9', 'Konzertfestivals', 'a2c72a89-6869-4d2d-9f90-be717537a148', 3, 1),
('7bf0e817-8f8a-4190-90d8-a559f380eb90', 'Zeitgenössische Kunst', '903a624c-7655-4941-92c2-fcbce45399da', 2, 1),
('7c5307d3-90d6-4602-b00f-e8808639ebd0', 'Hausaufgabenbetreuung', 'e1e16992-62cc-4544-ada8-e8ffc02254aa', 1, 1),
('7dea6712-360f-4e70-bb90-eeec33e466bd', 'Catering', 'c181ee05-5662-41f8-a241-0c2001e48359', 6, 1),
('7e1a8d59-fe13-4914-849c-7b7ecce7c65d', 'Volleyball', 'caee8b37-8686-4f95-a270-b52d9b332ded', 5, 1),
('7fa1727a-e166-479e-a87e-2cddbcb34945', 'Hilfsprojekte', '22c22f18-cec2-4676-9586-370bfd06f35b', 4, 1),
('80c76142-7a20-46c3-bf48-ecf80bd88036', 'Tanz', 'caee8b37-8686-4f95-a270-b52d9b332ded', 5, 1),
('81f05bc2-046f-470b-bcf8-d58157c7050d', 'Gesundheit', '22c22f18-cec2-4676-9586-370bfd06f35b', 4, 1),
('825cda70-60f5-4517-99e7-6b5415003e01', 'Frauenrechte', 'e1e16992-62cc-4544-ada8-e8ffc02254aa', 1, 1),
('8bdaffb1-6f76-49f3-a999-c0fecfad483b', 'Rassismusaufklärung', 'e1e16992-62cc-4544-ada8-e8ffc02254aa', 1, 1),
('8cecdd4d-57f5-47b2-ad1d-c6a83df8e9a3', 'Flamenco', 'caee8b37-8686-4f95-a270-b52d9b332ded', 5, 1),
('903a624c-7655-4941-92c2-fcbce45399da', 'Kunst und Kultur', NULL, 2, 1),
('9091601f-6df5-4350-904b-965bde1e085f', 'Musikunterricht für Kinder und Jugendliche', 'a2c72a89-6869-4d2d-9f90-be717537a148', 3, 1),
('9220d0a4-6442-4ea3-a0d2-4f0bbe4339f1', 'Vorträge', 'e1e16992-62cc-4544-ada8-e8ffc02254aa', 1, 1),
('9228d2bb-9271-4c0d-9a8e-37af82ea1d34', 'Zeitgenössische Musik', 'a2c72a89-6869-4d2d-9f90-be717537a148', 3, 1),
('96745945-5724-4d0e-b6e1-10013710d046', 'Bastel- und handwerkliche Workshops', 'e1e16992-62cc-4544-ada8-e8ffc02254aa', 1, 1),
('972e06c4-2805-47f2-9be1-c1dc01931e0e', 'Aufbauarbeit', '22c22f18-cec2-4676-9586-370bfd06f35b', 4, 1),
('97c7d12d-5af6-4e6d-b1c5-6349ace6a915', 'YouTube', 'f07a5595-f036-42b6-9d41-abd39896681a', 8, 1),
('9b726c9e-2566-4a38-b835-d1266a049faf', 'DJ', 'a2c72a89-6869-4d2d-9f90-be717537a148', 3, 1),
('9c5a822b-de59-40db-8fae-a40d4e081e33', 'Samba', 'a2c72a89-6869-4d2d-9f90-be717537a148', 3, 1),
('9d716150-f03e-43aa-91fb-13bd53626ecd', 'Podiumsdiskussionen und -gespräche', 'e1e16992-62cc-4544-ada8-e8ffc02254aa', 1, 1),
('9e582442-f85e-42b0-a18b-f0d9709b6a1a', 'Musikalische Früherziehung', 'a2c72a89-6869-4d2d-9f90-be717537a148', 3, 1),
('a04fc7da-497c-4c9f-a67b-f7f96bc987a9', 'Kampfsport', 'caee8b37-8686-4f95-a270-b52d9b332ded', 5, 1),
('a199aa26-d6af-4fba-89f4-a840401a8b7a', 'Gymnastik', 'caee8b37-8686-4f95-a270-b52d9b332ded', 5, 1),
('a1a496d0-a952-4718-9dc5-6299d763d376', 'Interkulturelle Kompetenzvermittlung', 'e1e16992-62cc-4544-ada8-e8ffc02254aa', 1, 1),
('a1db41c6-dd67-49d6-95a1-7076aad5cb06', 'Literaturveranstaltungen, Workshops', '903a624c-7655-4941-92c2-fcbce45399da', 2, 1),
('a2c72a89-6869-4d2d-9f90-be717537a148', 'Musik', NULL, 3, 1),
('a50b8b9f-e427-4057-9769-1e6c99eee205', 'Telefonische Sofortberatung, Hotline', '77c73324-6b81-4490-94c1-c7c699d75c36', 7, 1),
('a62583fa-4dc8-419f-a583-0e55bcc59e03', 'Chor-Gesang', 'a2c72a89-6869-4d2d-9f90-be717537a148', 3, 1),
('ab4dcc22-1389-49a2-8a35-a37d496e90cb', 'Afrobeat, Afropop', 'a2c72a89-6869-4d2d-9f90-be717537a148', 3, 1),
('abc9a1a3-b8ac-4ba3-b64d-b93fe702f129', 'Traditionelle Musik / Folklore', 'a2c72a89-6869-4d2d-9f90-be717537a148', 3, 1),
('ac7dc75e-e63d-4279-8574-2817148145c8', 'Rassismushilfe', '77c73324-6b81-4490-94c1-c7c699d75c36', 7, 1),
('b44949e8-9b04-4fbc-99e7-e278f0be08fc', 'Konzerte und Musikveranstaltungen', 'a2c72a89-6869-4d2d-9f90-be717537a148', 3, 1),
('b49214e4-26dc-4e23-9559-7eeefeb1e50d', 'Interreligiöse Begegnung', '903a624c-7655-4941-92c2-fcbce45399da', 2, 1),
('b8848ea0-78b5-4aa4-97ca-7ad5884937dc', 'Studienfahrten, Ausflüge, Sprach- und Kulturreisen', '903a624c-7655-4941-92c2-fcbce45399da', 2, 1),
('ba68962d-fa8a-4057-837d-3bdf708f2ce0', 'Offene Bühne', '903a624c-7655-4941-92c2-fcbce45399da', 2, 1),
('bbaae84e-1640-45ab-a92b-8d5d9e55146f', 'Häuserbau', '22c22f18-cec2-4676-9586-370bfd06f35b', 4, 1),
('bca4abd3-7782-49aa-8e02-a5bb389d72a1', 'Ausländische Kultur und Traditionen', '903a624c-7655-4941-92c2-fcbce45399da', 2, 1),
('bd8011d6-6811-4374-89c3-bc172ef47324', 'Radio', 'f07a5595-f036-42b6-9d41-abd39896681a', 8, 1),
('be43d95c-3e04-41d3-8c3c-5b57cea61f50', 'Bands', 'a2c72a89-6869-4d2d-9f90-be717537a148', 3, 1),
('c181ee05-5662-41f8-a241-0c2001e48359', 'Gastronomie', NULL, 6, 1),
('c1b1d7ee-4c4f-449e-8013-9611b0f925bc', 'Nachhilfe', 'e1e16992-62cc-4544-ada8-e8ffc02254aa', 1, 1),
('c7b06389-554b-4d82-9a8a-01107f7c348e', 'Fotografie', '903a624c-7655-4941-92c2-fcbce45399da', 2, 1),
('c844cb92-75fd-470f-a97a-9ad1235f9fb9', 'Muttersprachlicher Unterricht', 'e1e16992-62cc-4544-ada8-e8ffc02254aa', 1, 1),
('caee8b37-8686-4f95-a270-b52d9b332ded', 'Sport', NULL, 5, 1),
('cdb5b6d0-f818-41fa-b3b2-056151253f29', 'Fußball', 'caee8b37-8686-4f95-a270-b52d9b332ded', 5, 1),
('cdbee767-bb81-453a-9b6a-1cbf28449e7d', 'Interessenkurse', 'e1e16992-62cc-4544-ada8-e8ffc02254aa', 1, 1),
('cecd9baa-87a1-466b-82ac-a1dca8419f38', 'UNESCO-Projekte', '22c22f18-cec2-4676-9586-370bfd06f35b', 4, 1),
('d0634bc5-2e3e-480b-b612-9cdddb26f208', 'Diskussionsrunden', 'e1e16992-62cc-4544-ada8-e8ffc02254aa', 1, 1),
('d5158be0-2840-474a-a7cb-d5307f1d9b78', 'Reggae', 'a2c72a89-6869-4d2d-9f90-be717537a148', 3, 1),
('d64949fb-be56-48c2-a1cc-cb65acea6b85', 'Fitness', 'caee8b37-8686-4f95-a270-b52d9b332ded', 5, 1),
('dcf3eca4-ef5d-4aeb-9640-1ab8c06cc84e', 'Stipendienvergabe', 'e1e16992-62cc-4544-ada8-e8ffc02254aa', 1, 1),
('dcf810fd-c808-40e8-8a2f-7d1e1507ba59', 'Religiöse Veranstaltungen und Feste', '903a624c-7655-4941-92c2-fcbce45399da', 2, 1),
('e009d28c-5993-48bd-97da-e0f11e9f77de', 'Ebru-Kurs', '903a624c-7655-4941-92c2-fcbce45399da', 2, 1),
('e1e16992-62cc-4544-ada8-e8ffc02254aa', 'Bildung', NULL, 1, 1),
('e2ac863c-4be7-411f-b05e-4291c91cc636', 'Muttersprachliche Gastvorträge', '903a624c-7655-4941-92c2-fcbce45399da', 2, 1),
('e3e505ac-b1c9-4c3b-8197-db4bb0d2fb76', 'Poesie', '903a624c-7655-4941-92c2-fcbce45399da', 2, 1),
('e467ffd3-fb11-4612-8da1-37d1691d55bc', 'Arbeit mit Senior*innen', '22c22f18-cec2-4676-9586-370bfd06f35b', 4, 1),
('e4ceb00b-6a23-4de7-bb73-ed1cf8548c43', 'Übersetzungs- und Dolmetscherdienste', 'e1e16992-62cc-4544-ada8-e8ffc02254aa', 1, 1),
('e5f9e348-c3a8-4491-8f4d-241bc1022e9d', 'Training', 'caee8b37-8686-4f95-a270-b52d9b332ded', 5, 1),
('e8908bfd-1f08-482b-9f43-df8c9e0ce0c7', 'Kunst- und Kulturveranstaltungen, Workshops', '903a624c-7655-4941-92c2-fcbce45399da', 2, 1),
('ebfac38a-7acd-48ae-b79c-49441f98937b', 'Gesangsunterricht', 'a2c72a89-6869-4d2d-9f90-be717537a148', 3, 1),
('ef8228c0-b7d6-44a1-91cc-51d21a96e3cf', 'Kunstprojekte', '903a624c-7655-4941-92c2-fcbce45399da', 2, 1),
('f07a5595-f036-42b6-9d41-abd39896681a', 'Medien', NULL, 8, 1),
('f4a30eea-a163-433b-ba70-24b27546527d', 'Capoeira', 'caee8b37-8686-4f95-a270-b52d9b332ded', 5, 1),
('f618d917-a61d-46a3-808c-5e21a037a37d', 'Musikveranstaltungen mit Kindern und Jugendlichen', 'a2c72a89-6869-4d2d-9f90-be717537a148', 3, 1),
('f6822fff-0b6b-4739-a321-32124e952699', 'Cocktails', 'c181ee05-5662-41f8-a241-0c2001e48359', 6, 1),
('fb18eb8a-2e84-4110-9320-50dee5eac1dd', 'Suppenküchen', '22c22f18-cec2-4676-9586-370bfd06f35b', 4, 1),
('fdbc9436-c6fd-40c4-9154-30fad2acd582', 'Integrationshilfe', '22c22f18-cec2-4676-9586-370bfd06f35b', 4, 1);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `associations`
--

CREATE TABLE `associations` (
  `id` varchar(36) NOT NULL,
  `name` varchar(128) NOT NULL,
  `shortName` varchar(50) DEFAULT NULL,
  `lat` double NOT NULL,
  `lng` double NOT NULL,
  `addressLine1` varchar(128) DEFAULT NULL,
  `addressLine2` varchar(128) DEFAULT NULL,
  `addressLine3` varchar(128) DEFAULT NULL,
  `street` varchar(128) DEFAULT NULL,
  `postcode` varchar(128) DEFAULT NULL,
  `city` varchar(128) DEFAULT NULL,
  `country` varchar(128) DEFAULT NULL,
  `goals_format` varchar(64) DEFAULT NULL,
  `goals_text` text DEFAULT NULL,
  `activities_format` varchar(64) DEFAULT NULL,
  `activities_text` text DEFAULT NULL,
  `activityList` longtext DEFAULT NULL,
  `districtList` longtext DEFAULT NULL,
  `current` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Daten für Tabelle `associations`
--

INSERT INTO `associations` (`id`, `name`, `shortName`, `lat`, `lng`, `addressLine1`, `addressLine2`, `addressLine3`, `street`, `postcode`, `city`, `country`, `goals_format`, `goals_text`, `activities_format`, `activities_text`, `activityList`, `districtList`, `current`) VALUES
('01b97f40-b03f-4a9e-b738-8be2f682fbaa', 'Schwedischer Schulverein Stuttgart e. V.', '', 48.780936, 9.194478, 'keine öffentliche Anschrift', '', '', '', '', '', '', 'plain', 'Förderung der Erziehung, Volks- und Berufsbildung einschließlich der Studentenhilfe, insbesondere Vermittlung von Kenntnissen in schwedischer Sprache, Geschichte, Heimatkunde und Geografie.', 'plain', 'Bildung (mutersprachlicher Unterricht in schwedisch, Spielgruppe, Schulreisen); Kultur und Kunst (kulturelle Veranstaltungen, schwedische Feste).', 'null', '[\"bbf0d197-fcd6-4548-8548-ef1840057018\"]', 1),
('02b46ae8-d1ed-4b34-b05d-491a400cf66d', 'Arrafidain Kulturverein e. V.', '', 48.83014, 9.196158, '', '', '', 'Tapachstraße 60', '70437', 'Stuttgart', '', 'plain', 'Sprachunterricht Arabisch nach Lehrplan für alle Sprachniveaus A1 bis hin zum C1 (Schriftbild, Wortschatz, Grammatik, Kommunikation, Rhetorik) für Kinder, Jugendliche und Erwachsene um Selbstbewusstsein, Persönlichkeit, Begabungen und kommunikative &amp; schriftliche Kompetenzen der Heranwachsenden so zu unterstützen, aber auch ihre Integration &amp; Demokratieverständnis zu fördern.', 'plain', 'Bildung (muttersprachlicher Arabischunterricht mit anschließenden Prüfungen und Zeugnissen bzw. Zertifikaten als Leistungsnachweisen, unsere Lehrkräfte gehören zur Gruppe der Migranten, Flüchtlingen und/ oder Älteren und engagieren sich hier für die Schaffung neuer Perspektiven, Toleranz, Integration und Respekt); Kultur und Kunst ( Lesewettbewerb, Schreibwettbewerb, Theaterstück in der arabischen Sprache und Schulausflüge mit Schülern und Eltern).', 'null', '[\"def5709b-04dd-409e-a3d9-2831186574d7\",\"1a04156f-facc-494c-8061-7fc8138adf91\"]', 1),
('09c84ef4-3302-4868-b0a8-590d28b2e11a', 'Eritreische Vereinigung zur gegenseitigen Unterstützung Stuttgart e. V.', '', 48.793894, 9.181704, '', '', '', 'Heilbronnerstr. 107', '70191', 'Stuttgart', '', 'plain', 'Unser Ziel ist die Förderung der Jugendarbeit mit dem Schwerpunkt des muttersprachlichen Unterrichtes, Familienbezogenen Jugendarbeit, Freizeitgestaltung und Sport. Unser Verein ist sozial aktiv, unsere Mitglieder unterstützen und beraten Bedürftige im Todesfall und Trauerfall.<br/>Wir bemühen uns stets geflüchteten Eritreer*innen mit Unterstützungs- und Beratungs- Angebot zu helfen.', 'plain', 'Bildung (muttersprachlicher Unterricht für Kinder); Kultur und Kunst (Theaterveranstaltungen, Spieleabende in Gruppen, Kulturfest, Weihnachtsfest, Osterfest, und eritreische Unabhängigkeit Fest, Feste für Frauengruppen); Musik (Musikveranstaltungen mit traditionell eritreischer Musik und Instrumenten); Gastronomie (traditionell eritreisches Essen in der hauseigenen Küche); Sport (Sportveranstaltungen und Freizeitgestaltung für Jugendliche); Soziales (Unterstützung und Beratung von Mitgliedern nach Bedarf, bzw. im Todesfall, Trauerfall, Mitglieder besuchen Patienten mit langem Krankheitsverlauf); Geflüchtete (Unterstützungs- und Beratungsangebot an geflüchteten Eritreer*innen).', 'null', '[\"cc67be51-58de-4109-ae78-2b0c018e27da\"]', 1),
('0ddb204a-a10b-4d75-aa9c-b705b3316214', 'Deutsch-Albanischer Verein für Kultur, Jugend und Sport „Pavarësia“ e. V.', '', 48.782637, 9.184363, 'keine öffentliche Anschrift', '', '', '', '', '', '', 'plain', 'Förderung der Beziehungen zwischen deutschen und albanischen Bürgern, das Pflegen der albanischen Sprache, Kultur und Tradition, sowie die Förderung der Integration der albanischen Bevölkerung in die deutsche Gesellschaft.', 'plain', 'Bildung (muttersprachlicher Unterricht albanisch), Sport (traditioneller Tanz, albanischer Volkstanz, sportliche Aktivitäten), Kultur und Kunst (Vorträge über deutsche und albanische Literatur und Kunst, Land u. a., Dichterlesungen, Musik- und Tanzabende, Studienfahrten).', 'null', '[\"03913c8d-c21d-470a-90fc-b3032fc33f4a\",\"bbf0d197-fcd6-4548-8548-ef1840057018\",\"d3ea05ed-5dcd-4d47-a2aa-18e4eb6294c0\"]', 1),
('0e37656b-78da-4639-ac91-8b04b7d49e34', 'COEXIST e. V.', '', 48.812879, 9.158758, '', '', '', 'Kärntner Straße 40A', '70469', 'Stuttgart', '', 'plain', 'Der Verein Coexist hat den Anspruch bei gesamtgesellschaftlichen Diskursen mitzuwirken und bietet Menschen ein Sprachrohr.', 'plain', 'Bildung (Empowerment-Angebote, Workshops zum Thema &quot;Frauenrechte&quot;, Aufklärung).', 'null', '[\"d3ea05ed-5dcd-4d47-a2aa-18e4eb6294c0\"]', 1),
('0f000100-38cd-4c94-953c-c7b5740ac9c7', 'Latin Jazz Initiative', '', 48.774427, 9.167141, '', '', '', 'Gutenbergstraße 3B', '70176', 'Stuttgart', '', 'plain', 'Die Latin Jazz Initiative entstand aus dem Bedürfnis neue Wege zu suchen, um das Jazz Publikum (nicht nur das Latin Jazz Publikum) auf diese wunderbare Musik aufmerksam zu machen. Durch Jazz entsteht Kommunikation unabhängig von Herkunft, Glauben oder anderen «Hindernissen», die in vielen anderen Bereichen das Zusammensein schwieriger machen.', 'plain', 'Beratung (Veranstaltungsplanung), Kultur und Kunst (Organisation und Durchführung von Festivals, Konzerte, Konzertreihen, Workshops , Jazz Open Stage, UNESCO-International Jazzday, UNESCO-International Danceday, United Jazz Ensemble, Musik im Viertel (Konzerte in kleinen Geschäften in verschiedenen Stadtteilen)), Bildung (Musikunterricht, Jazz-Workshops, Latin Jazz, Jazzdance und Latin Jazzdance, ein lebendiges Hörbuch, in dem der Autor seine eigenen Bücher liest und die Lesung musikalisch mit Stücken umrahmt, die extra hierfür komponiert werden).', 'null', '[\"068af935-dc42-40a4-98ef-e59352e9706c\",\"cf4658bb-885d-4937-bfd8-c5a7963a22d0\"]', 1),
('12e960bb-0b60-472b-828b-b7cdfd4153e8', 'Yalla e. V.', '', 48.775303, 9.178135, 'keine öffentliche Anschrift', '', '', '', '', '', '', 'plain', 'Hilfe zur Selbsthilfe in arabischen Ländern, feste Einzelprojekte in Ägypten und Tunesien, Kulturaustausch und Völkerverständigung, Organisation von Workcamps und Orientalische Feste in Deutschland.', 'plain', 'Bildung (Organisation von Workcamps für Europäer*innen und arabische Teilnehmer*innen in arabischen Ländern und Deutschland)<br/>; Kultur und Kunst (Vorträge zur Kultur und Geschichte des historischen und modernen Ägypten, Veranstaltung orientalischer Feste in Deutschland); Soziales (Probleme in Entwicklungsländern, Informationsveranstaltung über soziale Projekte in Ägypten und arabischen Ländern, Unterstützung von Einrichtungen in Ägypten , die sich um sozial benachteiligte Menschen kümmern und Verkauf von Eine-Welt-Produkte, die in Selbsthilfeprojekten hergestellt wurden, Aufbau von Geräten für Spielplätze und Beteiligung an der Errichtung von Vielzwecksportplätzen für soziale Einrichtungen, Beitrag zur Entwicklung des Umweltbewußtseins, das in armen Ländern oft kaum vorhanden ist).', 'null', '[\"def5709b-04dd-409e-a3d9-2831186574d7\"]', 1),
('17629f08-1f85-4876-bb13-cf91616f20b7', 'Juma e. V.', '', 48.811584, 9.159012, '', '', '', 'Kärtnerstr. 40A', '70565', 'Stuttgart', '', 'plain', 'Gesellschaftliche Teilhabe, Empowerment und Vernetzung von Jugendlichen.', 'plain', 'Bildung (Workshops zu den Themen : Jugendverbandsarbeit, Projektmanagement, Vereinsmanagement, Öffentlichkeitsarbeit, Demokratische Teilhabe, Antidiskriminierung, Antimuslimischer Rassismus, Meet and Talks, Zukunftswerkstätten, Activity Days).', 'null', '[\"def5709b-04dd-409e-a3d9-2831186574d7\"]', 1),
('18c775ef-37d5-49ee-8745-bd5491f6eab3', 'Mädchenschule Khadigram e. V.', '', 48.79245, 9.208238, '', '', '', 'In der Reute 21', '71566', 'Althütte', '', 'plain', 'Solide Grundbildung von Mädchen aus vulnerablen Gesellschaftsgruppen/Unberührbare in Indien. Deckung der Grundbedürfnisse an Kleidung, Nahrung, medizinischer Versorgung. Ausbildung von Frauen zur Krankenpflegerin und Hebamme. Hunger - und Armutsbekämpfung. Wir engagieren uns für den Zugang zu sauberem Trinkwasser. Seit August 2020 finanzieren wir ein Programm &quot;COVID 19 RESCUE AGAINST HUNGER&quot; für 500 besonders vom Hunger bedrohten Familien zur Versorgung mit Grundnahrungmitteln.', 'plain', 'Bildung (muttersprachlicher Unterricht (in Indien) Gujarati und Hindi); Soziales (Wir sind ein Verein der in Deutschland Spenden akquiriert, um seine Ziele in Indien umzusetzen).', 'null', '[]', 1),
('193af93b-0329-464a-887e-3bef9aa800b4', 'Srpski Centar Stuttgart e. V.', '', 48.815154, 9.198532, '', '', '', 'Sigmund-Lindauer-Weg 24', '70376', 'Stuttgart', '', 'plain', 'Das serbische Zentrum Stuttgart e. V. ist ein deutsch-serbischer Kulturverein. Im Mittelpunkt steht das Tanzen von Volkstänzen, welche bei verschiedenen Meisterschaften oder Stadtfesten aufgeführt werden. Der Verein hat es sich zur Aufgabe gemacht, vor allem junge Menschen durch die Vereinstätigkeiten zu fördern und ihnen bestimmte Werte zu vermitteln.', 'plain', 'Bildung (Bastel-Workshops, Trachten nähen, Hausaufgabenbetreuung, Übernachtungsfest in Schlafsäcken mit Aufgaben und Spielen), Gastronomie (Kochkurse mit Kindern und Jugendlichen), Sport (traditioneller Tanz, Volkstanz, Fußballturniere).', 'null', '[\"cf4658bb-885d-4937-bfd8-c5a7963a22d0\",\"03913c8d-c21d-470a-90fc-b3032fc33f4a\",\"6903278b-dd88-4ae3-b08f-1e3c17aef3da\"]', 1),
('1c58eac8-e49b-4341-8d26-7b07e638f8c9', 'Punto de Encuentro e. V.', '', 48.775167, 9.177163, '', '', '', 'Hirschstraße 12', '70173', 'Stuttgart', '', 'plain', 'Eine interkulturelle Begegnungsstätte für Menschen, die in der spanischen und deutschen Kultur verwurzelt sind, für Familien mit spanisch sprechenden Mitgliedern, für Eltern, die Interesse an bilingualer Erziehung für ihre Kinder haben.', 'plain', 'Bildung (muttersprachlicher Spanischunterricht, Bastel-Worksops, Handwerken, Experimentieren), Kultur und Kunst (Vermittlung der spanischen Sprache und Kultur, Feste und Feiern zum Gedanken- und Erfahrungsaustausch, Ausflüge und Besuche kultureller und wissenschaftlicher Einrichtungen und Museen), Entwicklung und Zusammenarbeit (Unterstützung von Personen, die aus der spanischen Kultur stammen oder die sich der spanischen Sprache und Kultur verbunden fühlen), Sport (Yoga).', 'null', '[\"def5709b-04dd-409e-a3d9-2831186574d7\"]', 1),
('23d06b99-29d4-4f80-a065-bf4c6d309af8', 'Forum Afrikanum Stuttgart e. V.', '', 48.762232, 9.160389, 'keine öffentliche Anschrift', '', '', '', '', '', '', 'plain', 'Begegnungen schaffen, Austausch, Mitgestaltung des Kulturlebens in Stuttgart. Der Verein ist konfessionell und parteipolitisch neutral.', 'plain', 'Bildung (Vorträge, Workshops), Kultur und Kunst (Konzerte, Ausstellungen, Lesungen, Filme, Projekte).', 'null', '[\"cf4658bb-885d-4937-bfd8-c5a7963a22d0\"]', 1),
('2587605d-d2cf-4087-9a22-936e24debca3', 'Kalimera e. V. Deutsch-Griechische Kulturinitiative', '', 48.775471, 9.177591, '', '', '', 'Marktplatz 4', '70173', 'Stuttgart', '', 'plain', '', 'plain', 'Kultur und Kunst (Infoabende mit Podiums- und Publikumsgesprächen, Themen: Finanzkrise in Griechenland und Europa, Flucht und Asyl in Europa, was machen Kulturschaffende in Griechenland. Deutsch-Griechische Filmvorführungen und -festivals mit und ohne Regisseure mit anschließenden Publikumsgesprächen, Kinofestival, Theaterveranstaltungen, Theaterworkshops mit Kinder u. Jugendlichen, Stammtische im Laboratorium, Kooperationsprojekte mit Stuttgarter Einrichtungen, Kooperationsprojekt mit der Stadt Fellbach „Kultursommer Griechenland u. Italien), Musik (Musikkonzert &quot;Opera Chaotiq&quot; mit Jugendlichen, Musikkonzerte mit griechischen und internationalen Künstlern, Homagen an griechische Komponist*innen).', 'null', '[\"def5709b-04dd-409e-a3d9-2831186574d7\"]', 1),
('29988195-497a-443c-ae69-0facbbef31ca', 'Ars Narrandi e. V.', '', 48.757743, 8.88469, '', '', '', 'Burgunderstr. 16', '71263', 'Weil', '', 'plain', 'Wir fördern die (inter- und trans-)kulturelle Begegnung um mündlich, lebendig erzählte Geschichten aller Welt. Unsere Geschichten schlagen den Bogen zwischen den verschiedenen \rErzähltraditionen und ihren Weisheiten, individuellen Erfahrungen und biografischen Geschichten, sowie neu erfundenen Geschichten. Sie sind Türöffner zur Sensibilisierung und einen regen Austausch über wichtige Themen: Nachhaltigkeit, Natur und Umwelt, Demokratie und Menschenrechte. Wir unterstützen demokratische Teilhabe, indem wir interkulturelles Bewusstsein, aktives Hinhören und einen vorurteilsfreien Umgang mit Sprache und Mehrsprachigkeit trainieren. \r<br/>Wir möchten Menschen jeden Alters und Herkunft, sozialer Zugehörigkeit und Bildung miteinander reisen, träumen und in Gespräch kommen lassen.', 'plain', 'Bildung (Projekte der kulturellen Bildung, konsumfreie Festivals und Feste, Erzählakademie mit mehrsprachigen Erzählern, Vorträge, Kurse und Workshops); Kultur und Kunst (mündliches Erzählen im Freien, im Park oder in einem Stadtteil, auf der Bühne, in Büchereien, Schulen, Kindergärten und Begegnungsstätten, professionelle Erzähler*innen, Expert*innen der inter- und transkulturellen Kommunikation und Volkskundler); Es geht uns um die Kenntnis und Verbindung von Kulturen über ihre Erzähltraditionen, das Erwerben von Kompetenzen in der interkulturellen Kommunikation und der positiven Streitkultur, um die Aus- und Fortbildung des mündlichen Erzählens als soziale Kompetenz bis zur Kunst auf der Bühne.', 'null', '[\"068af935-dc42-40a4-98ef-e59352e9706c\"]', 1),
('2b78dd70-b3d6-48b4-8592-c66028876863', 'Lettischer Kulturverein SAIME e. V.', '', 48.762484, 9.160198, 'keine öffentliche Anschrift', '', '', '', '', '', '', 'plain', 'Pflege der lettischen Kultur und Geschichte, Bräuche sowie Sprache in Wort und Schrift für und mit den Landsleuten in der neuen Heimat . Es werden Konzerte, Lesungen, Treffen, Feste, Theatervorstellungen, Vorträge, Infoabende, Filmvorführungen etc. zur Vermittlung und Erhaltung kultureller und historischer Traditionen durchgeführt. Beteiligung am gesellschaftlichen und kulturellen Leben sowie die Zusammenarbeit zwischen Letten und Bürgern unterschiedlicher Herkunft und Generationen.', 'plain', 'Bildung (muttersprachlicher Unterricht lettisch, Kinder-Kultur-Schule mit Sprach-, Gesangs- und Tanzunterricht), Kultur und Kunst (Kulturveranstaltungen), Sport (traditioneller Tanz, lettische Volkstanzgruppe &quot;Trejdeksnitis&quot;).', 'null', '[\"03913c8d-c21d-470a-90fc-b3032fc33f4a\"]', 1),
('2be3d117-a995-459e-8ae4-7d00fcd6cf74', 'Ndwenga e. V.', '', 48.808049, 9.273254, 'keine öffentliche Anschrift', '', '', '', '', '', '', 'plain', 'Förderung der internationalen Gesinnung, der Toleranz und des Völkerverständigungsgedanken auf allen Gebieten der Kultur im In- und Ausland. Besonderen Fokus legt Ndwenga e. V. auf die Ziele: keine Armut, kein Hunger, hochwertige Bildung, weniger Ungleichheiten und Partnerschaften zur Erreichung der Nachhaltigkeitsziele.', 'plain', 'Bildung (kulinarische und musikalische Kulturvermitlung), Kultur und Kunst, Gastronomie (Catering).', 'null', '[\"def5709b-04dd-409e-a3d9-2831186574d7\",\"ee4de3c1-f202-4b67-a8ee-ee53c95af538\"]', 1),
('2e23fb7b-8e8d-4fbb-9c2d-e9fcebabd353', 'Mexikanische Tanzgruppe Adelitas Tapatías & Charros', '', 48.778256, 9.179768, 'keine öffentliche Anschrift', '', '', '', '', '', '', 'plain', 'Verbreitung der mexikanischen Kultur in Deutschland.', 'plain', 'Sport (mexikanischer Tanz).', 'null', '[\"def5709b-04dd-409e-a3d9-2831186574d7\"]', 1),
('30628cf8-0f1d-4dc3-9431-c810dbdfca69', 'Evidence e. V.', '', 48.812879, 9.158758, '', '', '', 'Kärntner Straße 40A', '70469', 'Stuttgart', '', 'plain', 'EVIDENCE ist unabhängig – auch parteipolitisch unabhängig. EVIDENCE verfolgt das Ziel, dass allen Interessierenden unserer Gesellschaft - Muslime und Nicht-Muslime - der Zugang zum Islam und zu seinen authentischen Quellen auf einem wissenschaftlich fundierten Niveau und in deutscher Sprache ermöglicht wird. EVIDENCE fördert die Gelehrten und zukünftigen Islamwissenschaftler in ihrer Forschung und baut Brücken zwischen den anerkannten Wissenschaftlern und den nach Wissen Strebenden.', 'plain', 'Bildung (Wissenschaft, Forschung, Seminare, Workshops, Events sowie die Produktion wissenschaftlicher Literatur).', 'null', '[\"def5709b-04dd-409e-a3d9-2831186574d7\"]', 1),
('357ea7a6-da38-4b03-bc58-12e6e53f196d', 'Förderverein Hero\'s Academy AIC Stuttgart e. V.', '', 48.777659, 9.151351, 'keine öffentliche Anschrift', '', '', '', '', '', '', 'plain', 'Verwirklichung von Projekten, um Kindern in Kenia zu helfen und ihnen eine Chance auf Bildung zu geben.', 'plain', 'Bildung (finanzielle Unterstützung des Unterhalts der Academy, Grundschule und Kindergarten), Entwicklung und Zusammenarbeit (Unterstützung bei der Instandsetzung und Einrichtung sowie evtl. Baumaßnahmen von Schule und Kindergarten, Hilfestellung zur Selbsthilfe des Unterhalts, anteilige finanzielle Unterstützung für Lehrmaterial, Vermittlung von Schulpatenschaften).', 'null', '[\"cf4658bb-885d-4937-bfd8-c5a7963a22d0\"]', 1),
('398792e6-1afc-4600-ab16-3118f2a627f1', 'India Culture Forum e. V.', '', 48.773204, 9.164096, 'keine öffentliche Anschrift', '', '', '', '', '', '', 'plain', '', 'plain', 'Kultur und Kunst (Jährliche Feste: Religiöses Fest in Fellbach, Lichterfest im Bürgerzentrum West), Gastronomie (traditionelles Essen), Sport (Tanz-Workshops, Yoga).', 'null', '[\"cf4658bb-885d-4937-bfd8-c5a7963a22d0\",\"ee4de3c1-f202-4b67-a8ee-ee53c95af538\"]', 1),
('3ba452ea-ee50-4ef8-80b2-12e986d823d4', 'Internationaler Musik- und Kulturverein Klangoase e. V.', '', 48.839759, 9.193012, '', '', '', 'Sauerkirschenweg 32', '70437', 'Stuttgart', '', 'plain', 'Unterschiedliche Kinder und Jugendliche mithilfe von Musik zusammenzubringen. Durch gemeinsames Musizieren stärkt der Verein die Persönlichkeit von Kindern, Jugendlichen und Erwachsenen sowie das Verständnis füreinander. Ein besonderer Schwerpunkt des Vereins ist die interkulturelle Arbeit mit dem Ziel, ein multinationales Orchester entstehen zu lassen.', 'plain', 'Bildung (Instrumentalunterricht: Gitarre, Klavier, Geige, Blockflöte, Cello, musikalische Früherziehung (M.F.E.), M.F.E.-unterricht in der Muttersprache Türkisch, Unterricht im Musikstil „Klassik“), Musik (Orchester, Chor-Gesang).', 'null', '[\"1a68b204-3bc7-4ebd-a5a9-effc1b65dcb1\",\"bab504b9-7f1b-42cf-a01e-ce322fe25590\"]', 1),
('4075fc5d-ae34-47d4-92e9-f6291b4d901f', 'STELP e. V.', '', 48.777167, 9.16147, '', '', '', 'Johannesstraße 35', '70176', 'Stuttgart', '', 'plain', 'Hilfe für Menschen in Not.', 'plain', 'Bildung (Bildungsprojekte), Soziales und Gesundheit (Notversorgung: Verteilung von Lebensmitteln, Verteilung von Kleidung, Häuserbau, Suppenküchen).', 'null', '[\"cf4658bb-885d-4937-bfd8-c5a7963a22d0\"]', 1),
('409d1bc5-f179-47a4-aef6-7487677dee7d', 'Afro Deutsches Akademiker Netzwerk ADAN', '', 48.780981, 9.182435, 'keine öffentliche Anschrift', '', '', '', '', '', '', 'plain', 'Eine Plattform für die Interaktion zwischen Afrodeutschen, AfrikanernInnen und Afrika-Interessierten Personen zu bieten;\r Vielfalt sichtbar zu machen und jungen AfrikanerInnen in der Diaspora Vorbilder aus unterschiedlichen Bereichen zu präsentieren;\r Afrika als Chancenkontinent zu präsentieren, um eine nachhaltige Brücke zwischen Afrika und Europa zu kreieren.', 'plain', 'Bildung (Beratung von Jugendlichen und Heranwachsenden bei den Themen Schule, Studium und Zukunftsplanung)<br/>; Diversity (Vielfalt sichtbar machen und fördern)<br/>; Netzwerk (welches als Plattform für den gegenseitigen Austausch von Deutsch-Afrikanern und<br/>Afrikainteressierten dient und nachhaltige Beziehungen in den Bereichen der Wirtschaft, Gesellschaft und Kultur zu entwickeln)', 'null', '[\"068af935-dc42-40a4-98ef-e59352e9706c\"]', 1),
('45abe07b-cdec-41ee-a0be-b293fd8c0e15', 'Igbo Cultural Foundation Stuttgart e. V.', '', 48.69453, 9.319517, '', '', '', 'Karlstraße 15', '73770', 'Denkendorf', '', 'plain', 'Kultur der Igbo der deutschen Bevölkerung näher bringen.', 'plain', 'Bildung (muttersprachlicher Unterricht), Kultur und Kunst (öffentliche Literaturveranstaltungen), Soziales und Gesundheit (Arbeit mit Senior*innen), Entwicklung und Zusammenarbeit (Integrationshilfe), Engagement für Geflüchtete (Zusammenarbeit mit Asylbewerber*innen), Gastronomie (Fingerfood, traditionelles Essen), Sport (Fußball, Basketball, Tanz, öffentliche Sportveranstaltungen), Musik (Trommeln, öffentliche Musikveranstaltungen), Podcast (auf YouTube unter Odenjinji Media Stuttgart).', 'null', '[\"d4b4dc39-3aa8-421b-991c-a37e3a05f08f\"]', 1),
('464b856f-beec-450c-a25c-5e2b923bb20a', 'tigre vermelho e. V. Freundeskreis zur Förderung der Kultur Brasiliens', '', 48.799667, 9.487469, '', '', '', 'Schorndorfer Straße 47', '73650', 'Winterbach', '', 'plain', 'Vermittlung brasilianischer Lebensfreude, Spenden an Projekte in Brasilien und Deutschland zum Wohl von Kindern.', 'plain', 'Kultur und Kunst (Karnevalsparty &quot;Carnaval dos Tigres&quot; im Römerkastell/Phönixhalle mit Tanzshows, DJs, &quot;Waiblinger Altstadtfest&quot; mit Samba-Shows, Partymusik, Cocktails), Gastronomie (Essen), Musik (brasilianische Band).', 'null', '[\"d3ea05ed-5dcd-4d47-a2aa-18e4eb6294c0\",\"b34a153d-bd29-4b97-9814-23f10c5048e8\"]', 1),
('46b88ff4-b7d2-48c8-9287-9a4df986ade2', 'Medienkulturverein Multicolor e. V.', '', 48.790009, 9.199521, '', '', '', 'Stöckachstraße 16a', '70190', 'Stuttgart', '', 'plain', 'Realisierung von Medienprojekten aller Art, meist unter interkulturellen Aspekten. Menschen mit und ohne Migrationshintergrund sollen mediale Möglichkeiten an die Hand gegeben werden, ihre Welt und ihre Themen in einer verständlichen Art sichtbar, hörbar und erlebbar zu machen.', 'plain', 'Kultur und Kunst (Ausstellung), Podcast (Radio, Podcasts, Audiodateien). Ausgewählte Projekte: &quot;Mittendrin – Mein Leben ist Stuttgart und davor&quot; (Eine Radioproduktion aus Texten, Klängen und Geräuschen, die Lebenserfahrungen und Alltag von Migrant*innen in Stuttgart hörbar macht), &quot;Spurensuche&quot; (Junge Menschen haben sich auf den Weg gemacht, Höhepunkte oder auch Verborgenes in Stuttgart zu entdecken und medial aufzubereiten), &quot;Meinst du, die Russen wollen Krieg?&quot; (Wanderausstellung mit Rollups und gerahmten Fotografien über das heutige Russland).', 'null', '[\"d4b4dc39-3aa8-421b-991c-a37e3a05f08f\"]', 1),
('4acbc0ea-0fcd-470a-a50c-ddbc12442eec', 'Deutschsprachiger Muslimekreis Stuttgart (DMS) e. V.', '', 48.810936, 9.166539, '', '', '', 'Stuttgarterstr. 15', '70469', 'Stuttgart', '', 'plain', 'Wir möchten mit unserem Angebot in erster Linie Wissen rund um den Islam in deutscher Sprache vermitteln. Uns ist es wichtig Vorurteile abzubauen, die es sowohl unter den Muslimen, als auch unter den Nichtmuslimen gibt. Wir möchten eine Plattform bieten, auf der sich Jung und Alt über ihren Glauben austauschen können. Es ist heute wichtiger denn je miteinander ins Gespräch zu kommen, daher ist uns der Aufbau und erhalt guter Beziehungen zu Nichtmuslimen ein wichtiges Anliegen.', 'plain', 'Bildung (Freitagstreff (offene Veranstaltung für alle Interessierten), Vorträge externer Referenten); Kultur und Kunst (Veranstaltungen an muslimischen Feiertagen); Geflüchtete (Arbeit mit Geflüchteten).', 'null', '[\"e0c9c7a7-d317-4662-93e5-28f281df4fd9\"]', 1),
('4be37ec0-dd64-4dbe-8ebf-2a79e4606fa8', 'Spanischsprechende Frauen in BW', '', 48.774901, 9.163174, '', '', '', 'Johannesstr. 13', '70176', 'Stuttgart', '', 'plain', 'Wir sind ein lokales Netzwerk, das die Integration von spanischsprechenden Menschen in Deutschland unterstützt, die Gleichberechtigung von Frauen und Männern fördert und Projekte der Entwicklungszusammenarbeit in Lateinamerika und Spanien durchführt.', 'plain', 'Bildung (regelmäßige und kostenlose Einzel- und Gruppenbildungstreffen, Konferenzen, Workshops, Schulungen); Kultur und Kunst (Kunstausstellungen auf Spanisch und Deutsch, veröffentlichen Bücher und Artikel zu den Themen Integration, Gleichberechtigung und Entwiklungszusammenarbeit); Organisationsentwicklung; Empowerment (Frauen); Umwelt.', 'null', '[\"def5709b-04dd-409e-a3d9-2831186574d7\"]', 1),
('4cc04cbb-8b19-4afb-8382-675f2ab08ba8', 'Capoeira Stuttgart e. V.', '', 48.827584, 9.076422, '', '', '', 'Gottfried-Keller-Straße 41', '71254', 'Ditzingen', '', 'plain', 'Gemeinnütziger Sportverein, mit dem Ziel den brasilianischen Nationalsport Capoeira in Stuttgart bekannt zu machen und den Stuttgartern die Gelegenheit zu bieten, diesen zu erlernen.', 'plain', 'Kultur und Kunst (vielfältige kulturelle und karitative Veranstaltungen), Entwicklung und Zusammenarbeit (Integrationshilfe), Engagement für Geflüchtete (Zusammenarbeit mit Geflüchteten: Sport und Musik - Capoeira für Kinder und Erwachsene, Training in Flüchtlingsheimen Bürgerhospital und Mercedesstraße), Sport (regelmäßige Trainings).', 'null', '[\"03913c8d-c21d-470a-90fc-b3032fc33f4a\",\"068af935-dc42-40a4-98ef-e59352e9706c\",\"d3ea05ed-5dcd-4d47-a2aa-18e4eb6294c0\"]', 1),
('4cd5f88c-6cce-4d35-8521-5ac70d2a08d4', 'Serbisches Akademikernetzwerk - Nikola Tesla e. V.', '', 48.784815, 9.178465, '', '', '', 'Kriegsbergstraße 28', '70174', 'Stuttgart', '', 'plain', 'Aktive Teilhabe an der deutschen Gesellschaft durch Projekte aus den Bereichen Bildung und Kultur. Die Vernetzung von deutschen und serbischen Institutionen und der aktive Wissensaustausch sind hierbei von großer Bedeutung, weshalb die Veranstaltungen für eine breite Öffentlichkeit zugänglich sind.', 'plain', 'Bildung (Bildungsprojekte z. B. Mobile Denkfabrik, Power Einwanderer), Kultur und Kunst (Filmfestival www.filmanak.de, Lesungen).', 'null', '[\"def5709b-04dd-409e-a3d9-2831186574d7\"]', 1),
('537421a5-1e05-4da1-8ebf-9a941be17dea', 'Bolivianisches Kinderhilfswerk e. V.', '', 48.788928, 9.205237, '', '', '', 'Hackstraße 76', '70190', 'Stuttgart', '', 'plain', 'Förderung von Kindern und Jugendlichen in Bolivien. Finanzielle Unterstützung von Bildungsprojekten in Bolivien. Vermittlung von engagierten Jugendlichen über Freiwilligendienste nach Bolivien bzw. Empfang von bolivianischen Freiwilligen in Deutschland.', 'plain', 'Entwicklung und Zusammenarbeit (Freiwilligendienst mit Einsatzland Bolivien, Spenden für Projektunterstützung in Bolivien, Patenschaften).', 'null', '[\"bbf0d197-fcd6-4548-8548-ef1840057018\"]', 1),
('613e7707-7982-4b91-acb0-3b3285179c7f', 'Sri Lanka-Deutschland Freundeskreis e. V.', '', 48.808985, 9.234255, '', '', '', 'Kneippweg 7', '70374', 'Stuttgart', '', 'plain', 'Förderung internationaler Gesinnung, der Toleranz auf allen Gebieten der Kultur und des Völkerverständigungsgedankens und die Förderung mildtätiger Zwecke.', 'plain', 'Bildung (muttersprachlicher Unterricht, Workshops zum Thema Sri Lanka: Land, Leute, Kultur, Gesellschaft, Religion, Politik usw.), Gastronomie (Catering, traditionelles Essen, Kochkurse), Sport (traditioneller Tanz, Indischer Tanz), Musik (traditionelle Musik, Indische Musik, Musikunterricht (Violinee).', 'null', '[\"def5709b-04dd-409e-a3d9-2831186574d7\"]', 1),
('648a26e5-e0f2-4e25-9cb5-f7f48396556c', 'Laboratorium e. V.', '', 48.781281, 9.207733, '', '', '', 'Wagenburgstr. 147', '70186', 'Stuttgart', '', 'plain', 'Förderung von Veranstaltungen kultureller und bildender Art durch Musik-, Kleinkunst-, Theater-, Literatur und Filmveranstaltungen, Vorträge und Ausstellungen.', 'plain', 'Der Name ist Programm: Das Laboratorium ist ein Ort, an dem seit fast 50 Jahren Experimente stattfinden. Musik (Blues, Americana, Singer/Songwriter, Weltmusik, Jazz, Experimentelles und unsere Local Heroes in den verschiedensten Spielarten: Wir lieben gute Musik und Künstler, die etwas zu sagen haben); Kultur und Kunst (das Theaterensemble des Forums der Kulturen, Workshops und politische Themen in Vorträgen und Diskussionen ergänzen die Palette unserer Veranstaltungen).', 'null', '[\"bbf0d197-fcd6-4548-8548-ef1840057018\"]', 1),
('76740b4f-2bcf-43de-9f37-cf0c5ffbb2a2', 'Serbischer Bildungs- und Kulturverein „Prosvjeta“ Deutschland e. V.', '', 48.770168, 9.165382, '', '', '', 'Reinsburgstraße 48', '70178', 'Stuttgart', '', 'plain', 'Durch zweisprachige Vorträge, Diskussionen, Literaturabende, integrative Projekte, kulturelle Veranstaltungen, Musikprojekte sowie durch Projekte in der Muttersprache ist der Verein bemüht, die allgemeine Kultur und Bildung der in Baden-Württemberg lebenden serbischen Bevölkerung und aller anderen interessierten Personen innerhalb des Vereins, zu fördern, zu entwickeln und auch zu präsentieren.', 'plain', 'Bildung (muttersprachlicher Unterricht für Erwachsene, Musikschule für Kinder und Erwachsene), Kultur und Kunst (Kunst- und Literaturworkshops für Kinder und Erwachsene).', 'null', '[\"def5709b-04dd-409e-a3d9-2831186574d7\"]', 1),
('7a6908f7-aaa6-463e-9775-fa919f077c88', 'Firkat, klassisch-türkischer Musikverein Stuttgart e. V.', '', 48.796897, 9.193595, '', '', '', 'Mittnachtstraße 18', '70191', 'Stuttgart', '', 'plain', 'Eine Vereinigung und Verbindung zur Förderung der türkischen Kultur.', 'plain', 'Bildung (Noten- und Instrumentenunterricht für Kinder, Jugendliche, Eltern und Erwachsene), Kultur und Kunst (Konzerte), Musik (klassische türkische Musik, Chor-Gesang).', 'null', '[\"cc67be51-58de-4109-ae78-2b0c018e27da\"]', 1),
('8bdc3e00-4e4a-41e8-ade1-298092173e47', 'Akademie für internationalen Kulturaustausch e. V.', '', 48.768394, 9.179873, '', '', '', 'Olgastraße 93B', '70180', 'Stuttgart', '', 'plain', 'Förderung des internationalen Kulturaustauschs durch Veranstaltungen mit Musik, Poesie und bildender Kunst aus verschiedenen Ländern unter Teilnahme interkultureller Künstler.', 'plain', 'Kultur und Kunst (Poesie, bildende Kunst in einer persönlichen, freundlichen Atmosphäre, wobei viel Gewicht auf Kommunikation zwischen Künstlern und Publikum gelegt wird), Musik (klassische und zeitgenössische Musik).', 'null', '[\"068af935-dc42-40a4-98ef-e59352e9706c\"]', 1),
('8cc19536-dfeb-4be2-b4f8-700f1bb20508', 'Sri Lankisch-Deutscher Verein Stuttgart e. V.', '', 48.830302, 9.217157, '', '', '', 'Hopfenseeweg 3A', '70378', 'Stuttgart', '', 'plain', 'Förderung der Gemeinschaft und die soziale Integration der Sri Lankarnen in Stuttgart und Umgebung.<br/>Das langfristige und übergreifende Ziel ist es, einen kleinen Beitrag zum gemeinsan Dialog und zum Verständnis unter den Menschen beizutragen.', 'plain', 'Bildung (Unterstützung von Projekten in Sri Lanka, Informations - und Diskussionsplattform), Kultur und Kunst (Events, künstlerische und kulturelle Projekte), Soziales und Gesundheit (Hilfsprojekte).', 'null', '[\"cc67be51-58de-4109-ae78-2b0c018e27da\",\"cf4658bb-885d-4937-bfd8-c5a7963a22d0\"]', 1),
('8ed59e73-02ab-4b32-b8fc-5596b740ead2', 'ADD Stuttgart – Verein zur Förderung der Ideen Atatürks e. V.\r Atatürk Düsünce Dernegi Stuttgart', '', 48.761837, 9.159631, '', '', '', 'Möhringerstraße 56', '70199', 'Stuttgart', '', 'plain', '', 'plain', 'Bildung (Nachhilfe für Kinder und Jugendliche in Deutsch, Englisch und Mathematik, Seminare und Kurse für Eltern und Erwachsene im Umgang mit Teenagern und möglichen Problemen, für die Gleichberechtigung und Rechte der Frauen), Kultur und Kunst (Konferenzen mit Gastvorträgen in türkischer Sprache, Veranstaltungen bei türkischen Nationalfeiertagen).', 'null', '[\"03913c8d-c21d-470a-90fc-b3032fc33f4a\"]', 1),
('913ffb7d-c0fe-4f65-8908-c626a0d7e9f0', 'Afrikafestival Stuttgart e. V.', '', 48.762266, 9.160229, 'keine öffentliche Anschrift', '', '', '', '', '', '', 'plain', 'Die Kultur Afrikas den Menschen in Stuttgart und Umgebung näher zu bringen.', 'plain', 'Kultur und Kunst (Kunstmarkt, offene Bühne mit Konzerten und Tanzdarbietungen, Vorträge, Filmvorführungen, Workshops und Theateraufführungen, Deutsch-Afrikanischer Gottesdienst in der Matthäuskirche jährlich am 2. Juliwochenende), Gastronomie (traditionelles Essen), Sport (Tanz).', 'null', '[\"03913c8d-c21d-470a-90fc-b3032fc33f4a\"]', 1),
('93280de9-dbae-48ad-8c67-97c018815fe6', 'Loyenge e. V.', '', 48.772584, 9.242969, '', '', '', 'Ulmer Straße 347', '70327', 'Stuttgart-Wangen', '', 'plain', 'Besseres Verstehen der Situation der Afrikaner in Europa und Afrika. Globalisierung der Kulturen. Vermittlung und Durchführung von Veranstaltungen mit Musik, Infos, Workshops.', 'plain', 'Bildung (Instrumentalunterricht: Trommelkurse &quot;Afrikanisches Trommeln&quot; für alle Altersgruppen), Kultur und Kunst (Theater, Kunst, Vorträge), Gastronomie (Benefizveranstaltungen mit traditionell afrikanischem Essen), Sport (Tanzkurse &quot;African Dance&quot;), Musik (Chor-Gesang, Afrikanischer Chor mit Hif Anga Belowi, Auftritte von Bands mit moderner und traditioneller afrikanischer Musik, Band &quot;Hif &amp; Afro Soleil&quot; (Afropop, Reggae), Band &quot;Hif &amp; Zanga&quot; (traditionelle Musik aus Afrika).', 'null', '[\"068af935-dc42-40a4-98ef-e59352e9706c\"]', 1),
('93ac3a1b-3fa4-4169-89d7-1c240e705fa2', 'Polnischer Kulturverein in Baden-Württemberg e. V.', '', 48.773605, 9.165593, 'keine öffentliche Anschrift', '', '', '', '', '', '', 'plain', 'Pflege und Entwicklung der polnischer Kultur und des polnischen Gesellschaftslebens. Der Verein ist uneigennützig.', 'plain', 'Bildung (Literaturveranstaltung, Lesung); Kultur und Kunst (Feste, Feiern, Ausflüge); Soziales (Gesellschaftliche und Thematische Treffen); Musik (Konzertveranstaltungen).', 'null', '[\"def5709b-04dd-409e-a3d9-2831186574d7\"]', 1),
('9402230d-9858-46a7-bf19-b52f2dbcfe17', 'Verein zur Förderung der zeitgemäßen Lebensweise Baden-Württemberg e. V.', '', 48.764364, 9.174661, '', '', '', 'Filderstraße 19', '70180', 'Stuttgart', '', 'plain', '', 'plain', 'Bildung (Stipendien für Studierende in der Türkei, Vorträge), Musik (musikalische Früherziehung).', 'null', '[\"d4b4dc39-3aa8-421b-991c-a37e3a05f08f\"]', 1),
('96c8695f-5844-40ec-99c1-0be19bc92333', 'China Kultur-Kreis e. V.', '', 48.808862, 9.236805, '', '', '', 'Prießnitzweg 7', '70374', 'Stuttgart', '', 'plain', 'Vermittlung chinesischer Sprachkenntnisse und chinesischer Kultur, Pflege der chinesisch-deutschen Zusammenarbeit und des Dialogs, sowie Förderung interkultureller Kompetenzen. Der Verein gründete 1997 die „Chinesische Sprachschule Stuttgart“, um die chinesische Kultur und Sprache zu unterrichten. Die Schule ist eine Wochenendschule für die in Deutschland lebenden Kinder chinesischer Abstammung und alle Freunde, die sich für die chinesische Kultur und die chinesische Sprache interessieren.', 'plain', 'Bildung (muttersprachlicher Unterricht chinesich, Kurse in der traditionellen chinesischen Kultur).', 'null', '[\"e0c9c7a7-d317-4662-93e5-28f281df4fd9\"]', 1),
('9fe421a6-6fe8-4550-895a-7dc140d65b24', 'Stuttgarter Ungarischer Kindergarten e.V.', '', 48.783945, 9.207342, '', '', '', 'Schönbühlstr. 57', '70188', 'Stuttgart', '', 'plain', 'Der Grundgedanke des Vereins ist, Kindern und Jugendlichen mit ungarischen Wurzeln aus dem Raum Stuttgart einen regelmäßigen Treffpunkt zu bieten, wo sie die ungarsiche Kultur und Sprache kennen lernen und in der Gruppe erleben können.', 'plain', 'Bildung (Förderung und Unterstützung beim Erwerb, Ausbau und Gebrauch der ungarischen Sprache von Kindern und Jugendlichen, Elternbildung, Unterstützung und Begleitung der Familien in der Mehrsprachigen Erziehung, aktiver Beitrag zur ganzheitlichen Entwicklung der Kinder und Jugendlichen); Kunst und Kultur (aktives kennen lernen und Aneignung der ungarischen Kinderkultur, Pflege der ungarischen Traditionen und Feiern).', 'null', '[\"bbf0d197-fcd6-4548-8548-ef1840057018\",\"cc67be51-58de-4109-ae78-2b0c018e27da\"]', 1),
('a025297e-da3d-4c21-b8d3-251819f36ac5', 'ABADÁ Capoeira e. V.', '', 48.809439, 9.226132, 'keine öffentliche Anschrift', '', '', '', '', '', '', 'plain', '', 'plain', 'Sport (Tanz-Kampfsport, Sport im Park, Functional Fitness).', 'null', '[\"d3ea05ed-5dcd-4d47-a2aa-18e4eb6294c0\"]', 1),
('b01b56fa-0975-4e2c-857d-c583ee8769fb', 'StuFem e. V. - Stuttgarter Femina e. V. (akademischer Frauenverein)', '', 48.812167, 9.226198, '', '', '', 'Oppelnerstraße 1', '70372', 'Stuttgart', '', 'plain', 'Die Mitglieder des Vereins setzen ihren Migrationshintergrund als Bereicherung ein und möchten diesen zur Förderung von interkulturellem Dialog und der Gleichberechtigung der Geschlechter in den Mittelpunkt stellen.', 'plain', 'Bildung (Workshops und Infoabende zur beruflichen Perspektive von Frauen, Unterstützung von Kultur- Austauschprogrammen), Kultur und Kunst (interkulturelle After Work Begegnung, interreligiöse Begegnungen, Kunst, Ebru Kurs, Fillografie), Gastronomie (Kochkurs, Catering).', 'null', '[\"def5709b-04dd-409e-a3d9-2831186574d7\"]', 1),
('b4926027-0ee2-497f-ad14-d9c85bf1b9fc', 'Africa Workshop Organisation e. V.', '', 48.772166, 9.174594, '', '', '', 'Tübinger Straße 15', '70178', 'Stuttgart', '', 'plain', 'Bekanntmachung der afrikanischen Kultur, Unterstützung bei der Integration in die Stuttgarter Gesellschaft. Der Verein ist als humanitäre Selbsthilfegruppe und Völkerverständigungsverein seit 1988 in der Region Stuttgart aktiv.', 'plain', 'Bildung (Zielgruppe Kinder, Jugendliche, Eltern und Erwachsene), Soziales und Gesundheit (Arbeit mit Senior*innen, Menschen mit Behinderung), Entwicklung und Zusammenarbeit (Integrationshilfe), Engagement für Geflüchtete (Zusammenarbeit mit Geflüchteten).', 'null', '[\"d4b4dc39-3aa8-421b-991c-a37e3a05f08f\"]', 1),
('b6ce400f-ae69-49e3-9e25-3fad409ee5cc', 'Baye-Fall e. V. senegalesisch-deutsche Vereinigung', '', 48.802498, 9.109533, '', '', '', 'Kiebitzweg 7', '70499', 'Stuttgart', '', 'plain', 'Förderung von Kunst und Kultur, Förderung der internationalen Gesinnung und des Völkerverständigungsgedankens sowie die Förderung<br/>der Entwicklungszusammenarbeit.', 'plain', 'Bildung (Übersetzungs- und Dolmetscherdienst, Simultanübersetzungen bei Refugio Stuttgart e. V.), Kultur und Kunst (Kulturveranstaltungen, Teilnahme an Kulturveranstaltungen und Straßenfesten, Reparatur von westafrikanischen Trommeln), Gastronomie (Catering, traditionell senegalesiches Essen), Musik (westafrikanisch, Afrobeat, Reggae, Trommelworkshops).', 'null', '[\"ff52e1fb-b421-46d4-828b-9e1298a441cf\",\"068af935-dc42-40a4-98ef-e59352e9706c\",\"bbf0d197-fcd6-4548-8548-ef1840057018\"]', 1),
('bd8d434d-53df-45d5-9fa8-6215dd123969', 'Deutsch-Rumänisches Forum e. V.', '', 48.776965, 9.163543, '', '', '', 'Schloßstraße 76', '70176', 'Stuttgart', '', 'plain', 'Orientierung – Akkommodation, zivilgesellschaftliche Inklusion in Stuttgart für rumänische und moldauische Diaspora.', 'plain', 'Bildung (Multiplikator für Stuttgarter Bildung und Workshops), Kultur und Kunst (Kulturveranstaltungen als Treffen der Gemeinde zu diversen Themen und Traditionen Rumäniens), Beratung (Telefon Hotline – kostenlose Sofortberatung).', 'null', '[\"cf4658bb-885d-4937-bfd8-c5a7963a22d0\"]', 1),
('bf0a4c28-4139-46d1-8a7d-ec8da2e108f6', 'Asociación Ecuatoriana e. V.', '', 48.775484, 9.155293, '', '', '', 'Bebelstraße 22', '70193', 'Stuttgart', '', 'plain', 'Das Land Ecuador und seine Kultur der deutschen Bevölkerung näher bringen.', 'plain', 'Entwicklung und Zusammenarbeit (Integrationshilfe, Unterstützung von Ecuadorianer*innen in Deutschland), Gastronomie (traditionelles ecuadorianisches Essen), Sport (Tanz).', 'null', '[]', 1),
('d34735bf-1a86-4238-9962-df39f98e06e1', 'Deutsch-Türkisches Forum Stuttgart e. V.', '', 48.773637, 9.175521, '', '', '', 'Hirschstraße 36', '70173', 'Stuttgart', '', 'plain', 'Förderung der kulturellen Begegnung, Verständigung und Zusammenarbeit. Mit Bildungsinitiativen und Kulturprogrammen leistet das DTF eigenständige Beiträge zur gesellschaftlichen Teilhabe türkeistämmiger Zuwanderer. Es tritt insbesondere für mehr Chancengleichheit in Bildung, Beruf und Gesellschaft ein. Dabei setzt es vor allem auf vielseitiges bürgerschaftliches Engagement. Das DTF ist partei- und konfessionsunabhängig.', 'plain', 'Bildung (Politik, Gesellschaftliches), Kultur und Kunst (zeitgenössische türkische Kunst und Künstler*innen).', 'null', '[\"d4b4dc39-3aa8-421b-991c-a37e3a05f08f\"]', 1),
('d9c363cc-20e1-4079-935e-0ad2f9fc73c4', 'Verein für Internationale Jugendarbeit e. V.', '', 48.779022, 9.187839, '', '', '', 'Moserstr. 10', '70182', 'Stuttgart', '', 'plain', 'Mit unserer Arbeit fördern wir die Begegnung und den Austausch zwischen Menschen unterschiedlicher Herkunft, Kultur und Religion und setzen uns für deren Chancen und Rechte ein. Der VIJ unterhält verschiedene Beratungsdienste sowie Bildungs- und Begegnungsangebote und ist Träger der Bahnhofsmission in Württemberg. Die Arbeitsbereiche sind: Arbeit und Bildung, Bahnhofsmission, Fraueninformationszentrum – FIZ, Zentralstelle MiA-Kurse, Zentrum für Integration und Mosaik – Kultur und Begegnung.', 'plain', 'Bildung (Beratung zu Arbeitsmarktintegration und Weiterbildung: Vermittlungsangebot für osteuropäische Betreuungskräfte, Interkulturelle Gründungsberatung, Coaching, Beratung von nicht EU-Angehörigen, muttersprachliche psychosoziale Beratung bei Krisen in der Migration, Menschenhandel und Arbeitsausbeutung, psychosoziale Prozessbegleitung, Deutschkurse, Migrationsberatung); Kultur und Kunst (Begegnungsraum Mosaik, Club International für junge Leute, die in Stuttgart Anschluss suchen, Jugendwohnheim).', 'null', '[\"068af935-dc42-40a4-98ef-e59352e9706c\"]', 1),
('da82a250-69ad-45a7-aa8b-4a49efa7fd6e', 'Female Fellows e. V.', '', 48.790071, 9.210416, '', '', '', 'Teckstr. 62', '70190', 'Stuttgart', '', 'plain', 'Der Verein Female Fellows e.V. setzt sich aktuell insbesondere für die Stärkung von Frauen mit Flucht - und Migrationserfahrung ein. Unter dem Motto „Hinter jeder starken Frau stehen starke Frauen“ möchten wir zum Fempowerment und damit zu einer Gesellschaft beitragen, die ihre Vielfalt lebt und in der alle gleichberechtigt mitgestalten. Die ehrenamtlich vermittelten Tandem - Projekte in Stuttgart, Bietigheim - Bissingen und Tübingen zeichnen sich daher neben sprachlicher und alltäglicher Unterstützung vor allem durch Events und Unternehmungen jeglicher Art aus – denn Begegnungen sind der Schlüssel für einen inspirierenden, helfenden, offenen und horizonterweiternden Umgang miteinander.', 'plain', 'Bildung (Infoveranstaltungen/Workshops bspw. zu Frauengesundheitsthemen, Selbstverteidigungskurs uvm.); Kultur und Kunst (diverse monatliche Events: picknicken, Kochevents, tanzen, Unternehmungen in und um Stuttgart); Geflüchtete (Fempowerment durch intensiven kulturellen Austausch).', 'null', '[\"def5709b-04dd-409e-a3d9-2831186574d7\"]', 1),
('de1c9de5-4670-4826-8ea3-40c390f77f78', 'Nordkaukasischer Kulturverein Stuttgart (NART) e. V.', '', 48.711395, 9.15437, '', '', '', 'Bonhoefferweg 14', '70565', 'Stuttgart', '', 'plain', 'Die kaukasische Kultur und die Sprachen zu erhalten diese Mitgliedern, Kulturinteressierten und vor allem einer breiten Öffentlichkeit zugänglich zu machen.<br/>Förderung soziokultureller Aufgaben und Anliegen in Stuttgart auf gemeinnütziger Basis. Leitbild: Kultur gehört zum Menschen – unabhängig von seiner persönlichen Situation und sozialen Lage. Der Verein ist bunt an Sprachen, Kulturen und Identitäten – genauso wie der Kaukasus!', 'plain', 'Bildung (muttersprachlicher Unterricht), Sport (Tanz), Musik (Musikwerkstatt, Chor-Gesang).', 'null', '[\"d4b4dc39-3aa8-421b-991c-a37e3a05f08f\"]', 1),
('df269e2c-c94c-479e-b481-76ff20eb7ed2', 'Black Community Foundation Stuttgart', '', 48.778669, 9.179631, 'keine öffentliche Anschrift', '', '', '', '', '', '', 'plain', 'Kampf gegen Anti Schwarzen Rassismus, Empowerment der Black Community, Rassismus Sensibilisierung.', 'plain', 'Bildung (Sensibilisierungs Workshops und Arbeit gegen Rassismus im Fokus auf Anti Schwarzen Rassismus, Empowerment Workshops zu verschiedenen Themen für die Black Community und PoCs); Beratung (Unterstützung von Blackowned Businesses und Schwarzen Künstlern, wie Artists); Kultur und Kunst (Teilnahme an Diskussionsrunden, Aufklärung an Schulen, Tägliches Aufklären verschiedener Themen auf unserem IG Account).', 'null', '[\"def5709b-04dd-409e-a3d9-2831186574d7\"]', 1),
('e35345ca-0c79-4150-8e50-ce85f732bd4f', 'Forum der Kulturen Stuttgart e. V.', '', 48.775471, 9.177591, '', '', '', 'Marktplatz 4', '70173', 'Stuttgart', '', 'plain', 'Dachverband der Migrantenvereine und interkulturellen Einrichtungen<br/>Stuttgarter Interkulturbüro<br/>Mitglied im Bundesverband Netzwerke von Migrantenorganisationen e. V. (NeMO)', 'plain', '', 'null', '[\"def5709b-04dd-409e-a3d9-2831186574d7\"]', 1),
('e5e1bb6f-c38b-48e7-9d28-44a37dfb4d9d', 'Jesidische Sonne Stuttgart Ezidische Sonne Stuttgart', '', 48.804904, 9.221803, 'keine öffentliche Anschrift', '', '', '', '', '', '', 'plain', '', 'plain', 'Kultur und Kunst, Entwicklung und Zusammenarbeit (Integrationshilfe, Unterstützung der jesidischen Gemeinde in Baden-Württemberg), Engagement für Geflüchtete (Zusammenarbeit mit Geflüchteten), Gastronomie (traditionelles Essen), Sport (Tanz).', 'null', '[\"d3ea05ed-5dcd-4d47-a2aa-18e4eb6294c0\"]', 1),
('e631f1c8-ef66-4e22-962e-f45d18ef9eee', 'Club Español Stuttgart e. V.', '', 48.78043, 9.182522, 'keine öffentliche Anschrift', '', '', '', '', '', '', 'plain', 'Förderung, Erhalt und Entwicklung der spanischen Kultur und Sprache, traditionelles Brauchtum und das Miteinenderleben von Spaniern, Deutschen und anderen spanischsprachigen Nationalitäten. Förderung von Sport und Internationaler Gesinnung, der Toleranz auf allen Gebieten der Kultur und des Völkerverständigungsgedankens. Unterstützung von hilfsbedürftigen Personen und Hilfsorganisationen.', 'plain', 'Bildung (Seminare,Vorträge, Workshops), Kultur und Kunst (Spanische Kulturtage, Kunst, Film, Theater), Gastronomie (Kochkurse, Stadtfeste), Sport (Fußsballturniere,Tanzkurse, traditioneller Tanz Flamenco)​, Musik (Konzerte).', 'null', '[\"def5709b-04dd-409e-a3d9-2831186574d7\"]', 1),
('e7928fb7-d155-4e58-8433-331ef1363dca', 'Womendays e. V.', '', 48.778448, 9.180013, '', '', '', '70342 Stuttgart', '', '', '', 'plain', 'Wir sind ein Netzwerk von Frauen mit afrikanischen Wurzeln, die für die Verbesserung des Status der Frauen engagiert sind.', 'plain', 'Bildung (Coaching Workshops und Seminare, Regelmäßige digitale Webinare für Frauen (&quot;Frauen: Vereinbarkeit Job-Familie-Ich, Wie?&quot;, &quot;Frauen: Das Loslassen lernen&quot;)); Kultur und Kunst (Weihnachtsgala mit Kinderaufführungen: Theater, Gedichte, Choreographie, Austausch im Rahmen des internationalen Frauentages); Sport ( CamShakeFit: Den Stress wegtanzen mit afrikanischer Musik).', 'null', '[\"e5c49e46-df39-46aa-af7c-c59c8d9765eb\"]', 1),
('ef52c7b3-624b-4850-a6cb-b06503ae414d', 'Vietnam Community Stuttgart VCS', '', 48.710085, 9.202935, '', '', '', 'Wollgrasweg 11', '70599', 'Stuttgart', '', 'plain', 'Forum für Vietnamesen und Nichtvietnamesen, Kontakte und kultureller Austausch, Vermittler für deutsche und vietnamesische Organisationen.', 'plain', 'Kultur und Kunst (Vorträge, Veranstaltungen in Deutsch und Vietnamesisch zu Themen Gesundheit, Sprachen, vietnamesische Literatur), Soziales und Gesundheit, Entwicklung und Zusammenarbeit (Integrationshilfe), Musik (traditionelle Musik).', 'null', '[\"def5709b-04dd-409e-a3d9-2831186574d7\"]', 1),
('f6301d5b-e7fa-4c10-87f7-4b3b3195ced2', 'Kulturverein Slovenija-Stuttgart e. V.', '', 48.77364, 9.191878, '', '', '', 'Stafflenbergstraße 64', '70184', 'Stuttgart', '', 'plain', 'Förderung und Pflege des slowenischen kulturellen Lebens in Stuttgart.', 'plain', 'Bildung (Sprachförderung bei Kindern und Jugendlichen), Kultur und Kunst (literarische Abende, Kulturabende), Musik (Veranstaltungen mit verschiedenen Chören und Gesangsgruppen aus Slowenien).', 'null', '[\"bbf0d197-fcd6-4548-8548-ef1840057018\"]', 1),
('f951a820-7dd7-47dc-bd41-e97791024e73', 'Deutsch-Chinesisches Forum Stuttgart e. V.', '', 48.708403, 9.171189, '', '', '', 'Zettachring 12A', '70567', 'Stuttgart', '', 'plain', 'Das Deutsch-Chinesische Forum Stuttgart fördert die gegenseitige Verständigung und das Kennenlernen. Es ist unabhängig und überparteilich. Das Forum bietet allen, die sich für einen unvoreingenommenen Dialog einsetzen, eine offene Plattform. Das Forum ist als gemeinnützig anerkannt. Der Verein fördert die Bildung, Ausbildung und Erziehung zum besseren Verständnis der Völker in Deutschland und China sowie den kulturellen, wirtschaftlichen und gesellschaftlichen Austausch.', 'plain', 'Bildung (muttersprachlicher Unterricht chinesich in der Huade Chinesisch-Schule für Kinder und Jugendliche, hochqualifizierter Sprachunterricht sowie interkulturelles Training mit dem Deutsch-Chinesischen Sprachinstitut Stuttgart, für Erwachsene, Privatpersonen, Organisationen sowie Unternehmen); Kultur und Kunst (vielfältiges Angebot von Veranstaltungen und Fachvorträgen zur Erreichung der Vereinsziele); Soziales (engagieren sich sozialpolitisch und helfen den chinesischen Mitbürger*innen bei der Integration in die deutsche Gesellschaft).', 'null', '[\"def5709b-04dd-409e-a3d9-2831186574d7\"]', 1),
('fa768a9d-1a54-4477-bcfe-3c9fcfda6c21', 'Internationales Forum für Wissenschaft, Bildung und Kultur e. V.', '', 48.808912, 9.229857, 'keine öffentliche Anschrift', '', '', '', '', '', '', 'plain', 'Popularisierung und Förderung der Wissenschaft, Bildung, Kunst und Kultur für alle Generationen, insbesondere für Kinder und Jugendliche auf regionaler, nationaler und internationaler Ebene. Der Verein bleibt bei der Verfolgung dieser Ziele politisch und konfessionell neutral.', 'plain', 'Bildung (MINT Projekt), Kultur und Kunst (Klassische Konzerte für Kinder und Jugendliche).', 'null', '[\"068af935-dc42-40a4-98ef-e59352e9706c\"]', 1),
('fa937f0d-a0f5-4cab-8c6d-10d95d8b42b1', 'Stuttgarter Dante-Gesellschaft e. V. Società Dante Alighieri Comitato di Stoccarda', '', 48.780413, 9.182478, 'keine öffentliche Anschrift', '', '', '', '', '', '', 'plain', 'Verständigung zweier großer Kulturvölker durch ein vielfältiges Angebot an Vorträgen, Lesungen, Konzerten, Führungen, Diskussionen und Reisen.', 'plain', 'Kultur und Kunst (Vorträge, Lesungen, Literaturveranstaltungen, Konzerte, Kunstführungen, Diskussionen, Sprach- und Kulturreisen, Veranstaltungskalender).', 'null', '[]', 1);
INSERT INTO `associations` (`id`, `name`, `shortName`, `lat`, `lng`, `addressLine1`, `addressLine2`, `addressLine3`, `street`, `postcode`, `city`, `country`, `goals_format`, `goals_text`, `activities_format`, `activities_text`, `activityList`, `districtList`, `current`) VALUES
('fef187fb-7b62-4a0d-8dba-1f9c9bbf2f7d', 'Freunde des Italienischen Kulturinstituts in Stuttgart e. V.', '', 48.765011, 9.169502, '', '', '', 'Kolbstraße 6', '70178', 'Stuttgart', '', 'plain', 'Bekanntmachung der italienischen Kultur und Sprache.', 'plain', 'Bildung (Sprachunterricht, Italienischkurse für alle).', 'null', '[\"03913c8d-c21d-470a-90fc-b3032fc33f4a\"]', 1);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `contacts`
--

CREATE TABLE `contacts` (
  `id` varchar(36) NOT NULL,
  `name` varchar(512) DEFAULT NULL,
  `poBox` varchar(500) DEFAULT NULL,
  `phone` varchar(512) DEFAULT NULL,
  `fax` varchar(512) DEFAULT NULL,
  `mail` varchar(512) DEFAULT NULL,
  `associationId` varchar(36) NOT NULL,
  `orderIndex` int(11) DEFAULT NULL,
  `current` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Daten für Tabelle `contacts`
--

INSERT INTO `contacts` (`id`, `name`, `poBox`, `phone`, `fax`, `mail`, `associationId`, `orderIndex`, `current`) VALUES
('0424b16f-9914-42dd-87b1-726640fd8998', '', '', '', '', 'stuttgart@ada-netzwerk.com', '409d1bc5-f179-47a4-aef6-7487677dee7d', 0, 1),
('059306c0-0bf7-4f65-9e64-e8dcd5fb25b6', '', '', '0178/3888986', '', 'n.jayasuriya@gmx.de', '8cc19536-dfeb-4be2-b4f8-700f1bb20508', 0, 1),
('06f7a9f5-cb16-4283-a2b7-eb817076b325', '', '', '0173/1912555', '', 'info@forum-wbk.de', 'fa768a9d-1a54-4477-bcfe-3c9fcfda6c21', 0, 1),
('0c841bf6-1b11-48a5-bf43-6b67f95f7ee4', '', '', '', '', 'info@nart-stuttgart.de', 'de1c9de5-4670-4826-8ea3-40c390f77f78', 0, 1),
('0e37c27b-c862-4d7e-a77b-7b6334633e75', '', '', '', '', 'vietnamcommunitystuttgart@googlemail.com', 'ef52c7b3-624b-4850-a6cb-b06503ae414d', 0, 1),
('0f9fc953-cc7d-40b5-b559-05a0e9cada49', '', '', '', '', 'info@kd-slovenija.de', 'f6301d5b-e7fa-4c10-87f7-4b3b3195ced2', 0, 1),
('1247f0f7-dc8e-40d6-b7ab-f5127de77938', '', '', '0711/94529847', '', 'info@stufem.de', 'b01b56fa-0975-4e2c-857d-c583ee8769fb', 0, 1),
('127969ab-a13a-408a-926b-511e5b733ff4', '', '', '0179/5010311', '', 'post@latin-jazz-initiative.de', '0f000100-38cd-4c94-953c-c7b5740ac9c7', 0, 1),
('142950b2-5282-437f-8e48-e9adc8869042', '', '', '', '', 'info@afrikafestival-stuttgart.de', '913ffb7d-c0fe-4f65-8908-c626a0d7e9f0', 0, 1),
('1655631a-acc6-4c6f-86d4-6c3506f63f14', '', '', '07183949374', '', 'marianne.frank.mast@gmx.net', '18c775ef-37d5-49ee-8745-bd5491f6eab3', 0, 1),
('2157122a-d236-4d71-841d-c2df6b6749aa', '', '', '0173/9718681', '', 'castillajor@aol.com', 'e631f1c8-ef66-4e22-962e-f45d18ef9eee', 0, 1),
('21d7d8e5-0879-458f-86c6-c99eda3d8c83', '', '', '0172/6334382', '', 'igboculturalfoundation@gmail.com', '45abe07b-cdec-41ee-a0be-b293fd8c0e15', 0, 1),
('21f0f8ba-01bc-48f8-a6a7-69261f55992a', '', '', '0176/82078688', '', 'info@klangoase-derya.de', '3ba452ea-ee50-4ef8-80b2-12e986d823d4', 0, 1),
('26e3c633-7a93-4cd4-ba80-1019dff53a7e', '', '', '0711/248 44 41', '', 'info@dtf-stuttgart.de', 'd34735bf-1a86-4238-9962-df39f98e06e1', 0, 1),
('2e879f9e-2efd-4465-bb1e-d4360caac6e5', '', '', '0711/6143552', '', 'hif@afro-soleil.de', '93280de9-dbae-48ad-8c67-97c018815fe6', 0, 1),
('3796bdb3-dc02-4654-aaca-eea5adcf804f', '', '', '0711/55 08 963', '', 'yputra@web.de', '613e7707-7982-4b91-acb0-3b3285179c7f', 0, 1),
('38f37ddc-0862-497d-9d7f-6c5aabcd390e', '', '', '', '', 'bcf.stuttgart@gmail.com', 'df269e2c-c94c-479e-b481-76ff20eb7ed2', 0, 1),
('3b9aae7e-bee0-4063-81f4-59c7aeea2011', '', '', '0711/528 67 36', '', 'info@chinesische-sprachschule-stuttgart.de', '96c8695f-5844-40ec-99c1-0be19bc92333', 0, 1),
('40d30bfe-9fa7-4da5-9576-1a61701d3c76', '', '', '', '', 'info@spspfrauen.org', '4be37ec0-dd64-4dbe-8ebf-2a79e4606fa8', 0, 1),
('428e97af-99ff-4946-87e2-05c5199db0b4', '', '', '', '', 'EritreischeVereinigung.ev@t-online.de', '09c84ef4-3302-4868-b0a8-590d28b2e11a', 0, 1),
('42fbe257-2a94-4f7f-bea8-b4e75290fd98', '', '', '0157/82965484', '', 'info@forum-afrikanum.de', '23d06b99-29d4-4f80-a065-bf4c6d309af8', 0, 1),
('435eb42a-1ba7-4a0b-a1e9-685188cc0ece', '', '', '0163/650 86 04', '', 'G.koeksal@gmx.de', '8ed59e73-02ab-4b32-b8fc-5596b740ead2', 0, 1),
('599326b8-50f5-4ab0-91bb-7a4e718299c3', '', '', '', '', 'info@femalefellows.com', 'da82a250-69ad-45a7-aa8b-4a49efa7fd6e', 0, 1),
('5dc36787-3b99-44e3-bea3-1ed4b2e99dbc', '', 'Postfach 150 462, 70076 Stuttgart', '', '', 'info@dante-stuttgart.de', 'fa937f0d-a0f5-4cab-8c6d-10d95d8b42b1', 0, 1),
('5f7a9223-636c-43c0-8b59-cdb0104db2c7', '', '', '0711/8946890', '', 'info@bkhw.org', '537421a5-1e05-4da1-8ebf-9a941be17dea', 0, 1),
('6066bc7f-8109-4b45-b2f7-e0011b39b2d5', '', '', '', '', 'vorstand@yallaev.de', '12e960bb-0b60-472b-828b-b7cdfd4153e8', 0, 1),
('61d0aa07-b528-44c4-bac0-ceace7c1b942', '', '', 'https://www.instagram.com/juma_stuttgart/?hl=de', '', '', '17629f08-1f85-4876-bb13-cf91616f20b7', 1, 1),
('652ec659-c2aa-471e-990d-8c28eab43f35', '', '', '0178/8346746', '', 'info@herosacademy.org', '357ea7a6-da38-4b03-bc58-12e6e53f196d', 0, 1),
('6637fd42-c437-4fdf-9ee6-cd79613824b2', '', '', '0711/640 74 82', '', 'aylishk@aol.com', '8bdc3e00-4e4a-41e8-ade1-298092173e47', 0, 1),
('678e15cf-7aee-4e90-9e0a-357e7b0fd2a7', '', '', 'https://de-de.facebook.com/JumaProjektJungMuslimischAktiv/', '', 'info@juma-ev.de, bawue@juma-ev.de', '17629f08-1f85-4876-bb13-cf91616f20b7', 0, 1),
('6833ca15-1bc7-47ea-b78c-bc2e89d3d299', '', '', '0176/24909496', '', 'team@stelp.eu', '4075fc5d-ae34-47d4-92e9-f6291b4d901f', 0, 1),
('6c99e24d-7040-475c-a4f7-c596d12fc8dd', '', '', '', '', 'skolan-i-stuttgart@gmx.de', '01b97f40-b03f-4a9e-b738-8be2f682fbaa', 0, 1),
('7661d854-ca5f-48a9-af57-595d7861704b', '', '', '0711 239 41 33', '', 'mosaik@vij-wuerttemberg.de', 'd9c363cc-20e1-4079-935e-0ad2f9fc73c4', 0, 1),
('76955b64-5589-4bcd-a33a-95ff5d5a4de8', '', '', '0711/248 48 08-0', '0711/248 48 08-88', 'info@forum-der-kulturen.de', 'e35345ca-0c79-4150-8e50-ce85f732bd4f', 0, 1),
('7993ad1b-4496-4d9d-b044-15e904cc3bc9', '', '', '', '', 'mail@punto-de-encuentro.net', '1c58eac8-e49b-4341-8d26-7b07e638f8c9', 0, 1),
('7ccafe16-4394-4e76-b037-dc53dc3b6f65', '', '', '0173/412 71 83', '', 'Yalova@hotmail.de', '7a6908f7-aaa6-463e-9775-fa919f077c88', 0, 1),
('8398313f-703b-488b-a503-c27b885cbba2', '', '', '0172/8578716', '', 'info@abada-capoeira.eu', 'a025297e-da3d-4c21-b8d3-251819f36ac5', 0, 1),
('951c8449-c61d-4be5-bcd6-311f46d9b25d', '', '', '0711/60 44 06', '', 'schaal.stuttgart@freenet.de', 'bf0a4c28-4139-46d1-8a7d-ec8da2e108f6', 0, 1),
('9d6d1bd6-3ff3-4333-9657-8398f4fda39e', '', '', '07192/200 82', '', '2009ggsa@gmail.com', 'b4926027-0ee2-497f-ad14-d9c85bf1b9fc', 0, 1),
('a0775ecd-47d1-4641-827d-f549a4cedc37', '', '', '', '', 'stuttgart@femalefellows.com (Anmeldung zum Tandemprojekt)', 'da82a250-69ad-45a7-aa8b-4a49efa7fd6e', 1, 1),
('a68f47ec-5ee6-468b-84e5-aaf5538fb7a1', '', '', '0157/790 78 470', '', 'info@forum-gerrum-stuttgart.de', 'bd8d434d-53df-45d5-9fa8-6215dd123969', 0, 1),
('aa29d309-e209-46aa-bd6e-b01f4d20b91a', '', '', '', '', 'pssk.stuttgart@t-online.de', '93ac3a1b-3fa4-4169-89d7-1c240e705fa2', 0, 1),
('aa65e83a-d630-414a-aced-0064eb19d282', '', '', '', '', 'info@tigre.de', '464b856f-beec-450c-a25c-5e2b923bb20a', 0, 1),
('b0d95259-5ab4-466d-9cf9-fa63495a851b', '', '', '', '', 'info@capoeira-stuttgart.org', '4cc04cbb-8b19-4afb-8382-675f2ab08ba8', 0, 1),
('b960e238-89cb-4ad0-93ec-a9947c9ad98b', '', '', '0179 9883220', '', '', '02b46ae8-d1ed-4b34-b05d-491a400cf66d', 1, 1),
('c3c0ef38-ace4-48c0-875f-dd84ce92d344', '', '', '0151/75859183', '', 'prosvjeta.stuttgart@gmx.de', '76740b4f-2bcf-43de-9f37-cf0c5ffbb2a2', 0, 1),
('c52b8d0f-320d-4803-8243-0cae06d76a7e', '', '', '', '', 'office@sam-nt.de', '4cd5f88c-6cce-4d35-8521-5ac70d2a08d4', 0, 1),
('c9a97850-3d9b-451f-a3b1-b5de7698d56f', '', '', '0162 876 2095', '', 'arrafidainschule@gmx.de', '02b46ae8-d1ed-4b34-b05d-491a400cf66d', 0, 1),
('c9ca5245-a774-429f-9056-30f6654e0761', '', '', '0711/964 12 53', '', 'info@multicolor-stuttgart.de', '46b88ff4-b7d2-48c8-9287-9a4df986ade2', 0, 1),
('d061ac10-9541-4328-b952-7cf6ca5e68c4', '', '', '0711/8601188', '', '', 'e5e1bb6f-c38b-48e7-9d28-44a37dfb4d9d', 0, 1),
('d5de5abb-994b-4a2b-8a6e-11a0193f2cd3', '', '', '0176/81057694', '', 'info@adelitas.de', '2e23fb7b-8e8d-4fbb-9c2d-e9fcebabd353', 0, 1),
('d8f266cf-68d8-4843-b154-3fee810f4818', '', '', '', '', 'info@stuttgarti-magyar-gyerekeknek.de', '9fe421a6-6fe8-4550-895a-7dc140d65b24', 0, 1),
('dc027f5a-9179-47c9-ae99-1a0d0887a161', '', '', '0711/8601304', '', 'baye_fall_ev@yahoo.com', 'b6ce400f-ae69-49e3-9e25-3fad409ee5cc', 0, 1),
('e04892c4-9dbe-44be-9917-bceeffeb89ae', '', '', '0170/582 6402', '', 'ozaharsha@gmail.com', '398792e6-1afc-4600-ab16-3118f2a627f1', 0, 1),
('e11e9497-bbc2-4300-a045-50adb2c0d1b2', '', '', '0711-86025544', '', 'info@ars-narrandi.de', '29988195-497a-443c-ae69-0facbbef31ca', 0, 1),
('e56713fc-d688-4144-92b6-09881334fdfc', '', '', '0152/08790860', '', 'info@ndwenga-fellbach.de', '2be3d117-a995-459e-8ae4-7d00fcd6cf74', 0, 1),
('e6d1e066-db3a-4745-a897-7d976a0d5ab1', '', '', '0157779577870', '', 'saime@latviesi.com', '2b78dd70-b3d6-48b4-8592-c66028876863', 0, 1),
('e6e97860-ff03-4d1f-b9e6-37e4cbea2161', '', '', '0711/162 81 20', '', 'corsilingua.iicstuttgart@esteri.it', 'fef187fb-7b62-4a0d-8dba-1f9c9bbf2f7d', 0, 1),
('e88fa9f1-bb9c-4947-b8d2-7100d4f69721', '', '', '', '', 'info@kalimera-ev.de', '2587605d-d2cf-4087-9a22-936e24debca3', 0, 1),
('ea9a3b8c-cc70-4a91-8496-bfccb617d92c', '', '', '', '', 'Kontakt@dmstuttgart.de', '4acbc0ea-0fcd-470a-a50c-ddbc12442eec', 0, 1),
('ec069ec8-39ad-49e0-bf38-addfa13686fb', '', '', '', '', 'coexist@t-online.de', '0e37656b-78da-4639-ac91-8b04b7d49e34', 0, 1),
('f8ba83d0-630c-4b5e-953c-dc433620d4af', '', '', '0711/78781883', '', 'info@dcfsev.org', 'f951a820-7dd7-47dc-bd41-e97791024e73', 0, 1),
('f9a78497-4b0b-42e7-ac74-2a69c18e4bfb', '', '', '', '', 'sc-stuttgart@gmx.de', '193af93b-0329-464a-887e-3bef9aa800b4', 0, 1),
('fbef9bdb-7eb2-494a-9295-26009dd4d156', '', '', '0711-5052001', '', 'info@laboratorium-stuttgart.de', '648a26e5-e0f2-4e25-9cb5-f7f48396556c', 0, 1),
('fc51fb4f-45c3-43ac-a046-95184a278ef4', '', '', '0176/456 751 31', '', 'info@vereinpavaresia.de', '0ddb204a-a10b-4d75-aa9c-b705b3316214', 0, 1);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `districts`
--

CREATE TABLE `districts` (
  `value` varchar(36) NOT NULL,
  `label` varchar(512) NOT NULL,
  `category` varchar(36) DEFAULT NULL,
  `orderIndex` int(11) DEFAULT NULL,
  `current` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Daten für Tabelle `districts`
--

INSERT INTO `districts` (`value`, `label`, `category`, `orderIndex`, `current`) VALUES
('03913c8d-c21d-470a-90fc-b3032fc33f4a', 'Stuttgart-Süd', 'd4b4dc39-3aa8-421b-991c-a37e3a05f08f', 1, 1),
('068af935-dc42-40a4-98ef-e59352e9706c', 'Stuttgart-Mitte', 'd4b4dc39-3aa8-421b-991c-a37e3a05f08f', 1, 1),
('0f91a15c-dd80-47c5-915e-b5b596641929', 'Übergreifend', NULL, 3, 1),
('126c225a-cd98-4560-8fae-94cd0ec0bff4', 'Bundesweit (Deutschland)', '0f91a15c-dd80-47c5-915e-b5b596641929', 3, 1),
('1a04156f-facc-494c-8061-7fc8138adf91', 'Ludwigsburg', '2717c531-6aa6-4d87-80d7-f70141d04c63', 2, 1),
('1a68b204-3bc7-4ebd-a5a9-effc1b65dcb1', 'Stuttgart-Zuffenhausen', 'd4b4dc39-3aa8-421b-991c-a37e3a05f08f', 1, 1),
('2717c531-6aa6-4d87-80d7-f70141d04c63', 'Region Stuttgart', NULL, 2, 1),
('29681fff-3d9a-4d88-b4fa-5984a2f3fbbf', 'Leonberg', '2717c531-6aa6-4d87-80d7-f70141d04c63', 2, 1),
('32db5a17-3732-498e-a6c9-1f87f79a7ecb', 'Stuttgart-Sillenbuch', 'd4b4dc39-3aa8-421b-991c-a37e3a05f08f', 1, 1),
('38fb84bd-9bc3-416f-ade8-1d4be4fdb22e', 'Esslingen am Neckar', '2717c531-6aa6-4d87-80d7-f70141d04c63', 2, 1),
('45b57423-e7ea-4e3e-ba37-5e0ec506b1f6', 'Stuttgart-Münster', 'd4b4dc39-3aa8-421b-991c-a37e3a05f08f', 1, 1),
('484d4d38-c9e3-4026-833d-69c3190422d9', 'Stuttgart-Obertürkheim', 'd4b4dc39-3aa8-421b-991c-a37e3a05f08f', 1, 1),
('4c2c4518-f53d-409d-9c3c-35dbd7ec5395', 'Stuttgart-Stammheim', 'd4b4dc39-3aa8-421b-991c-a37e3a05f08f', 1, 1),
('4e5d36ad-8387-47c5-9c48-5a5e933e6812', 'Stuttgart-Hedelfingen', 'd4b4dc39-3aa8-421b-991c-a37e3a05f08f', 1, 1),
('52fc72f5-5b87-4eea-a662-87dc14180f1f', 'Stuttgart-Vaihingen', 'd4b4dc39-3aa8-421b-991c-a37e3a05f08f', 1, 1),
('5a291e38-df35-4b79-bcd5-c0fef2eb07bb', 'Stuttgart-Birkach', 'd4b4dc39-3aa8-421b-991c-a37e3a05f08f', 1, 1),
('6069e093-59e5-45b5-8854-fc1691222472', 'Stuttgart-Mühlhausen', 'd4b4dc39-3aa8-421b-991c-a37e3a05f08f', 1, 1),
('632866a1-098a-4e0a-8bfe-e786fd6bdb00', 'Stuttgart-Wangen', 'd4b4dc39-3aa8-421b-991c-a37e3a05f08f', 1, 1),
('68c95b21-6d7b-4ef2-8372-a3e53869e52d', 'Böblingen', '2717c531-6aa6-4d87-80d7-f70141d04c63', 2, 1),
('6903278b-dd88-4ae3-b08f-1e3c17aef3da', 'Stuttgart-Hallschlag', 'd4b4dc39-3aa8-421b-991c-a37e3a05f08f', 1, 1),
('6aff7a3e-28be-45dd-90cc-5eaa689f2fd9', 'Ditzingen', '2717c531-6aa6-4d87-80d7-f70141d04c63', 2, 1),
('6f9350a6-0d94-44f4-86a0-d7e0c8edf9db', 'Stuttgart-Möhringen', 'd4b4dc39-3aa8-421b-991c-a37e3a05f08f', 1, 1),
('77861c3b-3c9c-4ba9-ba03-c6f8832394b2', 'Stuttgart-Heslach', 'd4b4dc39-3aa8-421b-991c-a37e3a05f08f', 1, 1),
('80df1e1c-c4c1-4999-b1ee-a089f9991038', 'Sindelfingen', '2717c531-6aa6-4d87-80d7-f70141d04c63', 2, 1),
('845c4868-a060-4f68-861a-f880404bbf11', 'International', '0f91a15c-dd80-47c5-915e-b5b596641929', 3, 1),
('a64b2ee7-ca34-427c-9a9c-df8f5f29319e', 'Stuttgart-Degerloch', 'd4b4dc39-3aa8-421b-991c-a37e3a05f08f', 1, 1),
('b34a153d-bd29-4b97-9814-23f10c5048e8', 'Waiblingen', '2717c531-6aa6-4d87-80d7-f70141d04c63', 2, 1),
('bab504b9-7f1b-42cf-a01e-ce322fe25590', 'Stuttgart-Zazenhausen', 'd4b4dc39-3aa8-421b-991c-a37e3a05f08f', 1, 1),
('bbf0d197-fcd6-4548-8548-ef1840057018', 'Stuttgart-Ost', 'd4b4dc39-3aa8-421b-991c-a37e3a05f08f', 1, 1),
('cc397b39-43ee-4d15-9310-746144c207ff', 'Stuttgart-Botnang', 'd4b4dc39-3aa8-421b-991c-a37e3a05f08f', 1, 1),
('cc67be51-58de-4109-ae78-2b0c018e27da', 'Stuttgart-Nord', 'd4b4dc39-3aa8-421b-991c-a37e3a05f08f', 1, 1),
('cf4658bb-885d-4937-bfd8-c5a7963a22d0', 'Stuttgart-West', 'd4b4dc39-3aa8-421b-991c-a37e3a05f08f', 1, 1),
('d3ea05ed-5dcd-4d47-a2aa-18e4eb6294c0', 'Stuttgart-Bad Cannstatt', 'd4b4dc39-3aa8-421b-991c-a37e3a05f08f', 1, 1),
('d4b4dc39-3aa8-421b-991c-a37e3a05f08f', 'Stadt Stuttgart', NULL, 1, 1),
('def5709b-04dd-409e-a3d9-2831186574d7', 'Stuttgart und Region', '0f91a15c-dd80-47c5-915e-b5b596641929', 3, 1),
('e0c9c7a7-d317-4662-93e5-28f281df4fd9', 'Stuttgart-Feuerbach', 'd4b4dc39-3aa8-421b-991c-a37e3a05f08f', 1, 1),
('e5c49e46-df39-46aa-af7c-c59c8d9765eb', 'Stuttgart-Untertürkheim', 'd4b4dc39-3aa8-421b-991c-a37e3a05f08f', 1, 1),
('ee4de3c1-f202-4b67-a8ee-ee53c95af538', 'Fellbach', '2717c531-6aa6-4d87-80d7-f70141d04c63', 2, 1),
('f15af137-6b8b-44f2-927e-5bfc0bb86ca9', 'Landesweit (Baden-Württemberg)', '0f91a15c-dd80-47c5-915e-b5b596641929', 3, 1),
('f3aa4a7e-5aac-46b9-9bcf-ced8fd0fa7d0', 'Stuttgart-Plieningen', 'd4b4dc39-3aa8-421b-991c-a37e3a05f08f', 1, 1),
('ff52e1fb-b421-46d4-828b-9e1298a441cf', 'Stuttgart-Weilimdorf', 'd4b4dc39-3aa8-421b-991c-a37e3a05f08f', 1, 1),
('ff6dfb12-0d8d-4f71-94c1-3f92f7314db2', 'Göppingen', '2717c531-6aa6-4d87-80d7-f70141d04c63', 2, 1);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `images`
--

CREATE TABLE `images` (
  `id` varchar(36) NOT NULL,
  `url` varchar(512) NOT NULL,
  `altText` varchar(512) DEFAULT NULL,
  `associationId` varchar(36) NOT NULL,
  `orderIndex` int(11) DEFAULT NULL,
  `current` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Daten für Tabelle `images`
--

INSERT INTO `images` (`id`, `url`, `altText`, `associationId`, `orderIndex`, `current`) VALUES
('06dcd3fd-7d94-4fde-b2ee-ba691b674e05', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2021/02/ADAN_LOGO-1.png', '', '409d1bc5-f179-47a4-aef6-7487677dee7d', 0, 1),
('0c2318b9-1053-4880-b20e-e2d87f14e753', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/Logo-Verein-Ndwenga-e.-V.jpg', '', '2be3d117-a995-459e-8ae4-7d00fcd6cf74', 0, 1),
('0f7b98a4-0eed-421a-a58a-2ce4529a138b', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2021/02/Female-Fellows.jpg', '', 'da82a250-69ad-45a7-aa8b-4a49efa7fd6e', 0, 1),
('0fa3f5a7-8aa9-4312-8172-e703eeabf725', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/firkat_logo_rgb.jpg', '', '7a6908f7-aaa6-463e-9775-fa919f077c88', 0, 1),
('14d3640e-8fd8-4311-a6c2-bbff928e9474', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/logo.jpg', '', '913ffb7d-c0fe-4f65-8908-c626a0d7e9f0', 0, 1),
('184fe9dc-dd97-4ff7-8cf9-2bcd7ee4d1d6', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/multicolor-nur-logo-neu.gif', '', '46b88ff4-b7d2-48c8-9287-9a4df986ade2', 0, 1),
('18e431b6-8bd4-4294-a0e2-6729a3d1490c', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2021/02/Deutsch-Chinesisches-Forum-Stuttgart-e.V..jpg', '', 'f951a820-7dd7-47dc-bd41-e97791024e73', 0, 1),
('1f5a0255-4d82-4683-b99e-1d3c91d236ba', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/logo_1f980094ef8e4dfc2c99eab269df270b_2x.png', '', 'b01b56fa-0975-4e2c-857d-c583ee8769fb', 0, 1),
('210e41e7-d265-455e-8dd1-908b024222c0', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2021/10/aum.jpg', '', '18c775ef-37d5-49ee-8745-bd5491f6eab3', 0, 1),
('22e94a21-769c-4e19-9b1a-104cb69e441c', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2021/10/Lab-Logo_rot.png', '', '648a26e5-e0f2-4e25-9cb5-f7f48396556c', 0, 1),
('241e198b-bdc5-4db4-9aa8-f99d5627c897', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2021/02/VCS-2-logo.jpg', '', 'ef52c7b3-624b-4850-a6cb-b06503ae414d', 0, 1),
('24569a31-8d3a-48c9-b51d-4a16c3580493', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/DTF-Projekte.png', '', 'd34735bf-1a86-4238-9962-df39f98e06e1', 0, 1),
('2c56e2c8-69be-4054-86db-ea42ff94de87', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/Deutsch-Rumaenisches-Forum-Stuttgart-e.V..png', '', 'bd8d434d-53df-45d5-9fa8-6215dd123969', 0, 1),
('37023ca9-c22e-4b15-ad32-68f9859fb0b7', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2021/10/wd-logo.jpg', '', 'e7928fb7-d155-4e58-8433-331ef1363dca', 0, 1),
('3d432f31-98f5-49ac-a44c-6085ec89bf31', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2021/10/Logo-web.jpg', '', '537421a5-1e05-4da1-8ebf-9a941be17dea', 0, 1),
('4344dc55-7c84-4a79-a1b9-413d55857656', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/Club_espanol_StuttgarLOGO.png', '', 'e631f1c8-ef66-4e22-962e-f45d18ef9eee', 0, 1),
('4571385b-c81a-4f78-ae25-d15123206ca0', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/Foerderverein-Heros-Academy-AIC-Stuttgart-e.-V.-scaled.jpg', '', '357ea7a6-da38-4b03-bc58-12e6e53f196d', 0, 1),
('47eb5684-d80a-44fd-8150-55fa59a68d2f', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/india-culture-forum.jpeg', '', '398792e6-1afc-4600-ab16-3118f2a627f1', 0, 1),
('4ebdc95f-29ef-4bcf-9a8c-f3917f1743cd', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2021/10/Spanischsprechende-Frauen-in-BW-.jpg', '', '4be37ec0-dd64-4dbe-8ebf-2a79e4606fa8', 0, 1),
('57f22826-7ad0-4a4f-bfab-72921a46c76c', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/Logo_SCS_2015-.jpg', '', '193af93b-0329-464a-887e-3bef9aa800b4', 0, 1),
('581a5005-0f6e-441a-a815-3d3c5bc5a5a8', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/Kulturverein-Slovenija-Stuttgart-e.-V.-logo.png', '', 'f6301d5b-e7fa-4c10-87f7-4b3b3195ced2', 0, 1),
('5b23dd2b-0dbb-410f-ac3d-0fe1b496d214', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2021/10/LOGO_NEU-Transparent.png', '', '30628cf8-0f1d-4dc3-9431-c810dbdfca69', 0, 1),
('5daf2df4-d6f5-4b15-b2d4-20a537372cf4', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/Punto-de-Encuentro-e.-V..png', '', '1c58eac8-e49b-4341-8d26-7b07e638f8c9', 0, 1),
('5e0e8066-e81c-4859-83da-b379d159702c', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/Logo-Akademie-fuer-internationalen-Kulturaustausch-e.V.-scaled.jpg', '', '8bdc3e00-4e4a-41e8-ade1-298092173e47', 0, 1),
('635b5474-fe43-4e5a-90a5-fad347367a31', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2021/10/Svenska-Skolan-Logo.jpg', '', '01b97f40-b03f-4a9e-b738-8be2f682fbaa', 0, 1),
('7708acf2-b151-4956-a351-3d165a0e1163', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/LogoJAZZ_OK.jpg', '', '0f000100-38cd-4c94-953c-c7b5740ac9c7', 0, 1),
('78f41e88-90d8-4d00-8303-dcdf56fba9b0', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/Forum-der-Kulturen-3-scaled.jpg', '', '613e7707-7982-4b91-acb0-3b3285179c7f', 0, 1),
('79e060f1-9bb1-4723-a0c7-0b50623dda55', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2021/02/Black-Community.jpeg', '', 'df269e2c-c94c-479e-b481-76ff20eb7ed2', 1, 1),
('7a5bad90-0bb2-423a-b872-e3e8f9786d1f', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2021/02/Eritreische-Vereinigung-zur-gegenseitigen-Unterstuetzung-Stuttgart-e.-V..jpg', '', '09c84ef4-3302-4868-b0a8-590d28b2e11a', 0, 1),
('7d73b429-5274-4fac-9c59-62981cb446b3', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/club-logo.png', '', '8cc19536-dfeb-4be2-b4f8-700f1bb20508', 0, 1),
('8477de5d-8c19-43fc-9d7c-0b61083d9579', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/FdK_Logo_4c_rot.png', '', 'e35345ca-0c79-4150-8e50-ce85f732bd4f', 0, 1),
('88ba89ec-6cba-4ebf-b0d8-64b0e062995b', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/Serbisches-Akademikernetzwerk-Nikola-Tesla-e.-V..png', '', '4cd5f88c-6cce-4d35-8521-5ac70d2a08d4', 0, 1),
('94c5dde3-7909-4922-bc15-5c19a7567a04', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2021/10/Logo2015-1.png', '', '02b46ae8-d1ed-4b34-b05d-491a400cf66d', 0, 1),
('95a7e667-831e-4c47-b647-839fe676f8c2', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/kalimera_klein.jpg', '', '2587605d-d2cf-4087-9a22-936e24debca3', 0, 1),
('962a5386-3356-4c02-9284-fcbc0aa06596', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2021/02/yalla-typo.jpg', '', '12e960bb-0b60-472b-828b-b7cdfd4153e8', 0, 1),
('97fb1b75-a4f2-47c7-a5a3-e990e76cad17', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2021/10/ARS-Narrandi-e.-V..jpg', '', '29988195-497a-443c-ae69-0facbbef31ca', 0, 1),
('9921e25a-2918-47bf-94c1-29a9d297a9f7', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2021/02/Deutschsprachiger-Muslimekreis-Stuttgart-DMS-e.-V..jpg', '', '4acbc0ea-0fcd-470a-a50c-ddbc12442eec', 0, 1),
('9a57f95a-12cd-4df4-9ed6-3b16c10d3373', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2021/02/Black-Community.png', '', 'df269e2c-c94c-479e-b481-76ff20eb7ed2', 0, 1),
('9cc5ad4e-ca3c-427b-a628-1d97f6855b7f', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2021/10/vij_Logo_ohne_Motto.jpg', '', 'd9c363cc-20e1-4079-935e-0ad2f9fc73c4', 0, 1),
('a6873bf4-49ce-42ed-a449-5bd903fc7207', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2021/10/JUMA-Logo.jpg', '', '17629f08-1f85-4876-bb13-cf91616f20b7', 0, 1),
('ad8751cd-cbcf-4973-a09b-8d277843fdb8', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/Saime_logo.jpg', '', '2b78dd70-b3d6-48b4-8592-c66028876863', 0, 1),
('b0fef819-d68c-4569-9252-56dadeb04ffe', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/Logo_Pavaresia.png', '', '0ddb204a-a10b-4d75-aa9c-b705b3316214', 0, 1),
('bfc3256b-5baf-48dd-adc7-d98278d3cb8d', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/IFWBK_logo_flyer.png', '', 'fa768a9d-1a54-4477-bcfe-3c9fcfda6c21', 0, 1),
('c4722448-120c-43e7-8528-a088566196fd', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/19388741_1152716738166081_8179760973660957952_o.jpg', '', '193af93b-0329-464a-887e-3bef9aa800b4', 1, 1),
('cd88cc7a-03cb-42c3-b4d0-f7a0e3f47c2a', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/Akademie-fuer-internationalen-Kulturaustausch-e.V.-Aylish-Kerrigan1.jpg', '', '8bdc3e00-4e4a-41e8-ade1-298092173e47', 1, 1),
('cf3e4635-d734-4cd3-8e33-e0e5c8212b64', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/Stelp_Supporter_yellow-blue-min.png', '', '4075fc5d-ae34-47d4-92e9-f6291b4d901f', 0, 1),
('d56cf7db-d4c1-481a-903f-40adfcddbd5e', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/Forum_Afrikanum_Logo-scaled.jpg', '', '23d06b99-29d4-4f80-a065-bf4c6d309af8', 0, 1),
('db3b4b4f-eb11-4931-88c6-2745519cf752', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/Serbischer-Bildungs-und-Kulturverein-„Prosvjeta-Deutschland-e.-V..jpg', '', '76740b4f-2bcf-43de-9f37-cf0c5ffbb2a2', 0, 1),
('ea64b40d-8ad1-4d52-8e76-63a649df33a7', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/Adelitas-Tapatias.jpg', '', '2e23fb7b-8e8d-4fbb-9c2d-e9fcebabd353', 0, 1),
('f1d2e2c6-b82d-4f95-9f00-ab69948d509e', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/logo.gif', '', '3ba452ea-ee50-4ef8-80b2-12e986d823d4', 0, 1),
('f7164121-c1b1-48c9-a25b-a5f8c8c55212', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/China-Kultur-Kreis-e.-V.-scaled.jpg', '', '96c8695f-5844-40ec-99c1-0be19bc92333', 0, 1),
('fa80bf05-2e65-4418-a48f-463cae855e5a', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/Nordkaukasischer-Kulturverein-Stuttgart.jpg', '', 'de1c9de5-4670-4826-8ea3-40c390f77f78', 0, 1);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `links`
--

CREATE TABLE `links` (
  `id` varchar(36) NOT NULL,
  `url` varchar(512) NOT NULL,
  `linkText` varchar(512) DEFAULT NULL,
  `associationId` varchar(36) NOT NULL,
  `orderIndex` int(11) DEFAULT NULL,
  `current` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Daten für Tabelle `links`
--

INSERT INTO `links` (`id`, `url`, `linkText`, `associationId`, `orderIndex`, `current`) VALUES
('0694707f-9a3d-4ff3-92e5-2b468a8c5f44', 'https://www.kalimera-ev.de/', '', '2587605d-d2cf-4087-9a22-936e24debca3', 0, 1),
('0b578a04-ef7d-4e67-9e38-019dc069102b', 'http://www.stuttgarti-magyar-gyerekeknek.de/kezdolap-startseite.html', '', '9fe421a6-6fe8-4550-895a-7dc140d65b24', 0, 1),
('1365cf2c-5af4-4e9f-9b9e-3ff756333fb3', 'https://www.latin-jazz-initiative.de/', '', '0f000100-38cd-4c94-953c-c7b5740ac9c7', 0, 1),
('1378b484-f9bc-432d-94d9-4235b0ba78a6', 'https://www.femalefellows.com', '', 'da82a250-69ad-45a7-aa8b-4a49efa7fd6e', 0, 1),
('14b16e6a-3e64-4aab-af54-cdf24ac8e7bc', 'https://mig.madeingermany-stuttgart.de', '', 'e35345ca-0c79-4150-8e50-ce85f732bd4f', 3, 1),
('1a91b4d5-3219-4c19-8d86-88dbd6b573e0', 'https://www.forum-der-kulturen.de', '', 'e35345ca-0c79-4150-8e50-ce85f732bd4f', 0, 1),
('1d5d2e50-e657-4280-8e90-9ade882eeef9', 'https://www.afrikafestival-stuttgart.de/', '', '913ffb7d-c0fe-4f65-8908-c626a0d7e9f0', 0, 1),
('22bab7b9-2c13-4d20-a8a3-3a1e0667f5cb', 'http://sldv-stuttgart.de', '', '8cc19536-dfeb-4be2-b4f8-700f1bb20508', 0, 1),
('2ecb7ac9-d7e7-431d-b11b-1771f0cf16cc', 'https://capoeira-stuttgart.org/', '', '4cc04cbb-8b19-4afb-8382-675f2ab08ba8', 0, 1),
('325de1b8-cec8-4e90-9b6f-7adcb2b2f992', 'https://www.iicstoccarda.esteri.it', '', 'fef187fb-7b62-4a0d-8dba-1f9c9bbf2f7d', 0, 1),
('3fa99bc9-62cc-4544-982d-dbc3d04366be', 'http://www.clubespagnolestuttgart.de', '', 'e631f1c8-ef66-4e22-962e-f45d18ef9eee', 0, 1),
('40c235b2-66a7-4178-be2a-6fc180b91dab', 'https://www.forum-afrikanum.de/', '', '23d06b99-29d4-4f80-a065-bf4c6d309af8', 0, 1),
('424e6a4a-615c-4ab0-9909-270274834a48', 'http://www.multicolor-stuttgart.de', '', '46b88ff4-b7d2-48c8-9287-9a4df986ade2', 0, 1),
('426feb0f-5560-49ab-8801-c76b13afe9e9', 'https://www.yallaev.de', '', '12e960bb-0b60-472b-828b-b7cdfd4153e8', 0, 1),
('44a4d87d-11e8-4e62-83bb-becc827638dd', 'https://www.herosacademy.org', '', '357ea7a6-da38-4b03-bc58-12e6e53f196d', 0, 1),
('4aebe2c8-046a-449f-ac7a-7b8eb632d919', 'https://vij-wuerttemberg.de/', '', 'd9c363cc-20e1-4079-935e-0ad2f9fc73c4', 0, 1),
('4b1e9e7c-e278-4144-9858-9e305d93ae27', 'https://stelp.eu', '', '4075fc5d-ae34-47d4-92e9-f6291b4d901f', 0, 1),
('4b276aeb-3b76-4a29-9be7-1590e3a66e02', 'http://deutsch-chinesisches-sprachinstitut.de/de/', '', 'f951a820-7dd7-47dc-bd41-e97791024e73', 1, 1),
('5250252f-6a95-43cb-aaf3-103853b7a640', 'https://www.stufem.de', '', 'b01b56fa-0975-4e2c-857d-c583ee8769fb', 0, 1),
('5309cfba-ba20-4721-b027-6d15a0f6c27a', 'https://sprachedermusik.de/', '', 'fa768a9d-1a54-4477-bcfe-3c9fcfda6c21', 1, 1),
('54d2b01d-886c-4758-8143-03c17ce38c0e', 'http://www.memo-bw.de', '', 'e35345ca-0c79-4150-8e50-ce85f732bd4f', 4, 1),
('56f6ce56-9a99-4c2a-bf24-078b5f6fc3c6', 'http://www.ndwenga-kinshasa.de', '', '2be3d117-a995-459e-8ae4-7d00fcd6cf74', 1, 1),
('582409fe-6f2e-4dc8-9132-e4056f158eae', 'https://www.ecuador-freunde-stuttgart.com/', '', 'bf0a4c28-4139-46d1-8a7d-ec8da2e108f6', 0, 1),
('5bea0e04-c85f-45b3-b5d6-f9728aa92afb', 'https://www.forum-gerrum-stuttgart.de/', '', 'bd8d434d-53df-45d5-9fa8-6215dd123969', 0, 1),
('5f4ca4bb-2192-4162-890a-f4f053b4c54c', 'https://www.laboratorium-stuttgart.de', '', '648a26e5-e0f2-4e25-9cb5-f7f48396556c', 0, 1),
('5f5b5c1c-c9e8-4f85-a8e1-2cae96037841', 'https://africa-workshop.de', '', 'b4926027-0ee2-497f-ad14-d9c85bf1b9fc', 1, 1),
('673966d4-9936-4c8a-bebe-077fb86b3ac1', 'https://www.evidence-institut.de', '', '30628cf8-0f1d-4dc3-9431-c810dbdfca69', 0, 1),
('6c8e943d-9336-499e-afd5-07a45f0624b1', 'https://www.skolan-i-stuttgart.de/', '', '01b97f40-b03f-4a9e-b738-8be2f682fbaa', 0, 1),
('6f5def0c-ed91-4828-82d3-1ddde9e09525', 'http://www.dtf-stuttgart.de', '', 'd34735bf-1a86-4238-9962-df39f98e06e1', 0, 1),
('7bbaf566-acde-4147-bcbc-b30a3daf5d33', 'http://www.maedchenschule-khadigram.de', '', '18c775ef-37d5-49ee-8745-bd5491f6eab3', 0, 1),
('7f9990a7-fd1f-4f15-8d89-91f866c3573c', 'https://kd-slovenija.de', '', 'f6301d5b-e7fa-4c10-87f7-4b3b3195ced2', 0, 1),
('82082f16-92a2-41e1-98be-3958f6ea303c', 'https://www.adelitas.de', '', '2e23fb7b-8e8d-4fbb-9c2d-e9fcebabd353', 0, 1),
('824123f2-9262-4842-b31e-87682d24f33e', 'http://ggsa.de', '', 'b4926027-0ee2-497f-ad14-d9c85bf1b9fc', 2, 1),
('867642e2-2bdb-4a56-9a26-ad7ed2eed4b2', 'https://www.bkhw.org', '', '537421a5-1e05-4da1-8ebf-9a941be17dea', 0, 1),
('9c64cb4d-afae-4df3-8174-303146132426', 'https://verein-saime.de', '', '2b78dd70-b3d6-48b4-8592-c66028876863', 0, 1),
('9c8578bf-981a-464f-a086-9d13db6afce8', 'https://www.ndwenga-fellbach.de', '', '2be3d117-a995-459e-8ae4-7d00fcd6cf74', 0, 1),
('a52cb230-2874-4fad-9816-2cb3ec5dfbff', 'https://www.ars-narrandi.de', '', '29988195-497a-443c-ae69-0facbbef31ca', 0, 1),
('a5aae6a0-c38c-420c-a737-89b15537bb49', 'https://www.tigre.de', '', '464b856f-beec-450c-a25c-5e2b923bb20a', 0, 1),
('a8b6fbbe-45d5-457e-a182-9abe5ee1dd3d', 'http://www.shoqatapavaresia.de', '', '0ddb204a-a10b-4d75-aa9c-b705b3316214', 0, 1),
('a8c87f42-ccfc-4143-b8c6-2f68fde60e0d', 'http://www.pssk.de', '', '93ac3a1b-3fa4-4169-89d7-1c240e705fa2', 0, 1),
('b5ffa632-5f89-4f73-9614-fdaf198342e2', 'https://dcfsev.org/de/', '', 'f951a820-7dd7-47dc-bd41-e97791024e73', 0, 1),
('b601035d-1b94-4bb6-85b2-5219aad323b4', 'http://www.add-stuttgart.de', '', '8ed59e73-02ab-4b32-b8fc-5596b740ead2', 0, 1),
('b770de20-a6fa-4520-92f4-173fe8b4dae0', 'http://coexistev.de', '', '0e37656b-78da-4639-ac91-8b04b7d49e34', 0, 1),
('c4852f89-6919-478d-bfb7-b21e1ab8286d', 'https://www.chinesische-sprachschule-stuttgart.de', '', '96c8695f-5844-40ec-99c1-0be19bc92333', 0, 1),
('c7806a8f-b36a-4b0b-b3f2-df7adcdfae0a', 'https://www.dante-stuttgart.de', '', 'fa937f0d-a0f5-4cab-8c6d-10d95d8b42b1', 0, 1),
('c9c6b04a-dc2e-4e77-8ce9-26e378f3bc8a', 'https://sommerfestival-der-kulturen.de/', '', 'e35345ca-0c79-4150-8e50-ce85f732bd4f', 2, 1),
('cb08414a-6fe4-40ca-80bd-5fa675773395', 'https://www.abada-capoeira.eu', '', 'a025297e-da3d-4c21-b8d3-251819f36ac5', 0, 1),
('d13fa6b8-8d43-47a0-914a-8fc97f9e233f', 'http://www.firkat.de', '', '7a6908f7-aaa6-463e-9775-fa919f077c88', 0, 1),
('d5685bba-da36-4539-97d2-75f6536c0391', 'http://www.afro-soleil.de', '', '93280de9-dbae-48ad-8c67-97c018815fe6', 0, 1),
('db7f5fe8-d5b1-4220-b21b-f29f63e8d5b3', 'https://ada-netzwerk.com/', '', '409d1bc5-f179-47a4-aef6-7487677dee7d', 0, 1),
('dd780767-a938-4dd0-a8e1-22f794b2c4f9', 'https://www.indiacultureforum.de', '', '398792e6-1afc-4600-ab16-3118f2a627f1', 0, 1),
('de5a9554-2042-49ae-a975-04d5c7ab40d8', 'https://forum-wbk.de/', '', 'fa768a9d-1a54-4477-bcfe-3c9fcfda6c21', 0, 1),
('e2cadb7b-c0e8-4ac4-a7fa-0a1e69e10ab2', 'https://house-of-resources-stuttgart.de/', '', 'e35345ca-0c79-4150-8e50-ce85f732bd4f', 1, 1),
('e33dff1c-bbdc-49d3-b454-b88b08a177e2', 'https://bayefall-ev.com', '', 'b6ce400f-ae69-49e3-9e25-3fad409ee5cc', 0, 1),
('ec5ee685-b845-4216-bce9-849032deaa42', 'https://sam-nt.eu/', '', '4cd5f88c-6cce-4d35-8521-5ac70d2a08d4', 0, 1),
('ed2c76bd-fc08-4156-83ca-a5523009c512', 'http://www.afrikaworkshop.de', '', 'b4926027-0ee2-497f-ad14-d9c85bf1b9fc', 0, 1),
('f78ef955-ac0a-483e-84ca-da09a09aa332', 'https://punto-de-encuentro.net/', '', '1c58eac8-e49b-4341-8d26-7b07e638f8c9', 0, 1),
('f9e34954-be37-4fc1-88af-d7c5d9ee69cb', 'http://www.cydd-bw.de', '', '9402230d-9858-46a7-bf19-b52f2dbcfe17', 0, 1),
('fd5cfd19-d035-4895-9d93-756c24045520', 'https://www.dmstuttgart.de', '', '4acbc0ea-0fcd-470a-a50c-ddbc12442eec', 0, 1),
('ff6d54d5-833c-4976-8d98-d610234332cd', 'http://www.klangoase-derya.com', '', '3ba452ea-ee50-4ef8-80b2-12e986d823d4', 0, 1);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `socialmedia`
--

CREATE TABLE `socialmedia` (
  `id` varchar(36) NOT NULL,
  `platform` varchar(128) NOT NULL,
  `url` varchar(512) NOT NULL,
  `linkText` varchar(512) DEFAULT NULL,
  `associationId` varchar(36) NOT NULL,
  `orderIndex` int(11) DEFAULT NULL,
  `current` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Daten für Tabelle `socialmedia`
--

INSERT INTO `socialmedia` (`id`, `platform`, `url`, `linkText`, `associationId`, `orderIndex`, `current`) VALUES
('1760cb35-5719-4c12-a85e-7b40fe1cd19c', 'YouTube', 'https://www.youtube.com/channel/UCQSh7OVUOm0UC7LsBQrEVGA', '', '30628cf8-0f1d-4dc3-9431-c810dbdfca69', 2, 1),
('1d64c8f4-5ec1-48a1-8e2e-571deee32216', 'Instagram', 'https://www.instagram.com/mujereshispanohablantesbw/?hl=de', '', '4be37ec0-dd64-4dbe-8ebf-2a79e4606fa8', 1, 1),
('1d92a08b-0a2c-4b1d-9032-2c211dfd7fed', 'Facebook', 'https://de-de.facebook.com/FDKStuttgart', '', 'e35345ca-0c79-4150-8e50-ce85f732bd4f', 0, 1),
('2a6d4c12-0974-4dec-bb76-7d29caf6f13a', 'Instagram', 'https://www.instagram.com/antoniocuadrosdebejar/', '', '0f000100-38cd-4c94-953c-c7b5740ac9c7', 1, 1),
('2bcc00b5-9a06-4c7a-b6b4-986269cb1770', 'Instagram', 'https://www.instagram.com/prosvjetanemacka/', '', '76740b4f-2bcf-43de-9f37-cf0c5ffbb2a2', 0, 1),
('2fa7f43c-92b7-452e-8658-c9de07acc15e', 'Instagram', 'https://www.instagram.com/evidence_institut/?hl=de', '', '30628cf8-0f1d-4dc3-9431-c810dbdfca69', 1, 1),
('34ea4f41-dc96-4446-b7a6-5c10983fa5d3', 'Facebook', 'https://www.facebook.com/laboratorium.stuttgart', '', '648a26e5-e0f2-4e25-9cb5-f7f48396556c', 0, 1),
('35ddcbe9-5822-4d96-96ad-d97c8a8e944f', 'Facebook', 'https://www.facebook.com/Jesidische-Sonne-Stuttgart-443134686435784', '', 'e5e1bb6f-c38b-48e7-9d28-44a37dfb4d9d', 0, 1),
('3918cb0f-f757-4258-aef3-b4af69737bb6', 'Facebook', 'https://www.facebook.com/alla.wbk.9', '', 'fa768a9d-1a54-4477-bcfe-3c9fcfda6c21', 0, 1),
('402300da-1cbf-4ad5-a7fd-68e6f09b2eb5', 'Facebook', 'https://www.facebook.com/alicetakin', '', '913ffb7d-c0fe-4f65-8908-c626a0d7e9f0', 0, 1),
('429c0afb-2fda-42fc-81dc-e9bb3933a626', 'Facebook', 'https://www.facebook.com/adelitas.de', '', '2e23fb7b-8e8d-4fbb-9c2d-e9fcebabd353', 0, 1),
('486d7649-7973-4804-b35a-f6da3f769ed2', 'Instagram', 'https://www.instagram.com/stelp_supporter_on_site/', '', '4075fc5d-ae34-47d4-92e9-f6291b4d901f', 1, 1),
('4cd1adba-8b89-441a-a982-373e801633ac', 'Facebook', 'https://www.facebook.com/groups/ecuatorianosenstuttgart', '', 'bf0a4c28-4139-46d1-8a7d-ec8da2e108f6', 0, 1),
('4dc4ef95-1b80-43a6-b2f4-a1c3c2e22318', 'Instagram', 'https://www.instagram.com/0711lab/', '', '648a26e5-e0f2-4e25-9cb5-f7f48396556c', 1, 1),
('587710eb-8390-4fd6-aaef-1790f8b47f3d', 'Facebook', 'https://www.facebook.com/Musikunterricht-Derya-Bektas-321766687901410/', '', '3ba452ea-ee50-4ef8-80b2-12e986d823d4', 0, 1),
('58d4d107-bf9d-4399-b222-e2e3b8884046', 'Facebook', 'https://de-de.facebook.com/NOVO-Capoeira-Stuttgart-1559519010778402', '', '4cc04cbb-8b19-4afb-8382-675f2ab08ba8', 0, 1),
('617ca18c-dc67-46ad-955a-841787273c7d', 'Instagram', 'https://www.instagram.com/asociacionpde/', '', '1c58eac8-e49b-4341-8d26-7b07e638f8c9', 1, 1),
('64f238e9-872d-4fde-9caa-e041347b161a', 'YouTube', 'https://www.youtube.com/channel/UCrXoEYsGsc-TrO1fwSk5XsA/videos', '', '45abe07b-cdec-41ee-a0be-b293fd8c0e15', 1, 1),
('6500e1e8-14a1-4b25-b89a-e3d7a4d33d7f', 'Facebook', 'https://www.facebook.com/FemaleFellows', '', 'da82a250-69ad-45a7-aa8b-4a49efa7fd6e', 0, 1),
('679b04a7-ac3d-404c-9d07-c2266cd18c61', 'Facebook', 'https://www.facebook.com/bayefallev', '', 'b6ce400f-ae69-49e3-9e25-3fad409ee5cc', 0, 1),
('688e6970-bab2-45d1-948b-065d34a10a29', 'Facebook', 'https://www.facebook.com/icfsev', '', '45abe07b-cdec-41ee-a0be-b293fd8c0e15', 0, 1),
('68fcd652-0f54-4dc9-bf66-94f8641ead83', 'Facebook', 'https://www.facebook.com/dcfsev', '', 'f951a820-7dd7-47dc-bd41-e97791024e73', 0, 1),
('6a9c3cc5-e6c1-41ac-a4f3-79b9457f107a', 'Instagram', 'https://www.instagram.com/shoqatapavaresia/', '', '0ddb204a-a10b-4d75-aa9c-b705b3316214', 1, 1),
('6f487975-8640-4e34-8294-b3913f063b3f', 'Facebook', 'https://www.facebook.com/deutschsprachiger.muslimkreis.stuttgart', '', '4acbc0ea-0fcd-470a-a50c-ddbc12442eec', 0, 1),
('7562c9b8-8f96-4a0f-99a9-37c38ed175ba', 'Instagram', 'https://www.instagram.com/bcf.stuttgart/?hl=de', '', 'df269e2c-c94c-479e-b481-76ff20eb7ed2', 0, 1),
('7fa677db-7224-4cce-9f01-10aea59bf8d5', 'Instagram', 'https://www.instagram.com/adanetzwerk/?hl=de', '', '409d1bc5-f179-47a4-aef6-7487677dee7d', 1, 1),
('843b8c52-9103-46f1-a72c-8b5319673dec', 'Instagram', 'https://instagram.com/femalefellows?igshid=y5ijs8lutc1f', '', 'da82a250-69ad-45a7-aa8b-4a49efa7fd6e', 1, 1),
('88a9d892-48fd-40e1-bf91-7472437718f0', 'Facebook', 'https://www.facebook.com/Coexist-eV-410786919397394', '', '0e37656b-78da-4639-ac91-8b04b7d49e34', 0, 1),
('8a9cdb73-8d38-4017-8eaa-74acdc94546f', 'Instagram', 'https://www.instagram.com/forumderkulturen/', '', 'e35345ca-0c79-4150-8e50-ce85f732bd4f', 1, 1),
('8ca47c0d-a811-4f64-a655-f83231592d45', 'Instagram', 'https://www.instagram.com/sam_nts/', '', '4cd5f88c-6cce-4d35-8521-5ac70d2a08d4', 1, 1),
('934033f9-2bb0-471d-9099-18158cc39ce5', 'Instagram', 'https://www.instagram.com/muslimkreis_stuttgart', '', '4acbc0ea-0fcd-470a-a50c-ddbc12442eec', 1, 1),
('99661285-73a9-4d55-a962-f80f6036365b', 'Facebook', 'https://de-de.facebook.com/754953194581359', '', 'ef52c7b3-624b-4850-a6cb-b06503ae414d', 0, 1),
('9df3d6bc-c316-43f2-a363-269732c4639e', 'Facebook', 'https://www.facebook.com/adanetzwerk', '', '409d1bc5-f179-47a4-aef6-7487677dee7d', 0, 1),
('a0301072-f3fa-4fd8-a8b5-0d019e9766e2', 'Instagram', 'https://www.instagram.com/club.stuttgart/?hl=de', '', 'd9c363cc-20e1-4079-935e-0ad2f9fc73c4', 1, 1),
('b1765d88-d791-444c-88a6-b217edd8b88d', 'Facebook', 'https://www.facebook.com/groups/792209454459495/', '', '4be37ec0-dd64-4dbe-8ebf-2a79e4606fa8', 0, 1),
('b599b7c2-4946-44c5-8ac5-182acba6783c', 'Facebook', 'https://www.facebook.com/Evidence-885079374951261/', '', '30628cf8-0f1d-4dc3-9431-c810dbdfca69', 0, 1),
('b6dcc7f4-529c-4312-a843-798f1fdd2fdf', 'Facebook', 'https://www.facebook.com/latinjazzfestival', '', '0f000100-38cd-4c94-953c-c7b5740ac9c7', 0, 1),
('bb4ac88d-387e-4251-a2dc-674c4e219413', 'Facebook', 'https://de-de.facebook.com/pages/category/Stadium--Arena---Sports-Venue/Srpski-Centar-Stuttgart-Српски-Центар-Штутгарт-618210711616689/', '', '193af93b-0329-464a-887e-3bef9aa800b4', 0, 1),
('bb4ba1e5-97cd-4cbf-a8f3-0969506eb3d6', 'Instagram', 'https://www.instagram.com/nartstuttgart', '', 'de1c9de5-4670-4826-8ea3-40c390f77f78', 1, 1),
('bb814fd3-c8b1-4c83-841b-723cda6b59d3', 'Facebook', 'https://www.facebook.com/BolivianischesKinderhilfswerk', '', '537421a5-1e05-4da1-8ebf-9a941be17dea', 0, 1),
('c74474b4-c0a2-4052-ba1b-a5cbec9b90f7', 'Instagram', 'https://www.instagram.com/dtfstuttgart/', '', 'd34735bf-1a86-4238-9962-df39f98e06e1', 1, 1),
('c9f08b8a-2ccf-47c7-8335-7a1493fc750f', 'Facebook', 'https://de-de.facebook.com/womendaysev-105523054524023/?ref=page_internal', '', 'e7928fb7-d155-4e58-8433-331ef1363dca', 0, 1),
('ca5e62ab-2cf6-49a7-bc9a-e93c98cfec36', 'Facebook', 'https://www.facebook.com/pages/category/Social-Club/Club-Espa%C3%B1ol-Stuttgart-Oficial-111439010486163/', '', 'e631f1c8-ef66-4e22-962e-f45d18ef9eee', 0, 1),
('cd2bc306-4a16-48bb-98e3-cb9ab70a424a', 'Facebook', 'https://www.facebook.com/pages/category/Nonprofit-Organization/Punto-de-Encuentro-eV-Stuttgart-110697967281557/', '', '1c58eac8-e49b-4341-8d26-7b07e638f8c9', 0, 1),
('d0720068-07d4-435c-b837-69995dde6961', 'Facebook', 'https://www.facebook.com/DeutschTuerkischesForumStuttgart', '', 'd34735bf-1a86-4238-9962-df39f98e06e1', 0, 1),
('d5c6b8dc-a05e-48b4-84a8-58be2c520c1f', 'Instagram', 'https://www.instagram.com/coexist_e.v', '', '0e37656b-78da-4639-ac91-8b04b7d49e34', 1, 1),
('e3330d5f-0d47-430b-88cf-d06661a7b3a7', 'Instagram', 'https://www.instagram.com/cyddbw/', '', '9402230d-9858-46a7-bf19-b52f2dbcfe17', 1, 1),
('e3332159-6670-4658-872a-16e52d9f4cd3', 'Facebook', 'https://www.facebook.com/groups/439745146116192/', '', '23d06b99-29d4-4f80-a065-bf4c6d309af8', 0, 1),
('e85a55b9-53c6-4df3-a060-484dd89a8441', 'Facebook', 'https://www.facebook.com/tigrevermelhoev', '', '464b856f-beec-450c-a25c-5e2b923bb20a', 0, 1),
('e9359dd4-e7e6-453b-a616-c447e056769c', 'Facebook', 'https://www.facebook.com/icfev/', '', '398792e6-1afc-4600-ab16-3118f2a627f1', 0, 1),
('f28e9dd7-0d14-4974-acae-f2a12749d765', 'Instagram', 'https://www.instagram.com/srpski_centar_stuttgart/', '', '193af93b-0329-464a-887e-3bef9aa800b4', 1, 1),
('f305ae93-a684-4455-9b07-7481dd5c076d', 'Facebook', 'https://www.facebook.com/Srpska.akademska.mreza.Nikola.Tesla', '', '4cd5f88c-6cce-4d35-8521-5ac70d2a08d4', 0, 1),
('f31b871e-cf46-495a-9423-a949a2b6aa41', 'Instagram', 'https://www.instagram.com/bkhw_org', '', '537421a5-1e05-4da1-8ebf-9a941be17dea', 1, 1),
('f31dd51f-cc90-42b1-8984-d27868381a5b', 'Facebook', 'https://www.facebook.com/vijStuttgart', '', 'd9c363cc-20e1-4079-935e-0ad2f9fc73c4', 0, 1),
('f621235a-87d2-46f1-b418-f38abdaced58', 'Facebook', 'https://www.facebook.com/ShoqataPavaresiaStuttgart/', '', '0ddb204a-a10b-4d75-aa9c-b705b3316214', 0, 1),
('fb39980e-1ab8-44b5-9d53-f6fecaf25278', 'Instagram', 'https://www.instagram.com/womendaysev/', '', 'e7928fb7-d155-4e58-8433-331ef1363dca', 1, 1),
('fe0e5d5d-12dd-43e1-9559-85bfc12525ff', 'Facebook', 'https://www.facebook.com/NartStuttgart', '', 'de1c9de5-4670-4826-8ea3-40c390f77f78', 0, 1),
('fee02874-4232-4ef6-b9c5-e23594207fee', 'Facebook', 'https://www.facebook.com/STELP.SupporterOnSite/', '', '4075fc5d-ae34-47d4-92e9-f6291b4d901f', 0, 1),
('ff8662dc-21a8-4d9e-bb02-ca9d43b46a28', 'Facebook', 'https://www.facebook.com/cyddbw/', '', '9402230d-9858-46a7-bf19-b52f2dbcfe17', 0, 1);

--
-- Indizes der exportierten Tabellen
--

--
-- Indizes für die Tabelle `activities`
--
ALTER TABLE `activities`
  ADD UNIQUE KEY `id` (`value`),
  ADD KEY `category` (`category`);

--
-- Indizes für die Tabelle `associations`
--
ALTER TABLE `associations`
  ADD PRIMARY KEY (`id`);

--
-- Indizes für die Tabelle `contacts`
--
ALTER TABLE `contacts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `contacts_ibfk_1` (`associationId`);

--
-- Indizes für die Tabelle `districts`
--
ALTER TABLE `districts`
  ADD PRIMARY KEY (`value`),
  ADD KEY `category` (`category`);

--
-- Indizes für die Tabelle `images`
--
ALTER TABLE `images`
  ADD PRIMARY KEY (`id`),
  ADD KEY `societyId` (`associationId`);

--
-- Indizes für die Tabelle `links`
--
ALTER TABLE `links`
  ADD PRIMARY KEY (`id`),
  ADD KEY `societyId` (`associationId`);

--
-- Indizes für die Tabelle `socialmedia`
--
ALTER TABLE `socialmedia`
  ADD PRIMARY KEY (`id`),
  ADD KEY `societyId` (`associationId`);

--
-- Constraints der exportierten Tabellen
--

--
-- Constraints der Tabelle `activities`
--
ALTER TABLE `activities`
  ADD CONSTRAINT `activities_ibfk_1` FOREIGN KEY (`category`) REFERENCES `activities` (`value`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints der Tabelle `contacts`
--
ALTER TABLE `contacts`
  ADD CONSTRAINT `contacts_ibfk_1` FOREIGN KEY (`associationId`) REFERENCES `associations` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints der Tabelle `districts`
--
ALTER TABLE `districts`
  ADD CONSTRAINT `districts_ibfk_1` FOREIGN KEY (`category`) REFERENCES `districts` (`value`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints der Tabelle `images`
--
ALTER TABLE `images`
  ADD CONSTRAINT `images_ibfk_1` FOREIGN KEY (`associationId`) REFERENCES `associations` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints der Tabelle `links`
--
ALTER TABLE `links`
  ADD CONSTRAINT `links_ibfk_1` FOREIGN KEY (`associationId`) REFERENCES `associations` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints der Tabelle `socialmedia`
--
ALTER TABLE `socialmedia`
  ADD CONSTRAINT `socialmedia_ibfk_1` FOREIGN KEY (`associationId`) REFERENCES `associations` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
