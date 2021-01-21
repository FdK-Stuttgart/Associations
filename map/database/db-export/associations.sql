-- phpMyAdmin SQL Dump
-- version 5.0.4
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Erstellungszeit: 22. Jan 2021 um 00:05
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
-- Tabellenstruktur für Tabelle `activities_options`
--

CREATE TABLE `activities_options` (
  `label` varchar(512) NOT NULL,
  `value` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Daten für Tabelle `activities_options`
--

INSERT INTO `activities_options` (`label`, `value`) VALUES
('Bildung', 100),
('Sprachunterricht', 101),
('Muttersprachlicher Unterricht', 102),
('Nachhilfe', 103),
('Hausaufgabenbetreuung', 104),
('Workshops', 105),
('Instrumentalunterricht', 106),
('Musikunterricht', 107),
('Übersetzungs- und Dolmetscherdienst', 108),
('Interessenkurse', 109),
('MINT', 110),
('Hörbuch', 111),
('Bücher', 112),
('Politik', 113),
('Kulturwissenschaften', 114),
('Gesellschaftliches', 115),
('UNESCO', 116),
('Kultur und Kunst', 200),
('Literaturveranstaltung', 201),
('Lesung', 202),
('Konferenz', 203),
('Poesie', 204),
('Sprach- und Kulturreisen', 205),
('Kunst', 206),
('Feste', 207),
('Festivals', 208),
('Feiern', 209),
('Podiumsgespräch', 210),
('Filmvorführung', 211),
('Theaterveranstaltung', 212),
('Theater', 213),
('Stammtisch', 214),
('Kinofestival', 215),
('Konzerte', 216),
('Konzertreihen', 217),
('Kunstmarkt', 218),
('Kunstführungen', 219),
('Workshops', 220),
('Soziales und Gesundheit', 300),
('Arbeit mit Senior*innen', 301),
('Menschen mit Behinderung', 302),
('Hilfsprojekte', 303),
('Notversorgung', 304),
('Verteilung von Lebensmitteln', 305),
('Entwicklung und Zusammenarbeit', 400),
('Integrationshilfe', 401),
('Freiwilligendienst', 402),
('Spenden für Projektunterstützung', 403),
('Patenschaften', 404),
('Engagement für Geflüchtete', 500),
('Zusammenarbeit mit Asylbewerber*innen', 501),
('Zusammenarbeit mit Geflüchteten', 502),
('Gastronomie', 600),
('Essen', 601),
('Traditionelles Essen', 602),
('Catering', 603),
('Fingerfood', 604),
('Kochkurs', 605),
('Sport', 700),
('Fußball', 701),
('Basketball', 702),
('Tanz', 703),
('Traditioneller Tanz', 704),
('Dance', 705),
('Jazzdance', 706),
('Flamenco', 707),
('Tanzkurse', 708),
('Yoga', 709),
('Fitness', 710),
('Capoeira', 711),
('Öffentliche Sportveranstaltung', 712),
('Trainings', 713),
('Musik', 800),
('Chor-Gesang', 801),
('Trommeln', 802),
('Öffentliche Musikveranstaltung', 803),
('Musik-Konzert', 804),
('Konzerte', 805),
('Konzertreihen', 806),
('Musikwerkstatt', 807),
('Musikunterricht', 808),
('Instrumentalunterricht', 809),
('Klassisch', 810),
('Jazz', 811),
('Latin Jazz', 812),
('Kinder', 813),
('Jugendliche', 814),
('Viertel', 815),
('Stadtteil', 816),
('Podcast', 900),
('Radio', 901),
('YouTube', 902),
('Beratung', 1000),
('Telefonberatung', 1001),
('Hotline', 1002),
('Sofortberatung', 1003),
('Veranstaltungsplanung', 1004);

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
('0110dd61-0bf5-4e62-abe5-772e1bd92d03', 'Loyenge e. V.', 48.772871367405, 9.2433282050367, '', '', '', 'Ulmer Straße 347', '70327', 'Stuttgart-Wangen', 'Deutschland', 'plain', 'Besseres Verstehen der Situation der Afrikaner in Europa und Afrika. Globalisierung der Kulturen. Vermittlung und Durchführung von Veranstaltungen mit Musik, Infos, Workshops.', 'plain', 'Bildung (Instrumentalunterricht: Trommelkurse \"Afrikanisches Trommeln\" für alle Altersgruppen), Kultur und Kunst (Theater, Kunst, Vorträge), Gastronomie (Benefizveranstaltungen mit traditionell afrikanischem Essen), Sport (Tanzkurse \"African Dance\"), Musik (Chor-Gesang, Afrikanischer Chor mit Hif Anga Belowi, Auftritte von Bands mit moderner und traditioneller afrikanischer Musik, Band \"Hif & Afro Soleil\" (Afropop, Reggae), Band \"Hif & Zanga\" (traditionelle Musik aus Afrika).', '[106,802,809,213,206,602,601,801,803,804,805]', '[105,101]'),
('030f5468-5e92-4232-aaa6-6780ed1db82c', 'Club Español Stuttgart e. V.', 48.780504677692, 9.1826130578386, 'keine öffentliche Anschrift', '', '', '', '', '', '', 'plain', 'Förderung, Erhalt und Entwicklung der spanischen Kultur und Sprache, traditionelles Brauchtum und das Miteinander von Spaniern, Deutschen und anderen spanischsprachigen Nationalitäten. Förderung von Sport und Internationaler Gesinnung, der Toleranz auf allen Gebieten der Kultur und des Völkerverständigungsgedankens. Unterstützung von hilfsbedürftigen Personen und Hilfsorganisationen.', 'plain', 'Bildung (Seminare, Vorträge, Workshops), Kultur und Kunst (Spanische Kulturtage, Kunst, Film, Theater), Gastronomie (Kochkurse, Stadtfeste), Sport (Fußsballturniere, Tanzkurse, traditioneller Tanz Flamenco)​, Musik (Konzerte).', '[105,220,213,206,211,212,207,209,205,605,703,704,707]', '[901]'),
('04659eb2-e809-4543-b987-ad491468593b', 'Deutsch-Rumänisches Forum e. V.', 48.777184264012, 9.163700898045, '', '', '', 'Schloßstraße 76', '70176', 'Stuttgart', 'Deutschland', 'plain', 'Orientierung – Akkommodation, zivilgesellschaftliche Inklusion in Stuttgart für rumänische und moldauische Diaspora.', 'plain', 'Bildung (Multiplikator für Stuttgarter Bildung und Workshops), Kultur und Kunst (Kulturveranstaltungen als Treffen der Gemeinde zu diversen Themen und Traditionen Rumäniens), Beratung (Telefon Hotline – kostenlose Sofortberatung).', '[105,206,220,1003,1002]', '[105]'),
('0991ef8a-2e54-4bb6-a2a9-523f35982a40', 'Asociación Ecuatoriana e. V.', 48.77558, 9.15534, '', '', '', 'Bebelstraße 22', '70193', 'Stuttgart', 'Deutschland', 'plain', 'Das Land Ecuador und seine Kultur der deutschen Bevölkerung näher bringen.', 'plain', 'Entwicklung und Zusammenarbeit (Integrationshilfe, Unterstützung von Ecuadorianer*innen in Deutschland), Gastronomie (traditionelles ecuadorianisches Essen), Sport (Tanz).', '[115,401,602,708,704,402]', '[902]'),
('171d9f6d-dd62-4113-b262-949692e790e8', 'Internationaler Musik- und Kulturverein Klangoase e. V.', 48.839990674335, 9.192938298047, '', '', '', 'Sauerkirschenweg 32', '70437', 'Stuttgart', 'Deutschland', 'plain', 'Unterschiedliche Kinder und Jugendliche mithilfe von Musik zusammenzubringen. Durch gemeinsames Musizieren stärkt der Verein die Persönlichkeit von Kindern, Jugendlichen und Erwachsenen sowie das Verständnis füreinander. Ein besonderer Schwerpunkt des Vereins ist die interkulturelle Arbeit mit dem Ziel, ein multinationales Orchester entstehen zu lassen.', 'plain', 'Bildung (Instrumentalunterricht: Gitarre, Klavier, Geige, Blockflöte, Cello, musikalische Früherziehung (M.F.E.), M.F.E.-unterricht in der Muttersprache Türkisch, Unterricht im Musikstil „Klassik“), Musik (Orchester, Chor-Gesang).', '[106,107,801,809,808]', '[124,123]'),
('195c1cfc-2e0a-4842-8700-d2f716e43ae0', 'ABADÁ Capoeira e. V.', 48.804819846049, 9.2220602878746, '', '', '', '', '', '', '', 'plain', '', 'plain', 'Sport (Tanz-Kampfsport, Sport im Park, Functional Fitness).', '[703,710,713]', '[106]'),
('19837db4-8b34-44ff-95fb-de5d88545f4d', 'Firkat, klassisch-türkischer Musikverein Stuttgart e. V.', 48.796885316347, 9.1935545980456, '', '', '', 'Mittnachtstraße 18', '70191', 'Stuttgart', 'Deutschland', 'plain', 'Eine Vereinigung und Verbindung zur Förderung der türkischen Kultur.', 'plain', 'Bildung (Noten- und Instrumentenunterricht für Kinder, Jugendliche, Eltern und Erwachsene), Kultur und Kunst (Konzerte), Musik (klassische türkische Musik, Chor-Gesang).', '[106,107,216,804,805,803,801,809,808,815,816,813,814]', '[102]'),
('219d2242-1c30-4493-be65-52cb9978f23e', 'Kulturverein Slovenija-Stuttgart e. V.', 48.77384932869, 9.1919585845519, '', '', '', 'Stafflenbergstraße 64', '70184', 'Stuttgart', 'Deutschland', 'plain', 'Förderung und Pflege des slowenischen kulturellen Lebens in Stuttgart.', 'plain', 'Bildung (Sprachförderung bei Kindern und Jugendlichen), Kultur und Kunst (literarische Abende, Kulturabende), Musik (Veranstaltungen mit verschiedenen Chören und Gesangsgruppen aus Slowenien).', '[101,201,801,804,805,803]', '[103]'),
('2417c64b-cb09-4e84-8d15-e972a8c6e313', 'Punto de Encuentro e. V.', 48.775198587828, 9.177220195703, '', '', '', 'Hirschstraße 12', '70173', 'Stuttgart', 'Deutschland', 'plain', 'Eine interkulturelle Begegnungsstätte für Menschen, die in der spanischen und deutschen Kultur verwurzelt sind, für Familien mit spanisch sprechenden Mitgliedern, für Eltern, die Interesse an bilingualer Erziehung für ihre Kinder haben.', 'plain', 'Bildung (muttersprachlicher Spanischunterricht, Bastel-Workshops, Handwerken, Experimentieren), Kultur und Kunst (Vermittlung der spanischen Sprache und Kultur, Feste und Feiern zum Gedanken- und Erfahrungsaustausch, Ausflüge und Besuche kultureller und wissenschaftlicher Einrichtungen und Museen), Entwicklung und Zusammenarbeit (Unterstützung von Personen, die aus der spanischen Kultur stammen oder die sich der spanischen Sprache und Kultur verbunden fühlen), Sport (Yoga).', '[102,205,207,209,709]', '[901]'),
('2991aab2-8d9d-48c3-8ee1-fda7a4335108', 'Sri Lankisch-Deutscher Verein Stuttgart e. V.', 48.830206682843, 9.2172877980467, '', '', '', 'Hopfenseeweg 3A', '70378', 'Stuttgart', 'Deutschland', 'plain', 'Förderung der Gemeinschaft und die soziale Integration der Sri Lankarnen in Stuttgart und Umgebung. Das langfristige und übergreifende Ziel ist es, einen kleinen Beitrag zum gemeinsamen Dialog und zum Verständnis unter den Menschen beizutragen.', 'plain', 'Bildung (Unterstützung von Projekten in Sri Lanka, Informations- und Diskussionsplattform), Kultur und Kunst (Events, künstlerische und kulturelle Projekte), Soziales und Gesundheit (Hilfsprojekte).', '[303,210]', '[102,105]'),
('2ffbfe6b-9a16-4e0d-9b60-4bd7c747fb34', 'Stuttgarter Dante-Gesellschaft e. V. Società Dante Alighieri Comitato di Stoccarda', 48.781116760203, 9.1833088515703, 'keine öffentliche Anschrift', '', '', 'Postfach 150 462', '70076', 'Stuttgart', '', 'plain', 'Verständigung zweier großer Kulturvölker durch ein vielfältiges Angebot an Vorträgen, Lesungen, Konzerten, Führungen, Diskussionen und Reisen.', 'plain', 'Kultur und Kunst (Vorträge, Lesungen, Literaturveranstaltungen, Konzerte, Kunstführungen, Diskussionen, Sprach- und Kulturreisen, Veranstaltungskalender).', '[202,220,201,217,216,219,205,805,806]', '[901]'),
('30d0925a-ca00-4d68-af44-0856092f2928', 'Ndwenga e. V.', 48.808127243602, 9.2733787388846, 'keine öffentliche Anschrift', '', '', '', '', '', '', 'plain', 'Förderung der internationalen Gesinnung, der Toleranz und des Völkerverständigungsgedanken auf allen Gebieten der Kultur im In- und Ausland. Besonderen Fokus legt Ndwenga e. V. auf die Ziele: keine Armut, kein Hunger, hochwertige Bildung, weniger Ungleichheiten und Partnerschaften zur Erreichung der Nachhaltigkeitsziele.', 'plain', 'Bildung (kulinarische und musikalische Kulturvermitlung), Kultur und Kunst, Gastronomie (Catering).', '[601,603,206,216,217]', '[302,901]'),
('36a84dbb-4776-4f05-8dd7-69101a30755c', 'India Culture Forum e. V.', 48.773145225426, 9.1647668465818, 'keine öffentliche Anschrift', '', '', '', '', '', '', 'plain', '', 'plain', 'Kultur und Kunst (Jährliche Feste: Religiöses Fest in Fellbach, Lichterfest im Bürgerzentrum West), Gastronomie (traditionelles Essen), Sport (Tanz-Workshops, Yoga).', '[207,602,703,709,713]', '[105,302]'),
('38e9abc6-dc51-4270-9568-2185a69ab0eb', 'Capoeira Stuttgart e. V.', 48.828291502175, 9.077781482704, '', '', '', 'Gottfried-Keller-Straße 41', '71254', 'Ditzingen', 'Deutschland', 'plain', 'Gemeinnütziger Sportverein, mit dem Ziel den brasilianischen Nationalsport Capoeira in Stuttgart bekannt zu machen und den Stuttgartern die Gelegenheit zu bieten, diesen zu erlernen.', 'plain', 'Kultur und Kunst (vielfältige kulturelle und karitative Veranstaltungen), Entwicklung und Zusammenarbeit (Integrationshilfe), Engagement für Geflüchtete (Zusammenarbeit mit Geflüchteten: Sport und Musik - Capoeira für Kinder und Erwachsene, Training in Flüchtlingsheimen Bürgerhospital und Mercedesstraße), Sport (regelmäßige Trainings).', '[206,202,401,501,502,711,713,712,802]', '[104,101,106]'),
('3b10b0c7-dc5a-4d96-9ce4-c23200652a86', 'Deutsch-Türkisches Forum Stuttgart e. V.', 48.773773222107, 9.1755832403735, '', '', '', 'Hirschstraße 36', '70173', 'Stuttgart', 'Deutschland', 'plain', 'Förderung der kulturellen Begegnung, Verständigung und Zusammenarbeit. Mit Bildungsinitiativen und Kulturprogrammen leistet das DTF eigenständige Beiträge zur gesellschaftlichen Teilhabe türkeistämmiger Zuwanderer. Es tritt insbesondere für mehr Chancengleichheit in Bildung, Beruf und Gesellschaft ein. Dabei setzt es vor allem auf vielseitiges bürgerschaftliches Engagement. Das DTF ist partei- und konfessionsunabhängig.', 'plain', 'Bildung (Politik, Gesellschaftliches), Kultur und Kunst (zeitgenössische türkische Kunst und Künstler*innen).', '[113,115,206]', '[901]'),
('3b72a4a4-024c-4049-ab75-9de2898f3ccd', 'Bolivianisches Kinderhilfswerk e. V.', 48.789164134661, 9.2051675845524, '', '', '', 'Hackstraße 76', '70190', 'Stuttgart', 'Deutschland', 'plain', 'Förderung von Kindern und Jugendlichen in Bolivien. Finanzielle Unterstützung von Bildungsprojekten in Bolivien. Vermittlung von engagierten Jugendlichen über Freiwilligendienste nach Bolivien bzw. Empfang von bolivianischen Freiwilligen in Deutschland.', 'plain', 'Entwicklung und Zusammenarbeit (Freiwilligendienst mit Einsatzland Bolivien, Spenden für Projektunterstützung in Bolivien, Patenschaften).', '[401,403,404,402,400,401,402,403,404]', '[901]'),
('3f123c62-7a3c-4d9f-a09b-674926356b88', 'Stuttgarter Femina e. V. (akademischer Frauenverein)', 48.812355971374, 9.2261954557788, '', '', '', 'Oppelnerstraße 1', '70372', 'Stuttgart', 'Deutschland', 'plain', 'Die Mitglieder des Vereins setzen ihren Migrationshintergrund als Bereicherung ein und möchten diesen zur Förderung von interkulturellem Dialog und der Gleichberechtigung der Geschlechter in den Mittelpunkt stellen.', 'plain', 'Bildung (Workshops und Infoabende zur beruflichen Perspektive von Frauen, Unterstützung von Kultur- Austauschprogrammen), Kultur und Kunst (interkulturelle After Work Begegnung, interreligiöse Begegnungen, Kunst, Ebru Kurs, Fillografie), Gastronomie (Kochkurs, Catering).', '[105,109,206,601,603,605]', '[901]'),
('59f81c29-5f86-47ec-8a8a-322d53ae14ff', 'Afrikafestival Stuttgart e. V.', 48.762560093391, 9.1599946337737, '', '', '', 'Erwin-Schöttle-Platz', '70199', 'Stuttgart', 'Deutschland', 'plain', 'Die Kultur Afrikas den Menschen in Stuttgart und Umgebung näher zu bringen.', 'plain', 'Kultur und Kunst (Kunstmarkt, offene Bühne mit Konzerten und Tanzdarbietungen, Vorträge, Filmvorführungen, Workshops und Theateraufführungen, Deutsch-Afrikanischer Gottesdienst in der Matthäuskirche jährlich am 2. Juliwochenende), Gastronomie (traditionelles Essen), Sport (Tanz).', '[206,207,208,209,804,703,704,217,216,115,105,201,213,215]', '[104]'),
('6de56a3e-f5b0-4f06-a77e-bbbd4858f9e9', 'Vietnam Community Stuttgart VCS', 48.710268969709, 9.2028536557142, '', '', '', 'Wollgrasweg 11', '70599', 'Stuttgart', '', 'plain', 'Forum für Vietnamesen und Nichtvietnamesen, Kontakte und kultureller Austausch, Vermittler für deutsche und vietnamesische Organisationen.', 'plain', 'Kultur und Kunst (Vorträge, Veranstaltungen in Deutsch und Vietnamesisch zu Themen Gesundheit, Sprachen, vietnamesische Literatur), Soziales und Gesundheit, Entwicklung und Zusammenarbeit (Integrationshilfe), Musik (traditionelle Musik).', '[205,214,1001]', '[901]'),
('70a5f5f0-8a8f-485c-9f76-f68484aadd75', 'Akademie für internationalen Kulturaustausch e. V.', 48.768554943196, 9.1798170828064, '', '', '', 'Olgastraße 93B', '70180', 'Stuttgart', 'Deutschland', 'plain', 'Förderung des internationalen Kulturaustauschs durch Veranstaltungen mit Musik, Poesie und bildender Kunst aus verschiedenen Ländern unter Teilnahme interkultureller Künstler.', 'plain', 'Kultur und Kunst (Poesie, bildende Kunst in einer persönlichen, freundlichen Atmosphäre, wobei viel Gewicht auf Kommunikation zwischen Künstlern und Publikum gelegt wird), Musik (klassische und zeitgenössische Musik).', '[204,201,206,810,804,805,806]', '[101]'),
('712a34c7-2f5c-41c2-aeb7-9821a304dd5c', 'Srpski Centar Stuttgart e. V.', 48.815253975916, 9.1985565981071, '', '', '', 'Sigmund-Lindauer-Weg 24', '70376', 'Stuttgart', 'Deutschland', 'plain', 'Das serbische Zentrum Stuttgart e. V. ist ein deutsch-serbischer Kulturverein. Im Mittelpunkt steht das Tanzen von Volkstänzen, welche bei verschiedenen Meisterschaften oder Stadtfesten aufgeführt werden. Der Verein hat es sich zur Aufgabe gemacht, vor allem junge Menschen durch die Vereinstätigkeiten zu fördern und ihnen bestimmte Werte zu vermitteln.', 'plain', 'Bildung (Bastel-Workshops, Trachten nähen, Hausaufgabenbetreuung, Übernachtungsfest in Schlafsäcken mit Aufgaben und Spielen), Gastronomie (Kochkurse mit Kindern und Jugendlichen), Sport (traditioneller Tanz, Volkstanz, Fußballturniere).', '[104,105,605,701,704,703]', '[105,104]'),
('767f00c7-3388-4c4a-9d22-fad5c0156e23', 'Deutsch-Albanischer Verein für Kultur, Jugend und Sport „Pavarësia“ e. V.', 48.777298731323, 9.1825549201621, 'keine öffentliche Anschrift', '', '', '', '', '', '', 'plain', 'Förderung der Beziehungen zwischen deutschen und albanischen Bürgern, das Pflegen der albanischen Sprache, Kultur und Tradition, sowie die Förderung der Integration der albanischen Bevölkerung in die deutsche Gesellschaft.', 'plain', 'Bildung (muttersprachlicher Unterricht albanisch), Sport (traditioneller Tanz, albanischer Volkstanz, sportliche Aktivitäten), Kultur und Kunst (Vorträge über deutsche und albanische Literatur und Kunst, Land u. a., Dichterlesungen, Musik- und Tanzabende, Studienfahrten).', '[102,101,202,205,206,207,208,209,201,214,704,703,804,805]', '[104,103,106]'),
('777032fb-0efd-4c57-a2ea-e8772c1dbd5b', 'Jesidische Sonne Stuttgart Ezidische Sonne Stuttgart', 48.804578617884, 9.2220661530693, 'keine öffentliche Anschrift', '', '', '', '', '', '', 'plain', '', 'plain', 'Kultur und Kunst, Entwicklung und Zusammenarbeit (Integrationshilfe, Unterstützung der jesidischen Gemeinde in Baden-Württemberg), Engagement für Geflüchtete (Zusammenarbeit mit Geflüchteten), Gastronomie (traditionelles Essen), Sport (Tanz).', '[401,501,502,602,703]', '[106]'),
('783ad9fb-1af7-48a2-b9f0-4c52a0167474', 'Baye-Fall e. V. senegalesisch-deutsche Vereinigung', 48.802644911453, 9.1095674557172, '', '', '', 'Kiebitzweg 7', '70499', 'Stuttgart', 'Deutschland', 'plain', 'Förderung von Kunst und Kultur, Förderung der internationalen Gesinnung und des Völkerverständigungsgedankens sowie die Förderung\nder Entwicklungszusammenarbeit.', 'plain', 'Bildung (Übersetzungs- und Dolmetscherdienst, Simultanübersetzungen bei Refugio Stuttgart e. V.), Kultur und Kunst (Kulturveranstaltungen, Teilnahme an Kulturveranstaltungen und Straßenfesten, Reparatur von westafrikanischen Trommeln), Gastronomie (Catering, traditionell senegalesiches Essen), Musik (westafrikanisch, Afrobeat, Reggae, Trommelworkshops).', '[108,207,209,601,603,602,802]', '[102,103,122]'),
('7b99b747-5a41-430e-8109-9ed96525cef7', 'ADD Stuttgart – Verein zur Förderung der Ideen Atatürks e. V. Atatürk Düsünce Dernegi Stuttgart', 48.762020962057, 9.1597730404775, '', '', '', 'Möhringerstraße 56', '70199', 'Stuttgart', 'Deutschland', 'plain', '', 'plain', 'Bildung (Nachhilfe für Kinder und Jugendliche in Deutsch, Englisch und Mathematik, Seminare und Kurse für Eltern und Erwachsene im Umgang mit Teenagern und möglichen Problemen, für die Gleichberechtigung und Rechte der Frauen), Kultur und Kunst (Konferenzen mit Gastvorträgen in türkischer Sprache, Veranstaltungen bei türkischen Nationalfeiertagen).', '[101,103,105,109,115,203,206,210]', '[104]'),
('7e655ac7-30c2-4479-b535-c3750ff9f4a3', 'Kalimera e. V. Deutsch-Griechische Kulturinitiative', 48.775379034274, 9.1776561485806, '', '', '', 'Marktplatz 4', '70173', 'Stuttgart', 'Deutschland', 'plain', '', 'plain', 'Kultur und Kunst (Infoabende mit Podiums- und Publikumsgesprächen, Themen: Finanzkrise in Griechenland und Europa, Flucht und Asyl in Europa, was machen Kulturschaffende in Griechenland. Deutsch-Griechische Filmvorführungen und -festivals mit und ohne Regisseure mit anschließenden Publikumsgesprächen, Kinofestival, Theaterveranstaltungen, Theaterworkshops mit Kinder u. Jugendlichen, Stammtische im Laboratorium, Kooperationsprojekte mit Stuttgarter Einrichtungen, Kooperationsprojekt mit der Stadt Fellbach „Kultursommer Griechenland u. Italien), Musik (Musikkonzert \"Opera Chaotiq\" mit Jugendlichen, Musikkonzerte mit griechischen und internationalen Künstlern, Homagen an griechische Komponist*innen).', '[201,210,211,212,215,216,214,220,804,805,813,814]', '[901]'),
('85e483d3-c84e-4f8b-99b2-2d1f4fb49e89', 'Serbischer Bildungs- und Kulturverein „Prosvjeta“ Deutschland e. V.', 48.770279960278, 9.1653534980447, '', '', '', 'Reinsburgstraße 48', '70178', 'Stuttgart', 'Deutschland', 'plain', 'Durch zweisprachige Vorträge, Diskussionen, Literaturabende, integrative Projekte, kulturelle Veranstaltungen, Musikprojekte sowie durch Projekte in der Muttersprache ist der Verein bemüht, die allgemeine Kultur und Bildung der in Baden-Württemberg lebenden serbischen Bevölkerung und aller anderen interessierten Personen innerhalb des Vereins, zu fördern, zu entwickeln und auch zu präsentieren.', 'plain', 'Bildung (muttersprachlicher Unterricht für Erwachsene, Musikschule für Kinder und Erwachsene), Kultur und Kunst (Kunst- und Literaturworkshops für Kinder und Erwachsene).', '[201,205,202,206,210,216,217,214,220,804,805,806]', '[901]'),
('884c0f37-fc6e-4f08-8028-8dd3ecb1a9a6', 'Nordkaukasischer Kulturverein Stuttgart (NART) e. V.', 48.71141127201, 9.1543316741244, '', '', '', 'Bonhoefferweg 14', '70565', 'Stuttgart', '', 'plain', 'Die kaukasische Kultur und die Sprachen zu erhalten diese Mitgliedern, Kulturinteressierten und vor allem einer breiten Öffentlichkeit zugänglich zu machen.\nFörderung soziokultureller Aufgaben und Anliegen in Stuttgart auf gemeinnütziger Basis. Leitbild: Kultur gehört zum Menschen – unabhängig von seiner persönlichen Situation und sozialen Lage. Der Verein ist bunt an Sprachen, Kulturen und Identitäten – genauso wie der Kaukasus!', 'plain', 'Bildung (muttersprachlicher Unterricht), Sport (Tanz), Musik (Musikwerkstatt, Chor-Gesang).', '[102,703,807,801]', '[901]'),
('954bf319-b5bc-4c5f-b4a2-3a6748e0ba7f', 'STELP e. V.', 48.77739265458, 9.1691614762846, '', '', '', 'Johannesstraße 35', '70176', 'Stuttgart', 'Deutschland', 'plain', 'Hilfe für Menschen in Not', 'plain', 'Bildung (Bildungsprojekte), Soziales und Gesundheit (Notversorgung: Verteilung von Lebensmitteln, Verteilung von Kleidung, Häuserbau, Suppenküchen).', '[109,105,115,303,304,305,402,403]', '[105]'),
('96c2c20f-1fa6-4b47-9445-9f4eceba7d50', 'Igbo Cultural Foundation Stuttgart e. V.', 48.694679592705, 9.3195469269822, '', '', '', 'Karlstraße 15', '73770', 'Denkendorf', 'Deutschland', 'plain', 'Kultur der Igbo der deutschen Bevölkerung näher bringen.', 'plain', 'Bildung (muttersprachlicher Unterricht), Kultur und Kunst (öffentliche Literaturveranstaltungen), Soziales und Gesundheit (Arbeit mit Seniorinnen), Entwicklung und Zusammenarbeit (Integrationshilfe), Engagement für Geflüchtete (Zusammenarbeit mit Asylbewerberinnen), Gastronomie (Fingerfood, traditionelles Essen), Sport (Fußball, Basketball, Tanz, öffentliche Sportveranstaltungen), Musik (Trommeln, öffentliche Musikveranstaltungen), Podcast (auf YouTube unter Odenjinji Media Stuttgart).', '[102,201,301,401,601,602,603,502,501,902,803,802,712,703,701,702]', '[901]'),
('97ac48a4-7218-4cff-a08a-810d971272ca', 'Forum Afrikanum Stuttgart e. V.', 48.762185005681, 9.1600409154624, 'keine öffentliche Anschrift', '', '', '', '', '', '', 'plain', 'Begegnungen schaffen, Austausch, Mitgestaltung des Kulturlebens in Stuttgart. Der Verein ist konfessionell und parteipolitisch neutral.', 'plain', 'Bildung (Vorträge, Workshops), Kultur und Kunst (Konzerte, Ausstellungen, Lesungen, Filme, Projekte).', '[216,217,215,213,207,202,115,105,211,220,804,805]', '[105,104]'),
('9e425f18-8f1e-4c09-a828-df470bb9ad9b', 'Black Community Foundation Stuttgart', 48.780421943983, 9.1826557898861, 'keine öffentliche Anschrift', '', '', '', '', '', '', 'plain', 'Kampf gegen Rassismus gegen Schwarze, Empowerment der Black Community, Rassismus-Sensibilisierung.', 'plain', 'Bildung (Sensibilisierungs-Workshops und Arbeit gegen Rassismus im Fokus auf Anti-Schwarzen-Rassismus, Empowerment-Workshops zu verschiedenen Themen für die Black Community und PoCs); Beratung (Unterstützung von Blackowned Businesses und schwarzen Künstlern, wie Artists); Kultur und Kunst (Teilnahme an Diskussionsrunden, Aufklärung an Schulen, tägliches Aufklären verschiedener Themen auf unserem IG-Account).', '[109,115,220,1001,1003,210,206]', '[901]'),
('9f8cbfc7-3ee5-40bd-bc1f-748046eb4989', 'Afro Deutsches Akademiker Netzwerk ADAN', 48.781338897416, 9.1824413964678, 'keine öffentliche Anschrift', '', '', '', '', '', '', 'plain', 'Eine Plattform für die Interaktion zwischen Afrodeutschen, AfrikanernInnen und Afrika-Interessierten Personen zu bieten;\nVielfalt sichtbar zu machen und jungen AfrikanerInnen in der Diaspora Vorbilder aus unterschiedlichen Bereichen zu präsentieren;\nAfrika als Chancenkontinent zu präsentieren, um eine nachhaltige Brücke zwischen Afrika und Europa zu kreieren.', 'plain', 'Bildung (Beratung von Jugendlichen und Heranwachsenden bei den Themen Schule, Studium und Zukunftsplanung); Diversity (Vielfalt sichtbar machen und fördern); Netzwerk (welches als Plattform für den gegenseitigen Austausch von Deutsch-Afrikanern und\nAfrikainteressierten dient und nachhaltige Beziehungen in den Bereichen der Wirtschaft, Gesellschaft und Kultur zu entwickeln)', '[1003,1001,813,814,401,115]', '[101,902]'),
('afd58c27-cf61-466d-96e7-c4ea4c54ce03', 'Medienkulturverein Multicolor e. V.', 48.790110007429, 9.1992397828072, '', '', '', 'Stöckachstraße 16a', '70190', 'Stuttgart', 'Deutschland', 'plain', 'Realisierung von Medienprojekten aller Art, meist unter interkulturellen Aspekten. Menschen mit und ohne Migrationshintergrund sollen mediale Möglichkeiten an die Hand gegeben werden, ihre Welt und ihre Themen in einer verständlichen Art sichtbar, hörbar und erlebbar zu machen.', 'plain', 'Kultur und Kunst (Ausstellung), Podcast (Radio, Podcasts, Audiodateien). Ausgewählte Projekte: \"Mittendrin – Mein Leben ist Stuttgart und davor\" (Eine Radioproduktion aus Texten, Klängen und Geräuschen, die Lebenserfahrungen und Alltag von Migrant*innen in Stuttgart hörbar macht), \"Spurensuche\" (Junge Menschen haben sich auf den Weg gemacht, Höhepunkte oder auch Verborgenes in Stuttgart zu entdecken und medial aufzubereiten), \"Meinst du, die Russen wollen Krieg?\" (Wanderausstellung mit Rollups und gerahmten Fotografien über das heutige Russland).', '[901,900,901,902,218]', '[901]'),
('b19c9166-b97f-45a9-9859-ce72012cb0a9', 'Freunde des Italienischen Kulturinstituts in Stuttgart e. V.', 48.76513531712, 9.1694913980446, '', '', '', 'Kolbstraße 6', '70178', 'Stuttgart', 'Deutschland', 'plain', 'Bekanntmachung der italienischen Kultur und Sprache.', 'plain', 'Bildung (Sprachunterricht, Italienischkurse für alle).', '[101,102,205]', '[104]'),
('b7909656-0aaf-4e01-929f-a7dd3d9d3193', 'tigre vermelho e. V. Freundeskreis zur Förderung der Kultur Brasiliens', 48.799830620432, 9.4873745520176, '', '', '', 'Schorndorfer Straße 47', '73650', 'Winterbach', 'Deutschland', 'plain', 'Vermittlung brasilianischer Lebensfreude, Spenden an Projekte in Brasilien und Deutschland zum Wohl von Kindern.', 'plain', 'Kultur und Kunst (Karnevalsparty \"Carnaval dos Tigres\" im Römerkastell/Phönixhalle mit Tanzshows, DJs, \"Waiblinger Altstadtfest\" mit Samba-Shows, Partymusik, Cocktails), Gastronomie (Essen), Musik (brasilianische Band).', '[206,207,209,216,601,602,603,804,815,816,812,802]', '[106,303]'),
('b90d8590-8068-462b-ae25-e9ec55f5e8c8', 'Internationales Forum für Wissenschaft, Bildung und Kultur e. V.', 48.808946920396, 9.229779374039, '', '', '', '', '', 'Stuttgart Bad-Cannstatt', 'Deutschland', 'plain', 'Popularisierung und Förderung der Wissenschaft, Bildung, Kunst und Kultur für alle Generationen, insbesondere für Kinder und Jugendliche auf regionaler, nationaler und internationaler Ebene. Der Verein bleibt bei der Verfolgung dieser Ziele politisch und konfessionell neutral.', 'plain', 'Bildung (MINT Projekt), Kultur und Kunst (Klassische Konzerte für Kinder und Jugendliche).', '[105,109,203,205,208,216,217,803,804,805,806,810,813,814,815,816,110]', '[101]'),
('bb6cbae9-5ad6-4d08-be2a-e2b0bd9791dd', 'COEXIST e. V.', 48.812831880518, 9.1587699981507, '', '', '', 'Kärntner Straße 40A', '70469', 'Stuttgart', 'Deutschland', 'plain', 'Der Verein Coexist hat den Anspruch bei gesamtgesellschaftlichen Diskursen mitzuwirken und bietet Menschen ein Sprachrohr.', 'plain', 'Bildung (Empowerment-Angebote, Workshops zum Thema \"Frauenrechte\", Aufklärung).', '[105,109]', '[106]'),
('bb8d0d54-21a3-4ead-be62-75f1f0ce90d6', 'Sri Lanka-Deutschland Freundeskreis e. V.', 48.809099556107, 9.23427437106, '', '', '', 'Kneippweg 7', '70374', 'Stuttgart', 'Deutschland', 'plain', 'Förderung internationaler Gesinnung, der Toleranz auf allen Gebieten der Kultur und des Völkerverständigungsgedankens und die Förderung mildtätiger Zwecke.', 'plain', 'Bildung (muttersprachlicher Unterricht, Workshops zum Thema Sri Lanka: Land, Leute, Kultur, Gesellschaft, Religion, Politik usw.), Gastronomie (Catering, traditionelles Essen, Kochkurse), Sport (traditioneller Tanz, Indischer Tanz), Musik (traditionelle Musik, Indische Musik, Musikunterricht (Violine).', '[102,703,704,808,601,602,603,605,809]', '[106,901]'),
('bf6d4d85-4016-4721-9bca-3404ff7db400', 'Lettischer Kulturverein SAIME e. V.', 48.762522833722, 9.1600062022539, 'keine öffentliche Anschrift', '', '', '', '', '', '', 'plain', 'Pflege der lettischen Kultur und Geschichte, Bräuche sowie Sprache in Wort und Schrift für und mit den Landsleuten in der neuen Heimat . Es werden Konzerte, Lesungen, Treffen, Feste, Theatervorstellungen, Vorträge, Infoabende, Filmvorführungen etc. zur Vermittlung und Erhaltung kultureller und historischer Traditionen durchgeführt. Beteiligung am gesellschaftlichen und kulturellen Leben sowie die Zusammenarbeit zwischen Letten und Bürgern unterschiedlicher Herkunft und Generationen.', 'plain', 'Bildung (muttersprachlicher Unterricht lettisch, Kinder-Kultur-Schule mit Sprach-, Gesangs- und Tanzunterricht), Kultur und Kunst (Kulturveranstaltungen), Sport (traditioneller Tanz, lettische Volkstanzgruppe \"Trejdeksnitis\").', '[101,102,107,703,704,206]', '[104,301,902]'),
('c4a32813-94db-4931-9088-57ac9b1673bb', 'Forum der Kulturen Stuttgart e. V.', 48.775587476396, 9.177651784552, '', '', '', 'Marktplatz 4', '70173', 'Stuttgart', '', 'plain', 'Dachverband der Migrantenvereine und interkulturellen Einrichtungen\nStuttgarter Interkulturbüro\nMitglied im Bundesverband Netzwerke von Migrantenorganisationen e. V. (NeMO)', 'plain', '', '[115,114,207,209,208,220,303,1001,403]', '[901,902]'),
('ccaf6bfa-1c4a-43ef-b8bc-e2da7412996a', 'China Kultur-Kreis e. V.', 48.808986293583, 9.2367213557174, '', '', '', 'Prießnitzweg 7', '70374', 'Stuttgart', 'Deutschland', 'plain', 'Vermittlung chinesischer Sprachkenntnisse und chinesischer Kultur, Pflege der chinesisch-deutschen Zusammenarbeit und des Dialogs, sowie Förderung interkultureller Kompetenzen. Der Verein gründete 1997 die „Chinesische Sprachschule Stuttgart“, um die chinesische Kultur und Sprache zu unterrichten. Die Schule ist eine Wochenendschule für die in Deutschland lebenden Kinder chinesischer Abstammung und alle Freunde, die sich für die chinesische Kultur und die chinesische Sprache interessieren.', 'plain', 'Bildung (muttersprachlicher Unterricht chinesisch, Kurse in der traditionellen chinesischen Kultur).', '[102,101,105,205]', '[110]'),
('cf10f76f-1a0b-4f6d-9dc7-80a68512032a', 'Serbisches Akademikernetzwerk - Nikola Tesla e. V.', 48.784878468878, 9.1786339557166, '', '', '', 'Kriegsbergstraße 28', '70174', 'Stuttgart', 'Deutschland', 'plain', 'Aktive Teilhabe an der deutschen Gesellschaft durch Projekte aus den Bereichen Bildung und Kultur. Die Vernetzung von deutschen und serbischen Institutionen und der aktive Wissensaustausch sind hierbei von großer Bedeutung, weshalb die Veranstaltungen für eine breite Öffentlichkeit zugänglich sind.', 'plain', 'Bildung (Bildungsprojekte z. B. Mobile Denkfabrik, Power Einwanderer), Kultur und Kunst (Filmfestival www.filmanak.de, Lesungen).', '[202,211,215]', '[901]'),
('d4fe1ebc-641b-416d-a51d-563ba733eb46', 'Mexikanische Tanzgruppe Adelitas Tapatías & Charros', 48.778569634971, 9.1798619013575, 'keine öffentliche Anschrift', '', '', '', '', '', '', 'plain', 'Verbreitung der mexikanischen Kultur in Deutschland.', 'plain', 'Sport (mexikanischer Tanz)', '[704,703]', '[901]'),
('eee41f26-5e5d-4b40-a5f4-f6c3272fd9bc', 'Latin Jazz Initiative', 48.77456828469, 9.1671889693137, '', '', '', 'Gutenbergstraße 3B', '70176', 'Stuttgart', 'Deutschland', 'plain', 'Die Latin Jazz Initiative entstand aus dem Bedürfnis neue Wege zu suchen, um das Jazz Publikum (nicht nur das Latin Jazz Publikum) auf diese wunderbare Musik aufmerksam zu machen. Durch Jazz entsteht Kommunikation unabhängig von Herkunft, Glauben oder anderen «Hindernissen», die in vielen anderen Bereichen das Zusammensein schwieriger machen.', 'plain', 'Beratung (Veranstaltungsplanung), Kunst und Kultur (Organisation und Durchführung von Festivals, Konzerte, Konzertreihen, Workshops, Jazz Open Stage, UNESCO-International Jazzday, UNESCO-International Danceday, United Jazz Ensemble, Musik im Viertel (Konzerte in kleinen Geschäften in verschiedenen Stadtteilen)), Bildung (Musikunterricht, Jazz-Workshops, Latin Jazz, Jazzdance und Latin Jazzdance, ein lebendiges Hörbuch, in dem der Autor seine eigenen Bücher liest und die Lesung musikalisch mit Stücken umrahmt, die extra hierfür komponiert werden).', '[111,116,208,802,804,805,806,808,812,815,816,1004]', '[101,105]'),
('fbc648a0-99da-4404-bc9f-3b13ad648277', 'Förderverein Hero\'s Academy AIC Stuttgart e. V.', 48.777637357309, 9.1513805953056, 'keine öffentliche Anschrift', '', '', '', '', '', '', 'plain', 'Verwirklichung von Projekten, um Kindern in Kenia zu helfen und ihnen eine Chance auf Bildung zu geben.', 'plain', 'Bildung (finanzielle Unterstützung des Unterhalts der Academy, Grundschule und Kindergarten), Entwicklung und Zusammenarbeit (Unterstützung bei der Instandsetzung und Einrichtung sowie evtl. Baumaßnahmen von Schule und Kindergarten, Hilfestellung zur Selbsthilfe des Unterhalts, anteilige finanzielle Unterstützung für Lehrmaterial, Vermittlung von Schulpatenschaften).', '[401,501,502,404,403,402]', '[105]'),
('fef60c29-29db-4cd3-81d1-289d09400160', 'Africa Workshop Organisation e. V.', 48.772345034833, 9.1746099980449, '', '', '', 'Tübinger Straße 15', '70178', 'Stuttgart', 'Deutschland', 'plain', 'Bekanntmachung der afrikanischen Kultur, Unterstützung bei der Integration in die Stuttgarter Gesellschaft. Der Verein ist als humanitäre Selbsthilfegruppe und Völkerverständigungsverein seit 1988 in der Region Stuttgart aktiv.', 'plain', 'Bildung (Zielgruppe Kinder, Jugendliche, Eltern und Erwachsene), Soziales und Gesundheit (Arbeit mit Senior*innen, Menschen mit Behinderung), Entwicklung und Zusammenarbeit (Integrationshilfe), Engagement für Geflüchtete (Zusammenarbeit mit Geflüchteten).', '[401,105,115,205,206,207,220,403,402,404,501,502]', '[100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124]');

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
('0a67370b-72c5-41d9-a309-e14d93ec6739', '', '0176 / 82078688', 'info@klangoase-derya.de', '171d9f6d-dd62-4113-b262-949692e790e8', 0),
('0a86dd91-4791-4d27-84dd-0aa7988727b4', '', '', 'mail@punto-de-encuentro.net', '2417c64b-cb09-4e84-8d15-e972a8c6e313', 0),
('0cf6722d-4b4e-4d69-b52f-35b64096c7eb', '', '0179/5010311', 'post@latin-jazz-initiative.de', 'eee41f26-5e5d-4b40-a5f4-f6c3272fd9bc', 0),
('1e97a03d-3dee-40c0-ab81-b566f2742440', '', '0173 / 9718681', 'castillajor@aol.com', '030f5468-5e92-4232-aaa6-6780ed1db82c', 0),
('20208bac-48bb-448f-9bcd-33105dce0cd0', '', '0172/8578716', 'info@abada-capoeira.eu', '195c1cfc-2e0a-4842-8700-d2f716e43ae0', 0),
('2d36bd45-bca5-4dd5-8bf0-27750129567f', '', '0152 / 08790860', 'info@ndwenga-fellbach.de', '30d0925a-ca00-4d68-af44-0856092f2928', 0),
('32d4c59a-6d1c-4408-a76d-9ebf3bd281fd', '', '', '', '59f81c29-5f86-47ec-8a8a-322d53ae14ff', 0),
('32f503ad-ab75-4352-9ea1-5400a643884e', '', '0711 / 8946890', 'info@bkhw.org', '3b72a4a4-024c-4049-ab75-9de2898f3ccd', 0),
('39137b79-625c-4589-bbc3-d64d1e443a8d', '', '0711 / 248 44 41', 'info@dtf-stuttgart.de', '3b10b0c7-dc5a-4d96-9ce4-c23200652a86', 0),
('3d3460fd-f86b-46f3-8dfa-97c585c76548', '', '0711/640 74 82', 'aylishk@aol.com', '70a5f5f0-8a8f-485c-9f76-f68484aadd75', 0),
('46094121-e04f-4ede-9cbf-a3065f2e2979', '', '0157 / 779577870', 'saime@latviesi.com', 'bf6d4d85-4016-4721-9bca-3404ff7db400', 0),
('5027fd57-f728-4812-b0fb-f4928426f073', '', '', 'stuttgart@ada-netzwerk.com', '9f8cbfc7-3ee5-40bd-bc1f-748046eb4989', 0),
('55252607-6128-408b-beb7-1ff951a7889a', '', '0178 / 8346746', 'info@herosacademy.org', 'fbc648a0-99da-4404-bc9f-3b13ad648277', 0),
('5bc8cd30-dea7-443d-ae14-a36b4c234e36', '', '0163/650 86 04', 'G.koeksal@gmx.de', '7b99b747-5a41-430e-8109-9ed96525cef7', 0),
('63349d8c-c3cc-4d70-8e9b-857844aaca2c', '', '', 'info@capoeira-stuttgart.org', '38e9abc6-dc51-4270-9568-2185a69ab0eb', 0),
('6911d7fc-6b4d-4dbc-8c52-6ea58479dcb1', '', '0173 / 412 71 83', 'Yalova@hotmail.de', '19837db4-8b34-44ff-95fb-de5d88545f4d', 0),
('6d29d7e0-117c-469a-a047-09472b4affd1', '', '0172 / 6334382', 'igboculturalfoundation@gmail.com', '96c2c20f-1fa6-4b47-9445-9f4eceba7d50', 0),
('7d3b6176-a87e-45a8-a964-4a33f94a2a2e', '', '0157 / 790 78 470', 'info@forum-gerrum-stuttgart.de', '04659eb2-e809-4543-b987-ad491468593b', 0),
('84140cd4-9232-4457-9a4b-8f9ed177ffef', '', '', 'info@tigre.de', 'b7909656-0aaf-4e01-929f-a7dd3d9d3193', 0),
('8bd4d88d-fdce-4922-ba01-d9b23637bb5c', '', '0178 / 3888986', 'n.jayasuriya@gmx.de', '2991aab2-8d9d-48c3-8ee1-fda7a4335108', 0),
('8cfa7275-960f-40c8-86dc-7e515871deda', '', '', 'info@nart-stuttgart.de', '884c0f37-fc6e-4f08-8028-8dd3ecb1a9a6', 0),
('90264513-3f4e-44e0-be69-7c8aabeef735', '', '0711 / 162 81 20', 'corsilingua.iicstuttgart@esteri.it', 'b19c9166-b97f-45a9-9859-ce72012cb0a9', 0),
('9217920e-046a-4d7a-ac9c-e11ebeac2eff', '', '0151 / 75859183', 'prosvjeta.stuttgart@gmx.de', '85e483d3-c84e-4f8b-99b2-2d1f4fb49e89', 0),
('99336b66-117f-48ec-835b-2ab0a0ae90fa', '', '0170 / 582 6402', 'ozaharsha@gmail.com', '36a84dbb-4776-4f05-8dd7-69101a30755c', 0),
('9c71bfae-f58e-4837-82ca-f34862a41390', '', '0711 / 8601188', '', '777032fb-0efd-4c57-a2ea-e8772c1dbd5b', 0),
('a7acd88e-084c-4220-9889-b4c539b21b0b', '', '', 'bcf.stuttgart@gmail.com', '9e425f18-8f1e-4c09-a828-df470bb9ad9b', 0),
('a9384ea6-41ec-40e7-bf01-a6b627029f46', '', '', 'sc-stuttgart@gmx.de', '712a34c7-2f5c-41c2-aeb7-9821a304dd5c', 0),
('af5217c5-9e00-4fb6-b8ca-d85d35d67267', '', '', 'vietnamcommunitystuttgart@googlemail.com', '6de56a3e-f5b0-4f06-a77e-bbbd4858f9e9', 0),
('b1283f93-aeb2-419a-899b-77e850ae86d2', '', '0176 / 24909496', 'team@stelp.eu', '954bf319-b5bc-4c5f-b4a2-3a6748e0ba7f', 0),
('b34d02a4-c972-4fbf-9f30-776068efa2ad', '', '0711 / 94529847', 'info@stufem.de', '3f123c62-7a3c-4d9f-a09b-674926356b88', 0),
('b829a6f2-847f-4df1-855c-e4c49a3c7214', '', '', 'coexist@t-online.de', 'bb6cbae9-5ad6-4d08-be2a-e2b0bd9791dd', 0),
('c5488987-2795-46af-8379-c8094b875944', '', '0176 / 81057694', 'info@adelitas.de', 'd4fe1ebc-641b-416d-a51d-563ba733eb46', 0),
('c9b7d408-614e-44f8-9721-fe6ee0c77ec5', '', '0711 / 248 48 08-88 (Fax)', '', 'c4a32813-94db-4931-9088-57ac9b1673bb', 1),
('cd72cf27-ac00-430f-b9be-b2520cc56b38', '', '0711 / 248 48 08-0', 'info@forum-der-kulturen.de', 'c4a32813-94db-4931-9088-57ac9b1673bb', 0),
('e0ff3bfe-957f-4a45-9b29-4ea912b3b92a', '', '0711 / 8601304', 'baye_fall_ev@yahoo.com', '783ad9fb-1af7-48a2-b9f0-4c52a0167474', 0),
('e1735047-e11f-46bb-96d7-cd16b09f4822', '', '0157 / 82965484', 'info@forum-afrikanum.de', '97ac48a4-7218-4cff-a08a-810d971272ca', 0),
('e21189f5-d009-4a29-a787-acadae3292c6', '', '', 'info@kd-slovenija.de', '219d2242-1c30-4493-be65-52cb9978f23e', 0),
('e6303fe7-e13f-469d-9178-b2ed39e60ef1', '', '', 'office@sam-nt.de', 'cf10f76f-1a0b-4f6d-9dc7-80a68512032a', 0),
('e8387d0a-eb6d-4fb4-ab23-cbc9156ec3ad', '', '0711 / 55 08 963', 'yputra@web.de', 'bb8d0d54-21a3-4ead-be62-75f1f0ce90d6', 0),
('e840cc66-a1c3-4d0d-bb41-10d4a7a3816a', '', '0173/1912555', 'info@forum-wbk.de', 'b90d8590-8068-462b-ae25-e9ec55f5e8c8', 0),
('ece3d675-f0c9-41c5-9333-198aa23ffa4b', '', '07192/200 82', '2009ggsa@gmail.com', 'fef60c29-29db-4cd3-81d1-289d09400160', 0),
('efe65c64-8610-4b4c-995c-722888affb76', '', '0711 / 964 12 53', 'info@multicolor-stuttgart.de', 'afd58c27-cf61-466d-96e7-c4ea4c54ce03', 0),
('f7dd6842-1bae-4d1e-95ac-b2f9e24dbed4', '', '0176 / 456 751 31', 'info@vereinpavaresia.de', '767f00c7-3388-4c4a-9d22-fad5c0156e23', 0),
('f80f5226-bb28-4801-82dd-3f2130ded295', '', '0711 / 6143552', 'hif@afro-soleil.de', '0110dd61-0bf5-4e62-abe5-772e1bd92d03', 0),
('f84a5276-b4a3-439a-9a8c-ec3fe11ce2cc', '', '0711 / 528 67 36', 'info@chinesische-sprachschule-stuttgart.de', 'ccaf6bfa-1c4a-43ef-b8bc-e2da7412996a', 0),
('fb929251-e589-451b-81c2-91c02fa8bd2b', '', '0711 / 60 44 06', 'schaal.stuttgart@freenet.de', '0991ef8a-2e54-4bb6-a2a9-523f35982a40', 0),
('fe969449-8f77-4180-a94e-b17ed3702dee', '', '', 'info@kalimera-ev.de', '7e655ac7-30c2-4479-b535-c3750ff9f4a3', 0),
('ffccfe7b-de43-4159-ba9e-fe4d3ccfabad', '', '', 'info@dante-stuttgart.de', '2ffbfe6b-9a16-4e0d-9b60-4bd7c747fb34', 0);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `districts_options`
--

CREATE TABLE `districts_options` (
  `label` varchar(512) NOT NULL,
  `value` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Daten für Tabelle `districts_options`
--

INSERT INTO `districts_options` (`label`, `value`) VALUES
('Stadt Stuttgart', 100),
('Stuttgart-Mitte', 101),
('Stuttgart-Nord', 102),
('Stuttgart-Ost', 103),
('Stuttgart-Süd', 104),
('Stuttgart-West', 105),
('Stuttgart-Bad-Cannstatt', 106),
('Stuttgart-Birkach', 107),
('Stuttgart-Botnang', 108),
('Stuttgart-Degerloch', 109),
('Stuttgart-Feuerbach', 110),
('Stuttgart-Hedelfingen', 111),
('Stuttgart-Möhringen', 112),
('Stuttgart-Mühlhausen', 113),
('Stuttgart-Münster', 114),
('Stuttgart-Obertürkheim', 115),
('Stuttgart-Plieningen', 116),
('Stuttgart-Sillenbuch', 117),
('Stuttgart-Stammheim', 118),
('Stuttgart-Untertürkheim', 119),
('Stuttgart-Vaihingen', 120),
('Stuttgart-Wangen', 121),
('Stuttgart-Weilimdorf', 122),
('Stuttgart-Zazenhausen', 123),
('Stuttgart-Zuffenhausen', 124),
('Region Stuttgart', 300),
('Esslingen', 301),
('Fellbach', 302),
('Waiblingen', 303),
('Baden-Württemberg', 900),
('Stuttgart und Region', 901),
('Landesweit', 902),
('International', 1000),
('Türkei', 1001),
('Russland', 1002);

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
('0b676161-a7e5-43e5-8d13-e2f32786a561', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/Forum_Afrikanum_Logo-scaled.jpg', 'Forum Afrikanum Stuttgart e. V.', '97ac48a4-7218-4cff-a08a-810d971272ca', 0),
('0da83685-aa73-4175-8ccc-bc5c22b95b29', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/Foerderverein-Heros-Academy-AIC-Stuttgart-e.-V.-scaled.jpg', 'Förderverein Hero\'s Academy AIC Stuttgart e. V.', 'fbc648a0-99da-4404-bc9f-3b13ad648277', 0),
('131967bc-56c8-4219-b2a1-b0f6b595d760', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/Logo_SCS_2015-.jpg', 'Srpski Centar Stuttgart e. V.', '712a34c7-2f5c-41c2-aeb7-9821a304dd5c', 0),
('2d3621f9-5bff-4bf3-849f-5bf866aff5b3', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/Adelitas-Tapatias.jpg', 'Mexikanische Tanzgruppe Adelitas Tapatías & Charros', 'd4fe1ebc-641b-416d-a51d-563ba733eb46', 0),
('393f6679-f470-4993-ae3f-e43503df8632', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/Punto-de-Encuentro-e.-V..png', 'Punto de encuentro', '2417c64b-cb09-4e84-8d15-e972a8c6e313', 0),
('406e9c50-9f3b-4346-adad-32f055c5fb35', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/Serbischer-Bildungs-und-Kulturverein-%E2%80%9EProsvjeta-Deutschland-e.-V..jpg', 'Serbischer Bildungs- und Kulturverein „Prosvjeta“ Deutschland e. V.', '85e483d3-c84e-4f8b-99b2-2d1f4fb49e89', 0),
('441be4dc-62e2-43ce-aa75-7eb7c8855b67', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/DTF-Projekte.png', 'Deutsch-Türkisches Forum Stuttgart e. V.', '3b10b0c7-dc5a-4d96-9ce4-c23200652a86', 0),
('444c4a7c-43ce-4d82-8a53-88483d63fe8d', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/Forum-der-Kulturen-3-scaled.jpg', 'Sri Lanka-Deutschland Freundeskreis e. V.', 'bb8d0d54-21a3-4ead-be62-75f1f0ce90d6', 0),
('53481afe-b730-41e5-b0a1-5a386b12cc81', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/club-logo.png', 'Srilankisch-Deutscher-Verein Stuttgart e. V.', '2991aab2-8d9d-48c3-8ee1-fda7a4335108', 0),
('5e13a2bb-01e0-4a74-ad23-afcb9fdfadee', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/China-Kultur-Kreis-e.-V.-scaled.jpg', 'China Kultur-Kreis e. V.', 'ccaf6bfa-1c4a-43ef-b8bc-e2da7412996a', 0),
('60c2b984-91ff-4922-8879-61a432dd5084', 'https://forum-wbk.de/wp-content/uploads/10-1800x1080.jpg', 'Gruppenbild', 'b90d8590-8068-462b-ae25-e9ec55f5e8c8', 1),
('678d4660-53ae-4868-9659-7f5ea73362f0', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/Akademie-fuer-internationalen-Kulturaustausch-e.V.-Aylish-Kerrigan1.jpg', 'Aylish Kerrigan', '70a5f5f0-8a8f-485c-9f76-f68484aadd75', 1),
('6f55f175-c419-45d6-8614-f02db63f42ae', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/india-culture-forum.jpeg', 'India Culture Forum e. V.', '36a84dbb-4776-4f05-8dd7-69101a30755c', 0),
('70d036e9-30a3-4403-851d-b577fa65faae', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/logo_1f980094ef8e4dfc2c99eab269df270b_2x.png', '', '3f123c62-7a3c-4d9f-a09b-674926356b88', 0),
('71e5f770-dd74-4594-9b9f-4c5a33cc80b4', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/Stelp_Supporter_yellow-blue-min.png', 'STELP e. V.', '954bf319-b5bc-4c5f-b4a2-3a6748e0ba7f', 0),
('755a16ea-bfce-48f4-ae09-b82a9be5b3e6', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/Logo-Verein-Ndwenga-e.-V.jpg', 'Ndwenga e. V.', '30d0925a-ca00-4d68-af44-0856092f2928', 0),
('771cd654-6ec0-4615-8aa7-84d7a434da79', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/multicolor-nur-logo-neu.gif', 'Medienkulturverein Multicolor e. V.', 'afd58c27-cf61-466d-96e7-c4ea4c54ce03', 0),
('8f8f63f6-5c9b-4e3f-85f6-a6bc2b763862', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/Kulturverein-Slovenija-Stuttgart-e.-V.-logo.png', 'Kulturverein Slovenija-Stuttgart e. V.', '219d2242-1c30-4493-be65-52cb9978f23e', 0),
('92efe338-86bc-46e4-a05d-60435a1f3795', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/Deutsch-Rumaenisches-Forum-Stuttgart-e.V..png', 'Deutsch-Rumänisches Forum e. V.', '04659eb2-e809-4543-b987-ad491468593b', 0),
('97037571-c436-4863-aa0e-a411892852b5', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/FdK_Logo_4c_rot.png', 'Forum der Kulturen Stuttgart e. V.', 'c4a32813-94db-4931-9088-57ac9b1673bb', 0),
('975a58ff-8d4a-4fde-8a5a-d174907da048', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/kalimera_klein.jpg', 'Kalimera e. V. Deutsch-Griechische Kulturinitiative', '7e655ac7-30c2-4479-b535-c3750ff9f4a3', 0),
('b8f6c4af-a3d0-44f3-b2ec-8121667b3954', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/Serbisches-Akademikernetzwerk-Nikola-Tesla-e.-V..png', 'Serbisches Akademikernetzwerk - Nikola Tesla e. V.', 'cf10f76f-1a0b-4f6d-9dc7-80a68512032a', 0),
('bd3999f3-8cc2-4b18-bab4-554c8e67b3ca', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/Nordkaukasischer-Kulturverein-Stuttgart.jpg', 'Nordkaukasischer Kulturverein Stuttgart (NART) e. V.', '884c0f37-fc6e-4f08-8028-8dd3ecb1a9a6', 0),
('bd4d9846-60df-4dcf-8ead-413a6f70ae8e', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/Logo-Akademie-fuer-internationalen-Kulturaustausch-e.V.-scaled.jpg', 'Akademie für internationalen Kulturaustausch e. V.', '70a5f5f0-8a8f-485c-9f76-f68484aadd75', 0),
('c15841ad-5f9b-4f3b-b77e-72facf12b14e', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/logo.gif', 'Internationaler Musik- und Kulturverein Klangoase e. V.', '171d9f6d-dd62-4113-b262-949692e790e8', 0),
('d5deb61e-507c-40fb-9439-66aba043a314', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/IFWBK_logo_flyer.png', 'IFWBK-Logo', 'b90d8590-8068-462b-ae25-e9ec55f5e8c8', 0),
('deed6764-76e4-4272-ac5c-ad4bc0c46292', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/logo.jpg', 'Afrikafestival Stuttgart', '59f81c29-5f86-47ec-8a8a-322d53ae14ff', 0),
('e1d65af5-5f21-4607-9ee5-8c9b3c437fe5', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/Logo_Pavaresia.png', 'Deutsch-Albanischer Verein für Kultur, Jugend und Sport „Pavarësia“ e. V.', '767f00c7-3388-4c4a-9d22-fad5c0156e23', 0),
('e80e13c8-dcda-4306-af3d-7cae7dcbdbf6', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/19388741_1152716738166081_8179760973660957952_o.jpg', 'Srpski Centar Stuttgart e. V.', '712a34c7-2f5c-41c2-aeb7-9821a304dd5c', 1),
('ea0f61b1-cf08-4dfa-9ee8-458f5c10fdfe', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/Saime_logo.jpg', 'Lettischer Kulturverein SAIME e. V.', 'bf6d4d85-4016-4721-9bca-3404ff7db400', 0),
('f989276b-9e8a-40ba-913b-364e0bc5c301', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/Club_espanol_StuttgarLOGO.png', 'Club Español Stuttgart e. V.', '030f5468-5e92-4232-aaa6-6780ed1db82c', 0),
('ffddf641-1fbc-4f8d-a701-11a466540178', 'https://house-of-resources-stuttgart.de/wp-content/uploads/2020/11/firkat_logo_rgb.jpg', 'Firkat, klassisch-türkischer Musikverein Stuttgart e. V.', '19837db4-8b34-44ff-95fb-de5d88545f4d', 0);

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
('00435128-2c66-4883-a52a-4218b3f4f59b', 'https://www.forum-der-kulturen.de/', 'www.forum-der-kulturen.de', 'c4a32813-94db-4931-9088-57ac9b1673bb', 0),
('018ceb70-a7ae-42da-98c3-3d4d4786fc53', 'http://www.africa-workshop.de', 'Africa-workshop.de', 'fef60c29-29db-4cd3-81d1-289d09400160', 1),
('0e6d079e-f585-49fd-b2a3-0746f9fddb81', 'https://www.chinesische-sprachschule-stuttgart.de/', 'www.chinesische-sprachschule-stuttgart.de', 'ccaf6bfa-1c4a-43ef-b8bc-e2da7412996a', 0),
('176b4a55-ba08-4b19-841e-a07453c39815', 'https://www.forum-afrikanum.de/', 'www.forum-afrikanum.de', '97ac48a4-7218-4cff-a08a-810d971272ca', 0),
('1e2afacc-9535-4f1a-8d2e-50e38d65d685', 'https://www.forum-wbk.de', 'Internationales Forum für Wissenschaft, Bildung und Kultur e.V.', 'b90d8590-8068-462b-ae25-e9ec55f5e8c8', 0),
('1e89543d-4d1c-48c0-aa26-015de6608bed', 'https://kd-slovenija.de/', 'kd-slovenija.de', '219d2242-1c30-4493-be65-52cb9978f23e', 0),
('20d53c39-df3f-497b-a222-f6b4749be3a0', 'https://house-of-resources-stuttgart.de/', 'house-of-resources-stuttgart.de', 'c4a32813-94db-4931-9088-57ac9b1673bb', 1),
('20fd455b-21b1-44de-ab55-add33b939978', 'https://www.latin-jazz-initiative.de', 'Latin Jazz Initiative', 'eee41f26-5e5d-4b40-a5f4-f6c3272fd9bc', 0),
('21bac2e2-095d-482b-8d6a-d849240523f4', 'https://www.sprachedermusik.de', 'Die Sprache der Musik', 'b90d8590-8068-462b-ae25-e9ec55f5e8c8', 1),
('2da14e08-ca3f-4cba-a9a5-a1c5d033c492', 'http://www.dtf-stuttgart.de/', 'www.dtf-stuttgart.de', '3b10b0c7-dc5a-4d96-9ce4-c23200652a86', 0),
('2ec00bad-6aa5-422e-80e8-1afdf18c2b56', 'https://www.herosacademy.org/', 'www.herosacademy.org', 'fbc648a0-99da-4404-bc9f-3b13ad648277', 0),
('309959b0-adc3-4c5e-8a88-1ac5f4506e1b', 'https://www.abada-capoeira.eu', 'ABADÁ Capoeira e. V.', '195c1cfc-2e0a-4842-8700-d2f716e43ae0', 0),
('38481feb-3f34-4ebc-b4bd-3a026cfbeaa4', 'http://www.ndwenga-kinshasa.de/', 'www.ndwenga-kinshasa.de', '30d0925a-ca00-4d68-af44-0856092f2928', 1),
('3adb8c2c-606d-47b4-aa30-d146ced5780e', 'https://ada-netzwerk.com/', 'ada-netzwerk.com', '9f8cbfc7-3ee5-40bd-bc1f-748046eb4989', 0),
('4c43a33b-23d7-4017-b99b-f9bdd03bb6d6', 'https://www.adelitas.de/', 'www.adelitas.de', 'd4fe1ebc-641b-416d-a51d-563ba733eb46', 0),
('4fe93128-d645-4ded-919b-b2293cc506f0', 'http://www.memo-bw.de/', 'www.memo-bw.de', 'c4a32813-94db-4931-9088-57ac9b1673bb', 4),
('4ffc82ca-0936-4b43-971d-0b62d599cf19', 'https://www.stufem.de/', 'www.stufem.de', '3f123c62-7a3c-4d9f-a09b-674926356b88', 0),
('51917066-c0a9-4ca9-afcd-94937b38b015', 'https://www.ecuador-freunde-stuttgart.com', 'www.ecuador-freunde-stuttgart.com', '0991ef8a-2e54-4bb6-a2a9-523f35982a40', 0),
('5aaef8af-232f-4457-a725-e3b0fe50fef1', 'https://www.iicstoccarda.esteri.it/', 'www.iicstoccarda.esteri.it', 'b19c9166-b97f-45a9-9859-ce72012cb0a9', 0),
('62cb904f-a99b-4409-ba1d-d2696c7f9716', 'https://verein-saime.de/', 'verein-saime.de', 'bf6d4d85-4016-4721-9bca-3404ff7db400', 0),
('63f2e35e-3f14-497c-a0bb-588fa4b24fb4', 'http://sldv-stuttgart.de/', 'sldv-stuttgart.de', '2991aab2-8d9d-48c3-8ee1-fda7a4335108', 0),
('6c0008cc-7308-4c3f-aa10-87f53e5627b2', 'https://www.tigre.de/', 'www.tigre.de', 'b7909656-0aaf-4e01-929f-a7dd3d9d3193', 0),
('7a6e1376-9747-480f-a512-ce76bd648a98', 'http://www.add-stuttgart.de', 'ADD Stuttgart', '7b99b747-5a41-430e-8109-9ed96525cef7', 0),
('80113d00-8812-4478-8c05-1d7e51cc7bda', 'http://www.klangoase-derya.com/', 'www.klangoase-derya.com', '171d9f6d-dd62-4113-b262-949692e790e8', 0),
('889dad2d-bd99-4f1a-8afa-1cbf9bde30b3', 'https://punto-de-encuentro.net/', 'punto-de-encuentro.net', '2417c64b-cb09-4e84-8d15-e972a8c6e313', 0),
('8bd03d7f-61f8-4ed0-b2c4-6a6134335953', 'http://www.coexistev.de', 'coexistev.de', 'bb6cbae9-5ad6-4d08-be2a-e2b0bd9791dd', 0),
('8d1a75e5-8e4f-4937-8cf4-69fdc963cd92', 'https://sprachedermusik.de/musik-ohne-grenzen', '\"Musik ohne Grenzen\" (Festival)', 'b90d8590-8068-462b-ae25-e9ec55f5e8c8', 2),
('8e1f64a7-1fc3-41f5-be78-c0b0e61dd615', 'http://www.clubespagnolestuttgart.de/', 'www.clubespagnolestuttgart.de', '030f5468-5e92-4232-aaa6-6780ed1db82c', 0),
('9c5b9bb3-8e14-4da6-a409-beb42dc70337', 'http://www.multicolor-stuttgart.de/', 'www.multicolor-stuttgart.de', 'afd58c27-cf61-466d-96e7-c4ea4c54ce03', 0),
('a5fc877d-0476-4f3d-a8d5-1dcfb21fffe5', 'https://sommerfestival-der-kulturen.de/', 'sommerfestival-der-kulturen.de', 'c4a32813-94db-4931-9088-57ac9b1673bb', 2),
('a7f3b8fc-ff12-441b-a872-589f09ad5e8f', 'https://mig.madeingermany-stuttgart.de/', 'mig.madeingermany-stuttgart.de', 'c4a32813-94db-4931-9088-57ac9b1673bb', 3),
('a88f020f-b3b3-4907-a9bd-590077b86860', 'https://www.cydd-bw.de', 'cydd-bw.de', '00de259f-254a-491f-8555-1ed658c6a85b', 0),
('b42b92ff-47be-44c6-8bba-ddb4db3ce1db', 'https://www.forum-gerrum-stuttgart.de/', 'www.forum-gerrum-stuttgart.de', '04659eb2-e809-4543-b987-ad491468593b', 0),
('bf822c16-def9-4153-9748-1098e77f7482', 'https://bayefall-ev.com/', 'bayefall-ev.com', '783ad9fb-1af7-48a2-b9f0-4c52a0167474', 0),
('cbfbc0f6-cd80-4c1a-b2ea-d0c55e12f5ce', 'https://stelp.eu/', 'www.stelp.eu', '954bf319-b5bc-4c5f-b4a2-3a6748e0ba7f', 0),
('d00df8a8-f733-4e86-b962-2b7f65c51612', 'https://www.indiacultureforum.de/', 'www.indiacultureforum.de', '36a84dbb-4776-4f05-8dd7-69101a30755c', 0),
('d4b009dc-27b9-4507-b671-aa1c401a9336', 'http://www.afro-soleil.de/', 'www.afro-soleil.de', '0110dd61-0bf5-4e62-abe5-772e1bd92d03', 0),
('d4ed5b00-e760-4c41-bb88-23480bea54fc', 'https://www.dante-stuttgart.de/', 'www.dante-stuttgart.de', '2ffbfe6b-9a16-4e0d-9b60-4bd7c747fb34', 0),
('d507cd07-9d57-4012-bbd1-c7326b23b579', 'http://www.shoqatapavaresia.de/', 'www.shoqatapavaresia.de', '767f00c7-3388-4c4a-9d22-fad5c0156e23', 0),
('e7341884-30cd-4ce5-be77-f8b7a773bd6d', 'https://www.kalimera-ev.de/', '', '7e655ac7-30c2-4479-b535-c3750ff9f4a3', 0),
('e82a6533-be0c-4d34-94dc-5f94e5ffdf0e', 'http://www.firkat.de/', 'www.firkat.de', '19837db4-8b34-44ff-95fb-de5d88545f4d', 0),
('eb52a930-2383-4b71-be14-2fac7cd210c8', 'http://www.ggsa.de/', 'www.ggsa.de', 'fef60c29-29db-4cd3-81d1-289d09400160', 2),
('ec1b0c49-d1e1-4edf-b4f6-3b53eaeea3f3', 'https://sam-nt.eu/', 'sam-nt.eu', 'cf10f76f-1a0b-4f6d-9dc7-80a68512032a', 0),
('f176697c-2b1e-4b4c-93fa-beee267db49a', 'https://www.ndwenga-fellbach.de/', 'www.ndwenga-fellbach.de', '30d0925a-ca00-4d68-af44-0856092f2928', 0),
('f32fee8c-9b61-4c4f-94d6-5978859283e9', 'https://capoeira-stuttgart.org/', 'www.capoeira-stuttgart.org', '38e9abc6-dc51-4270-9568-2185a69ab0eb', 0),
('f47e3c5d-f8e5-4d13-9e8c-dff978a86cd6', 'https://www.bkhw.org/', 'www.bkhw.org', '3b72a4a4-024c-4049-ab75-9de2898f3ccd', 0),
('fb4236d7-6026-4b82-b4ce-cb7bbb637576', 'http://www.afrikaworkshop.de', 'Afrikaworkshop.de', 'fef60c29-29db-4cd3-81d1-289d09400160', 0),
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
('03c222e0-093b-45c8-90e8-2de6128048e5', 'Facebook', 'https://www.facebook.com/DeutschTuerkischesForumStuttgart', '', '3b10b0c7-dc5a-4d96-9ce4-c23200652a86', 0),
('15152036-427b-40e1-8385-0711f1892613', 'Facebook', 'https://www.facebook.com/pages/category/Nonprofit-Organization/Punto-de-Encuentro-eV-Stuttgart-110697967281557/', '', '2417c64b-cb09-4e84-8d15-e972a8c6e313', 0),
('26ed1add-5e7d-4031-a580-f1075e582cee', 'Instagram', 'https://www.instagram.com/dtfstuttgart/', '', '3b10b0c7-dc5a-4d96-9ce4-c23200652a86', 1),
('2b2de65f-7b09-4331-9cde-fb666532a261', 'Facebook', 'https://de-de.facebook.com/FDKStuttgart', '', 'c4a32813-94db-4931-9088-57ac9b1673bb', 0),
('2e8b2865-12f1-48f1-ba49-3d0af2cf7505', 'Youtube', 'https://www.youtube.com/channel/UCrXoEYsGsc-TrO1fwSk5XsA/videos', '', '96c2c20f-1fa6-4b47-9445-9f4eceba7d50', 1),
('31bc335f-2c1e-4894-b49a-123f0922d4ef', 'Instagram', 'https://www.instagram.com/asociacionpde/', '', '2417c64b-cb09-4e84-8d15-e972a8c6e313', 1),
('328a508e-cc85-42f6-8935-58fb1e06bd39', 'Instagram', 'https://www.instagram.com/sam_nts/', '', 'cf10f76f-1a0b-4f6d-9dc7-80a68512032a', 1),
('409e4b75-0d60-4a4c-8b4d-976cce23ea3f', 'Facebook', 'https://www.facebook.com/groups/ecuatorianosenstuttgart', '', '0991ef8a-2e54-4bb6-a2a9-523f35982a40', 0),
('446f320c-0ae1-4e00-83d9-7295a13afd78', 'Instagram', 'https://www.instagram.com/srpski_centar_stuttgart/', '', '712a34c7-2f5c-41c2-aeb7-9821a304dd5c', 1),
('47e9b58a-bad1-4872-b249-8a91ddcda706', 'Facebook', 'https://www.facebook.com/Musikunterricht-Derya-Bektas-321766687901410/', '', '171d9f6d-dd62-4113-b262-949692e790e8', 0),
('4ae543f9-301c-47ff-9eee-aaaf815d8fac', 'Facebook', 'https://www.facebook.com/sprachedermusik/', 'Facebook (Die Sprache der Musik)', 'b90d8590-8068-462b-ae25-e9ec55f5e8c8', 1),
('51546d2a-15b2-4832-8e04-e0b42401825a', 'Facebook', 'https://www.facebook.com/latinjazzfestival', '', 'eee41f26-5e5d-4b40-a5f4-f6c3272fd9bc', 1),
('52eca14c-beca-4f27-a030-74f515d49793', 'Instagram', 'https://www.instagram.com/forumderkulturen/', '', 'c4a32813-94db-4931-9088-57ac9b1673bb', 1),
('54b563d4-8a25-43d2-8cb2-364c61ef16ba', 'Facebook', 'https://de-de.facebook.com/pages/category/Stadium--Arena---Sports-Venue/Srpski-Centar-Stuttgart-%D0%A1%D1%80%D0%BF%D1%81%D0%BA%D0%B8-%D0%A6%D0%B5%D0%BD%D1%82%D0%B0%D1%80-%D0%A8%D1%82%D1%83%D1%82%D0%B3%D0%B0%D1%80%D1%82-618210711616689/', '', '712a34c7-2f5c-41c2-aeb7-9821a304dd5c', 0),
('5534c995-9922-4219-b56a-72e70c3bb8ae', 'Instagram', 'https://www.instagram.com/sprachedermusik/', 'Instagram (Die Sprache der Musik)', 'b90d8590-8068-462b-ae25-e9ec55f5e8c8', 2),
('5580f167-630e-48d5-b2cd-54e3c2821bc3', 'Facebook', 'https://www.facebook.com/alicetakin', '', '59f81c29-5f86-47ec-8a8a-322d53ae14ff', 0),
('5f006721-3b94-4123-9d47-3b164d44ff18', 'Facebook', 'https://www.facebook.com/tigrevermelhoev', '', 'b7909656-0aaf-4e01-929f-a7dd3d9d3193', 0),
('61a49cd6-b8f2-45c4-82a7-83d3f93a316a', 'Facebook', 'https://de-de.facebook.com/NOVO-Capoeira-Stuttgart-1559519010778402', '', '38e9abc6-dc51-4270-9568-2185a69ab0eb', 0),
('63124cd7-c621-4ccd-b366-6a5a3f80c6f1', 'Facebook', 'https://de-de.facebook.com/754953194581359', '', '6de56a3e-f5b0-4f06-a77e-bbbd4858f9e9', 0),
('70a60b49-d592-4cff-b058-08ddbc439d28', 'Facebook', 'https://www.facebook.com/icfsev', '', '96c2c20f-1fa6-4b47-9445-9f4eceba7d50', 0),
('7660e744-781d-485a-85f1-ecd305c3b6ae', 'Facebook', 'https://www.facebook.com/alla.wbk.9', '', 'b90d8590-8068-462b-ae25-e9ec55f5e8c8', 0),
('876408e5-b68c-4c2b-8e48-d7226b68d701', 'Instagram', 'https://www.instagram.com/prosvjetanemacka/', '', '85e483d3-c84e-4f8b-99b2-2d1f4fb49e89', 0),
('9ae45f52-91fe-4541-a7cc-5feb323652ca', 'Instagram', 'https://www.instagram.com/cyddbw/', '', '00de259f-254a-491f-8555-1ed658c6a85b', 1),
('9d6e99ce-61ff-4279-b893-543fbec6cb4f', 'Facebook', 'https://www.facebook.com/bayefallev', '', '783ad9fb-1af7-48a2-b9f0-4c52a0167474', 0),
('9ee07612-9cf5-4495-9de9-b86c186e458a', 'Facebook', 'https://www.facebook.com/cyddbw/', '', '00de259f-254a-491f-8555-1ed658c6a85b', 0),
('a1875725-0125-438b-8f54-155e30b0a192', 'Facebook', 'https://www.facebook.com/Srpska.akademska.mreza.Nikola.Tesla', '', 'cf10f76f-1a0b-4f6d-9dc7-80a68512032a', 0),
('a8bc6fca-d845-48e1-a43e-157ea1e950f4', 'Facebook', 'https://www.facebook.com/groups/439745146116192/', '', '97ac48a4-7218-4cff-a08a-810d971272ca', 0),
('ae7281b3-944a-4a1c-bd29-73a843831bbd', 'Facebook', 'https://www.facebook.com/BolivianischesKinderhilfswerk', '', '3b72a4a4-024c-4049-ab75-9de2898f3ccd', 0),
('b0744d35-8ed1-4212-8bb7-20057488b330', 'Facebook', 'https://www.facebook.com/icfev/', '', '36a84dbb-4776-4f05-8dd7-69101a30755c', 0),
('b34c9f5f-65a2-4a92-872c-11f86b62e47e', 'Instagram', 'https://www.instagram.com/bcf.stuttgart/?hl=de', '', '9e425f18-8f1e-4c09-a828-df470bb9ad9b', 0),
('bb45b6ba-9eb4-420b-884f-31f8547fcf3b', 'Facebook', 'https://www.facebook.com/Coexist-eV-410786919397394', '', 'bb6cbae9-5ad6-4d08-be2a-e2b0bd9791dd', 0),
('be673039-5a9f-4996-8a2e-e1271824614d', 'Facebook', 'https://www.facebook.com/STELP.SupporterOnSite/', '', '954bf319-b5bc-4c5f-b4a2-3a6748e0ba7f', 0),
('c3a8d7b8-9f5a-45c1-a498-2ba85fe53a03', 'Facebook', 'https://www.facebook.com/Jesidische-Sonne-Stuttgart-443134686435784', '', '777032fb-0efd-4c57-a2ea-e8772c1dbd5b', 0),
('c8320533-56b7-4248-a202-3cc5df31709c', 'Instagram', 'https://www.instagram.com/bkhw_org', '', '3b72a4a4-024c-4049-ab75-9de2898f3ccd', 1),
('c9304690-a66b-47dc-a1bf-303456394945', 'Instagram', 'https://www.instagram.com/adanetzwerk/?hl=de', '', '9f8cbfc7-3ee5-40bd-bc1f-748046eb4989', 1),
('dce39316-5c9a-49fb-8133-9298fb26a30f', 'Facebook', 'https://www.facebook.com/ShoqataPavaresiaStuttgart/', '', '767f00c7-3388-4c4a-9d22-fad5c0156e23', 0),
('de464839-c9ef-47b8-a849-cad4fecdbe5f', 'Facebook', 'https://www.facebook.com/NartStuttgart', '', '884c0f37-fc6e-4f08-8028-8dd3ecb1a9a6', 0),
('de5c79d9-7f4c-4fa7-96af-50535d839a38', 'Instagram', 'https://www.instagram.com/stelp_supporter_on_site/', '', '954bf319-b5bc-4c5f-b4a2-3a6748e0ba7f', 1),
('e0be4792-5750-482e-b9c0-9cc11864619f', 'Facebook', 'https://www.facebook.com/adelitas.de', '', 'd4fe1ebc-641b-416d-a51d-563ba733eb46', 0),
('e9200267-6605-41b0-9a5f-762414bb152d', 'Instagram', 'https://www.instagram.com/shoqatapavaresia/', '', '767f00c7-3388-4c4a-9d22-fad5c0156e23', 1),
('edb8f55c-a2f6-4475-84c9-d5f154efeb4c', 'Instagram', 'https://www.instagram.com/coexist_e.v', '', 'bb6cbae9-5ad6-4d08-be2a-e2b0bd9791dd', 1),
('eec0c70d-6ec3-4ad2-b55a-62137dbebe50', 'Instagram', 'https://www.instagram.com/nartstuttgart', '', '884c0f37-fc6e-4f08-8028-8dd3ecb1a9a6', 1),
('f01525b5-2c80-44ea-9975-ec05acf4d6e2', 'Facebook', 'https://www.facebook.com/pages/category/Social-Club/Club-Espa%C3%B1ol-Stuttgart-Oficial-111439010486163/', '', '030f5468-5e92-4232-aaa6-6780ed1db82c', 0),
('f469f82d-6616-49aa-8bba-f8f207d187c8', 'Facebook', 'https://www.facebook.com/adanetzwerk', '', '9f8cbfc7-3ee5-40bd-bc1f-748046eb4989', 0);

--
-- Indizes der exportierten Tabellen
--

--
-- Indizes für die Tabelle `activities_options`
--
ALTER TABLE `activities_options`
  ADD PRIMARY KEY (`value`);

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
-- Indizes für die Tabelle `districts_options`
--
ALTER TABLE `districts_options`
  ADD PRIMARY KEY (`value`);

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
