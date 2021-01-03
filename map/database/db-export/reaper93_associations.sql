-- phpMyAdmin SQL Dump
-- version 5.0.4
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:60109
-- Erstellungszeit: 03. Jan 2021 um 17:32
-- Server-Version: 10.3.24-MariaDB
-- PHP-Version: 7.4.11

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Datenbank: `reaper93_associations`
--

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `associations`
--

CREATE TABLE `associations` (
  `id` varchar(36) NOT NULL,
  `name` varchar(128) NOT NULL,
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
  `activityIds` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`activityIds`)),
  `districtIds` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`districtIds`))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Daten für Tabelle `associations`
--

INSERT INTO `associations` (`id`, `name`, `lat`, `lng`, `addressLine1`, `addressLine2`, `addressLine3`, `street`, `postcode`, `city`, `country`, `goals_format`, `goals_text`, `activities_format`, `activities_text`, `activityIds`, `districtIds`) VALUES
('00de259f-254a-491f-8555-1ed658c6a85b', 'Verein zur Förderung der zeitgemäßen Lebensweise Baden-Württemberg e. V.', 48.76449, 9.17463, '', '', '', 'Filderstraße 19', '70180', 'Stuttgart', 'Deutschland', 'plain', '', 'plain', 'Bildung (Stipendien für Studierende in der Türkei, Vorträge), Musik (musikalische Früherziehung).', '[103,106,107,115,800,808]', '[1001,101,104,105]'),
('195c1cfc-2e0a-4842-8700-d2f716e43ae0', 'ABADÁ Capoeira e. V.', 48.804819846049, 9.2220602878746, '', '', '', '', '', '', '', 'plain', '', 'plain', 'Sport (Tanz-Kampfsport, Sport im Park, Functional Fitness).', '[703,710,713]', '[106]'),
('59f81c29-5f86-47ec-8a8a-322d53ae14ff', 'Afrikafestival Stuttgart e. V.', 48.762560093391, 9.1599946337737, '', '', '', 'Erwin-Schöttle-Platz', '70199', 'Stuttgart', 'Deutschland', 'plain', 'Die Kultur Afrikas den Menschen in Stuttgart und Umgebung näher zu bringen.', 'plain', 'Kultur und Kunst (Kunstmarkt, offene Bühne mit Konzerten und Tanzdarbietungen, Vorträge, Filmvorführungen, Workshops und Theateraufführungen, Deutsch-Afrikanischer Gottesdienst in der Matthäuskirche jährlich am 2. Juliwochenende), Gastronomie (traditionelles Essen), Sport (Tanz).', '[206,207,208,209,804,703,704,217,216,115,105,201,213,215]', '[104]'),
('70a5f5f0-8a8f-485c-9f76-f68484aadd75', 'Akademie für internationalen Kulturaustausch e. V.', 48.768554943196, 9.1798170828064, '', '', '', 'Olgastraße 93B', '70180', 'Stuttgart', 'Deutschland', 'plain', 'Förderung des internationalen Kulturaustauschs durch Veranstaltungen mit Musik, Poesie und bildender Kunst aus verschiedenen Ländern unter Teilnahme interkultureller Künstler.', 'plain', 'Kultur und Kunst (Poesie, bildende Kunst in einer persönlichen, freundlichen Atmosphäre, wobei viel Gewicht auf Kommunikation zwischen Künstlern und Publikum gelegt wird), Musik (klassische und zeitgenössische Musik).', '[204,201,206,810,804,805,806]', '[101]'),
('7b99b747-5a41-430e-8109-9ed96525cef7', 'ADD Stuttgart – Verein zur Förderung der Ideen Atatürks e. V. Atatürk Düsünce Dernegi Stuttgart', 48.762020962057, 9.1597730404775, '', '', '', 'Möhringerstraße 56', '70199', 'Stuttgart', 'Deutschland', 'plain', '', 'plain', 'Bildung (Nachhilfe für Kinder und Jugendliche in Deutsch, Englisch und Mathematik, Seminare und Kurse für Eltern und Erwachsene im Umgang mit Teenagern und möglichen Problemen, für die Gleichberechtigung und Rechte der Frauen), Kultur und Kunst (Konferenzen mit Gastvorträgen in türkischer Sprache, Veranstaltungen bei türkischen Nationalfeiertagen).', '[101,103,105,109,115,203,206,210]', '[104]'),
('b90d8590-8068-462b-ae25-e9ec55f5e8c8', 'Internationales Forum für Wissenschaft, Bildung und Kultur e. V.', 48.808946920396, 9.229779374039, '', '', '', '', '', 'Stuttgart Bad-Cannstatt', 'Deutschland', 'plain', 'Popularisierung und Förderung der Wissenschaft, Bildung, Kunst und Kultur für alle Generationen, insbesondere für Kinder und Jugendliche auf regionaler, nationaler und internationaler Ebene. Der Verein bleibt bei der Verfolgung dieser Ziele politisch und konfessionell neutral.', 'plain', 'Bildung (MINT Projekt), Kultur und Kunst (Klassische Konzerte für Kinder und Jugendliche).', '[105,109,203,205,208,216,217,803,804,805,806,810,813,814,815,816,110]', '[101]'),
('bb6cbae9-5ad6-4d08-be2a-e2b0bd9791dd', 'COEXIST e. V.', 48.812831880518, 9.1587699981507, '', '', '', 'Kärntner Straße 40A', '70469', 'Stuttgart', 'Deutschland', 'plain', 'Der Verein Coexist hat den Anspruch bei gesamtgesellschaftlichen Diskursen mitzuwirken und bietet Menschen ein Sprachrohr.', 'plain', 'Bildung (Empowerment-Angebote, Workshops zum Thema \"Frauenrechte\", Aufklärung).', '[105,109]', '[106]'),
('eee41f26-5e5d-4b40-a5f4-f6c3272fd9bc', 'Latin Jazz Initiative', 48.77456828469, 9.1671889693137, '', '', '', 'Gutenbergstraße 3B', '70176', 'Stuttgart', 'Deutschland', 'plain', 'Die Latin Jazz Initiative entstand aus dem Bedürfnis neue Wege zu suchen, um das Jazz Publikum (nicht nur das Latin Jazz Publikum) auf diese wunderbare Musik aufmerksam zu machen. Durch Jazz entsteht Kommunikation unabhängig von Herkunft, Glauben oder anderen «Hindernissen», die in vielen anderen Bereichen das Zusammensein schwieriger machen.', 'plain', 'Beratung (Veranstaltungsplanung), Kunst und Kultur (Organisation und Durchführung von Festivals, Konzerte, Konzertreihen, Workshops, Jazz Open Stage, UNESCO-International Jazzday, UNESCO-International Danceday, United Jazz Ensemble, Musik im Viertel (Konzerte in kleinen Geschäften in verschiedenen Stadtteilen)), Bildung (Musikunterricht, Jazz-Workshops, Latin Jazz, Jazzdance und Latin Jazzdance, ein lebendiges Hörbuch, in dem der Autor seine eigenen Bücher liest und die Lesung musikalisch mit Stücken umrahmt, die extra hierfür komponiert werden).', '[111,116,208,802,804,805,806,808,812,815,816,1004]', '[101,105]'),
('fef60c29-29db-4cd3-81d1-289d09400160', 'Africa Workshop Organisation e. V.', 48.772345034833, 9.1746099980449, '', '', '', 'Tübinger Straße 15', '70178', 'Stuttgart', 'Deutschland', 'plain', 'Bekanntmachung der afrikanischen Kultur, Unterstützung bei der Integration in die Stuttgarter Gesellschaft. Der Verein ist als humanitäre Selbsthilfegruppe und Völkerverständigungsverein seit 1988 in der Region Stuttgart aktiv.', 'plain', 'Bildung (Zielgruppe Kinder, Jugendliche, Eltern und Erwachsene), Soziales und Gesundheit (Arbeit mit Senior*innen, Menschen mit Behinderung), Entwicklung und Zusammenarbeit (Integrationshilfe), Engagement für Geflüchtete (Zusammenarbeit mit Geflüchteten).', '[401,105,115,205,206,207,220,403,402,404,501,502]', '[100,101,102,103,104,105,106,110,124,121,120,116,109]');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `contacts`
--

