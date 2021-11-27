-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Erstellungszeit: 27. Nov 2021 um 14:07
-- Server-Version: 10.4.22-MariaDB
-- PHP-Version: 7.4.20

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Datenbank: `db264270_120`
--

DROP DATABASE IF EXISTS associations;
CREATE DATABASE IF NOT EXISTS associations;
use associations;

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
('047b2565-03c3-4bae-bbd3-00b4fa194471', 'Womendays e. V.', '', 48.778448, 9.180013, '', '', '', '70342 Stuttgart', '', '', '', 'plain', 'Wir sind ein Netzwerk von Frauen mit afrikanischen Wurzeln, die für die Verbesserung des Status der Frauen engagiert sind.', 'plain', 'Bildung (Coaching Workshops und Seminare, Regelmäßige digitale Webinare für Frauen (&quot;Frauen: Vereinbarkeit Job-Familie-Ich, Wie?&quot;, &quot;Frauen: Das Loslassen lernen&quot;)); Kultur und Kunst (Weihnachtsgala mit Kinderaufführungen: Theater, Gedichte, Choreographie, Austausch im Rahmen des internationalen Frauentages); Sport ( CamShakeFit: Den Stress wegtanzen mit afrikanischer Musik).', 'null', '[\"e5c49e46-df39-46aa-af7c-c59c8d9765eb\"]', 1),
('05cae93c-c701-4dfc-a9df-f41fc6aa6b18', 'Internationales Forum für Wissenschaft, Bildung und Kultur e. V.', '', 48.808912, 9.229857, 'keine öffentliche Anschrift', '', '', '', '', '', '', 'plain', 'Popularisierung und Förderung der Wissenschaft, Bildung, Kunst und Kultur für alle Generationen, insbesondere für Kinder und Jugendliche auf regionaler, nationaler und internationaler Ebene. Der Verein bleibt bei der Verfolgung dieser Ziele politisch und konfessionell neutral.', 'plain', 'Bildung (MINT Projekt), Kultur und Kunst (Klassische Konzerte für Kinder und Jugendliche).', 'null', '[\"068af935-dc42-40a4-98ef-e59352e9706c\"]', 1),
('0e49a524-77ac-427c-80cb-4567762f6ecd', 'STELP e. V.', '', 48.777167, 9.16147, '', '', '', 'Johannesstraße 35', '70176', 'Stuttgart', '', 'plain', 'Hilfe für Menschen in Not.', 'plain', 'Bildung (Bildungsprojekte), Soziales und Gesundheit (Notversorgung: Verteilung von Lebensmitteln, Verteilung von Kleidung, Häuserbau, Suppenküchen).', 'null', '[\"cf4658bb-885d-4937-bfd8-c5a7963a22d0\"]', 1),
('1828beaf-0ce2-4eb2-87f0-128ce2ecb2ac', 'Laboratorium e. V.', '', 48.781281, 9.207733, '', '', '', 'Wagenburgstr. 147', '70186', 'Stuttgart', '', 'plain', 'Förderung von Veranstaltungen kultureller und bildender Art durch Musik-, Kleinkunst-, Theater-, Literatur und Filmveranstaltungen, Vorträge und Ausstellungen.', 'plain', 'Der Name ist Programm: Das Laboratorium ist ein Ort, an dem seit fast 50 Jahren Experimente stattfinden. Musik (Blues, Americana, Singer/Songwriter, Weltmusik, Jazz, Experimentelles und unsere Local Heroes in den verschiedensten Spielarten: Wir lieben gute Musik und Künstler, die etwas zu sagen haben); Kultur und Kunst (das Theaterensemble des Forums der Kulturen, Workshops und politische Themen in Vorträgen und Diskussionen ergänzen die Palette unserer Veranstaltungen).', 'null', '[\"bbf0d197-fcd6-4548-8548-ef1840057018\"]', 1),
('1d431cd5-99b4-46a6-b194-23c123cb01ea', 'Spanischsprechende Frauen in BW', '', 48.774901, 9.163174, '', '', '', 'Johannesstr. 13', '70176', 'Stuttgart', '', 'plain', 'Wir sind ein lokales Netzwerk, das die Integration von spanischsprechenden Menschen in Deutschland unterstützt, die Gleichberechtigung von Frauen und Männern fördert und Projekte der Entwicklungszusammenarbeit in Lateinamerika und Spanien durchführt.', 'plain', 'Bildung (regelmäßige und kostenlose Einzel- und Gruppenbildungstreffen, Konferenzen, Workshops, Schulungen); Kultur und Kunst (Kunstausstellungen auf Spanisch und Deutsch, veröffentlichen Bücher und Artikel zu den Themen Integration, Gleichberechtigung und Entwiklungszusammenarbeit); Organisationsentwicklung; Empowerment (Frauen); Umwelt.', 'null', '[\"def5709b-04dd-409e-a3d9-2831186574d7\"]', 1),
('23214454-a952-4a4a-94fb-8b6dd63ff602', 'Ndwenga e. V.', '', 48.808049, 9.273254, 'keine öffentliche Anschrift', '', '', '', '', '', '', 'plain', 'Förderung der internationalen Gesinnung, der Toleranz und des Völkerverständigungsgedanken auf allen Gebieten der Kultur im In- und Ausland. Besonderen Fokus legt Ndwenga e. V. auf die Ziele: keine Armut, kein Hunger, hochwertige Bildung, weniger Ungleichheiten und Partnerschaften zur Erreichung der Nachhaltigkeitsziele.', 'plain', 'Bildung (kulinarische und musikalische Kulturvermitlung), Kultur und Kunst, Gastronomie (Catering).', 'null', '[\"def5709b-04dd-409e-a3d9-2831186574d7\",\"ee4de3c1-f202-4b67-a8ee-ee53c95af538\"]', 1),
('293b0f91-f109-4b74-ab91-a265834e0897', 'Forum der Kulturen Stuttgart e. V.', '', 48.775471, 9.177591, '', '', '', 'Marktplatz 4', '70173', 'Stuttgart', '', 'plain', 'Dachverband der Migrantenvereine und interkulturellen Einrichtungen<br/>Stuttgarter Interkulturbüro<br/>Mitglied im Bundesverband Netzwerke von Migrantenorganisationen e. V. (NeMO)', 'plain', '', 'null', '[\"def5709b-04dd-409e-a3d9-2831186574d7\"]', 1),
('2a0c0981-125c-4bf2-bb18-d17da3f4a72e', 'Internationaler Musik- und Kulturverein Klangoase e. V.', '', 48.839759, 9.193012, '', '', '', 'Sauerkirschenweg 32', '70437', 'Stuttgart', '', 'plain', 'Unterschiedliche Kinder und Jugendliche mithilfe von Musik zusammenzubringen. Durch gemeinsames Musizieren stärkt der Verein die Persönlichkeit von Kindern, Jugendlichen und Erwachsenen sowie das Verständnis füreinander. Ein besonderer Schwerpunkt des Vereins ist die interkulturelle Arbeit mit dem Ziel, ein multinationales Orchester entstehen zu lassen.', 'plain', 'Bildung (Instrumentalunterricht: Gitarre, Klavier, Geige, Blockflöte, Cello, musikalische Früherziehung (M.F.E.), M.F.E.-unterricht in der Muttersprache Türkisch, Unterricht im Musikstil „Klassik“), Musik (Orchester, Chor-Gesang).', 'null', '[\"1a68b204-3bc7-4ebd-a5a9-effc1b65dcb1\",\"bab504b9-7f1b-42cf-a01e-ce322fe25590\"]', 1),
('2ff36edf-550a-4b14-af0d-7e572ebb1520', 'Vietnam Community Stuttgart VCS', '', 48.710085, 9.202935, '', '', '', 'Wollgrasweg 11', '70599', 'Stuttgart', '', 'plain', 'Forum für Vietnamesen und Nichtvietnamesen, Kontakte und kultureller Austausch, Vermittler für deutsche und vietnamesische Organisationen.', 'plain', 'Kultur und Kunst (Vorträge, Veranstaltungen in Deutsch und Vietnamesisch zu Themen Gesundheit, Sprachen, vietnamesische Literatur), Soziales und Gesundheit, Entwicklung und Zusammenarbeit (Integrationshilfe), Musik (traditionelle Musik).', 'null', '[\"def5709b-04dd-409e-a3d9-2831186574d7\"]', 1),
('352239b3-9d62-4571-94c9-6ded7e07b20e', 'Firkat, klassisch-türkischer Musikverein Stuttgart e. V.', '', 48.796897, 9.193595, '', '', '', 'Mittnachtstraße 18', '70191', 'Stuttgart', '', 'plain', 'Eine Vereinigung und Verbindung zur Förderung der türkischen Kultur.', 'plain', 'Bildung (Noten- und Instrumentenunterricht für Kinder, Jugendliche, Eltern und Erwachsene), Kultur und Kunst (Konzerte), Musik (klassische türkische Musik, Chor-Gesang).', 'null', '[\"cc67be51-58de-4109-ae78-2b0c018e27da\"]', 1),
('38e4c9d7-9a1e-4151-992c-65f5935f35fe', 'Black Community Foundation Stuttgart', '', 48.778669, 9.179631, 'keine öffentliche Anschrift', '', '', '', '', '', '', 'plain', 'Kampf gegen Anti Schwarzen Rassismus, Empowerment der Black Community, Rassismus Sensibilisierung.', 'plain', 'Bildung (Sensibilisierungs Workshops und Arbeit gegen Rassismus im Fokus auf Anti Schwarzen Rassismus, Empowerment Workshops zu verschiedenen Themen für die Black Community und PoCs); Beratung (Unterstützung von Blackowned Businesses und Schwarzen Künstlern, wie Artists); Kultur und Kunst (Teilnahme an Diskussionsrunden, Aufklärung an Schulen, Tägliches Aufklären verschiedener Themen auf unserem IG Account).', 'null', '[\"def5709b-04dd-409e-a3d9-2831186574d7\"]', 1),
('390ac58c-d7a7-4fd7-8534-33bbf4c34ff2', 'Deutschsprachiger Muslimekreis Stuttgart (DMS) e. V.', '', 48.810936, 9.166539, '', '', '', 'Stuttgarterstr. 15', '70469', 'Stuttgart', '', 'plain', 'Wir möchten mit unserem Angebot in erster Linie Wissen rund um den Islam in deutscher Sprache vermitteln. Uns ist es wichtig Vorurteile abzubauen, die es sowohl unter den Muslimen, als auch unter den Nichtmuslimen gibt. Wir möchten eine Plattform bieten, auf der sich Jung und Alt über ihren Glauben austauschen können. Es ist heute wichtiger denn je miteinander ins Gespräch zu kommen, daher ist uns der Aufbau und erhalt guter Beziehungen zu Nichtmuslimen ein wichtiges Anliegen.', 'plain', 'Bildung (Freitagstreff (offene Veranstaltung für alle Interessierten), Vorträge externer Referenten); Kultur und Kunst (Veranstaltungen an muslimischen Feiertagen); Geflüchtete (Arbeit mit Geflüchteten).', 'null', '[\"e0c9c7a7-d317-4662-93e5-28f281df4fd9\"]', 1),
('3ae5a598-ab7f-4a14-acdc-690be402569a', 'Punto de Encuentro e. V.', '', 48.775167, 9.177163, '', '', '', 'Hirschstraße 12', '70173', 'Stuttgart', '', 'plain', 'Eine interkulturelle Begegnungsstätte für Menschen, die in der spanischen und deutschen Kultur verwurzelt sind, für Familien mit spanisch sprechenden Mitgliedern, für Eltern, die Interesse an bilingualer Erziehung für ihre Kinder haben.', 'plain', 'Bildung (muttersprachlicher Spanischunterricht, Bastel-Worksops, Handwerken, Experimentieren), Kultur und Kunst (Vermittlung der spanischen Sprache und Kultur, Feste und Feiern zum Gedanken- und Erfahrungsaustausch, Ausflüge und Besuche kultureller und wissenschaftlicher Einrichtungen und Museen), Entwicklung und Zusammenarbeit (Unterstützung von Personen, die aus der spanischen Kultur stammen oder die sich der spanischen Sprache und Kultur verbunden fühlen), Sport (Yoga).', 'null', '[\"def5709b-04dd-409e-a3d9-2831186574d7\"]', 1),
('4687342f-8990-4a34-a0a2-0baec5a4e912', 'Serbischer Bildungs- und Kulturverein „Prosvjeta“ Deutschland e. V.', '', 48.770168, 9.165382, '', '', '', 'Reinsburgstraße 48', '70178', 'Stuttgart', '', 'plain', 'Durch zweisprachige Vorträge, Diskussionen, Literaturabende, integrative Projekte, kulturelle Veranstaltungen, Musikprojekte sowie durch Projekte in der Muttersprache ist der Verein bemüht, die allgemeine Kultur und Bildung der in Baden-Württemberg lebenden serbischen Bevölkerung und aller anderen interessierten Personen innerhalb des Vereins, zu fördern, zu entwickeln und auch zu präsentieren.', 'plain', 'Bildung (muttersprachlicher Unterricht für Erwachsene, Musikschule für Kinder und Erwachsene), Kultur und Kunst (Kunst- und Literaturworkshops für Kinder und Erwachsene).', 'null', '[\"def5709b-04dd-409e-a3d9-2831186574d7\"]', 1),
('4e1d3c36-6104-4134-a84b-bdfaea285fbf', 'Sri Lankisch-Deutscher Verein Stuttgart e. V.', '', 48.830302, 9.217157, '', '', '', 'Hopfenseeweg 3A', '70378', 'Stuttgart', '', 'plain', 'Förderung der Gemeinschaft und die soziale Integration der Sri Lankarnen in Stuttgart und Umgebung.<br/>Das langfristige und übergreifende Ziel ist es, einen kleinen Beitrag zum gemeinsan Dialog und zum Verständnis unter den Menschen beizutragen.', 'plain', 'Bildung (Unterstützung von Projekten in Sri Lanka, Informations - und Diskussionsplattform), Kultur und Kunst (Events, künstlerische und kulturelle Projekte), Soziales und Gesundheit (Hilfsprojekte).', 'null', '[\"cc67be51-58de-4109-ae78-2b0c018e27da\",\"cf4658bb-885d-4937-bfd8-c5a7963a22d0\"]', 1),
('4e40cbc8-c77f-4f7c-9e19-16287ec5e6bd', 'Baye-Fall e. V. senegalesisch-deutsche Vereinigung', '', 48.802498, 9.109533, '', '', '', 'Kiebitzweg 7', '70499', 'Stuttgart', '', 'plain', 'Förderung von Kunst und Kultur, Förderung der internationalen Gesinnung und des Völkerverständigungsgedankens sowie die Förderung<br/>der Entwicklungszusammenarbeit.', 'plain', 'Bildung (Übersetzungs- und Dolmetscherdienst, Simultanübersetzungen bei Refugio Stuttgart e. V.), Kultur und Kunst (Kulturveranstaltungen, Teilnahme an Kulturveranstaltungen und Straßenfesten, Reparatur von westafrikanischen Trommeln), Gastronomie (Catering, traditionell senegalesiches Essen), Musik (westafrikanisch, Afrobeat, Reggae, Trommelworkshops).', 'null', '[\"ff52e1fb-b421-46d4-828b-9e1298a441cf\",\"068af935-dc42-40a4-98ef-e59352e9706c\",\"bbf0d197-fcd6-4548-8548-ef1840057018\"]', 1),
('513e769c-bee3-4cb6-8c92-5a2b8b98f4dc', 'Loyenge e. V.', '', 48.772584, 9.242969, '', '', '', 'Ulmer Straße 347', '70327', 'Stuttgart-Wangen', '', 'plain', 'Besseres Verstehen der Situation der Afrikaner in Europa und Afrika. Globalisierung der Kulturen. Vermittlung und Durchführung von Veranstaltungen mit Musik, Infos, Workshops.', 'plain', 'Bildung (Instrumentalunterricht: Trommelkurse &quot;Afrikanisches Trommeln&quot; für alle Altersgruppen), Kultur und Kunst (Theater, Kunst, Vorträge), Gastronomie (Benefizveranstaltungen mit traditionell afrikanischem Essen), Sport (Tanzkurse &quot;African Dance&quot;), Musik (Chor-Gesang, Afrikanischer Chor mit Hif Anga Belowi, Auftritte von Bands mit moderner und traditioneller afrikanischer Musik, Band &quot;Hif &amp; Afro Soleil&quot; (Afropop, Reggae), Band &quot;Hif &amp; Zanga&quot; (traditionelle Musik aus Afrika).', 'null', '[\"068af935-dc42-40a4-98ef-e59352e9706c\"]', 1),
('62d5d3ef-8d58-483f-bbdf-68cc5335586e', 'Akademie für internationalen Kulturaustausch e. V.', '', 48.768394, 9.179873, '', '', '', 'Olgastraße 93B', '70180', 'Stuttgart', '', 'plain', 'Förderung des internationalen Kulturaustauschs durch Veranstaltungen mit Musik, Poesie und bildender Kunst aus verschiedenen Ländern unter Teilnahme interkultureller Künstler.', 'plain', 'Kultur und Kunst (Poesie, bildende Kunst in einer persönlichen, freundlichen Atmosphäre, wobei viel Gewicht auf Kommunikation zwischen Künstlern und Publikum gelegt wird), Musik (klassische und zeitgenössische Musik).', 'null', '[\"068af935-dc42-40a4-98ef-e59352e9706c\"]', 1),
('6eb95e35-4777-42f2-bd54-4a6279552622', 'Igbo Cultural Foundation Stuttgart e. V.', '', 48.69453, 9.319517, '', '', '', 'Karlstraße 15', '73770', 'Denkendorf', '', 'plain', 'Kultur der Igbo der deutschen Bevölkerung näher bringen.', 'plain', 'Bildung (muttersprachlicher Unterricht), Kultur und Kunst (öffentliche Literaturveranstaltungen), Soziales und Gesundheit (Arbeit mit Senior*innen), Entwicklung und Zusammenarbeit (Integrationshilfe), Engagement für Geflüchtete (Zusammenarbeit mit Asylbewerber*innen), Gastronomie (Fingerfood, traditionelles Essen), Sport (Fußball, Basketball, Tanz, öffentliche Sportveranstaltungen), Musik (Trommeln, öffentliche Musikveranstaltungen), Podcast (auf YouTube unter Odenjinji Media Stuttgart).', 'null', '[\"d4b4dc39-3aa8-421b-991c-a37e3a05f08f\"]', 1),
('727a1af9-2157-4593-be2a-41dcb506cda4', 'Latin Jazz Initiative', '', 48.774427, 9.167141, '', '', '', 'Gutenbergstraße 3B', '70176', 'Stuttgart', '', 'plain', 'Die Latin Jazz Initiative entstand aus dem Bedürfnis neue Wege zu suchen, um das Jazz Publikum (nicht nur das Latin Jazz Publikum) auf diese wunderbare Musik aufmerksam zu machen. Durch Jazz entsteht Kommunikation unabhängig von Herkunft, Glauben oder anderen «Hindernissen», die in vielen anderen Bereichen das Zusammensein schwieriger machen.', 'plain', 'Beratung (Veranstaltungsplanung), Kultur und Kunst (Organisation und Durchführung von Festivals, Konzerte, Konzertreihen, Workshops , Jazz Open Stage, UNESCO-International Jazzday, UNESCO-International Danceday, United Jazz Ensemble, Musik im Viertel (Konzerte in kleinen Geschäften in verschiedenen Stadtteilen)), Bildung (Musikunterricht, Jazz-Workshops, Latin Jazz, Jazzdance und Latin Jazzdance, ein lebendiges Hörbuch, in dem der Autor seine eigenen Bücher liest und die Lesung musikalisch mit Stücken umrahmt, die extra hierfür komponiert werden).', 'null', '[\"068af935-dc42-40a4-98ef-e59352e9706c\",\"cf4658bb-885d-4937-bfd8-c5a7963a22d0\"]', 1),
('78b2f07e-c7b3-43d5-9725-beff5e42f704', 'Forum Afrikanum Stuttgart e. V.', '', 48.762232, 9.160389, 'keine öffentliche Anschrift', '', '', '', '', '', '', 'plain', 'Begegnungen schaffen, Austausch, Mitgestaltung des Kulturlebens in Stuttgart. Der Verein ist konfessionell und parteipolitisch neutral.', 'plain', 'Bildung (Vorträge, Workshops), Kultur und Kunst (Konzerte, Ausstellungen, Lesungen, Filme, Projekte).', 'null', '[\"cf4658bb-885d-4937-bfd8-c5a7963a22d0\"]', 1),
('7f6944a2-98a1-4564-a9eb-3ec1036014c2', 'Freunde des Italienischen Kulturinstituts in Stuttgart e. V.', '', 48.765011, 9.169502, '', '', '', 'Kolbstraße 6', '70178', 'Stuttgart', '', 'plain', 'Bekanntmachung der italienischen Kultur und Sprache.', 'plain', 'Bildung (Sprachunterricht, Italienischkurse für alle).', 'null', '[\"03913c8d-c21d-470a-90fc-b3032fc33f4a\"]', 1),
('7f938139-c0d3-42c1-b975-62786d744093', 'Mexikanische Tanzgruppe Adelitas Tapatías & Charros', '', 48.778256, 9.179768, 'keine öffentliche Anschrift', '', '', '', '', '', '', 'plain', 'Verbreitung der mexikanischen Kultur in Deutschland.', 'plain', 'Sport (mexikanischer Tanz).', 'null', '[\"def5709b-04dd-409e-a3d9-2831186574d7\"]', 1),
('8426e17b-c18e-4061-aac7-3085b564ddf9', 'Förderverein Hero\'s Academy AIC Stuttgart e. V.', '', 48.777659, 9.151351, 'keine öffentliche Anschrift', '', '', '', '', '', '', 'plain', 'Verwirklichung von Projekten, um Kindern in Kenia zu helfen und ihnen eine Chance auf Bildung zu geben.', 'plain', 'Bildung (finanzielle Unterstützung des Unterhalts der Academy, Grundschule und Kindergarten), Entwicklung und Zusammenarbeit (Unterstützung bei der Instandsetzung und Einrichtung sowie evtl. Baumaßnahmen von Schule und Kindergarten, Hilfestellung zur Selbsthilfe des Unterhalts, anteilige finanzielle Unterstützung für Lehrmaterial, Vermittlung von Schulpatenschaften).', 'null', '[\"cf4658bb-885d-4937-bfd8-c5a7963a22d0\"]', 1),
('85e9a6f1-1688-490d-abd8-e5310b351df6', 'Deutsch-Türkisches Forum Stuttgart e. V.', '', 48.773637, 9.175521, '', '', '', 'Hirschstraße 36', '70173', 'Stuttgart', '', 'plain', 'Förderung der kulturellen Begegnung, Verständigung und Zusammenarbeit. Mit Bildungsinitiativen und Kulturprogrammen leistet das DTF eigenständige Beiträge zur gesellschaftlichen Teilhabe türkeistämmiger Zuwanderer. Es tritt insbesondere für mehr Chancengleichheit in Bildung, Beruf und Gesellschaft ein. Dabei setzt es vor allem auf vielseitiges bürgerschaftliches Engagement. Das DTF ist partei- und konfessionsunabhängig.', 'plain', 'Bildung (Politik, Gesellschaftliches), Kultur und Kunst (zeitgenössische türkische Kunst und Künstler*innen).', 'null', '[\"d4b4dc39-3aa8-421b-991c-a37e3a05f08f\"]', 1),
('933edcfe-3ace-40ad-ba25-1647d78d048c', 'Juma e. V.', '', 48.811584, 9.159012, '', '', '', 'Kärtnerstr. 40A', '70565', 'Stuttgart', '', 'plain', 'Gesellschaftliche Teilhabe, Empowerment und Vernetzung von Jugendlichen.', 'plain', 'Bildung (Workshops zu den Themen : Jugendverbandsarbeit, Projektmanagement, Vereinsmanagement, Öffentlichkeitsarbeit, Demokratische Teilhabe, Antidiskriminierung, Antimuslimischer Rassismus, Meet and Talks, Zukunftswerkstätten, Activity Days).', 'null', '[\"def5709b-04dd-409e-a3d9-2831186574d7\"]', 1),
('96385eda-f56e-4dab-9305-9a8c025881b3', 'Sri Lanka-Deutschland Freundeskreis e. V.', '', 48.808985, 9.234255, '', '', '', 'Kneippweg 7', '70374', 'Stuttgart', '', 'plain', 'Förderung internationaler Gesinnung, der Toleranz auf allen Gebieten der Kultur und des Völkerverständigungsgedankens und die Förderung mildtätiger Zwecke.', 'plain', 'Bildung (muttersprachlicher Unterricht, Workshops zum Thema Sri Lanka: Land, Leute, Kultur, Gesellschaft, Religion, Politik usw.), Gastronomie (Catering, traditionelles Essen, Kochkurse), Sport (traditioneller Tanz, Indischer Tanz), Musik (traditionelle Musik, Indische Musik, Musikunterricht (Violinee).', 'null', '[\"def5709b-04dd-409e-a3d9-2831186574d7\"]', 1),
('999e07e3-e174-4a47-a1b6-9c44f21341c4', 'Verein für Internationale Jugendarbeit e. V.', '', 48.779022, 9.187839, '', '', '', 'Moserstr. 10', '70182', 'Stuttgart', '', 'plain', 'Mit unserer Arbeit fördern wir die Begegnung und den Austausch zwischen Menschen unterschiedlicher Herkunft, Kultur und Religion und setzen uns für deren Chancen und Rechte ein. Der VIJ unterhält verschiedene Beratungsdienste sowie Bildungs- und Begegnungsangebote und ist Träger der Bahnhofsmission in Württemberg. Die Arbeitsbereiche sind: Arbeit und Bildung, Bahnhofsmission, Fraueninformationszentrum – FIZ, Zentralstelle MiA-Kurse, Zentrum für Integration und Mosaik – Kultur und Begegnung.', 'plain', 'Bildung (Beratung zu Arbeitsmarktintegration und Weiterbildung: Vermittlungsangebot für osteuropäische Betreuungskräfte, Interkulturelle Gründungsberatung, Coaching, Beratung von nicht EU-Angehörigen, muttersprachliche psychosoziale Beratung bei Krisen in der Migration, Menschenhandel und Arbeitsausbeutung, psychosoziale Prozessbegleitung, Deutschkurse, Migrationsberatung); Kultur und Kunst (Begegnungsraum Mosaik, Club International für junge Leute, die in Stuttgart Anschluss suchen, Jugendwohnheim).', 'null', '[\"068af935-dc42-40a4-98ef-e59352e9706c\"]', 1),
('9a3f346c-50dd-418f-838d-4f4b6b299abf', 'Ars Narrandi e. V.', '', 48.757743, 8.88469, '', '', '', 'Burgunderstr. 16', '71263', 'Weil', '', 'plain', 'Wir fördern die (inter- und trans-)kulturelle Begegnung um mündlich, lebendig erzählte Geschichten aller Welt. Unsere Geschichten schlagen den Bogen zwischen den verschiedenen \rErzähltraditionen und ihren Weisheiten, individuellen Erfahrungen und biografischen Geschichten, sowie neu erfundenen Geschichten. Sie sind Türöffner zur Sensibilisierung und einen regen Austausch über wichtige Themen: Nachhaltigkeit, Natur und Umwelt, Demokratie und Menschenrechte. Wir unterstützen demokratische Teilhabe, indem wir interkulturelles Bewusstsein, aktives Hinhören und einen vorurteilsfreien Umgang mit Sprache und Mehrsprachigkeit trainieren. \r<br/>Wir möchten Menschen jeden Alters und Herkunft, sozialer Zugehörigkeit und Bildung miteinander reisen, träumen und in Gespräch kommen lassen.', 'plain', 'Bildung (Projekte der kulturellen Bildung, konsumfreie Festivals und Feste, Erzählakademie mit mehrsprachigen Erzählern, Vorträge, Kurse und Workshops); Kultur und Kunst (mündliches Erzählen im Freien, im Park oder in einem Stadtteil, auf der Bühne, in Büchereien, Schulen, Kindergärten und Begegnungsstätten, professionelle Erzähler*innen, Expert*innen der inter- und transkulturellen Kommunikation und Volkskundler); Es geht uns um die Kenntnis und Verbindung von Kulturen über ihre Erzähltraditionen, das Erwerben von Kompetenzen in der interkulturellen Kommunikation und der positiven Streitkultur, um die Aus- und Fortbildung des mündlichen Erzählens als soziale Kompetenz bis zur Kunst auf der Bühne.', 'null', '[\"068af935-dc42-40a4-98ef-e59352e9706c\"]', 1),
('9b7bb4ed-ad2c-4285-bbdd-41fbae36012f', 'China Kultur-Kreis e. V.', '', 48.808862, 9.236805, '', '', '', 'Prießnitzweg 7', '70374', 'Stuttgart', '', 'plain', 'Vermittlung chinesischer Sprachkenntnisse und chinesischer Kultur, Pflege der chinesisch-deutschen Zusammenarbeit und des Dialogs, sowie Förderung interkultureller Kompetenzen. Der Verein gründete 1997 die „Chinesische Sprachschule Stuttgart“, um die chinesische Kultur und Sprache zu unterrichten. Die Schule ist eine Wochenendschule für die in Deutschland lebenden Kinder chinesischer Abstammung und alle Freunde, die sich für die chinesische Kultur und die chinesische Sprache interessieren.', 'plain', 'Bildung (muttersprachlicher Unterricht chinesich, Kurse in der traditionellen chinesischen Kultur).', 'null', '[\"e0c9c7a7-d317-4662-93e5-28f281df4fd9\"]', 1),
('9d78b29c-606c-4840-af8d-ffd9e95059c5', 'Bolivianisches Kinderhilfswerk e. V.', '', 48.788928, 9.205237, '', '', '', 'Hackstraße 76', '70190', 'Stuttgart', '', 'plain', 'Förderung von Kindern und Jugendlichen in Bolivien. Finanzielle Unterstützung von Bildungsprojekten in Bolivien. Vermittlung von engagierten Jugendlichen über Freiwilligendienste nach Bolivien bzw. Empfang von bolivianischen Freiwilligen in Deutschland.', 'plain', 'Entwicklung und Zusammenarbeit (Freiwilligendienst mit Einsatzland Bolivien, Spenden für Projektunterstützung in Bolivien, Patenschaften).', 'null', '[\"bbf0d197-fcd6-4548-8548-ef1840057018\"]', 1),
('a4be69a3-e758-456c-a6e2-f207c8df1a94', 'Afro Deutsches Akademiker Netzwerk ADAN', '', 48.780981, 9.182435, 'keine öffentliche Anschrift', '', '', '', '', '', '', 'plain', 'Eine Plattform für die Interaktion zwischen Afrodeutschen, AfrikanernInnen und Afrika-Interessierten Personen zu bieten;\r Vielfalt sichtbar zu machen und jungen AfrikanerInnen in der Diaspora Vorbilder aus unterschiedlichen Bereichen zu präsentieren;\r Afrika als Chancenkontinent zu präsentieren, um eine nachhaltige Brücke zwischen Afrika und Europa zu kreieren.', 'plain', 'Bildung (Beratung von Jugendlichen und Heranwachsenden bei den Themen Schule, Studium und Zukunftsplanung)<br/>; Diversity (Vielfalt sichtbar machen und fördern)<br/>; Netzwerk (welches als Plattform für den gegenseitigen Austausch von Deutsch-Afrikanern und<br/>Afrikainteressierten dient und nachhaltige Beziehungen in den Bereichen der Wirtschaft, Gesellschaft und Kultur zu entwickeln)', 'null', '[\"068af935-dc42-40a4-98ef-e59352e9706c\"]', 1),
('ab012da0-663c-41a8-8b87-b0db5a3be8e6', 'Female Fellows e. V.', '', 48.790071, 9.210416, '', '', '', 'Teckstr. 62', '70190', 'Stuttgart', '', 'plain', 'Der Verein Female Fellows e.V. setzt sich aktuell insbesondere für die Stärkung von Frauen mit Flucht - und Migrationserfahrung ein. Unter dem Motto „Hinter jeder starken Frau stehen starke Frauen“ möchten wir zum Fempowerment und damit zu einer Gesellschaft beitragen, die ihre Vielfalt lebt und in der alle gleichberechtigt mitgestalten. Die ehrenamtlich vermittelten Tandem - Projekte in Stuttgart, Bietigheim - Bissingen und Tübingen zeichnen sich daher neben sprachlicher und alltäglicher Unterstützung vor allem durch Events und Unternehmungen jeglicher Art aus – denn Begegnungen sind der Schlüssel für einen inspirierenden, helfenden, offenen und horizonterweiternden Umgang miteinander.', 'plain', 'Bildung (Infoveranstaltungen/Workshops bspw. zu Frauengesundheitsthemen, Selbstverteidigungskurs uvm.); Kultur und Kunst (diverse monatliche Events: picknicken, Kochevents, tanzen, Unternehmungen in und um Stuttgart); Geflüchtete (Fempowerment durch intensiven kulturellen Austausch).', 'null', '[\"def5709b-04dd-409e-a3d9-2831186574d7\"]', 1),
('b4e874ed-da4d-4da9-bb3a-f698815136aa', 'Evidence e. V.', '', 48.812879, 9.158758, '', '', '', 'Kärntner Straße 40A', '70469', 'Stuttgart', '', 'plain', 'EVIDENCE ist unabhängig – auch parteipolitisch unabhängig. EVIDENCE verfolgt das Ziel, dass allen Interessierenden unserer Gesellschaft - Muslime und Nicht-Muslime - der Zugang zum Islam und zu seinen authentischen Quellen auf einem wissenschaftlich fundierten Niveau und in deutscher Sprache ermöglicht wird. EVIDENCE fördert die Gelehrten und zukünftigen Islamwissenschaftler in ihrer Forschung und baut Brücken zwischen den anerkannten Wissenschaftlern und den nach Wissen Strebenden.', 'plain', 'Bildung (Wissenschaft, Forschung, Seminare, Workshops, Events sowie die Produktion wissenschaftlicher Literatur).', 'null', '[\"def5709b-04dd-409e-a3d9-2831186574d7\"]', 1),
('b7122ecf-cde8-43f7-8c79-b79cd628b1cb', 'Kalimera e. V. Deutsch-Griechische Kulturinitiative', '', 48.775471, 9.177591, '', '', '', 'Marktplatz 4', '70173', 'Stuttgart', '', 'plain', '', 'plain', 'Kultur und Kunst (Infoabende mit Podiums- und Publikumsgesprächen, Themen: Finanzkrise in Griechenland und Europa, Flucht und Asyl in Europa, was machen Kulturschaffende in Griechenland. Deutsch-Griechische Filmvorführungen und -festivals mit und ohne Regisseure mit anschließenden Publikumsgesprächen, Kinofestival, Theaterveranstaltungen, Theaterworkshops mit Kinder u. Jugendlichen, Stammtische im Laboratorium, Kooperationsprojekte mit Stuttgarter Einrichtungen, Kooperationsprojekt mit der Stadt Fellbach „Kultursommer Griechenland u. Italien), Musik (Musikkonzert &quot;Opera Chaotiq&quot; mit Jugendlichen, Musikkonzerte mit griechischen und internationalen Künstlern, Homagen an griechische Komponist*innen).', 'null', '[\"def5709b-04dd-409e-a3d9-2831186574d7\"]', 1),
('b77d5264-4072-401d-b4d0-58b870e12df0', 'Club Español Stuttgart e. V.', '', 48.78043, 9.182522, 'keine öffentliche Anschrift', '', '', '', '', '', '', 'plain', 'Förderung, Erhalt und Entwicklung der spanischen Kultur und Sprache, traditionelles Brauchtum und das Miteinenderleben von Spaniern, Deutschen und anderen spanischsprachigen Nationalitäten. Förderung von Sport und Internationaler Gesinnung, der Toleranz auf allen Gebieten der Kultur und des Völkerverständigungsgedankens. Unterstützung von hilfsbedürftigen Personen und Hilfsorganisationen.', 'plain', 'Bildung (Seminare,Vorträge, Workshops), Kultur und Kunst (Spanische Kulturtage, Kunst, Film, Theater), Gastronomie (Kochkurse, Stadtfeste), Sport (Fußsballturniere,Tanzkurse, traditioneller Tanz Flamenco)​, Musik (Konzerte).', 'null', '[\"def5709b-04dd-409e-a3d9-2831186574d7\"]', 1),
('b8782431-af44-4770-b8c1-081a602ef2f8', 'Deutsch-Chinesisches Forum Stuttgart e. V.', '', 48.708403, 9.171189, '', '', '', 'Zettachring 12A', '70567', 'Stuttgart', '', 'plain', 'Das Deutsch-Chinesische Forum Stuttgart fördert die gegenseitige Verständigung und das Kennenlernen. Es ist unabhängig und überparteilich. Das Forum bietet allen, die sich für einen unvoreingenommenen Dialog einsetzen, eine offene Plattform. Das Forum ist als gemeinnützig anerkannt. Der Verein fördert die Bildung, Ausbildung und Erziehung zum besseren Verständnis der Völker in Deutschland und China sowie den kulturellen, wirtschaftlichen und gesellschaftlichen Austausch.', 'plain', 'Bildung (muttersprachlicher Unterricht chinesich in der Huade Chinesisch-Schule für Kinder und Jugendliche, hochqualifizierter Sprachunterricht sowie interkulturelles Training mit dem Deutsch-Chinesischen Sprachinstitut Stuttgart, für Erwachsene, Privatpersonen, Organisationen sowie Unternehmen); Kultur und Kunst (vielfältiges Angebot von Veranstaltungen und Fachvorträgen zur Erreichung der Vereinsziele); Soziales (engagieren sich sozialpolitisch und helfen den chinesischen Mitbürger*innen bei der Integration in die deutsche Gesellschaft).', 'null', '[\"def5709b-04dd-409e-a3d9-2831186574d7\"]', 1),
('bab7921f-4a15-41b2-9932-854dd2bbcde7', 'COEXIST e. V.', '', 48.812879, 9.158758, '', '', '', 'Kärntner Straße 40A', '70469', 'Stuttgart', '', 'plain', 'Der Verein Coexist hat den Anspruch bei gesamtgesellschaftlichen Diskursen mitzuwirken und bietet Menschen ein Sprachrohr.', 'plain', 'Bildung (Empowerment-Angebote, Workshops zum Thema &quot;Frauenrechte&quot;, Aufklärung).', 'null', '[\"d3ea05ed-5dcd-4d47-a2aa-18e4eb6294c0\"]', 1),
('bde815f5-e8dc-4725-bf81-a1e547e201b9', 'Stuttgarter Ungarischer Kindergarten e.V.', '', 48.783945, 9.207342, '', '', '', 'Schönbühlstr. 57', '70188', 'Stuttgart', '', 'plain', 'Der Grundgedanke des Vereins ist, Kindern und Jugendlichen mit ungarischen Wurzeln aus dem Raum Stuttgart einen regelmäßigen Treffpunkt zu bieten, wo sie die ungarsiche Kultur und Sprache kennen lernen und in der Gruppe erleben können.', 'plain', 'Bildung (Förderung und Unterstützung beim Erwerb, Ausbau und Gebrauch der ungarischen Sprache von Kindern und Jugendlichen, Elternbildung, Unterstützung und Begleitung der Familien in der Mehrsprachigen Erziehung, aktiver Beitrag zur ganzheitlichen Entwicklung der Kinder und Jugendlichen); Kunst und Kultur (aktives kennen lernen und Aneignung der ungarischen Kinderkultur, Pflege der ungarischen Traditionen und Feiern).', 'null', '[\"bbf0d197-fcd6-4548-8548-ef1840057018\",\"cc67be51-58de-4109-ae78-2b0c018e27da\"]', 1),
('bf9f0f29-a412-4660-bbd9-dc7b6227bef5', 'Deutsch-Rumänisches Forum e. V.', '', 48.776965, 9.163543, '', '', '', 'Schloßstraße 76', '70176', 'Stuttgart', '', 'plain', 'Orientierung – Akkommodation, zivilgesellschaftliche Inklusion in Stuttgart für rumänische und moldauische Diaspora.', 'plain', 'Bildung (Multiplikator für Stuttgarter Bildung und Workshops), Kultur und Kunst (Kulturveranstaltungen als Treffen der Gemeinde zu diversen Themen und Traditionen Rumäniens), Beratung (Telefon Hotline – kostenlose Sofortberatung).', 'null', '[\"cf4658bb-885d-4937-bfd8-c5a7963a22d0\"]', 1),
('c57815f4-3521-422b-9b21-970a3d91b5a1', 'Eritreische Vereinigung zur gegenseitigen Unterstützung Stuttgart e. V.', '', 48.793894, 9.181704, '', '', '', 'Heilbronnerstr. 107', '70191', 'Stuttgart', '', 'plain', 'Unser Ziel ist die Förderung der Jugendarbeit mit dem Schwerpunkt des muttersprachlichen Unterrichtes, Familienbezogenen Jugendarbeit, Freizeitgestaltung und Sport. Unser Verein ist sozial aktiv, unsere Mitglieder unterstützen und beraten Bedürftige im Todesfall und Trauerfall.<br/>Wir bemühen uns stets geflüchteten Eritreer*innen mit Unterstützungs- und Beratungs- Angebot zu helfen.', 'plain', 'Bildung (muttersprachlicher Unterricht für Kinder); Kultur und Kunst (Theaterveranstaltungen, Spieleabende in Gruppen, Kulturfest, Weihnachtsfest, Osterfest, und eritreische Unabhängigkeit Fest, Feste für Frauengruppen); Musik (Musikveranstaltungen mit traditionell eritreischer Musik und Instrumenten); Gastronomie (traditionell eritreisches Essen in der hauseigenen Küche); Sport (Sportveranstaltungen und Freizeitgestaltung für Jugendliche); Soziales (Unterstützung und Beratung von Mitgliedern nach Bedarf, bzw. im Todesfall, Trauerfall, Mitglieder besuchen Patienten mit langem Krankheitsverlauf); Geflüchtete (Unterstützungs- und Beratungsangebot an geflüchteten Eritreer*innen).', 'null', '[\"cc67be51-58de-4109-ae78-2b0c018e27da\"]', 1),
('c7254571-01ce-4465-aa2f-f481c8f32fec', 'Africa Workshop Organisation e. V.', '', 48.772166, 9.174594, '', '', '', 'Tübinger Straße 15', '70178', 'Stuttgart', '', 'plain', 'Bekanntmachung der afrikanischen Kultur, Unterstützung bei der Integration in die Stuttgarter Gesellschaft. Der Verein ist als humanitäre Selbsthilfegruppe und Völkerverständigungsverein seit 1988 in der Region Stuttgart aktiv.', 'plain', 'Bildung (Zielgruppe Kinder, Jugendliche, Eltern und Erwachsene), Soziales und Gesundheit (Arbeit mit Senior*innen, Menschen mit Behinderung), Entwicklung und Zusammenarbeit (Integrationshilfe), Engagement für Geflüchtete (Zusammenarbeit mit Geflüchteten).', 'null', '[\"d4b4dc39-3aa8-421b-991c-a37e3a05f08f\"]', 1),
('c8f6ca83-b09e-40b9-9893-50c44b98256b', 'Srpski Centar Stuttgart e. V.', '', 48.815154, 9.198532, '', '', '', 'Sigmund-Lindauer-Weg 24', '70376', 'Stuttgart', '', 'plain', 'Das serbische Zentrum Stuttgart e. V. ist ein deutsch-serbischer Kulturverein. Im Mittelpunkt steht das Tanzen von Volkstänzen, welche bei verschiedenen Meisterschaften oder Stadtfesten aufgeführt werden. Der Verein hat es sich zur Aufgabe gemacht, vor allem junge Menschen durch die Vereinstätigkeiten zu fördern und ihnen bestimmte Werte zu vermitteln.', 'plain', 'Bildung (Bastel-Workshops, Trachten nähen, Hausaufgabenbetreuung, Übernachtungsfest in Schlafsäcken mit Aufgaben und Spielen), Gastronomie (Kochkurse mit Kindern und Jugendlichen), Sport (traditioneller Tanz, Volkstanz, Fußballturniere).', 'null', '[\"cf4658bb-885d-4937-bfd8-c5a7963a22d0\",\"03913c8d-c21d-470a-90fc-b3032fc33f4a\",\"6903278b-dd88-4ae3-b08f-1e3c17aef3da\"]', 1),
('c9a25c59-9176-431f-b42a-058f08e94cbb', 'Verein zur Förderung der zeitgemäßen Lebensweise Baden-Württemberg e. V.', '', 48.764364, 9.174661, '', '', '', 'Filderstraße 19', '70180', 'Stuttgart', '', 'plain', '', 'plain', 'Bildung (Stipendien für Studierende in der Türkei, Vorträge), Musik (musikalische Früherziehung).', 'null', '[\"d4b4dc39-3aa8-421b-991c-a37e3a05f08f\"]', 1),
('cdff22e6-dd64-4d46-9b15-a610f2982c9f', 'StuFem e. V. - Stuttgarter Femina e. V. (akademischer Frauenverein)', '', 48.812167, 9.226198, '', '', '', 'Oppelnerstraße 1', '70372', 'Stuttgart', '', 'plain', 'Die Mitglieder des Vereins setzen ihren Migrationshintergrund als Bereicherung ein und möchten diesen zur Förderung von interkulturellem Dialog und der Gleichberechtigung der Geschlechter in den Mittelpunkt stellen.', 'plain', 'Bildung (Workshops und Infoabende zur beruflichen Perspektive von Frauen, Unterstützung von Kultur- Austauschprogrammen), Kultur und Kunst (interkulturelle After Work Begegnung, interreligiöse Begegnungen, Kunst, Ebru Kurs, Fillografie), Gastronomie (Kochkurs, Catering).', 'null', '[\"def5709b-04dd-409e-a3d9-2831186574d7\"]', 1),
('d033fdf5-ac43-453e-b9ab-717043f49d93', 'Asociación Ecuatoriana e. V.', '', 48.775484, 9.155293, '', '', '', 'Bebelstraße 22', '70193', 'Stuttgart', '', 'plain', 'Das Land Ecuador und seine Kultur der deutschen Bevölkerung näher bringen.', 'plain', 'Entwicklung und Zusammenarbeit (Integrationshilfe, Unterstützung von Ecuadorianer*innen in Deutschland), Gastronomie (traditionelles ecuadorianisches Essen), Sport (Tanz).', 'null', '[]', 1),
('d060dda1-a776-4b70-89e1-6af867271e37', 'Schwedischer Schulverein Stuttgart e. V.', '', 48.780936, 9.194478, 'keine öffentliche Anschrift', '', '', '', '', '', '', 'plain', 'Förderung der Erziehung, Volks- und Berufsbildung einschließlich der Studentenhilfe, insbesondere Vermittlung von Kenntnissen in schwedischer Sprache, Geschichte, Heimatkunde und Geografie.', 'plain', 'Bildung (mutersprachlicher Unterricht in schwedisch, Spielgruppe, Schulreisen); Kultur und Kunst (kulturelle Veranstaltungen, schwedische Feste).', 'null', '[\"bbf0d197-fcd6-4548-8548-ef1840057018\"]', 1),
('d1524c94-5421-40f7-9220-fb29d8e95947', 'Lettischer Kulturverein SAIME e. V.', '', 48.762484, 9.160198, 'keine öffentliche Anschrift', '', '', '', '', '', '', 'plain', 'Pflege der lettischen Kultur und Geschichte, Bräuche sowie Sprache in Wort und Schrift für und mit den Landsleuten in der neuen Heimat . Es werden Konzerte, Lesungen, Treffen, Feste, Theatervorstellungen, Vorträge, Infoabende, Filmvorführungen etc. zur Vermittlung und Erhaltung kultureller und historischer Traditionen durchgeführt. Beteiligung am gesellschaftlichen und kulturellen Leben sowie die Zusammenarbeit zwischen Letten und Bürgern unterschiedlicher Herkunft und Generationen.', 'plain', 'Bildung (muttersprachlicher Unterricht lettisch, Kinder-Kultur-Schule mit Sprach-, Gesangs- und Tanzunterricht), Kultur und Kunst (Kulturveranstaltungen), Sport (traditioneller Tanz, lettische Volkstanzgruppe &quot;Trejdeksnitis&quot;).', 'null', '[\"03913c8d-c21d-470a-90fc-b3032fc33f4a\"]', 1),
('d28dd38c-4e88-4a84-a876-1eab137768c9', 'Kulturverein Slovenija-Stuttgart e. V.', '', 48.77364, 9.191878, '', '', '', 'Stafflenbergstraße 64', '70184', 'Stuttgart', '', 'plain', 'Förderung und Pflege des slowenischen kulturellen Lebens in Stuttgart.', 'plain', 'Bildung (Sprachförderung bei Kindern und Jugendlichen), Kultur und Kunst (literarische Abende, Kulturabende), Musik (Veranstaltungen mit verschiedenen Chören und Gesangsgruppen aus Slowenien).', 'null', '[\"bbf0d197-fcd6-4548-8548-ef1840057018\"]', 1),
('d2aa6f28-b72b-447a-960f-7c2395f7afe7', 'Arrafidain Kulturverein e. V.', '', 48.83014, 9.196158, '', '', '', 'Tapachstraße 60', '70437', 'Stuttgart', '', 'plain', 'Sprachunterricht Arabisch nach Lehrplan für alle Sprachniveaus A1 bis hin zum C1 (Schriftbild, Wortschatz, Grammatik, Kommunikation, Rhetorik) für Kinder, Jugendliche und Erwachsene um Selbstbewusstsein, Persönlichkeit, Begabungen und kommunikative &amp; schriftliche Kompetenzen der Heranwachsenden so zu unterstützen, aber auch ihre Integration &amp; Demokratieverständnis zu fördern.', 'plain', 'Bildung (muttersprachlicher Arabischunterricht mit anschließenden Prüfungen und Zeugnissen bzw. Zertifikaten als Leistungsnachweisen, unsere Lehrkräfte gehören zur Gruppe der Migranten, Flüchtlingen und/ oder Älteren und engagieren sich hier für die Schaffung neuer Perspektiven, Toleranz, Integration und Respekt); Kultur und Kunst ( Lesewettbewerb, Schreibwettbewerb, Theaterstück in der arabischen Sprache und Schulausflüge mit Schülern und Eltern).', 'null', '[\"def5709b-04dd-409e-a3d9-2831186574d7\",\"1a04156f-facc-494c-8061-7fc8138adf91\"]', 1),
('de13059f-0b31-4b03-92c7-4cb78872cca8', 'ADD Stuttgart – Verein zur Förderung der Ideen Atatürks e. V.\r Atatürk Düsünce Dernegi Stuttgart', '', 48.761837, 9.159631, '', '', '', 'Möhringerstraße 56', '70199', 'Stuttgart', '', 'plain', '', 'plain', 'Bildung (Nachhilfe für Kinder und Jugendliche in Deutsch, Englisch und Mathematik, Seminare und Kurse für Eltern und Erwachsene im Umgang mit Teenagern und möglichen Problemen, für die Gleichberechtigung und Rechte der Frauen), Kultur und Kunst (Konferenzen mit Gastvorträgen in türkischer Sprache, Veranstaltungen bei türkischen Nationalfeiertagen).', 'null', '[\"03913c8d-c21d-470a-90fc-b3032fc33f4a\"]', 1),
('dea1242b-e0d8-4a00-94f1-7de0e8765855', 'Polnischer Kulturverein in Baden-Württemberg e. V.', '', 48.773605, 9.165593, 'keine öffentliche Anschrift', '', '', '', '', '', '', 'plain', 'Pflege und Entwicklung der polnischer Kultur und des polnischen Gesellschaftslebens. Der Verein ist uneigennützig.', 'plain', 'Bildung (Literaturveranstaltung, Lesung); Kultur und Kunst (Feste, Feiern, Ausflüge); Soziales (Gesellschaftliche und Thematische Treffen); Musik (Konzertveranstaltungen).', 'null', '[\"def5709b-04dd-409e-a3d9-2831186574d7\"]', 1),
('df4085b6-f941-4df7-995e-e8eb20fbd76c', 'Stuttgarter Dante-Gesellschaft e. V. Società Dante Alighieri Comitato di Stoccarda', '', 48.780413, 9.182478, 'keine öffentliche Anschrift', '', '', '', '', '', '', 'plain', 'Verständigung zweier großer Kulturvölker durch ein vielfältiges Angebot an Vorträgen, Lesungen, Konzerten, Führungen, Diskussionen und Reisen.', 'plain', 'Kultur und Kunst (Vorträge, Lesungen, Literaturveranstaltungen, Konzerte, Kunstführungen, Diskussionen, Sprach- und Kulturreisen, Veranstaltungskalender).', 'null', '[]', 1),
('ea7d29fa-96a3-4f41-a36a-474ad62d3d0a', 'tigre vermelho e. V. Freundeskreis zur Förderung der Kultur Brasiliens', '', 48.799667, 9.487469, '', '', '', 'Schorndorfer Straße 47', '73650', 'Winterbach', '', 'plain', 'Vermittlung brasilianischer Lebensfreude, Spenden an Projekte in Brasilien und Deutschland zum Wohl von Kindern.', 'plain', 'Kultur und Kunst (Karnevalsparty &quot;Carnaval dos Tigres&quot; im Römerkastell/Phönixhalle mit Tanzshows, DJs, &quot;Waiblinger Altstadtfest&quot; mit Samba-Shows, Partymusik, Cocktails), Gastronomie (Essen), Musik (brasilianische Band).', 'null', '[\"d3ea05ed-5dcd-4d47-a2aa-18e4eb6294c0\",\"b34a153d-bd29-4b97-9814-23f10c5048e8\"]', 1),
('eefd0107-56c2-486f-ac33-0ce646edc243', 'Nordkaukasischer Kulturverein Stuttgart (NART) e. V.', '', 48.711395, 9.15437, '', '', '', 'Bonhoefferweg 14', '70565', 'Stuttgart', '', 'plain', 'Die kaukasische Kultur und die Sprachen zu erhalten diese Mitgliedern, Kulturinteressierten und vor allem einer breiten Öffentlichkeit zugänglich zu machen.<br/>Förderung soziokultureller Aufgaben und Anliegen in Stuttgart auf gemeinnütziger Basis. Leitbild: Kultur gehört zum Menschen – unabhängig von seiner persönlichen Situation und sozialen Lage. Der Verein ist bunt an Sprachen, Kulturen und Identitäten – genauso wie der Kaukasus!', 'plain', 'Bildung (muttersprachlicher Unterricht), Sport (Tanz), Musik (Musikwerkstatt, Chor-Gesang).', 'null', '[\"d4b4dc39-3aa8-421b-991c-a37e3a05f08f\"]', 1),
('efb6cdd6-a788-45cf-ba14-5158e1aae370', 'Medienkulturverein Multicolor e. V.', '', 48.790009, 9.199521, '', '', '', 'Stöckachstraße 16a', '70190', 'Stuttgart', '', 'plain', 'Realisierung von Medienprojekten aller Art, meist unter interkulturellen Aspekten. Menschen mit und ohne Migrationshintergrund sollen mediale Möglichkeiten an die Hand gegeben werden, ihre Welt und ihre Themen in einer verständlichen Art sichtbar, hörbar und erlebbar zu machen.', 'plain', 'Kultur und Kunst (Ausstellung), Podcast (Radio, Podcasts, Audiodateien). Ausgewählte Projekte: &quot;Mittendrin – Mein Leben ist Stuttgart und davor&quot; (Eine Radioproduktion aus Texten, Klängen und Geräuschen, die Lebenserfahrungen und Alltag von Migrant*innen in Stuttgart hörbar macht), &quot;Spurensuche&quot; (Junge Menschen haben sich auf den Weg gemacht, Höhepunkte oder auch Verborgenes in Stuttgart zu entdecken und medial aufzubereiten), &quot;Meinst du, die Russen wollen Krieg?&quot; (Wanderausstellung mit Rollups und gerahmten Fotografien über das heutige Russland).', 'null', '[\"d4b4dc39-3aa8-421b-991c-a37e3a05f08f\"]', 1),
('f1768cdd-b63d-47da-8dba-518dd35643af', 'Serbisches Akademikernetzwerk - Nikola Tesla e. V.', '', 48.784815, 9.178465, '', '', '', 'Kriegsbergstraße 28', '70174', 'Stuttgart', '', 'plain', 'Aktive Teilhabe an der deutschen Gesellschaft durch Projekte aus den Bereichen Bildung und Kultur. Die Vernetzung von deutschen und serbischen Institutionen und der aktive Wissensaustausch sind hierbei von großer Bedeutung, weshalb die Veranstaltungen für eine breite Öffentlichkeit zugänglich sind.', 'plain', 'Bildung (Bildungsprojekte z. B. Mobile Denkfabrik, Power Einwanderer), Kultur und Kunst (Filmfestival www.filmanak.de, Lesungen).', 'null', '[\"def5709b-04dd-409e-a3d9-2831186574d7\"]', 1),
('f186c23e-05ff-49a8-bb32-df524d28277a', 'Deutsch-Albanischer Verein für Kultur, Jugend und Sport „Pavarësia“ e. V.', '', 48.782637, 9.184363, 'keine öffentliche Anschrift', '', '', '', '', '', '', 'plain', 'Förderung der Beziehungen zwischen deutschen und albanischen Bürgern, das Pflegen der albanischen Sprache, Kultur und Tradition, sowie die Förderung der Integration der albanischen Bevölkerung in die deutsche Gesellschaft.', 'plain', 'Bildung (muttersprachlicher Unterricht albanisch), Sport (traditioneller Tanz, albanischer Volkstanz, sportliche Aktivitäten), Kultur und Kunst (Vorträge über deutsche und albanische Literatur und Kunst, Land u. a., Dichterlesungen, Musik- und Tanzabende, Studienfahrten).', 'null', '[\"03913c8d-c21d-470a-90fc-b3032fc33f4a\",\"bbf0d197-fcd6-4548-8548-ef1840057018\",\"d3ea05ed-5dcd-4d47-a2aa-18e4eb6294c0\"]', 1),
('f43b9a85-f33d-495d-9d62-42bcd7470c8b', 'ABADÁ Capoeira e. V.', '', 48.809439, 9.226132, 'keine öffentliche Anschrift', '', '', '', '', '', '', 'plain', '', 'plain', 'Sport (Tanz-Kampfsport, Sport im Park, Functional Fitness).', 'null', '[\"d3ea05ed-5dcd-4d47-a2aa-18e4eb6294c0\"]', 1),
('f53866ca-24c5-445c-b9c1-6eaf1b16fd9a', 'Mädchenschule Khadigram e. V.', '', 48.79245, 9.208238, '', '', '', 'In der Reute 21', '71566', 'Althütte', '', 'plain', 'Solide Grundbildung von Mädchen aus vulnerablen Gesellschaftsgruppen/Unberührbare in Indien. Deckung der Grundbedürfnisse an Kleidung, Nahrung, medizinischer Versorgung. Ausbildung von Frauen zur Krankenpflegerin und Hebamme. Hunger - und Armutsbekämpfung. Wir engagieren uns für den Zugang zu sauberem Trinkwasser. Seit August 2020 finanzieren wir ein Programm &quot;COVID 19 RESCUE AGAINST HUNGER&quot; für 500 besonders vom Hunger bedrohten Familien zur Versorgung mit Grundnahrungmitteln.', 'plain', 'Bildung (muttersprachlicher Unterricht (in Indien) Gujarati und Hindi); Soziales (Wir sind ein Verein der in Deutschland Spenden akquiriert, um seine Ziele in Indien umzusetzen).', 'null', '[]', 1),
('f8d5aa7a-b049-4644-a838-b43f7f63abd5', 'Jesidische Sonne Stuttgart Ezidische Sonne Stuttgart', '', 48.804904, 9.221803, 'keine öffentliche Anschrift', '', '', '', '', '', '', 'plain', '', 'plain', 'Kultur und Kunst, Entwicklung und Zusammenarbeit (Integrationshilfe, Unterstützung der jesidischen Gemeinde in Baden-Württemberg), Engagement für Geflüchtete (Zusammenarbeit mit Geflüchteten), Gastronomie (traditionelles Essen), Sport (Tanz).', 'null', '[\"d3ea05ed-5dcd-4d47-a2aa-18e4eb6294c0\"]', 1),
('fa7f4588-9bd3-4f37-8451-9e9f1efa7193', 'Afrikafestival Stuttgart e. V.', '', 48.762266, 9.160229, 'keine öffentliche Anschrift', '', '', '', '', '', '', 'plain', 'Die Kultur Afrikas den Menschen in Stuttgart und Umgebung näher zu bringen.', 'plain', 'Kultur und Kunst (Kunstmarkt, offene Bühne mit Konzerten und Tanzdarbietungen, Vorträge, Filmvorführungen, Workshops und Theateraufführungen, Deutsch-Afrikanischer Gottesdienst in der Matthäuskirche jährlich am 2. Juliwochenende), Gastronomie (traditionelles Essen), Sport (Tanz).', 'null', '[\"03913c8d-c21d-470a-90fc-b3032fc33f4a\"]', 1),
('fc243b18-37d2-4bdf-8d2e-8806d915639a', 'India Culture Forum e. V.', '', 48.773204, 9.164096, 'keine öffentliche Anschrift', '', '', '', '', '', '', 'plain', '', 'plain', 'Kultur und Kunst (Jährliche Feste: Religiöses Fest in Fellbach, Lichterfest im Bürgerzentrum West), Gastronomie (traditionelles Essen), Sport (Tanz-Workshops, Yoga).', 'null', '[\"cf4658bb-885d-4937-bfd8-c5a7963a22d0\",\"ee4de3c1-f202-4b67-a8ee-ee53c95af538\"]', 1),
('ff105bd7-9438-4548-9880-9926f7ef0c96', 'Yalla e. V.', '', 48.775303, 9.178135, 'keine öffentliche Anschrift', '', '', '', '', '', '', 'plain', 'Hilfe zur Selbsthilfe in arabischen Ländern, feste Einzelprojekte in Ägypten und Tunesien, Kulturaustausch und Völkerverständigung, Organisation von Workcamps und Orientalische Feste in Deutschland.', 'plain', 'Bildung (Organisation von Workcamps für Europäer*innen und arabische Teilnehmer*innen in arabischen Ländern und Deutschland)<br/>; Kultur und Kunst (Vorträge zur Kultur und Geschichte des historischen und modernen Ägypten, Veranstaltung orientalischer Feste in Deutschland); Soziales (Probleme in Entwicklungsländern, Informationsveranstaltung über soziale Projekte in Ägypten und arabischen Ländern, Unterstützung von Einrichtungen in Ägypten , die sich um sozial benachteiligte Menschen kümmern und Verkauf von Eine-Welt-Produkte, die in Selbsthilfeprojekten hergestellt wurden, Aufbau von Geräten für Spielplätze und Beteiligung an der Errichtung von Vielzwecksportplätzen für soziale Einrichtungen, Beitrag zur Entwicklung des Umweltbewußtseins, das in armen Ländern oft kaum vorhanden ist).', 'null', '[\"def5709b-04dd-409e-a3d9-2831186574d7\"]', 1);
INSERT INTO `associations` (`id`, `name`, `shortName`, `lat`, `lng`, `addressLine1`, `addressLine2`, `addressLine3`, `street`, `postcode`, `city`, `country`, `goals_format`, `goals_text`, `activities_format`, `activities_text`, `activityList`, `districtList`, `current`) VALUES
('ff2b4372-6623-4fa2-856d-5c13ee8ec800', 'Capoeira Stuttgart e. V.', '', 48.827584, 9.076422, '', '', '', 'Gottfried-Keller-Straße 41', '71254', 'Ditzingen', '', 'plain', 'Gemeinnütziger Sportverein, mit dem Ziel den brasilianischen Nationalsport Capoeira in Stuttgart bekannt zu machen und den Stuttgartern die Gelegenheit zu bieten, diesen zu erlernen.', 'plain', 'Kultur und Kunst (vielfältige kulturelle und karitative Veranstaltungen), Entwicklung und Zusammenarbeit (Integrationshilfe), Engagement für Geflüchtete (Zusammenarbeit mit Geflüchteten: Sport und Musik - Capoeira für Kinder und Erwachsene, Training in Flüchtlingsheimen Bürgerhospital und Mercedesstraße), Sport (regelmäßige Trainings).', 'null', '[\"03913c8d-c21d-470a-90fc-b3032fc33f4a\",\"068af935-dc42-40a4-98ef-e59352e9706c\",\"d3ea05ed-5dcd-4d47-a2aa-18e4eb6294c0\"]', 1);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `contacts`
--