CREATE TABLE `contacts` (
  `id` varchar(36) NOT NULL,
  `name` varchar(512) DEFAULT NULL,
  `phone` varchar(512) DEFAULT NULL,
  `mail` varchar(512) DEFAULT NULL,
  `associationId` varchar(36) NOT NULL,
  `orderIndex` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Daten für Tabelle `contacts`
--

INSERT INTO `contacts` (`id`, `name`, `phone`, `mail`, `associationId`, `orderIndex`) VALUES
('0cf6722d-4b4e-4d69-b52f-35b64096c7eb', '', '0179/5010311', 'post@latin-jazz-initiative.de', 'eee41f26-5e5d-4b40-a5f4-f6c3272fd9bc', 0),
('20208bac-48bb-448f-9bcd-33105dce0cd0', '', '0172/8578716', 'info@abada-capoeira.eu', '195c1cfc-2e0a-4842-8700-d2f716e43ae0', 0),
('32d4c59a-6d1c-4408-a76d-9ebf3bd281fd', '', '', '', '59f81c29-5f86-47ec-8a8a-322d53ae14ff', 0),
('3d3460fd-f86b-46f3-8dfa-97c585c76548', 'Aylish Kerrigan', '0711/640 74 82', 'aylishk@aol.com', '70a5f5f0-8a8f-485c-9f76-f68484aadd75', 0),
('5bc8cd30-dea7-443d-ae14-a36b4c234e36', '', '0163/650 86 04', 'G.koeksal@gmx.de', '7b99b747-5a41-430e-8109-9ed96525cef7', 0),
('b829a6f2-847f-4df1-855c-e4c49a3c7214', '', '', 'coexist@t-online.de', 'bb6cbae9-5ad6-4d08-be2a-e2b0bd9791dd', 0),
('e840cc66-a1c3-4d0d-bb41-10d4a7a3816a', '', '0173/1912555', 'info@forum-wbk.de', 'b90d8590-8068-462b-ae25-e9ec55f5e8c8', 0),
('ece3d675-f0c9-41c5-9333-198aa23ffa4b', '', '07192/200 82', '2009ggsa@gmail.com', 'fef60c29-29db-4cd3-81d1-289d09400160', 0);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `images`
--

CREATE TABLE `images` (
  `id` varchar(36) NOT NULL,
  `url` varchar(512) NOT NULL,
  `altText` varchar(512) DEFAULT NULL,
  `associationId` varchar(36) NOT NULL,
  `orderIndex` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Daten für Tabelle `images`
--

INSERT INTO `images` (`id`, `url`, `altText`, `associationId`, `orderIndex`) VALUES
('01725d93-f3e7-489a-8e0e-dfed79c57852', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/LogoJAZZ_OK.jpg', 'Latin Jazz Initiative', 'eee41f26-5e5d-4b40-a5f4-f6c3272fd9bc', 0),
('60c2b984-91ff-4922-8879-61a432dd5084', 'https://forum-wbk.de/wp-content/uploads/10-1800x1080.jpg', 'Gruppenbild', 'b90d8590-8068-462b-ae25-e9ec55f5e8c8', 1),
('678d4660-53ae-4868-9659-7f5ea73362f0', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/Akademie-fuer-internationalen-Kulturaustausch-e.V.-Aylish-Kerrigan1.jpg', 'Aylish Kerrigan', '70a5f5f0-8a8f-485c-9f76-f68484aadd75', 1),
('bd4d9846-60df-4dcf-8ead-413a6f70ae8e', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/Logo-Akademie-fuer-internationalen-Kulturaustausch-e.V.-scaled.jpg', 'Akademie für internationalen Kulturaustausch e. V.', '70a5f5f0-8a8f-485c-9f76-f68484aadd75', 0),
('d5deb61e-507c-40fb-9439-66aba043a314', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/IFWBK_logo_flyer.png', 'IFWBK-Logo', 'b90d8590-8068-462b-ae25-e9ec55f5e8c8', 0),
('deed6764-76e4-4272-ac5c-ad4bc0c46292', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/logo.jpg', 'Afrikafestival Stuttgart', '59f81c29-5f86-47ec-8a8a-322d53ae14ff', 0);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `links`
--

CREATE TABLE `links` (
  `id` varchar(36) NOT NULL,
  `url` varchar(512) NOT NULL,
  `linkText` varchar(512) DEFAULT NULL,
  `associationId` varchar(36) NOT NULL,
  `orderIndex` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Daten für Tabelle `links`
--

INSERT INTO `links` (`id`, `url`, `linkText`, `associationId`, `orderIndex`) VALUES
('018ceb70-a7ae-42da-98c3-3d4d4786fc53', 'http://www.africa-workshop.de', 'www.africa-workshop.de', 'fef60c29-29db-4cd3-81d1-289d09400160', 1),
('1e2afacc-9535-4f1a-8d2e-50e38d65d685', 'https://www.forum-wbk.de', 'Internationales Forum für Wissenschaft, Bildung und Kultur e.V.', 'b90d8590-8068-462b-ae25-e9ec55f5e8c8', 0),
('20fd455b-21b1-44de-ab55-add33b939978', 'https://www.latin-jazz-initiative.de', 'Latin Jazz Initiative', 'eee41f26-5e5d-4b40-a5f4-f6c3272fd9bc', 0),
('21bac2e2-095d-482b-8d6a-d849240523f4', 'https://www.sprachedermusik.de', 'Die Sprache der Musik', 'b90d8590-8068-462b-ae25-e9ec55f5e8c8', 1),
('309959b0-adc3-4c5e-8a88-1ac5f4506e1b', 'https://www.abada-capoeira.eu', 'ABADÁ Capoeira e. V.', '195c1cfc-2e0a-4842-8700-d2f716e43ae0', 0),
('7a6e1376-9747-480f-a512-ce76bd648a98', 'http://www.add-stuttgart.de', 'ADD Stuttgart', '7b99b747-5a41-430e-8109-9ed96525cef7', 0),
('8bd03d7f-61f8-4ed0-b2c4-6a6134335953', 'http://www.coexistev.de', 'coexistev.de', 'bb6cbae9-5ad6-4d08-be2a-e2b0bd9791dd', 0),
('8d1a75e5-8e4f-4937-8cf4-69fdc963cd92', 'https://sprachedermusik.de/musik-ohne-grenzen', '\"Musik ohne Grenzen\" (Festival)', 'b90d8590-8068-462b-ae25-e9ec55f5e8c8', 2),
('a88f020f-b3b3-4907-a9bd-590077b86860', 'https://www.cydd-bw.de', 'cydd-bw.de', '00de259f-254a-491f-8555-1ed658c6a85b', 0),
('fb4236d7-6026-4b82-b4ce-cb7bbb637576', 'http://www.afrikaworkshop.de', 'www.afrikaworkshop.de', 'fef60c29-29db-4cd3-81d1-289d09400160', 0),
('fcc2e530-cbf4-4bf1-8011-295f21891636', 'https://www.afrikafestival-stuttgart.de', 'Afrikafestival Stuttgart', '59f81c29-5f86-47ec-8a8a-322d53ae14ff', 0);

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
  `orderIndex` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Daten für Tabelle `socialmedia`
--

INSERT INTO `socialmedia` (`id`, `platform`, `url`, `linkText`, `associationId`, `orderIndex`) VALUES
('00e3a4ef-9166-40e9-a825-2ac51074a29c', 'Instagram', 'https://www.instagram.com/antoniocuadrosdebejar/', '', 'eee41f26-5e5d-4b40-a5f4-f6c3272fd9bc', 0),
('4ae543f9-301c-47ff-9eee-aaaf815d8fac', 'Facebook', 'https://www.facebook.com/sprachedermusik/', 'Facebook (Die Sprache der Musik)', 'b90d8590-8068-462b-ae25-e9ec55f5e8c8', 1),
('51546d2a-15b2-4832-8e04-e0b42401825a', 'Facebook', 'https://www.facebook.com/latinjazzfestival', '', 'eee41f26-5e5d-4b40-a5f4-f6c3272fd9bc', 1),
('5534c995-9922-4219-b56a-72e70c3bb8ae', 'Instagram', 'https://www.instagram.com/sprachedermusik/', 'Instagram (Die Sprache der Musik)', 'b90d8590-8068-462b-ae25-e9ec55f5e8c8', 2),
('5580f167-630e-48d5-b2cd-54e3c2821bc3', 'Facebook', 'https://www.facebook.com/alicetakin', '', '59f81c29-5f86-47ec-8a8a-322d53ae14ff', 0),
('7660e744-781d-485a-85f1-ecd305c3b6ae', 'Facebook', 'https://www.facebook.com/alla.wbk.9', '', 'b90d8590-8068-462b-ae25-e9ec55f5e8c8', 0),
('9ae45f52-91fe-4541-a7cc-5feb323652ca', 'Instagram', 'https://www.instagram.com/cyddbw/', '', '00de259f-254a-491f-8555-1ed658c6a85b', 1),
('9ee07612-9cf5-4495-9de9-b86c186e458a', 'Facebook', 'https://www.facebook.com/cyddbw/', '', '00de259f-254a-491f-8555-1ed658c6a85b', 0),
('bb45b6ba-9eb4-420b-884f-31f8547fcf3b', 'Facebook', 'https://www.facebook.com/Coexist-eV-410786919397394', '', 'bb6cbae9-5ad6-4d08-be2a-e2b0bd9791dd', 0),
('edb8f55c-a2f6-4475-84c9-d5f154efeb4c', 'Instagram', 'https://www.instagram.com/coexist_e.v', '', 'bb6cbae9-5ad6-4d08-be2a-e2b0bd9791dd', 1);

--
-- Indizes der exportierten Tabellen
--

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
-- Constraints der Tabelle `contacts`
--
ALTER TABLE `contacts`
  ADD CONSTRAINT `contacts_ibfk_1` FOREIGN KEY (`associationId`) REFERENCES `associations` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

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