CREATE TABLE `contacts` (
  `id` varchar(36) NOT NULL,
  `name` varchar(512) DEFAULT NULL,
  `phone` varchar(512) DEFAULT NULL,
  `fax` varchar(512) DEFAULT NULL,
  `mail` varchar(512) DEFAULT NULL,
  `poBox` varchar(512) DEFAULT NULL,
  `associationId` varchar(36) NOT NULL,
  `orderIndex` int(11) DEFAULT NULL,
  `current` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Daten für Tabelle `contacts`
--

INSERT INTO `contacts` (`id`, `name`, `phone`, `fax`, `mail`, `poBox`, `associationId`, `orderIndex`, `current`) VALUES
('0ff11e5c-3a8e-4c8f-9638-e0d1c12b875a', '', '07183949374', '', 'marianne.frank.mast@gmx.net', '', 'f53866ca-24c5-445c-b9c1-6eaf1b16fd9a', 0, 1),
('17ea8be2-8b50-41a5-9890-4c0f90f521e6', '', '0711/248 44 41', '', 'info@dtf-stuttgart.de', '', '85e9a6f1-1688-490d-abd8-e5310b351df6', 0, 1),
('1c92ede6-18d4-4fdd-b989-5a9f77100188', '', '0711/528 67 36', '', 'info@chinesische-sprachschule-stuttgart.de', '', '9b7bb4ed-ad2c-4285-bbdd-41fbae36012f', 0, 1),
('1cab2d01-ed73-48be-93d3-03bafe299cb5', '', '', '', 'info@spspfrauen.org', '', '1d431cd5-99b4-46a6-b194-23c123cb01ea', 0, 1),
('1de02571-f6ff-4c4c-b98f-70b56833e9e3', '', '0711-5052001', '', 'info@laboratorium-stuttgart.de', '', '1828beaf-0ce2-4eb2-87f0-128ce2ecb2ac', 0, 1),
('2c9edd56-0f62-40c3-8b49-30e7a28e8fc2', '', '0711/55 08 963', '', 'yputra@web.de', '', '96385eda-f56e-4dab-9305-9a8c025881b3', 0, 1),
('2e018ce2-444b-4318-be60-fbd89facddbe', '', '', '', 'sc-stuttgart@gmx.de', '', 'c8f6ca83-b09e-40b9-9893-50c44b98256b', 0, 1),
('34de6953-7472-46a9-83da-2fdf6a09e5b6', '', '', '', 'info@afrikafestival-stuttgart.de', '', 'fa7f4588-9bd3-4f37-8451-9e9f1efa7193', 0, 1),
('36268dfc-e3f3-4aad-b01b-67dcab35f60a', '', '0711-86025544', '', 'info@ars-narrandi.de', '', '9a3f346c-50dd-418f-838d-4f4b6b299abf', 0, 1),
('38c81d03-7609-4bad-a4b6-9ed7e8612a44', '', '0173/1912555', '', 'info@forum-wbk.de', '', '05cae93c-c701-4dfc-a9df-f41fc6aa6b18', 0, 1),
('38e1acb8-3a2d-45d4-9066-050e2a8d059c', '', '0711/6143552', '', 'hif@afro-soleil.de', '', '513e769c-bee3-4cb6-8c92-5a2b8b98f4dc', 0, 1),
('3b8c9947-d78a-4686-a67e-169d7dc5c915', '', 'https://www.instagram.com/juma_stuttgart/?hl=de', '', '', '', '933edcfe-3ace-40ad-ba25-1647d78d048c', 1, 1),
('42a8d912-1523-4a30-9f4d-ecf4bcd54eab', '', '0179 9883220', '', '', '', 'd2aa6f28-b72b-447a-960f-7c2395f7afe7', 1, 1),
('44dde2a6-e6e3-482a-b757-882bac63e55f', '', '0178/8346746', '', 'info@herosacademy.org', '', '8426e17b-c18e-4061-aac7-3085b564ddf9', 0, 1),
('49d968f2-7de1-4525-b947-05f7bd14ded2', '', '', '', 'stuttgart@ada-netzwerk.com', '', 'a4be69a3-e758-456c-a6e2-f207c8df1a94', 0, 1),
('4a3e87c2-f04c-4fa2-ab78-d5578bc503b6', '', '0711/94529847', '', 'info@stufem.de', '', 'cdff22e6-dd64-4d46-9b15-a610f2982c9f', 0, 1),
('4a458b85-8436-4041-8d44-270c4551418f', '', '0711/8601304', '', 'baye_fall_ev@yahoo.com', '', '4e40cbc8-c77f-4f7c-9e19-16287ec5e6bd', 0, 1),
('4fade2c3-3348-4bfe-98db-e40d23514881', '', '0711/162 81 20', '', 'corsilingua.iicstuttgart@esteri.it', '', '7f6944a2-98a1-4564-a9eb-3ec1036014c2', 0, 1),
('553d9a72-f10f-4c75-a930-70ae7066f7ad', '', '0172/6334382', '', 'igboculturalfoundation@gmail.com', '', '6eb95e35-4777-42f2-bd54-4a6279552622', 0, 1),
('57e140d1-527d-4928-bc49-18ddeee4a1ef', '', '0172/8578716', '', 'info@abada-capoeira.eu', '', 'f43b9a85-f33d-495d-9d62-42bcd7470c8b', 0, 1),
('5eaebfab-e70c-44a1-ab5b-ee32f1631464', '', 'https://de-de.facebook.com/JumaProjektJungMuslimischAktiv/', '', 'info@juma-ev.de, bawue@juma-ev.de', '', '933edcfe-3ace-40ad-ba25-1647d78d048c', 0, 1),
('5f708b00-b2bd-487e-8989-fa217d4a4673', '', '0151/75859183', '', 'prosvjeta.stuttgart@gmx.de', '', '4687342f-8990-4a34-a0a2-0baec5a4e912', 0, 1),
('62a6bd8a-d8a3-4636-b127-403b461ce907', '', '', '', 'vietnamcommunitystuttgart@googlemail.com', '', '2ff36edf-550a-4b14-af0d-7e572ebb1520', 0, 1),
('65528083-62d6-4f84-ae82-9a817eb0074e', '', '0711/60 44 06', '', 'schaal.stuttgart@freenet.de', '', 'd033fdf5-ac43-453e-b9ab-717043f49d93', 0, 1),
('6c39c6c5-b52b-4ee5-8f0c-f3e73164a13b', '', '', '', 'info@stuttgarti-magyar-gyerekeknek.de', '', 'bde815f5-e8dc-4725-bf81-a1e547e201b9', 0, 1),
('6d3649c3-bc8f-4e5e-9475-5354b47efa07', '', '', '', 'info@kalimera-ev.de', '', 'b7122ecf-cde8-43f7-8c79-b79cd628b1cb', 0, 1),
('6f40ed86-1561-4c0b-b309-413bf467d243', '', '0176/82078688', '', 'info@klangoase-derya.de', '', '2a0c0981-125c-4bf2-bb18-d17da3f4a72e', 0, 1),
('704a5423-a1f3-4ead-8bd8-f8a16b61c6a0', '', '0152/08790860', '', 'info@ndwenga-fellbach.de', '', '23214454-a952-4a4a-94fb-8b6dd63ff602', 0, 1),
('7200b995-a3b1-4b10-84da-7255567a33cf', '', '', '', 'bcf.stuttgart@gmail.com', '', '38e4c9d7-9a1e-4151-992c-65f5935f35fe', 0, 1),
('7723b79b-edbc-4a5f-8067-4c49f9bea074', '', '0711/640 74 82', '', 'aylishk@aol.com', '', '62d5d3ef-8d58-483f-bbdf-68cc5335586e', 0, 1),
('7b57edfb-916c-4e21-a6ab-29a57c86ac1b', '', '0170/582 6402', '', 'ozaharsha@gmail.com', '', 'fc243b18-37d2-4bdf-8d2e-8806d915639a', 0, 1),
('7e349735-66b3-4486-aeb3-41c53e69c711', '', '', '', 'info@kd-slovenija.de', '', 'd28dd38c-4e88-4a84-a876-1eab137768c9', 0, 1),
('850194e2-b62f-4e1b-82ad-6ef618fab60f', '', '', '', 'info@dante-stuttgart.de', 'Postfach 150 462, 70076 Stuttgart', 'df4085b6-f941-4df7-995e-e8eb20fbd76c', 0, 1),
('8527b654-607b-45b3-9569-11db4d963206', '', '', '', 'vorstand@yallaev.de', '', 'ff105bd7-9438-4548-9880-9926f7ef0c96', 0, 1),
('867fa3b8-3038-48f1-83a5-24f17caa7a5e', '', '', '', 'mail@punto-de-encuentro.net', '', '3ae5a598-ab7f-4a14-acdc-690be402569a', 0, 1),
('873ce82e-737d-45ec-84d9-e4e65adcb438', '', '0176/24909496', '', 'team@stelp.eu', '', '0e49a524-77ac-427c-80cb-4567762f6ecd', 0, 1),
('8ae460db-3c5f-4366-a464-a7b8e9b37d1d', '', '0157779577870', '', 'saime@latviesi.com', '', 'd1524c94-5421-40f7-9220-fb29d8e95947', 0, 1),
('8ce8b5be-b500-43fc-bbbe-90828b9362d2', '', '0157/82965484', '', 'info@forum-afrikanum.de', '', '78b2f07e-c7b3-43d5-9725-beff5e42f704', 0, 1),
('8d555502-3eae-4e1c-8f09-c82289b27a8e', '', '', '', 'info@nart-stuttgart.de', '', 'eefd0107-56c2-486f-ac33-0ce646edc243', 0, 1),
('93a29e7c-56f0-4ff7-9c3e-b539b422457c', '', '', '', 'office@sam-nt.de', '', 'f1768cdd-b63d-47da-8dba-518dd35643af', 0, 1),
('9a1f44b9-b625-43d4-8a39-3e8fc7db0d0b', '', '07192/200 82', '', '2009ggsa@gmail.com', '', 'c7254571-01ce-4465-aa2f-f481c8f32fec', 0, 1),
('a01abdf5-c816-491d-9cf5-7961e4d55705', '', '0173/9718681', '', 'castillajor@aol.com', '', 'b77d5264-4072-401d-b4d0-58b870e12df0', 0, 1),
('a0451399-e649-42d2-b1e3-c03fd79503a4', '', '', '', 'info@femalefellows.com', '', 'ab012da0-663c-41a8-8b87-b0db5a3be8e6', 0, 1),
('a40cd7b5-0156-4fdc-be6d-5ee35631141c', '', '0176/456 751 31', '', 'info@vereinpavaresia.de', '', 'f186c23e-05ff-49a8-bb32-df524d28277a', 0, 1),
('a6517e63-75b4-4378-9832-c34d4214ce1f', '', '', '', 'Kontakt@dmstuttgart.de', '', '390ac58c-d7a7-4fd7-8534-33bbf4c34ff2', 0, 1),
('a8527ca4-8bc6-439d-8c98-2c1b7140d382', '', '0157/790 78 470', '', 'info@forum-gerrum-stuttgart.de', '', 'bf9f0f29-a412-4660-bbd9-dc7b6227bef5', 0, 1),
('b3c2c519-2f30-41cc-892a-d6700b67f622', '', '', '', 'EritreischeVereinigung.ev@t-online.de', '', 'c57815f4-3521-422b-9b21-970a3d91b5a1', 0, 1),
('bc622327-ec01-4d55-9c28-bbd1845b340f', '', '0178/3888986', '', 'n.jayasuriya@gmx.de', '', '4e1d3c36-6104-4134-a84b-bdfaea285fbf', 0, 1),
('be4dec39-7d7b-4163-90e3-2376fb1d8cb4', '', '', '', 'stuttgart@femalefellows.com (Anmeldung zum Tandemprojekt)', '', 'ab012da0-663c-41a8-8b87-b0db5a3be8e6', 1, 1),
('bf379270-1c94-443d-8d85-f2cc43e4a59d', '', '', '', 'coexist@t-online.de', '', 'bab7921f-4a15-41b2-9932-854dd2bbcde7', 0, 1),
('c5a99619-e166-4ea4-862f-74c6f6fc3f9c', '', '0711/964 12 53', '', 'info@multicolor-stuttgart.de', '', 'efb6cdd6-a788-45cf-ba14-5158e1aae370', 0, 1),
('c7284573-f94d-4c5f-9141-c592e6972900', '', '', '', 'info@tigre.de', '', 'ea7d29fa-96a3-4f41-a36a-474ad62d3d0a', 0, 1),
('cf7f3060-b81e-4fe0-8399-f5f9f0a96960', '', '0162 876 2095', '', 'arrafidainschule@gmx.de', '', 'd2aa6f28-b72b-447a-960f-7c2395f7afe7', 0, 1),
('d015fc8b-9be8-4173-a908-31d5d41fc2b4', '', '0711/8946890', '', 'info@bkhw.org', '', '9d78b29c-606c-4840-af8d-ffd9e95059c5', 0, 1),
('d5e7376c-321f-4ab5-a1fd-3d040734e0af', '', '0711/78781883', '', 'info@dcfsev.org', '', 'b8782431-af44-4770-b8c1-081a602ef2f8', 0, 1),
('d66d7f06-f0c4-427d-bd51-8f40fbac60e4', '', '', '', 'info@capoeira-stuttgart.org', '', 'ff2b4372-6623-4fa2-856d-5c13ee8ec800', 0, 1),
('d7eb6d74-9fab-4a2f-a078-07c21f5d7dce', '', '0163/650 86 04', '', 'G.koeksal@gmx.de', '', 'de13059f-0b31-4b03-92c7-4cb78872cca8', 0, 1),
('dc973480-d33c-4e34-8033-96955f11f7ce', '', '', '', 'pssk.stuttgart@t-online.de', '', 'dea1242b-e0d8-4a00-94f1-7de0e8765855', 0, 1),
('e23de01e-6c53-45c8-a848-a6f4e6c63a30', '', '0711 239 41 33', '', 'mosaik@vij-wuerttemberg.de', '', '999e07e3-e174-4a47-a1b6-9c44f21341c4', 0, 1),
('e3837ca0-3a6d-402e-be4b-e6c41fe9a0dd', '', '0176/81057694', '', 'info@adelitas.de', '', '7f938139-c0d3-42c1-b975-62786d744093', 0, 1),
('e86ad515-789c-426a-8677-047d73c4f620', '', '0711/248 48 08-0', '0711/248 48 08-88', 'info@forum-der-kulturen.de', '', '293b0f91-f109-4b74-ab91-a265834e0897', 0, 1),
('f134be50-42c4-4030-abbf-4143ac7f2a46', '', '0173/412 71 83', '', 'Yalova@hotmail.de', '', '352239b3-9d62-4571-94c9-6ded7e07b20e', 0, 1),
('fa8d065b-208e-4a80-a857-98e35516cf64', '', '', '', 'skolan-i-stuttgart@gmx.de', '', 'd060dda1-a776-4b70-89e1-6af867271e37', 0, 1),
('fc44778e-bfba-42b1-8d4a-f757ac07440e', '', '0179/5010311', '', 'post@latin-jazz-initiative.de', '', '727a1af9-2157-4593-be2a-41dcb506cda4', 0, 1),
('fd862415-e24b-42d5-9ae1-da7304dcc1c1', '', '0711/8601188', '', '', '', 'f8d5aa7a-b049-4644-a838-b43f7f63abd5', 0, 1);

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
('06d93ac1-6cb3-42f5-a69f-bbff8af09448', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/Logo_SCS_2015-.jpg', '', 'c8f6ca83-b09e-40b9-9893-50c44b98256b', 0, 1),
('073e4a99-273d-4412-ae21-83bb62737465', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/Club_espanol_StuttgarLOGO.png', '', 'b77d5264-4072-401d-b4d0-58b870e12df0', 0, 1),
('07b3656a-d286-4108-9fa0-48210a99ec9b', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2021/10/Spanischsprechende-Frauen-in-BW-.jpg', '', '1d431cd5-99b4-46a6-b194-23c123cb01ea', 0, 1),
('0c337041-95ad-43a7-92a7-88a1e0519fa2', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2021/10/vij_Logo_ohne_Motto.jpg', '', '999e07e3-e174-4a47-a1b6-9c44f21341c4', 0, 1),
('11b3ffb4-2c3b-479c-8670-c5a26cff5bf3', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/19388741_1152716738166081_8179760973660957952_o.jpg', '', 'c8f6ca83-b09e-40b9-9893-50c44b98256b', 1, 1),
('1a7bda04-2f16-4ee9-9f1f-44878ea98e67', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/Saime_logo.jpg', '', 'd1524c94-5421-40f7-9220-fb29d8e95947', 0, 1),
('205831c7-caed-43ed-835f-18c320bf7ec5', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/logo.jpg', '', 'fa7f4588-9bd3-4f37-8451-9e9f1efa7193', 0, 1),
('2a98173f-5c5a-4057-848b-aa91b6bdccee', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2021/10/wd-logo.jpg', '', '047b2565-03c3-4bae-bbd3-00b4fa194471', 0, 1),
('2d5db454-03bc-41bf-8361-93f25cd8c817', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/Kulturverein-Slovenija-Stuttgart-e.-V.-logo.png', '', 'd28dd38c-4e88-4a84-a876-1eab137768c9', 0, 1),
('359632d6-5459-48c6-8bd6-a487dbaeef8e', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2021/10/Lab-Logo_rot.png', '', '1828beaf-0ce2-4eb2-87f0-128ce2ecb2ac', 0, 1),
('45d6fc26-c7d2-4632-85c4-c62395547767', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/Logo_Pavaresia.png', '', 'f186c23e-05ff-49a8-bb32-df524d28277a', 0, 1),
('4fbcf61b-64c1-489a-aa94-25bc66a126e0', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2021/10/Logo-web.jpg', '', '9d78b29c-606c-4840-af8d-ffd9e95059c5', 0, 1),
('55011e8d-df21-4b94-bee5-158aa153aa98', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/Stelp_Supporter_yellow-blue-min.png', '', '0e49a524-77ac-427c-80cb-4567762f6ecd', 0, 1),
('56433314-9f60-41f3-86b9-445321a32f3b', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2021/10/Logo2015-1.png', '', 'd2aa6f28-b72b-447a-960f-7c2395f7afe7', 0, 1),
('5760ec89-d1a4-4447-85a3-895e779c791c', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/Logo-Verein-Ndwenga-e.-V.jpg', '', '23214454-a952-4a4a-94fb-8b6dd63ff602', 0, 1),
('623c7c4a-88b9-4ac0-bc13-2f65dd59260d', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/Deutsch-Rumaenisches-Forum-Stuttgart-e.V..png', '', 'bf9f0f29-a412-4660-bbd9-dc7b6227bef5', 0, 1),
('6579eadd-2991-46a1-9638-d153618f82c6', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/Logo-Akademie-fuer-internationalen-Kulturaustausch-e.V.-scaled.jpg', '', '62d5d3ef-8d58-483f-bbdf-68cc5335586e', 0, 1),
('6da0964f-5301-49e7-b3da-f94809d4f3d8', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2021/02/yalla-typo.jpg', '', 'ff105bd7-9438-4548-9880-9926f7ef0c96', 0, 1),
('6e871904-49ab-4dee-a8c2-8e2d65e837f6', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2021/10/JUMA-Logo.jpg', '', '933edcfe-3ace-40ad-ba25-1647d78d048c', 0, 1),
('7180e031-dc2a-4adc-be07-32d119306caf', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/Serbischer-Bildungs-und-Kulturverein-„Prosvjeta-Deutschland-e.-V..jpg', '', '4687342f-8990-4a34-a0a2-0baec5a4e912', 0, 1),
('71954ad0-ac7b-4740-8297-2e49ef3a692f', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/firkat_logo_rgb.jpg', '', '352239b3-9d62-4571-94c9-6ded7e07b20e', 0, 1),
('73ac7930-c423-408d-9c15-96c457fba2da', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2021/10/ARS-Narrandi-e.-V..jpg', '', '9a3f346c-50dd-418f-838d-4f4b6b299abf', 0, 1),
('7540ebaa-c8b7-4ea2-9435-ae340609cd58', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2021/10/Svenska-Skolan-Logo.jpg', '', 'd060dda1-a776-4b70-89e1-6af867271e37', 0, 1),
('8317a794-1fb0-4640-9b9c-85b72e27abc3', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/logo.gif', '', '2a0c0981-125c-4bf2-bb18-d17da3f4a72e', 0, 1),
('84c1a912-0109-457b-91a1-f643e81f7527', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/Forum_Afrikanum_Logo-scaled.jpg', '', '78b2f07e-c7b3-43d5-9725-beff5e42f704', 0, 1),
('8cd0e1dc-6dc4-4dc9-8c09-662005c67c47', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/logo_1f980094ef8e4dfc2c99eab269df270b_2x.png', '', 'cdff22e6-dd64-4d46-9b15-a610f2982c9f', 0, 1),
('92d780ad-223a-4ed8-88e8-3c061877e909', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2021/02/Deutschsprachiger-Muslimekreis-Stuttgart-DMS-e.-V..jpg', '', '390ac58c-d7a7-4fd7-8534-33bbf4c34ff2', 0, 1),
('940c5fa8-02f5-4b28-bce7-fd048da7ca0b', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/FdK_Logo_4c_rot.png', '', '293b0f91-f109-4b74-ab91-a265834e0897', 0, 1),
('9c3bde9f-b971-4209-94bf-cef90524fcd5', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2021/02/Female-Fellows.jpg', '', 'ab012da0-663c-41a8-8b87-b0db5a3be8e6', 0, 1),
('a77fc83b-31cd-4ae2-b40b-db024f766c42', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/Serbisches-Akademikernetzwerk-Nikola-Tesla-e.-V..png', '', 'f1768cdd-b63d-47da-8dba-518dd35643af', 0, 1),
('aca8baf1-b249-43d1-9639-518e7dd8fad4', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2021/02/Eritreische-Vereinigung-zur-gegenseitigen-Unterstuetzung-Stuttgart-e.-V..jpg', '', 'c57815f4-3521-422b-9b21-970a3d91b5a1', 0, 1),
('b0900b31-05d5-432b-b6b7-ce0d9022449d', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/Forum-der-Kulturen-3-scaled.jpg', '', '96385eda-f56e-4dab-9305-9a8c025881b3', 0, 1),
('b09e31c9-796a-41e3-8a80-2bdc16b60f69', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2021/02/VCS-2-logo.jpg', '', '2ff36edf-550a-4b14-af0d-7e572ebb1520', 0, 1),
('b1151351-5b68-49e1-aa62-773b177c9b92', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/Adelitas-Tapatias.jpg', '', '7f938139-c0d3-42c1-b975-62786d744093', 0, 1),
('b518b7d6-2dc8-4069-9e0a-ab83dd2111f5', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2021/10/LOGO_NEU-Transparent.png', '', 'b4e874ed-da4d-4da9-bb3a-f698815136aa', 0, 1),
('bbc82db0-2ce4-4043-80c0-074f825db056', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/DTF-Projekte.png', '', '85e9a6f1-1688-490d-abd8-e5310b351df6', 0, 1),
('c21d088c-fc1c-4b9a-b6cc-8ebf1a8266e5', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/IFWBK_logo_flyer.png', '', '05cae93c-c701-4dfc-a9df-f41fc6aa6b18', 0, 1),
('c62b1537-6598-4e1d-9335-c8bafb8e42eb', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2021/10/aum.jpg', '', 'f53866ca-24c5-445c-b9c1-6eaf1b16fd9a', 0, 1),
('cb2f07e3-2559-4949-b8cf-adc75ffd82bd', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2021/02/Black-Community.jpeg', '', '38e4c9d7-9a1e-4151-992c-65f5935f35fe', 1, 1),
('cdc839f1-0377-4cc8-99be-aee7381f43ee', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/Foerderverein-Heros-Academy-AIC-Stuttgart-e.-V.-scaled.jpg', '', '8426e17b-c18e-4061-aac7-3085b564ddf9', 0, 1),
('d9d9aea8-a14c-4059-af96-2c92de7e199f', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/China-Kultur-Kreis-e.-V.-scaled.jpg', '', '9b7bb4ed-ad2c-4285-bbdd-41fbae36012f', 0, 1),
('da8ba2a1-67d2-4fd9-a497-2344771e0d87', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/Akademie-fuer-internationalen-Kulturaustausch-e.V.-Aylish-Kerrigan1.jpg', '', '62d5d3ef-8d58-483f-bbdf-68cc5335586e', 1, 1),
('dbc37115-9a51-4b89-a7a0-8162e0b28d40', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/india-culture-forum.jpeg', '', 'fc243b18-37d2-4bdf-8d2e-8806d915639a', 0, 1),
('dfaee8ef-8a8f-4151-8a2f-073c26c7cdef', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/LogoJAZZ_OK.jpg', '', '727a1af9-2157-4593-be2a-41dcb506cda4', 0, 1),
('ea3b9a3d-2d99-49c2-9886-69d4ecfb6f90', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2021/02/Black-Community.png', '', '38e4c9d7-9a1e-4151-992c-65f5935f35fe', 0, 1),
('f046ceb8-0e0a-40ca-823a-d094c64c40b6', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/club-logo.png', '', '4e1d3c36-6104-4134-a84b-bdfaea285fbf', 0, 1),
('f0a40183-3bea-4645-b3f9-b1a9cdd46cce', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2021/02/ADAN_LOGO-1.png', '', 'a4be69a3-e758-456c-a6e2-f207c8df1a94', 0, 1),
('f2189799-a338-40e0-bbed-9d6b4d1638cc', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/Nordkaukasischer-Kulturverein-Stuttgart.jpg', '', 'eefd0107-56c2-486f-ac33-0ce646edc243', 0, 1),
('f281016e-9dc4-4903-9b7a-616b105afe19', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/kalimera_klein.jpg', '', 'b7122ecf-cde8-43f7-8c79-b79cd628b1cb', 0, 1),
('f45f2fb0-f83d-46dc-a084-a808631d7611', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/multicolor-nur-logo-neu.gif', '', 'efb6cdd6-a788-45cf-ba14-5158e1aae370', 0, 1),
('fd94200a-1e07-436b-96de-a7302a33fe37', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2021/02/Deutsch-Chinesisches-Forum-Stuttgart-e.V..jpg', '', 'b8782431-af44-4770-b8c1-081a602ef2f8', 0, 1),
('ff3ec0ee-fd53-446d-8ad6-189f557c489e', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/Punto-de-Encuentro-e.-V..png', '', '3ae5a598-ab7f-4a14-acdc-690be402569a', 0, 1);

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
('01c3401f-b3ff-46a0-b4e4-6d48f1f45e52', 'https://www.afrikafestival-stuttgart.de/', '', 'fa7f4588-9bd3-4f37-8451-9e9f1efa7193', 0, 1),
('04137733-83a9-4bda-895d-1aaedebd3227', 'https://www.forum-gerrum-stuttgart.de/', '', 'bf9f0f29-a412-4660-bbd9-dc7b6227bef5', 0, 1),
('05e708b1-4fd3-49d6-ae16-d320bf446200', 'https://www.herosacademy.org', '', '8426e17b-c18e-4061-aac7-3085b564ddf9', 0, 1),
('07bd9ffd-a8a8-4d70-8ad3-6a7b5f1acdfc', 'http://www.afro-soleil.de', '', '513e769c-bee3-4cb6-8c92-5a2b8b98f4dc', 0, 1),
('0b5b1c1a-4f1c-4cc8-b491-ea5c3d44dd43', 'http://deutsch-chinesisches-sprachinstitut.de/de/', '', 'b8782431-af44-4770-b8c1-081a602ef2f8', 1, 1),
('0c48c87b-50f5-405a-901c-bc58da8d244c', 'https://www.ecuador-freunde-stuttgart.com/', '', 'd033fdf5-ac43-453e-b9ab-717043f49d93', 0, 1),
('0ee3c84b-1f77-4420-b951-1f2ea262cc09', 'https://www.forum-afrikanum.de/', '', '78b2f07e-c7b3-43d5-9725-beff5e42f704', 0, 1),
('1e7aefd1-9766-4ed3-b604-360a1a755bde', 'https://www.yallaev.de', '', 'ff105bd7-9438-4548-9880-9926f7ef0c96', 0, 1),
('204c839a-dffa-4be4-8f55-9ee7f3b9b995', 'https://sam-nt.eu/', '', 'f1768cdd-b63d-47da-8dba-518dd35643af', 0, 1),
('20a16961-d5c0-458f-ba85-11c3acdb0be6', 'https://www.forum-der-kulturen.de', '', '293b0f91-f109-4b74-ab91-a265834e0897', 0, 1),
('20c98b75-9fcc-4b08-8859-d7b75cdcc009', 'https://ada-netzwerk.com/', '', 'a4be69a3-e758-456c-a6e2-f207c8df1a94', 0, 1),
('2466933f-92ea-4a61-a702-969a6247c1c0', 'https://www.dmstuttgart.de', '', '390ac58c-d7a7-4fd7-8534-33bbf4c34ff2', 0, 1),
('29841995-58b6-4957-90a0-4f6a6f071257', 'https://capoeira-stuttgart.org/', '', 'ff2b4372-6623-4fa2-856d-5c13ee8ec800', 0, 1),
('2bf17f55-109d-473e-9316-231c668fdda7', 'https://house-of-resources-stuttgart.de/', '', '293b0f91-f109-4b74-ab91-a265834e0897', 1, 1),
('2ca83dcd-b0f4-4266-98f5-9fac1df13d50', 'http://www.clubespagnolestuttgart.de', '', 'b77d5264-4072-401d-b4d0-58b870e12df0', 0, 1),
('2e893fb7-520c-49ce-8b68-e8364ae02348', 'https://www.chinesische-sprachschule-stuttgart.de', '', '9b7bb4ed-ad2c-4285-bbdd-41fbae36012f', 0, 1),
('2f05d58b-4636-4664-ac7e-5473d1ec95b0', 'http://www.firkat.de', '', '352239b3-9d62-4571-94c9-6ded7e07b20e', 0, 1),
('36604dce-ee53-4d1f-9e4b-008979a26de8', 'https://www.laboratorium-stuttgart.de', '', '1828beaf-0ce2-4eb2-87f0-128ce2ecb2ac', 0, 1),
('383871b4-aaed-4e07-8a98-0467d68cf5be', 'https://www.iicstoccarda.esteri.it', '', '7f6944a2-98a1-4564-a9eb-3ec1036014c2', 0, 1),
('3a9544bb-2812-42bb-8582-4b57017d3e09', 'https://www.skolan-i-stuttgart.de/', '', 'd060dda1-a776-4b70-89e1-6af867271e37', 0, 1),
('3bf10941-e210-4fc0-8f43-d79b184113e7', 'https://www.abada-capoeira.eu', '', 'f43b9a85-f33d-495d-9d62-42bcd7470c8b', 0, 1),
('3c5f8992-b497-4286-9e91-3f05376c1e23', 'https://www.indiacultureforum.de', '', 'fc243b18-37d2-4bdf-8d2e-8806d915639a', 0, 1),
('3e7e9623-ca45-4663-9c7b-e5f4921b7939', 'https://bayefall-ev.com', '', '4e40cbc8-c77f-4f7c-9e19-16287ec5e6bd', 0, 1),
('3ed7cab4-e480-40d6-be5d-c34df2f6c02a', 'http://www.stuttgarti-magyar-gyerekeknek.de/kezdolap-startseite.html', '', 'bde815f5-e8dc-4725-bf81-a1e547e201b9', 0, 1),
('437fa362-8f05-4f8e-8109-9464ae356d02', 'https://www.kalimera-ev.de/', '', 'b7122ecf-cde8-43f7-8c79-b79cd628b1cb', 0, 1),
('44bcb1d7-ce2f-4b3e-b2bd-47bfe1cde379', 'https://www.dante-stuttgart.de', '', 'df4085b6-f941-4df7-995e-e8eb20fbd76c', 0, 1),
('4643bda6-d949-4606-b794-e7ed3bcef92f', 'https://www.evidence-institut.de', '', 'b4e874ed-da4d-4da9-bb3a-f698815136aa', 0, 1),
('4a8503a5-ea43-4b7b-ba8e-b4dbc6f9e59d', 'https://africa-workshop.de', '', 'c7254571-01ce-4465-aa2f-f481c8f32fec', 1, 1),
('4af88fae-09b5-45f3-ae0e-af0bc221afae', 'http://www.klangoase-derya.com', '', '2a0c0981-125c-4bf2-bb18-d17da3f4a72e', 0, 1),
('4ef2b000-9e5b-452c-9fca-1515190e20d5', 'http://www.maedchenschule-khadigram.de', '', 'f53866ca-24c5-445c-b9c1-6eaf1b16fd9a', 0, 1),
('51444078-0a8a-4138-b32c-0988a7656c05', 'https://stelp.eu', '', '0e49a524-77ac-427c-80cb-4567762f6ecd', 0, 1),
('59f26e69-7458-4547-8621-0c304acff369', 'http://www.afrikaworkshop.de', '', 'c7254571-01ce-4465-aa2f-f481c8f32fec', 0, 1),
('5e946eeb-b004-4d80-a0e3-74118ea5d021', 'http://www.pssk.de', '', 'dea1242b-e0d8-4a00-94f1-7de0e8765855', 0, 1),
('5e949860-20dc-472e-8bf1-b0630ff16d5f', 'https://www.ndwenga-fellbach.de', '', '23214454-a952-4a4a-94fb-8b6dd63ff602', 0, 1),
('6360129c-f38c-4254-86fa-d99ccde35fc9', 'https://sprachedermusik.de/', '', '05cae93c-c701-4dfc-a9df-f41fc6aa6b18', 1, 1),
('66989f2a-478e-4012-b1d6-cb8928ceb78b', 'https://mig.madeingermany-stuttgart.de', '', '293b0f91-f109-4b74-ab91-a265834e0897', 3, 1),
('6a16d20d-cf5f-4d2c-ad60-9ac62b9a5ced', 'http://sldv-stuttgart.de', '', '4e1d3c36-6104-4134-a84b-bdfaea285fbf', 0, 1),
('7966c61d-792c-4483-8acc-42eb367932c0', 'http://coexistev.de', '', 'bab7921f-4a15-41b2-9932-854dd2bbcde7', 0, 1),
('88beb93c-ae8b-4d43-8df9-4c0a92dba45f', 'http://ggsa.de', '', 'c7254571-01ce-4465-aa2f-f481c8f32fec', 2, 1),
('9989985e-8260-47b1-863e-2825b685a5ee', 'http://www.memo-bw.de', '', '293b0f91-f109-4b74-ab91-a265834e0897', 4, 1),
('9b1f7f7f-d5ee-4251-aca7-bcfc0b4c6860', 'https://www.stufem.de', '', 'cdff22e6-dd64-4d46-9b15-a610f2982c9f', 0, 1),
('9c383047-b078-444a-84d9-a04279d480f2', 'https://vij-wuerttemberg.de/', '', '999e07e3-e174-4a47-a1b6-9c44f21341c4', 0, 1),
('a3290c71-e7c2-40d8-a8fd-09e4d3774410', 'https://www.latin-jazz-initiative.de/', '', '727a1af9-2157-4593-be2a-41dcb506cda4', 0, 1),
('a3ab7ded-15ea-44aa-b943-09f147e602e1', 'http://www.shoqatapavaresia.de', '', 'f186c23e-05ff-49a8-bb32-df524d28277a', 0, 1),
('a8cf1b6b-02ef-4303-86c9-c96648ee80de', 'https://verein-saime.de', '', 'd1524c94-5421-40f7-9220-fb29d8e95947', 0, 1),
('ad88acf7-79c7-4eac-b303-054c13b94427', 'https://www.femalefellows.com', '', 'ab012da0-663c-41a8-8b87-b0db5a3be8e6', 0, 1),
('adc1ff2b-9d45-498c-862b-67f67ef1cd6f', 'http://www.ndwenga-kinshasa.de', '', '23214454-a952-4a4a-94fb-8b6dd63ff602', 1, 1),
('ae54553d-c025-4641-b048-7e873b9e2587', 'https://www.bkhw.org', '', '9d78b29c-606c-4840-af8d-ffd9e95059c5', 0, 1),
('b2c83bf7-5f99-4cfb-9914-3b8c77c3cf5e', 'https://www.tigre.de', '', 'ea7d29fa-96a3-4f41-a36a-474ad62d3d0a', 0, 1),
('c0a36b3d-95ad-41a7-8b98-95120570ae16', 'http://www.cydd-bw.de', '', 'c9a25c59-9176-431f-b42a-058f08e94cbb', 0, 1),
('c6260d3d-a374-4ff4-a769-d1dd8bc5f4c1', 'http://www.add-stuttgart.de', '', 'de13059f-0b31-4b03-92c7-4cb78872cca8', 0, 1),
('c7f5a4a5-e86c-4f7d-b89d-c8353f03d4d8', 'http://www.multicolor-stuttgart.de', '', 'efb6cdd6-a788-45cf-ba14-5158e1aae370', 0, 1),
('d3ca0779-d62a-427f-b052-95bdb26797ea', 'https://kd-slovenija.de', '', 'd28dd38c-4e88-4a84-a876-1eab137768c9', 0, 1),
('e3315805-5d6f-4630-b036-ef5862050ec9', 'https://www.adelitas.de', '', '7f938139-c0d3-42c1-b975-62786d744093', 0, 1),
('e4871288-46bb-4cb4-9a44-7c839cfbdce5', 'https://forum-wbk.de/', '', '05cae93c-c701-4dfc-a9df-f41fc6aa6b18', 0, 1),
('e5b7a051-1886-4aaf-aa65-055681103704', 'https://sommerfestival-der-kulturen.de/', '', '293b0f91-f109-4b74-ab91-a265834e0897', 2, 1),
('e81b1187-6550-4576-8fe6-580f883fdea8', 'https://dcfsev.org/de/', '', 'b8782431-af44-4770-b8c1-081a602ef2f8', 0, 1),
('f1b7436f-b28e-4156-b484-21abf1ff994e', 'http://www.dtf-stuttgart.de', '', '85e9a6f1-1688-490d-abd8-e5310b351df6', 0, 1),
('f1d6408a-3fd1-41a9-9d4c-30180c15d913', 'https://punto-de-encuentro.net/', '', '3ae5a598-ab7f-4a14-acdc-690be402569a', 0, 1),
('f233e031-7eb9-4964-8c55-a73297e6d7d6', 'https://www.ars-narrandi.de', '', '9a3f346c-50dd-418f-838d-4f4b6b299abf', 0, 1);

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
('0005bfa2-6468-4ad1-b454-ae552fb632c6', 'Facebook', 'https://www.facebook.com/STELP.SupporterOnSite/', '', '0e49a524-77ac-427c-80cb-4567762f6ecd', 0, 1),
('005f01b6-3075-4fa5-945d-3e3d02f7a31e', 'Facebook', 'https://www.facebook.com/groups/792209454459495/', '', '1d431cd5-99b4-46a6-b194-23c123cb01ea', 0, 1),
('03db6d92-f453-400a-9111-d44b07c1fb4d', 'Facebook', 'https://www.facebook.com/Coexist-eV-410786919397394', '', 'bab7921f-4a15-41b2-9932-854dd2bbcde7', 0, 1),
('056b35f4-b674-4288-8da3-7a28b037328c', 'Instagram', 'https://www.instagram.com/sam_nts/', '', 'f1768cdd-b63d-47da-8dba-518dd35643af', 1, 1),
('0906d180-c8ca-4bc6-8f03-1435a7aa8793', 'Facebook', 'https://de-de.facebook.com/womendaysev-105523054524023/?ref=page_internal', '', '047b2565-03c3-4bae-bbd3-00b4fa194471', 0, 1),
('0c2ea45d-6344-4cf3-a375-407be37ec956', 'Facebook', 'https://www.facebook.com/latinjazzfestival', '', '727a1af9-2157-4593-be2a-41dcb506cda4', 0, 1),
('0d19f024-de8e-4a64-9686-9f1574e0ddfe', 'Facebook', 'https://www.facebook.com/adelitas.de', '', '7f938139-c0d3-42c1-b975-62786d744093', 0, 1),
('13d37258-7203-4d96-841c-bd0bb3673496', 'Facebook', 'https://de-de.facebook.com/FDKStuttgart', '', '293b0f91-f109-4b74-ab91-a265834e0897', 0, 1),
('1d4f2541-6ad1-41b7-af62-23a869e78ccc', 'Instagram', 'https://www.instagram.com/bkhw_org', '', '9d78b29c-606c-4840-af8d-ffd9e95059c5', 1, 1),
('2278f63c-3040-4735-8930-a449acc48662', 'Facebook', 'https://www.facebook.com/deutschsprachiger.muslimkreis.stuttgart', '', '390ac58c-d7a7-4fd7-8534-33bbf4c34ff2', 0, 1),
('272d669c-accf-4722-add9-96c759b77baa', 'Facebook', 'https://www.facebook.com/groups/ecuatorianosenstuttgart', '', 'd033fdf5-ac43-453e-b9ab-717043f49d93', 0, 1),
('2b5ef097-7cce-467b-88e1-3dcc47c14e40', 'Facebook', 'https://www.facebook.com/vijStuttgart', '', '999e07e3-e174-4a47-a1b6-9c44f21341c4', 0, 1),
('3ad48789-a8ab-4ab4-b759-5d94c60d6c67', 'Instagram', 'https://www.instagram.com/forumderkulturen/', '', '293b0f91-f109-4b74-ab91-a265834e0897', 1, 1),
('3b69db79-6afc-4561-828f-2dce7cd05375', 'Facebook', 'https://www.facebook.com/Musikunterricht-Derya-Bektas-321766687901410/', '', '2a0c0981-125c-4bf2-bb18-d17da3f4a72e', 0, 1),
('3cce21b1-6c1a-4356-b113-9bb334526bc6', 'Facebook', 'https://www.facebook.com/pages/category/Social-Club/Club-Espa%C3%B1ol-Stuttgart-Oficial-111439010486163/', '', 'b77d5264-4072-401d-b4d0-58b870e12df0', 0, 1),
('42b76563-871b-4f21-bf10-8fcd92480f04', 'Facebook', 'https://de-de.facebook.com/NOVO-Capoeira-Stuttgart-1559519010778402', '', 'ff2b4372-6623-4fa2-856d-5c13ee8ec800', 0, 1),
('42e13d86-4628-4f68-aab8-df2e7a405d1f', 'Instagram', 'https://www.instagram.com/shoqatapavaresia/', '', 'f186c23e-05ff-49a8-bb32-df524d28277a', 1, 1),
('44471e78-f931-4446-ae99-e1b0587b284c', 'Instagram', 'https://www.instagram.com/srpski_centar_stuttgart/', '', 'c8f6ca83-b09e-40b9-9893-50c44b98256b', 1, 1),
('45a72cd3-9a72-4b9a-91fe-6683eec9cf3e', 'Facebook', 'https://www.facebook.com/cyddbw/', '', 'c9a25c59-9176-431f-b42a-058f08e94cbb', 0, 1),
('486a87a9-a00e-4a7c-a39f-bfd1b3dcad5c', 'Facebook', 'https://de-de.facebook.com/pages/category/Stadium--Arena---Sports-Venue/Srpski-Centar-Stuttgart-Српски-Центар-Штутгарт-618210711616689/', '', 'c8f6ca83-b09e-40b9-9893-50c44b98256b', 0, 1),
('4be0d0e1-f49e-4ee3-9dad-bee62094712b', 'Facebook', 'https://www.facebook.com/Srpska.akademska.mreza.Nikola.Tesla', '', 'f1768cdd-b63d-47da-8dba-518dd35643af', 0, 1),
('540c8639-c161-4d6b-8db7-4b769ea20654', 'Instagram', 'https://www.instagram.com/dtfstuttgart/', '', '85e9a6f1-1688-490d-abd8-e5310b351df6', 1, 1),
('54594461-3b34-46b4-b278-40b2b2792f24', 'Instagram', 'https://instagram.com/femalefellows?igshid=y5ijs8lutc1f', '', 'ab012da0-663c-41a8-8b87-b0db5a3be8e6', 1, 1),
('5d3273c8-0ed3-46be-aaf9-75f8278b8f85', 'Facebook', 'https://www.facebook.com/adanetzwerk', '', 'a4be69a3-e758-456c-a6e2-f207c8df1a94', 0, 1),
('67050484-ade0-4539-a0b5-09a122e56e1e', 'Facebook', 'https://www.facebook.com/Jesidische-Sonne-Stuttgart-443134686435784', '', 'f8d5aa7a-b049-4644-a838-b43f7f63abd5', 0, 1),
('6a901c59-5f9f-4323-9146-fdb241988124', 'Facebook', 'https://www.facebook.com/Evidence-885079374951261/', '', 'b4e874ed-da4d-4da9-bb3a-f698815136aa', 0, 1),
('7765330b-98dc-45ed-a473-20500eacb700', 'Instagram', 'https://www.instagram.com/antoniocuadrosdebejar/', '', '727a1af9-2157-4593-be2a-41dcb506cda4', 1, 1),
('7dca9318-69f6-4991-98b8-7dd2997c2a87', 'Facebook', 'https://www.facebook.com/DeutschTuerkischesForumStuttgart', '', '85e9a6f1-1688-490d-abd8-e5310b351df6', 0, 1),
('8b37a408-67c5-42ee-9fec-ea7cec4cbaf4', 'Facebook', 'https://www.facebook.com/pages/category/Nonprofit-Organization/Punto-de-Encuentro-eV-Stuttgart-110697967281557/', '', '3ae5a598-ab7f-4a14-acdc-690be402569a', 0, 1),
('8b442464-167d-4054-b722-0486ea162865', 'Facebook', 'https://www.facebook.com/ShoqataPavaresiaStuttgart/', '', 'f186c23e-05ff-49a8-bb32-df524d28277a', 0, 1),
('8b739fe5-fb68-4e1c-a20a-136252954f7a', 'Facebook', 'https://www.facebook.com/laboratorium.stuttgart', '', '1828beaf-0ce2-4eb2-87f0-128ce2ecb2ac', 0, 1),
('8d62afa1-dfba-4c18-8310-5eeaf134e44d', 'Facebook', 'https://www.facebook.com/BolivianischesKinderhilfswerk', '', '9d78b29c-606c-4840-af8d-ffd9e95059c5', 0, 1),
('8e928b1a-256a-4fe0-ab90-ea1d9bc4fef6', 'Facebook', 'https://www.facebook.com/icfsev', '', '6eb95e35-4777-42f2-bd54-4a6279552622', 0, 1),
('905f6d62-dd43-4f5e-8705-613455ffb094', 'Facebook', 'https://de-de.facebook.com/754953194581359', '', '2ff36edf-550a-4b14-af0d-7e572ebb1520', 0, 1),
('94384058-3c15-4ef8-914d-7f1acb166154', 'YouTube', 'https://www.youtube.com/channel/UCrXoEYsGsc-TrO1fwSk5XsA/videos', '', '6eb95e35-4777-42f2-bd54-4a6279552622', 1, 1),
('949a8759-14ec-44fb-a3f2-9d02528cb286', 'YouTube', 'https://www.youtube.com/channel/UCQSh7OVUOm0UC7LsBQrEVGA', '', 'b4e874ed-da4d-4da9-bb3a-f698815136aa', 2, 1),
('a101816a-7ec8-47f9-8d53-f89579447863', 'Facebook', 'https://www.facebook.com/NartStuttgart', '', 'eefd0107-56c2-486f-ac33-0ce646edc243', 0, 1),
('aa85cad9-12fe-4b51-8deb-0d33adaace69', 'Instagram', 'https://www.instagram.com/bcf.stuttgart/?hl=de', '', '38e4c9d7-9a1e-4151-992c-65f5935f35fe', 0, 1),
('abd31c5b-631e-498d-b1ff-f4df2370e2fc', 'Instagram', 'https://www.instagram.com/evidence_institut/?hl=de', '', 'b4e874ed-da4d-4da9-bb3a-f698815136aa', 1, 1),
('ad4a0116-783b-4023-8fa3-ffcd8fd98c20', 'Instagram', 'https://www.instagram.com/cyddbw/', '', 'c9a25c59-9176-431f-b42a-058f08e94cbb', 1, 1),
('af2ed234-7bc5-4088-8186-605e6029b660', 'Facebook', 'https://www.facebook.com/tigrevermelhoev', '', 'ea7d29fa-96a3-4f41-a36a-474ad62d3d0a', 0, 1),
('b646ee96-41af-4f48-9e9e-755ac048dde3', 'Instagram', 'https://www.instagram.com/mujereshispanohablantesbw/?hl=de', '', '1d431cd5-99b4-46a6-b194-23c123cb01ea', 1, 1),
('bb595323-3403-44ca-be00-823536fd4e67', 'Instagram', 'https://www.instagram.com/adanetzwerk/?hl=de', '', 'a4be69a3-e758-456c-a6e2-f207c8df1a94', 1, 1),
('c6407739-d495-40d6-a1c0-db0c97a5265b', 'Instagram', 'https://www.instagram.com/womendaysev/', '', '047b2565-03c3-4bae-bbd3-00b4fa194471', 1, 1),
('c7acf8dd-356e-4dba-a6d9-23c638f83427', 'Instagram', 'https://www.instagram.com/club.stuttgart/?hl=de', '', '999e07e3-e174-4a47-a1b6-9c44f21341c4', 1, 1),
('cc0be5cd-424e-454c-9753-39ede5bbdf6f', 'Facebook', 'https://www.facebook.com/dcfsev', '', 'b8782431-af44-4770-b8c1-081a602ef2f8', 0, 1),
('d0048607-c3f2-4bba-99e6-64bfd7226655', 'Facebook', 'https://www.facebook.com/alla.wbk.9', '', '05cae93c-c701-4dfc-a9df-f41fc6aa6b18', 0, 1),
('d534eae0-1f62-46de-b749-b42653f1ae06', 'Instagram', 'https://www.instagram.com/coexist_e.v', '', 'bab7921f-4a15-41b2-9932-854dd2bbcde7', 1, 1),
('d8b9e583-8b75-4149-99b7-f51c6becaeae', 'Instagram', 'https://www.instagram.com/nartstuttgart', '', 'eefd0107-56c2-486f-ac33-0ce646edc243', 1, 1),
('e1bee892-4319-46b5-aec8-764055ea7033', 'Facebook', 'https://www.facebook.com/FemaleFellows', '', 'ab012da0-663c-41a8-8b87-b0db5a3be8e6', 0, 1),
('e24b103d-6674-4c9b-8bc0-f03bdc18eccd', 'Facebook', 'https://www.facebook.com/groups/439745146116192/', '', '78b2f07e-c7b3-43d5-9725-beff5e42f704', 0, 1),
('e2eadeb9-e7cf-4b24-8755-eb3341789be6', 'Instagram', 'https://www.instagram.com/stelp_supporter_on_site/', '', '0e49a524-77ac-427c-80cb-4567762f6ecd', 1, 1),
('e8bbd10e-60bd-4059-8cd2-15fa95b39f1d', 'Facebook', 'https://www.facebook.com/bayefallev', '', '4e40cbc8-c77f-4f7c-9e19-16287ec5e6bd', 0, 1),
('ecbc61fa-fc44-4bb7-af4e-c40392f07a00', 'Facebook', 'https://www.facebook.com/icfev/', '', 'fc243b18-37d2-4bdf-8d2e-8806d915639a', 0, 1),
('ed22b5b1-16fd-40cc-8e2e-5e2239964c31', 'Instagram', 'https://www.instagram.com/0711lab/', '', '1828beaf-0ce2-4eb2-87f0-128ce2ecb2ac', 1, 1),
('ef209583-74d9-434e-8891-7e8a9436f613', 'Facebook', 'https://www.facebook.com/alicetakin', '', 'fa7f4588-9bd3-4f37-8451-9e9f1efa7193', 0, 1),
('f43f2956-9ed4-4469-b702-62eacb9cccff', 'Instagram', 'https://www.instagram.com/muslimkreis_stuttgart', '', '390ac58c-d7a7-4fd7-8534-33bbf4c34ff2', 1, 1),
('fa324806-de5b-4644-9611-82570b09bd92', 'Instagram', 'https://www.instagram.com/prosvjetanemacka/', '', '4687342f-8990-4a34-a0a2-0baec5a4e912', 0, 1),
('fd19e646-47a5-4a5a-b949-1cf1788caf58', 'Instagram', 'https://www.instagram.com/asociacionpde/', '', '3ae5a598-ab7f-4a14-acdc-690be402569a', 1, 1);

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
