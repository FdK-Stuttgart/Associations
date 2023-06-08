(ns fdk.rooms
  (:require
   [clojure.string :as s]
   ))

(def rooms
  [
   ["Gemeinwesen Räume Burgholzhof"
    "James-F.-Byrnes-Straße 37
70372 Stuttgart"
    "9.190668 48.817858"
    "Ansprechpartner: Jugendtreffbüro
Herr Fuchs
Tel. 0711/540 82 80
Fax 0711/540 82 81
Gruppenraum mit 39 m2
Gruppenraum + Saal mit 165 m2
Saal mit 126 m2
Saal + Café mit 206 m2
ab 15 €
ab 50 €
ab 40 €
ab 65 €
Es gibt eine kleine Küche. Miete: es gilt Grundmiete nach Tarif I, II und III"]

   ["Gemeinwesenzentrum Seelbergtreff"
    "Taubenheimstraße 67
70372 Stuttgart"
    "9.229827 48.802487"
    "Herr Etzel
Tel. 0711/56 01 49
bgs.seelberg@awo-stuttgart.de
1 Raum mit 29 m2
für 15 Pers.
1 Raum mit 66 m2
für 60 Pers.
ca. 40 € Es gibt eine kleine Küche."]

   ["Kath. Kirchengemeinde Liebfrauen"
    "Wildunger Straße 55
70372 Stuttgart"
    "9.226213 48.80349"
    "Frau Dehn
Tel. 0711/954 68 00
info@pf-liebfrauen.de
www.pf-liebfrauen.de
Räume von 40 bis 105 m2 Miete 35–65 €
NK 5–25 €
+ Endreinigung 30 €
Küche kann dazu gemietet
werden.
Technische Geräte:
OHP,
Diaprojektor,
Leinwand,
Mikro
3 der 4 Räume plus Foyer können zu einem Saal
verbunden werden (für 100–120 Pers.).
Forum der Kulturen Stuttgart e. V.
House of Resources
Marktplatz 4 · 70173 Stuttgart
Tel. 0711/248 48 08-28
Fax 0711/248 48 08-88
hor-stuttgart@forum-der-kulturen.de · house-of-resources-stuttgart.de"]

   ["Katholische Kirchengemeinde
St. Rupert"
    "Koblenzer Straße 19
70376 Stuttgart"
    "9.20475 48.813267"
    "Frau Knies
Tel. 0711/54 40 73
Fax 0711/54 67 45
großer Saal
kleiner Saal
beide Säle
Foyer
Gruppenräume
Hausmeister
ab 90 €
ab 65 €
ab 145 €
ab 60 €
ab 50 €
ab 15 €
60 €
Es gibt eine kleine Küche.
Technische Geräte:
Verstärker
Geräte der Erwachsenen-
bildung
Getränke nur über das Haus.
Ab 0 Uhr keine laute Musik.
Keine Kochmöglichkeiten.
Veranstaltungen müssen eigenverantwortlich
durchgeführt werden (Bestuhlung, Reinigung).
bis 3 Std. halbe Raummiete.
Bei allen Vermietungen werden Kaution angehoben."]

   #_["Kursaal Stuttgart Bad-Cannstatt Reservierung Räume
Tel. 0711/216 71 08
Fax 56 11 15
Bewirtung/Pächter Herr Heinze
Tel. 0711/559 52 52
Hausmeister für technischen Ablauf oder zur
Besichtigung
Tel. 0711/216 29 30
Kleiner Saal mit 340 m2
Daimler-Zimmer mit 35 m2
Thouret-Saal mit 90 m2
Preise auf Anfrage Technische Geräte gegen
Aufpreis:
Konzertflügel
Leinwand
Projektor
Bühnenpodest
Laufstege
Verstärker
Auch ganztägige Nutzung möglich.
Preise je nach Bedarf (z. B. Heizung, Equipment,
Beleuchtungsanlage, mit oder ohne Bewirtung etc.)
bitte direkt erfragen."]

   ["Römerkastell - Nachbarschaftstreff"
    "Am Römerkastell 73
70376 Stuttgart"
    "9.210521 48.814931"
    "Frau Tomruck
Tel. 0711/549 83 60
Fax 0711/549 83 61
Veranstaltungs- und
Partyraum für
ca. 55 Pers.
Seminarraum
für 25 Pers.
für 6 Pers.
79 € inkl. Gläser und Geschirr
in der Regel kostenlos
Keine Küche.
Technische Geräte sind
vorhanden.
Auch unter der Woche zu mieten, für Wochenende
rechtzeitig reservieren."]

   ["Staatl. Museum für Naturkunde (Rosensteinpark)"
    "Rosenstein 1
70191 Stuttgart"
    "9.191026 48.804657"
    "Herr Schall
Tel. 0711/893 61 13
Herr Wilhelm
Tel. 0711/893 61 04
museum.smns@naturkundemuseum-bw.de
www.naturkundemuseum-bw.de
Vortragssaal 213 m2
(Museum Löwentor)
Säulenhalle 280 m2
(Schloss Rosenstein)
1800 € + NK
1800 € + NK
Technische Geräte:
Leinwand,
Mikro,
Overhead
Beide Räume sind nur für geschlossene Veranstaltungen
bis max. 150 Personen zu mieten.
Säulenhalle nur abends, nach Schließung des Museums."]

   ["Jugendherberge Stuttgart Neckarpark"
    "Elwertstraße 2
70372 Stuttgart"
    "9.218382 48.80037"
    "Tel. 0711/664 74 70
info@jugendherberge-stuttgart-neckarpark.de
2 Seminarräume Technische Geräte:
Beamer,
Overheadprojektor,
Laptop
WLAN ist vorhanden."]

   ["Türk Halay e. V. •"
    "Schmidenerstraße 106
70374 Stuttgart"
    "9.228161 48.812092"
    "Frau Ünvar
Tel. 0170 527 74 93
denizuenvar@aol.com"]

   ["Bürgerhaus Botnang"
    "Griegstraße 18
70195 Stuttgart"
    "9.126407 48.778624"
    "Tel. 0711/69 01 28
Fax 0711/656 76 19
info@buergerhaus-botnang.de
www.stuttgart.de/buergerhaeuser
Saal 165 m2 mit Bühne (bestuhlt
max. 99 Pers./ unbestuhlt max.
199 Pers.)
Musiksaal 144 m2
2 Clubräume 26/57 m2
Webraum 51 m2
Mehrzweckraum 44 m2
Kindermalwerkstatt
75–223 €
65–194 €
12–77 €
23–69 €
20–61 €
37–112 €
Keine Küche. Für öffentliche Veranstaltungen wird eine Kaution
erhoben.
Tische und Stühle sind vorhanden."]

   ["Treffpunkt Degerloch"
    "Mittlere Straße 17
70597 Stuttgart"
    "9.172179 48.747019"
    "über Bezirksamt Degerloch
Tel. 0711/216 49 81
Fax 0711/216 49 26
Saal 1 mit 145 m2
(bestuhlt für ca. 80 Pers.)
Saal 2 mit 145 m2 Besprechungs-
zimmer für ca. 15 Pers.
Clubraum mit 28 m2 bis 20 Pers.
44–131 €
12–36 €
8–25 €
Küchenbenutzung nur
nach Absprache.
Tafel und Stellwände
vorhanden.
Keine Vermietung für Feste.
Evtl. noch Möglichkeiten für regelmäßige Treffen,
Unterricht o. ä."]

   ["AWO Stuttgart-Feuerbach
Begegnungsstätte Pfostenwäldle"
    "Pfostenwäldle 25
70469 Feuerbach"
    "9.135678 48.812835"
    "Herr Springmann
Tel. 0711/945 726 04
bgs.feuerbach@awo-stuttgart.de
2 Raum mit 60 m2 für
ca. 50 Pers.
bestuhlt
25 €
50 €
Keine Küche. Räume sind auch geeignet für regelmäßige Treffen,
Raummiete dann nach Vereinbarung.
Vermietung auch abends und an den Wochenenden.
Die Räume befinden sich in einem Altersheim, daher
nicht geeignet für laute Feiern und nur nutzbar bis 22
Uhr."]

   ["Bonatz-Bau Vereinsetage Feuerbach
(beim Bahnhof Feuerbach)"
    "Stuttgarter Straße 15
70469 Stuttgart"
    "9.166539 48.810937"
    "Raumbelegung: Freies Musikzentrum
Tel. 0711/135 30 113
Info@freie-musikschule.de
Clubräume,
Foyer,
Bürgersaal
Es gibt eine kleine Küche. Für Vereine unter bestimmten Voraussetzungen
kostenlos.
Infos und Bilder unter
www.stuttgart.de/buergerhaeuser"]

   ["Freie Musikschule Stuttgart"
    "Stuttgarter Straße 15
70469 Stuttgart"
    "9.166539 48.810937"
    "Tel. 0711/135 30 113
Info@freie-musikschule.de
Konzert- und Theaterraum
mit 160 Plätzen"]

   ["bhz Stuttgart e. V.
Werk Haus Feuerbach"
    "Magirusstraße 26
70469 Stuttgart"
    "9.176108 48.815623"
    "Frau Bräuchle
Tel. 0711/540 81 519
Markus Sattler
Tel. 0711/540 81 511
info@bhz.de
Mehrere Konferenzräume (mit
Bistro, das für Pausen genutzt
werden kann)
Pauschalpreis halber Tag:
Je nach Raumgröße 16–33 €.
Mietpreis halber Tag (inkl.
Technik): 40–140 €.
Pauschalpreis 1 Tag: Je nach
Raumgröße 20–48 €.
Mietpreis 1 Tag (inkl. Technik):
70–220 €.
Technische Geräte:
Whiteboard,
vier Metapläne
(Pinnwände),
Hochleistungsbeamer mit
2400 Ansi Lumen
Lichtleistung,
S-VHS Videogerät,
VHS und NTSC abspielbar,
DVD Player (Wiedergabe-
Systeme: Foto CD, DVD-
Video, Video CD&SVCD,
CD, MP3-CD,CD-R, CD-RW,
DVD+R, DVD+RW),
Multikanal Verstärker von
Sony mit BOSE Sound
System,
zwei Anschlussfelder für
Technik und Laptop,
Internetanschluss,
Overhead- Projektor
Räume in verschiedenen Größen für 6 bis 130 Personen.
Einzeln nutzbar oder auch kombinierbar.
Die Räume sind klimatisiert.
Bewirtung möglich: Preise pro Person: Frühstück (3,50
€), Mittagessen (8,50 €), Nachmittagskaffee (3,50 €).
Weitere Infos zur Preisliste: http://www.bhz.de/CUBE-
Konferenzservice.306.0.html"]

   #_["Europäische Dersim Initiative e. V. •
Stuttgart-Feuerbach (2 min vom Bahnhof)
Herr Kaya
Tel. 0172/634 80 70
2 kleinere Räume mit 40
Sitzplätzen
Preis nach
Absprache
Technische Geräte:
Musikanlage,
Mikrofon,
Fernseher vorhanden.
Geschirr und Gläser sind vorhanden, Essen kann
mitgebracht werden."]

   ["Jethro Pub Cocktailbar •
Deutsch-Russisch-Ukrainische Ges."
    "Grazer Straße 50
70469 Stuttgart-Feuerbach"
    "9.159309 48.811255"
    "Tel. 0711/184 58 87
drug@gmx.org
1 Raum mit ca. 50 m2
Bestuhlt für 40 Pers.
Miete auf Anfrage Küche kann dazu gemietet
werden.
Technische Geräte:
Musikanlage mit Mikrofon
kann man mieten.
Gut geeignet für Versammlungen und kleinere
Veranstaltungen."]

   ["bhz gemeinsam mit und ohne Behinderung •"
    "Magirusstraße 26
70469 Stuttgart"
    "9.176108 48.815623"
    "gehört zur Diakonie
Frau Weber, Leitung Hauswirtschaft Feuerbach
Tel. 0711/54 08 15-19
angela.weber(at)bhz.de
Mehrere Seminarräume Preis variiert je nach Größe
des Raums zwischen 50–125 €
(halber Tag)
Weitere Infos:
https://www.bhz.de/ueber-uns/die-standorte/in-feuerbach/catering-conferencing/"]

   ["Bürgerhaus Hedelfingen"
    "Hedelfinger Straße 163
70329 Stuttgart"
    "9.25475 48.760119"
    "über Bezirksamt Hedelfingen
Tel. 0711/216 57 255
poststelle.hedelfingen@stuttgart.de
www.stuttgart.de/buergerhaeuser
AWO-Begegnungsstätte 80 m2
Mehrzweckräume 84 m2
Vereinsraum 63 m2
Übungsraum Vereine 17 m2
36–109 €
38–113 €
28–85 €
8–23 €
Es gibt eine kleine Küche. Für Seminare oder ähnliche einmalige Veranstaltungen
geeignet, evtl. auch für regelmäßige Treffen.
Keine privaten/gewerblichen oder Betriebsfeiern
möglich."]

   ["AWO Süd / Altes Feuerwehrhaus"
    "Möhringer Straße 56
70199 Stuttgart"
    "9.159596 48.761846"
    "Tel. 0711/649 89 94
Fax 0711/606 07 32
bgs.sued@awo-stuttgart.de
Saal mit Bühne und Empore
411 m2,
Saal o. Bühne mit 252 m2
Empore mit 100 m2
2 Clubräume, 27 m2
Besprechungsraum, 49 m2
123–370 €
76–227 €
30–90 €
8–24 €
15–44 €
Es gibt eine kleine Küche.
Getränke müssen
abgenommen werden.
Für große Feierlichkeiten geeignet."]

   ["Buddha-Lounge
(früher Altes Schützenhaus)"
    "Burgstallstraße 99
70199 Stuttgart"
    "9.14509282187856 48.7555304"
    "Herr Eres
Tel. 0711/248 51 72
info@events-bl.de
Kombination bis 100 Pers.:
Japanischer Garten (180 m2),
White Room (78 m2),
Lounge Nordflügel (70 m2) und
Shisha Lounge (59 m2)
Kombination ab 100 Pers.:
Chillout Heaven (168 m2),
Flaming Bar (89 m2),
Beach Club (Außenbereich mit
1500 m2) und
Lounge Nordflügel (70 m2)
je nach Personenzahl und
Aufwand
590–2800 €
Technische Geräte:
Funkmikrofon
Räumlichkeiten können einzeln oder in Kombination
genutzt werden.
Mindestteilnehmerzahl: 25 Pers.
Es stehen 100 kostenfreie Parkplätze zur Verfügung.
Bestuhlt oder unbestuhlt, mit Bühne mietbar.
Essen und Getränke nur über das Haus.
WLAN vorhanden."]

   ["Generationenhaus Heslach"
    "Gebrüder Schmid-Weg 13
70199 Stuttgart"
    "9.158542 48.76288"
    "Herr Paterna
Tel. 0711/216 80 73
Fax 0711/216 80 74
Jaroslav.Paterna@stuttgart.de
Großer Saal 200 m2
Feiergarten
Mehrzweck 75 m2
Gruppenraum 30 m2
ab 23 € Großer Saal und
Mehrzweckraum mit
Teeküche ausgestattet.
Preise werden je nach Nutzung unterschiedlich
(gemeinnützig oder privat) vereinbart.
Das Haus ist mit über 50 Vereinen schon voll belegt,
z. Zt. sind keine Kapazitäten frei."]

   ["ARCES (Cento Arces)"
    "Lohäckerstraße 11
70567 Stuttgart"
    "9.146493 48.718412"
    "Domenico de Palma
Tel. 0711/719 99 96
Mobil 0171 44 80 333
Privat 0711/61 66 69
Mehrzweckraum bis zu 80 Pers.
Küche vorhanden (ca. 30 m2)
Fußballplatz mit Umkleidekabinen
Bocciabahn (für internationale
Spiele zugelassen)
Höhe der Miete nach
Absprache
Es gibt eine kleine Küche.
Sie ist ausgestattet mit
Elektroherd,
Spüle,
Kühlschrank,
Geschirr,
Besteck.
Vereinsheim mit Gaststätte und Gartenwirtschaft,
abseits der Straße, daher gut für Kinder geeignet.
Tische und Stühle vorhanden (Klavier kann auch genutzt
werden)."]

   ["Bürgerhaus Möhringen"
    "Filderbahnplatz 32
70567 Stuttgart"
    "9.147588 48.730094"
    "über Bezirksamt Möhringen
Tel. 216 88 218
Fax 216 49 68
poststelle.moehringen@stuttgart.de
poststelle.buergerhaus.moehringen@stuttgart.de
Ursula-Ida-Lapp-Saal 652 m2
kann auch nur teilweise benutzt
werden (175–514 m2)
Diverse Sitzungsräume und
Mehrzweckräume
(21–86 m2)
ab 79–880 €
ab 9–116 €
Küche kann dazu gemietet
werden.
Auf alle Räume wird eine Kaution erhoben.
Nähere Informationen direkt über das Bezirksamt."]

   ["Bürgertreff Möhringen"
    "Oberdorfplatz 8
70567 Stuttgart"
    "9.145092 48.725267"
    "über Bezirksamt Möhringen
Tel. 0711/216 44 00
Fax 0711/216 49 68
poststelle.moehringen@stuttgart.de
www.stuttgart.de/buergerhaeuser
2 Räume im EG mit 22–36 m2"]

   ["Bürgerverein Freiberg/Mönchfeld"
    "Adalbert-Stifter-Straße 9
70437 Stuttgart"
    "9.213034 48.841841"
    "über Bezirksamt Mühlhausen
Tel. 0711/216 45 96
Fax 0711/849 46 35
Tel. 0711/810 77 90- 91
Fax 0711/216 42 20
raumplanung@freibergmoenchfeld.org
www.stuttgart.de/buergerhaeuser
großer Saal mit 127 m2
kleiner Saal 45 m2
Cafeteria 62 m2
einige Mehrzweckräume
ab 15–28 m2
57–171 €
20–61 €
28–84 €
7–38 €
Es gibt eine kleine Küche. Sperrstunde 24 Uhr.
Räume reservieren bei Bürgersprechstunde
Mi, Fr 16–18 Uhr."]

   ["Altes Rathaus Uhlbach"
    "Uhlbacher Platz 2
70329 Stuttgart"
    "9.278577 48.776348"
    "Kulturforum Uhlbacher Rathaus
Tel. 0711/32 23 31
info@kulturforum-uhlbach.de
www.stuttgart.de/buergerhaeuser
1 Saal für max. 60 Pers. mit Tische
und Stühlen (63 m2)
3 Gruppenräume von 14–24 m2
185 € für private Feiern.
Öffentliche Veranstaltungen
nach Absprache.
Es gibt eine komplette
Küche mit Geschirr- und
Spülmaschine für
Selbstverpflegung.
Keine Sperrstunde, aber ab 22 Uhr auf Nachtruhe
achten."]

   ["Begegnungsstätte AWO Ost
Gemeinwesen Zentrum Ost"
    "Ostendstr. 83
70188 Stuttgart"
    "9.2081975 48.7841325"
    "Tel. 0711/286 83 99
bgs.ost@awo-stuttgart.de
Raum 1 mit 150 m2
Raum 2 mit 100 m2
Raum 3 mit 50 m2
Raum 4 mit 25 m2
30–90 Cent pro m2 Keine Küche vorhanden."]

   ["Caritasverband für Stuttgart e.V."
    "Strombergstraße 11
70188 Stuttgart"
    "9.207156 48.782745"
    "Tel. 0711/210 69 35
Tel. 0711/210 69 36
1 Raum mit 110 m2
für ca. 120 Pers. (mit Bühne)
trennbar
ab 25 € Küche kann für 35 € dazu
gemietet werden.
Nähere Informationen direkt beim Caritasverband."]

   ["Katholisches Pfarramt \"Heiliger Geist\""
    "Boslerstr. 1
70188 Stuttgart"
    "9.214414 48.787836"
    "Frau Krojer
Tel. 0711/16 65 30
Fax 0711/166 53 12
heiliggeist@freenet.de
Jugendfoyer ca. 80 Pers.
H.-G.–Stube für 30 Personen
Konferenzraum für 20 Pers.
Pauluszimmer für 15-20 Pers.
jeder Raum die ersten 4
Stunden 30 €,
jede weitere Std. 7,50 €
Küche (wenn benötigt) 25 €
Es gibt eine kleine Küche
mit Geschirr.
Technische Geräte:
Mikrofon
Sonntags Raummiete nicht möglich.
Sperrstunde 23:00 Uhr.
Getränke müssen über das Haus abgenommen werden."]

   ["Waldheim Gaisburg"
    "Obere Neue Halde 1
70186 Stuttgart"
    "9.219201 48.776101"
    "Herr Lang
Tel. 0711/46 58 20
Waldheimgaisburg@aol.com
1 Nebenzimmer bis 100 Pers.
1 Nebenzimmer bis 50 Pers.
Miete je nach Veranstaltung
und Bewirtung.
Technische Geräte:
Lautsprecher,
Leinwand,
Schultafel,
Flügel
Bewirtung möglich, Selbstverpflegung möglich
(Selbstverpflegung geht nur an Ruhetagen).
Gut geeignet für Kinder– und Familienfeiern."]

   ["Zentrum im Depot"
    "Schönbühlstraße 75
70188 Stuttgart"
    "9.20993 48.784367"
    "Kontakt über AWO Ost
Tel. 0711/286 83 99
Raum 1 mit 102 m2
Raum 2 mit 56 m2
Raum 3 mit 89 m2
Raum 4 mit 60 m2
Raum 5 mit 40 m2
30–90 Cent pro m2 Küche kann für 18 € dazu
gemietet werden.
Bestimmte Voraussetzungen nötig (förderungswürdige
Vereine, Haftpflichtversicherung)."]

   ["Jugendherberge Stuttgart"
    "Haußmannstraße 27
70188 Stuttgart"
    "9.190828 48.78071"
    "Tel. 0711/664 74 714
Fax 0711/664 74 710
seminare@jugendherberge-stuttgart.de
Räume St. Louis/St. Helens je mit
50 m2
Raum Cardiff mit 45 m2
Räume Kairo 1–4 mit 152 m2
Kairo 1–4 je mit 38 m2
Raum Lodz mit 18 m2
Raum Brünn mit 60 m2
150 €
150 €
500 €
je 150 €
60 €
150 €
Technische Geräte:
Beamer,
CD/DVD-Player,
PC,
Overheadprojektor,
Funkmikrofone,
Laptop,
Flipchart,
Metallplanwand.
WLAN vorhanden.
Kaffeepausen am Vor- und/oder Nachmittag zum Preis
von 4,50 Euro p. Pers.
Mittagessen zum Preis von 5,90 Euro p. Pers.
Abendessen zum Preis von 6,50 Euro p. Pers."]

   ["Theater Akademie Stuttgart
Schulungsräume"
    "Fuchseckstr. 7
70188 Stuttgart"
    "9.206721 48.781972"
    "Leitung: Frau Elter-Schlösser und Herr Schlösser
Tel. 0711/26 73 74
info@aka-stuttgart.com
Bühnensaal (ca. 120 m²):
Bis 30 Pers.
Tanzsaal (ca. 55 m²)
Theatersaal 1 (ca. 100 m²):
Bis 15 Pers.
Theatersaal 2 (ca. 70 m²):
Bis 10 Pers.
Tagesanmietungen
(6–8 Std.): 110 €
Wochenende Sa/So
(12 Std.): 180 €
Verlängertes Wochenende:
Fr 18 Uhr bis So 18 Uhr: 220 €
Tagesanmietungen
(6–8 Std.): 70 €
Wochenende Sa/So
(12 Std.): 110 €
Verlängertes Wochenende:
Fr 18 Uhr bis So 18 Uhr: 150 €
Tagesanmietungen
(6–8 Std.): 90 €
Wochenende Sa/So
(12 Std.): 150 €
Verlängertes Wochenende:
Fr 18 Uhr bis So 18 Uhr: 190 €
Tagesanmietungen
(6–8 Std.): 70 €
Wochenende Sa/So
(12 Std.): 110€
Verlängertes Wochenende:
Fr 18 Uhr bis So 18 Uhr: 150 €
Verdunkelbar, auf Wunsch
bestuhlt
Verdunkelbar, auf Wunsch
bestuhlt
auf Wunsch bestuhlt"]

   ["Museumsverein Stuttgart-Ost e. V. •
Altes Schulhaus Gablenberg"
    "Gablenberger Hauptstr. 130
70186 Stuttgart"
    "9.203191 48.774731"
    "Tel. 0711/319 45 822
info@cafe-museo.de
www.cafe-museo-stuttgart.de
Zwei Vereinsräume
(Raum 5 und Raum 6), die
angemietet werden können
ca. 50 m2
60 € pro Tag für
gemeinnützige Vereine
Getränke/Speisen gibt es
vom Café Museo nebenan
Weitere Infos:
www.muse-o.de/angebote/raumvermietung/"]

   ["Zehntscheuer Stuttgart-Plieningen"
    "Mönchhof 7
70599 Stuttgart"
    "9.216025 48.701068"
    "über Bezirksamt Plieningen/Birkach
Frau Berner
Tel. 0711/216 49 37
Fax 0711/216 49 43
claudia.berner@stuttgart.de
Eingangshalle EG 82 m2
Galerieraum OG 32 m2
Saal im Dachgeschoss mit
Reihenbestuhlung bis 160, mit
Tische bis 120 Pers.
25–74 €
10–29 €
60–239 €
Selbstverpflegung Geschirr
vorhanden.
Große Bühne vorhanden,
Nur freitags und samstags zu mieten.
Ortsansässige Vereine haben Vorrang."]

   ["Haus „Rohrer Höhe“"
    "Musbergerstr. 52
70565 Stuttgart"
    "9.091283 48.716945"
    "Frau Hirrle
Tel. 0711/216 89 532
1 Raum für 80 Pers.
(mit Tischen 50)
1 Raum für 20 Pers.
150 €
80 €
Technische Geräte:
HiFi-Anlage,
Overhead,
Flipchart,
Fernsehwagen,
Mikrofone und
Flügel können gemietet
werden."]

   ["Vereinshaus Rohr - Alte Rohrer Schule"
    "Egelhaafstraße 1
70565 Stuttgart"
    "9.106565 48.717183"
    "Ansprechpartner für Raumbelegung
Herr Proß vom Musikverein Rohr
Tel. 0711/718 93 11
Fax 0711/489 98 69
a.pross@web.de
2 Räume mit 70 m2
1 Raum mit 59 m2
1 Raum mit 54 m2
für Vereine teilweise kostenlos Es gibt eine kleine Küche. für Vereine, die Räume für regelmäßige Treffen suchen
(Gesang, Sprachunterricht etc.)
Auch Veranstaltungen sind möglich."]

   ["Bürgerhaus Alte Schule Rohracker"
    "Tiefenbachstraße 4
70329 Stuttgart"
    "9.228985 48.756107"
    "Frau Bollermann
Tel. 0711/508 75 645
Buergerhaus-Rohracker@t-online.de
Festsaal ca. 60 Pers.
Partykeller für maximal 25 Pers.
Verschiedene kleinere Räume
110 €
50 €
8–14 € pro Stunde
Es gibt eine kleine Küche
beim Festsaal.
Räumlichkeiten für Geburtstage, Familienfeiern,
Seminare."]

   ["Altes Rathaus Heumaden"
    "Mannsperger Straße 48
70619 Stuttgart"
    "9.239058 48.745668"
    "Herr und Frau Hald
Tel. 0711/440 36 91
Fax 0711/440 36 92
postestelle.sillenbuch@stuttgart.de
1 Saal mit 44 m2
3 Gruppenräume von je 10 m2
Spende für die Pflege der
Räume.
Es gibt eine kleine Küche. Nicht Rollstuhlgerecht .
Keine Musik–/Tanzveranstaltungen."]

   ["Atrium Sillenbuch"
    "Gorch-Fock-Straße 30
70619 Stuttgart"
    "9.204519 48.74498"
    "über Bezirksamt Sillenbuch
Tel. 0711/216 17 71
Fax 0711/216 42 70
poststelle.sillenbuch@stuttgart.de
1 Saal mit 96 m2 zum bestuhlen
Foyer Bereich EG für ca. 12 Pers.
Für Vereine und Institutionen
kostenlos (ansonsten 43–130
€).
Es gibt eine Kochnische.
Selbstverpflegung.
Kaum freie Termine, langfristige Voranmeldung
erforderlich."]

   ["Waldheim Sillenbuch"
    "Gorch-Fock-Straße 26
70619 Stuttgart"
    "9.204864 48.745389"
    "Herr Schuster
Tel. 0711/47 12 35
(Montag und Dienstag Ruhetag)
3 Nebenzimmer jeweils für bis zu
80 Pers.
Preis ist abhängig von
Bewirtung oder
Eigenverpflegung.
Technische Geräte:
Flipchart
Schöne Räumlichkeiten mit
viel Grün drumherum.
Für regelmäßige Treffen geeignet.
Für Kinder– und Familienfeiern geeignet."]

   ["Schloss-Scheuer Stammheim"
    "Korntalerstraße 1A
70439 Stuttgart"
    "9.204519 48.74498"
    "Ansprechpartner für Raumbelegung: Bezirksamt
Stammheim
Frau Mauch
Tel. 0711/216 53 65
Fax 0711/216 54 99
Schloss-Scheuer: bis 100 Pers.
Gemeindehaus: bis 90 Pers.
Mietpreise bitte direkt
nachfragen.
Es gibt eine kleine Küche.
Selbstverpflegung.
Veranstaltungen nur bis 22 Uhr."]

   ["Stadtbücherei Stammheim"
    "Kornwestheimer Straße 7
70349 Stuttgart"
    "9.1569809 48.8487019"
    "Frau Fielbrandt
Tel. 0711/216 87 22
1 Raum mit 80 m2 für ca. 70 Pers. Preis auf Anfrage. Es gibt eine kleine Küche
auf Anfrage.
Technische Geräte
inklusive:
Dia-Projektor,
Leinwand
Dienstags keine Vermietung möglich."]

   ["Begegnungsraum"
    "Breitscheidstraße 2f
70174 Stuttgart"
    "9.171331 48.780474"
    "Tel. 0162 528 1836
hallo@begegnungsraum-stuttgart.de
www.begegnungsraum-stuttgart.de
20 m2 großer ruhiger Lernraum
40 m2 großer Veranstaltungsraum
kleine Teeküche /
Kühlschrank /
Spülmaschine
WC
Bilderschienen und
Stellflächen für
Ausstellungen
Flipchart und Beamer für
Workshops
Flexible Möblierung Tische
/ Stühle / Hocker /
Mediationskissen
Es gibt regelmäßige Treffen und Angebote in den
Räumen, daher sollte eine Verfügbarkeit vorher über
den Terminkalender auf der Website geprüft werden."]

   ["Begegnungsstätte Bischof-Moser-Haus
Zentrum für ältere Menschen
Caritasverband für Stuttgart e.V."
    "Wagnerstraße 45
70182 Stuttgart"
    "9.183121 48.773463"
    "Frau Haibt
Tel. 0711/210 69 35
Fax 0711/210 69 30
e.haibt@caritas-stuttgart.de
www.caritas-stuttgart.de
1 Saal für 100 Pers.
1/2 Saal für 40 Pers.
Gruppenräume für 15 Pers.
1 Gymnastikraum für 20 Pers.
ab 55 € (je nach Dauer)
ab 27 €
ab 22 €
ab 27 €
Küche kann dazu gemietet
werden (35–105€).
Getränke müssen
abgenommen werden.
Technische Geräte gegen
Aufpreis:
Beamer,
Mikrofon usw.
Mieteinheiten gliedern sich nach Vormittag,
Nachmittag, Abend.)
Ende um 22 Uhr.
Auch für regelmäßige Treffen geeignet, frühzeitig
anfragen."]

   ["Berger Festplatz (Zelt)"
    "Marktplatz 1
70173 Stuttgart"
    "9.177492 48.774816"
    "Haupt- und Personalamt
Frau Einenkel
Tel. 0711/216 68 43
Fax 0711/216 75 37
birgit.einenkel@stuttgart.de
Großes Rund Zelt für ca. 500 Pers. 230 € pro Tag Tische,
Bänke,
Geschirr vorhanden, muss
extra angemietet werden.
Nur am Wochenende zu mieten.
Die Termine werden bereits im Herbst des Vorjahres
vergeben."]

   ["Experimentierraum"
    "Katharinenstraße 21D
70182 Stuttgart"
    "9.181393 48.772379"
    "Frau Katrin Rehfuss
buergerengagement@stuttgart.de
https://portal.engagement-
stuttgart.de/experimentierraum
1 Raum mit 75 m2 für:
Veranstaltungen, Ausstellungen,
Performances, Initiierung von
Projekten & Kooperationen,
Beratungs- und
Informationsangebote
Es gibt eine kleine Küche.
Küche und WC
barrierefrei
Nutzung frei für Akteure des bürgerschaftlichen
Engagements in Stuttgart
Reservierung per Mail für max. 3 Tage am Stück und
max. 3 Monate im Voraus"]

   ["Forum 3 / Kulturzentrum"
    "Gymnasiumstraße 21
70173 Stuttgart"
    "9.173709 48.776555"
    "Herr Fricke
Tel. 0711/440 07 49-74
Fax 0711/440 07 49-76
raumvergabe@forum3.de
Forumsaal und Tanzsaal,
je ca. 80 m2
Raum 1, 3, 4 und Atelier 18–40 m2
Preise je nach Größe und
Nutzungsdauer 50–200 €
Technische Geräte:
Beamer 45 € für 4 Stunden
Keine Räume mit integrierter Küche vorhanden.
Anfragen Mo, Di, Do, ab 17 Uhr."]

   ["Frauenkulturzentrum Sarah e. V."
    "Johannesstraße 13
70176 Stuttgart"
    "9.1631746 48.7749012"
    "Frau Eckardt und Frau Facchino
Tel. 0711/62 66 38
Fax 0711/615 21 07
das-Sarah@gmx.de
1 Nebenraum für ca. 30 Frauen
ein Café für ca. 60 Frauen
Mietpreise bitte direkt bei
Sarah erfragen
Es gibt eine kleine Küche."]

   ["Gewerkschaftshaus Stuttgart (DGB)"
    "Willi-Bleicher-Straße 20
70174 Stuttgart"
    "9.1751356 48.7787444"
    "Frau Huck (Pforten-u. Infodienst)
Tel. 0711/20 28 0
Fax 0711/202 82 50
Kleiner Saal (100 Plätze)
Großer Saal (340 Plätze)
5 Sitzungszimmer (22-40 Plätze)
150–1.040 € je nach Dauer
und Personenzahl
20–40 €
Technische Geräte:
Flipcharts,
Tonverstärker,
Tageslicht-Projektor,
Bühnenelemente
können gemietet werden.
Haus hat nur bis 20 Uhr geöffnet."]

   ["Haus der Wirtschaft"
    "Willi-Bleicher-Straße 19
70174 Stuttgart"
    "9.173618882755711 48.778901649999995"
    "Frau Haiser
Tel. 0711/123 26 46
verena.haiser@wm.bwl.de
www.hausderwirtschaft.de
12 verschiedene Konferenzräume
6 Ausstellungsräume
Preise von
50–3.600 €
(je nach Größe und
Veranstaltungsdauer)
Umfangreiches
technisches Equipment
vorhanden (gegen
Aufpreis).
Versorgung über Bistro Logo möglich.
Personal (Hausmeister, Veranstaltungstechniker) wird
nach Stundenpreis abgerechnet."]

   ["Jugendhaus West"
    "Bebelstraße 26
70193 Stuttgart"
    "9.154274 48.775312"
    "Tel. 0711/63 08 21
Fax 0711/636 24 28
west@jugendhaus.net
www.jugendhaus.net/west
1 Partyraum, 40–60 Pers.
Das gesamte Haus (mit Foyer, Café
und Disco mit Lichtanlage bis zu
300 Pers.)
Café und Foyer bis zu 200 Pers.
100 € + 100 € Kaution
250 € + 250 € Kaution
200 € + 200 € Kaution
Kühlschrank,
Theke,
Biertischgarnituren,
Billiardtisch im Foyer
vorhanden.
Technische Geräte:
Musikanlage
Frühzeitige Anmeldung erforderlich."]

   ["Karl-Adam-Haus"
    "Hospitalstraße 26
70174 Stuttgart"
    "9.171797 48.776981"
    "Herr Jantschik
Tel. 0711/29 33 39
gjantschik@bo.drs.de
1 Saal
bei Reihenbestuhlung
300 Pers.
mit Tischen je nach Aufstellung
bis 4 Std. 200 €
jede weitere Std. 20 €
Küche 40 €
Reinigung extra
NK/Std. 20 €
Technische Ausstattung
vorhanden
Dienstag und Mittwoch ist der Saal mit festen
Veranstaltungen belegt. (Stand 2010)"]

   ["Kultur- und Kongresszentrum Liederhalle"
    "Berliner Platz 1-3
70174 Stuttgart"
    "9.169252 48.779131"
    "Tel. 0711/202 77 10
Fax 0711/202 77 60
info@liederhalle-stuttgart.de
www.liederhalle-stuttgart.de
Beethoven-Saal für ca.
700–1.500 Pers., je nach
Bestuhlung
Hegel-Saal für ca. 1800 Pers.
Mozart-Saal für ca. 750 Pers.
Schiller-Saal mit 406 Plätzen
Silcher-Saal für ca. 180–320 Pers.
Versch. Tagungsräume
Grundmiete:
3.200 €
3.200 €
1.450 €
800–1.450 €
320–550 €
Technische Geräte:
Umfangreiche Audio-,
Video-,
Kommunikations-,
Lichttechnik vorhanden
Grundbeleuchtung, Standardbestuhlung und
Grundreinigung sind in der Grundmiete enthalten.
Dolmetscheranlagen,
Bühnenausstattung,
Musikinstrumente sowie zahlreiche
Dienstleistungsangebote.
Infomaterial direkt anfordern"]

   ["Linden-Museum Stuttgart"
    "Hegelplatz 1
70174 Stuttgart"
    "9.170053 48.782742"
    "Frau Thomaschewski
Tel. 0711/202 24 01
Fax 0711/202 25 90
thomas@lindenmuseum.de
www.lindenmuseum.de
Wannersaal mit 240 m2
280 Pers., feste Reihenbestuhlung
Bühne 25 m2
Miete bis 4 Std wochentags
600 €, Wochenende 700 €,
ansonsten je nach techn.
Bedarf
Technische Geräte:
Tonübertragungsanlage,
Mikrofone,
Filmprojektor,
Overhead,
Diaprojektor,
CD–Player,
TV,
DVD
Bis 24 Uhr müssen die Veranstaltungen beendet sein."]

   ["Merlin Kultur e.V."
    "Augustenstr.72
70178 Stuttgart"
    "9.161101 48.770212"
    "Tel. 0711/664 58 82
Fax 0711/615 76 76
rv@merlin-kultur.de
www.merlin-kultur.de/raeume
Saal bis 120 Pers. bestuhlt
200 stehend
kleine Gruppenräume für ca.
10 Pers.
Seminarraum für ca. 15 Pers.
Die Räume werden
pro Einheit berechnet
(siehe Website).
Licht- und Tontechnik 50 €"]

   ["Nellys Puppentheater/Theater am Olgaeck"
    "Charlottenstraße 44
70182 Stuttgart"
    "9.186708 48.7731528"
    "Tel. 0711/23 34 48
Fax 0711/24 64 69
theater@nelly.de,
www.theateramolgaeck.de
Platz für ca. 150 Pers. Preis je nach Veranstaltung
und Personenzahl direkt
erfragen!
Geeignet für regelmäßige Spieletreffs."]

   ["Stiftung Geißstraße 7"
    "Geißstraße 7
70173 Stuttgart"
    "9.177461 48.77364"
    "Frau Barth
Tel. 0711/236 02 01
stiftung@geisstrasse.de
www.geisstrasse.de
Platz für 40 Pers. Mietpreise (Stand Juli 2017)
Mo–Fr 200 €
Sa–So + Feiertag 350 €
Putzpauschale pro Vermietung
50 €
Die Rechnung ist ohne MWST.
Es gibt eine kleine Küche.
Die Küche kann für 30 €
dazu gemietet werden
(Kühlschrank vorhanden).
Beamer vorhanden,
Miete 50 €
Auf Wunsch mit Bewirtung.
Rauchverbot!!"]

   ["Studio Theater"
    "Hohenheimerstr. 44
70184 Stuttgart"
    "9.1861386 48.7701862"
    "Frau Lohkamp
Tel. 0711/24 60 93
Fax 0711/236 14 82
info@studiotheater.de
1 Raum für ca. 70 Pers.
mit Bestuhlung
1 Raum für ca. 55 Pers.
Preis nach Absprache. Technische Geräte:
DMX-gesteuerte
Lichtanlage mit
Scheinwerfer,
CD-Player
Vermietungstermine nach Absprache."]

   ["Theater Rampe Stuttgart"
    "Filderstraße 47
70180 Stuttgart"
    "9.170704 48.763656"
    "Frau Schulz
Tel. 0711/620 09 09-10
Fax 0711/620 09 09-20
1 Raum für ca. 40 Pers. 400 € Das Theatercafé kann montags für regelmäßige Treffs
gemietet werden. Sonst nur an spielfreien Tagen."]

   ["TREFFPUNKT Rotebühlplatz"
    "Rotebühlplatz 28
70173 Stuttgart"
    "9.170472 48.775307"
    "Herr Kempter
Tel. 0711/187 38 76
Fax 0711/187 38 74
1 Saal für ca. 300 Pers.
Räume für ca. 70–100 Pers.
Miete ab 600 €
ab 160 € bis 4 Stunden
gemeinnützige Vereine
bekommen 25% Rabatt
Keine Küche. Gastronomie-Versorgung möglich durch Café Punktum
im Haus nur für geschlossene Veranstaltungen.
Räume sind oft belegt."]

   #_["Turn- und Versammlungshallen
über Sportamt
Tel. 0711/216 65 65
bzw. Schulverwaltungsamt
Tel. 0711/637 62 00"]

   ["TurmForum Stuttgart 21
Im Hauptbahnhof (9. Stock)"
    "Arnulf-Klett-Platz 2
70173 Stuttgart"
    "9.1788457 48.7813814"
    "Tel. 0711/209 22 920
Fax 0711/209 23 729
(Mo–Fr / 10–18 Uhr)
Konferenzraum mit 80 m2
für 30 Pers.
(mit Tischen und Stühlen)
60 Pers. (Reihenbestuhlung)
bis 4 Std. 150 €
ab 5 Std. 280 €
Endreinigung und
technische Ausstattung
werden mit 30 € extra
berechnet.
Verpflegung über Bistro 21 möglich."]

   ["Balassi Institut •
Ungarisches Kulturinstitut Stuttgart"
    "Haußmannstraße 22
70188 Stuttgart"
    "9.191567 48.779682"
    "Tel. 0711/16 48 70
Fax 0711/164 87 10
uki-s@uki-s.de
Übernachtungsmöglichkeiten
3DZ / 1 EZ
Preis nach Absprache. Auch für Veranstaltungen und Versammlungen
geeignet."]

   ["SÖS-Laden für Politik und Kultur •"
    "Arndtstr. 29
70197 Stuttgart"
    "9.15041 48.774144"
    "Frau Hensinger
Tel. 0711/63 81 08
dhensinger@online.de
140 m2: 1 großer
„Veranstaltungsraum“
(für Vorträge oder Ausstellungen),
2 Besprechungsräume, Küche
Anmietung auf Spendenbasis. 2 Geh-Minuten von der U-Bahn-Haltestelle
„Arndt-/Splittasterrasse“ entfernt."]

   ["WeltRaum des ifa •"
    "Charlottenplatz 17
70173 Stuttgart"
    "9.182048 48.776279"
    "Geschäftsleitung Dr. Martin Kilgus
Tel. 0711/222 51 01
Fax 0711/222 52 16
kilgus@ifa-akademie.de
www.ifa-akademie.de
100 Pers.
Kleinere Räume für Workshops
etc. vorhanden
Die Räume sind alle renoviert und
mit neuster Tagungstechnik etc.
ausgestattet"]

   ["Das Jugendhaus Mitte •"
    "Hohe Str. 9
70174 Stuttgart"
    "9.169941 48.777214"
    "Tel. 0711/997 83 670
Fax 0711/997 83 678
mitte@jugendhaus.net
http://www.mitte-dev.de
Tagungsraum für zirka 20 Pers.
Großer Saal für zirka 80 Pers.
(Reihenbestuhlung) und zirka 160
Pers. bei Konzerten
Räume für einzelne Veranstaltungen.
Keine regelmäßige Vermietung möglich."]

   ["Globales Klassenzimmer im Welthaus Stuttgart •
WeltHaus Stuttgart e.V."
    "Charlottenplatz 17
70173 Stuttgart"
    "9.182048 48.776279"
    "Raumanfrage
koordination@welthaus-stuttgart.de
Tagungsraum für max. 40 Pers. Nutzungsbedingungen und Preise unter:
http://welthaus-stuttgart.de/wp-
content/uploads/2015/01/20162103-
Nutzungsbedingungen-GK-JK.pdf"]

   ["Pflegezenturm Paulinenpark •
Die Begegnungsstätte Krempels Bistro"
    "Seidenstraße 35
70174 Stuttgart"
    "9.165945 48.780451"
    "Tel. 0711/585 32 90
Vermietung:
Tel. 0711/585 32 91-00
paulinenpark@diak-stuttgart.de
www.diak-altenhilfe.de/paulinenpark
Knapp 190 m2 großen Gastraum
mit Ausgabebereich, eine
vollständig eingerichtete
Vorbereitungsküche und eine 100
m2 große, ruhige Terrasse im
Innenhof.
Bei Vorlesungen und Vorträgen
können bis zu 100 Pers. Platz
finden. Bei Bewirtung reicht die
Kapazität für maximal 75 Pers. Die
Außenterrasse bietet rund 40
weitere Plätze.
Zusätzlich zu Krempels Bistro kann
ein angrenzender
Multifunktionsraum gemietet
werden. Hier haben bis zu 20 Pers.
bei Tagungen, bis zu 40 Pers. bei
Vorträgen Platz.
Miete ganztags 280 €
oder halbtags 155 €
oder je angefangene Stunde
75 €/Stunde
je Mahlzeit und Gedeck
5 € je Gedeck
für die zweite Mahlzeit
2,50 € je Gedeck
Es gibt eine kleine Küche.
Küche vollständig
ausgestattet mit Geschirr,
Kochutensilien etc.
Technische Geräte:
Beamer,
Flipcharts und weitere
Materialien,
eine Musikanlage,
ein Flügel etc.
Weitere Infos:
diak-altenhilfe.de/pflegezentrum-
paulinenpark/krempels-bistro/vermietung/
Bestellformular:
diak-
altenhilfe.de/fileadmin/downloads/2017/Bestellformul
ar_Krempels_Bistro.pdf"]

   ["Selbsthilfekontaktstelle KISS Stuttgart"
    "Tübinger Straße 15
70178 Stuttgart"
    "9.174596 48.772154"
    "Tel. 0711/640 61 17
Fax 0711/640 45 61
info@kiss-stuttgart.de
Stundensatz für
Selbsthilfegruppen / Vereine
3,50 € die Stunde
für gemeinnützige
Einrichtungen wie z. B. das
Forum der Kulturen 7 € die
Stunde.
Die Räume werden auch an Vereine vermietet, die
keine Selbsthilfegruppen (SHG) sind. Bei den
Abendterminen haben jedoch SHG, die sich regelmäßig
treffen Vorrang. Abende in zwei Blocks aufgeteilt: Der
erste Block geht von 17:30–19:30 Uhr und der zweite
Block von 19:30–21:30 Uhr. Einmalige Termine in
diesen Blocks vergeben wir für die Abende nur sehr
kurzfristig (1 Woche vorher). Am Wochenende sind die
Räume samstags von 9–17 Uhr nutzbar."]

   ["Kinder-und Jugendhaus Cafe Ratz"
    "Margaretenstraße 67
70327 Stuttgart"
    "9.252467 48.789464"
    "Frau Rehm
Tel. 0711/336 52 340
Fax 0711/336 52 344
info@caferatz.de
1 Discoraum für ca. 35 Pers.
1 Halle für ca. 50 Pers.
Preise auf Anfrage. Es gibt eine kleine Küche.
Discoanlage vorhanden.
Partyraum am Freitag und Samstag bis 2 Uhr."]

   ["Alte Kelter Vaihingen"
    "Kelterberg 5
70563 Stuttgart"
    "9.108215 48.731833"
    "über Bezirksamt Vaihingen
Tel. 0711/216 57 449
Fax 0711/216 48 31
Gebaeudemanagement.Vaihingen@stuttgart.de
66 m2 Foyer mit Küche
50 m2 Foyer ohne Küche
190 m2 Saal
Für Vereine und Institutionen
kostenlos.
Es gibt eine kleine Küche.
Selbstversorgung.
Infos und Bilder unter:
www.stuttgart.de/buergerhaeuser"]

   ["Häussler Bürgerforum"
    "Schwabenplatz 3
70565 Stuttgart"
    "9.108601 48.730951"
    "Raumbelegung Bezirksamt Vaihingen
Tel. 0711/216 48 35
Fax 216 48 31
Gebaeudemanagement.vaihingen@stuttgart.de
1 Raum 65 m2
1 Raum 22 m2
1 Raum 44 m2
Foyer 120 m2
Bürgersaal mit/o. Bühne
20–59 €
7–20 €
13–40 €
36–108 €
ab 111 €
Es gibt eine kleine Küche.
Selbstversorgung.
Preise entsprechen 4 Stunden. Pro weitere Stunde wird
1/4 vom Grundpreis dazugerechnet."]

   ["Kelter Wangen"
    "Ulmer Straße 334
70327 Stuttgart"
    "9.242024319117977 48.77292955"
    "Raumbelegung Bezirksamt Wangen
Tel. 0711/16 50 10
Fax 0711/216 50 94
Raum mit 74 m2"]

   ["Kulturhaus Arena"
    "Ulmerstraße 241
70372 Stuttgart"
    "9.235823961568407 48.777845"
    "Tel. 0711/707 17 73
Fax 0711/707 17 74
info@kh-a.de
www.kulturhausarena.de
Saal 1 mit ca. 800 Sitzplätze
Saal 2 mit ca. 200 Sitzplätze
Seminarraum mit 50 Sitzplätze
ab 1.000 €
ca. 280 €
ca. 120 €
Keine Küche. Von großen Musikveranstaltungen bis hin zu Tanz- und
Theaterproben bietet das Kulturhaus Arena passende
Räumlichkeiten.
Nähere Informationen am besten direkt dort."]

   ["Altes Pfarrhaus Weilimdorf"
    "Ditzinger Straße 7
70499 Stuttgart"
    "9.109859 48.816086"
    "über Bezirksamt Weilimdorf
Tel. 0711/216 53 02
Fax 0711/216 53 23
poststelle.weilimdorf@stuttgart.de
Saal mit 61 m2 (bis ca. 30 Pers.)
4 Clubräume mit 18–27 m2
27–82,50 €
7,50–36 €
Es gibt eine kleine Küche.
Selbstversorgung.
Termin muss mit den Vereinen abgesprochen werden.
Keine privaten Feiern (Familien- und Betriebsfeiern) oder
gewerbliche Veranstaltungen.
Infos und Bilder unter:
www.stuttgart.de/buergerhaeuser"]

   ["Bürgertreff Hausen"
    "Beim Fasanengarten 5
70499 Stuttgart"
    "9.085266 48.816837"
    "über Bezirksamt Weilimdorf
Tel. 0711/216 53 02
Fax 0711/216 53 23
1 Mehrzweckraum mit 121 m2
für 60 (mit Tischen) –
100 Pers. (mit Bestuhlung)
Galerie mit 26 m2
36–109 €
8–23 €
Nähere Informationen direkt über das Bezirksamt."]

   ["Begegnungsstätte der AWO"
    "Lothringer Straße 13 a
70435 Stuttgart"
    "9.168295 48.831767"
    "Frau Stepper-Wolf
Tel. 0711/365 93 76
bgs.zuffenhausen@awo-stuttgart.de
1 Raum mit 80 m2 je nach Anzahl
der Personen
ab 120 €, Kaution 250 €
Küche kann nur mit
Bewirtung angemietet
werden.
Technische Geräte
Radio,
Kassette,
Video, Mikrofon kann
mitbenutzt werden"]

   ["Bürgerhaus Rot"
    "Auricher Straße 34
70437 Stuttgart"
    "9.1879562 48.8300774"
    "über Bezirksamt Zuffenhausen
Tel. 0711/216 53 51
Fax 0711/216 53 97
Saal 342 m2
2 Spiel- und Mehrzweckräume
32–42 m2
1 Besprechungsraum 56 m2
154–462 €
14–57 €
25–76 €
Es gibt eine kleine Küche.
Selbstversorgung.
Cafeteria vorhanden.
Bestuhlung möglich (37 Tische und 182 Stühle oder nur
270 Stühle)."]

   ["Hotel-Restaurant Marbacher Hof"
    "Marbacher Straße 18
70435 Stuttgart"
    "9.176361 48.831522"
    "Tel. 0711/987 95 40
reservierung@hotel-marbacher-hof.de
www.hotel-marbacher-hof.de
mit Tanzfläche bis 150 Pers.
(ohne bis 200 Pers.)
Saalmiete bei
Selbstversorgung 450 €
auch mit Bewirtung möglich.
Am Wochenende kann Verlängerung bis 3 Uhr
beantragt werden."]
   ])

(defn print-fn [v]
  ((comp
    (partial printf "\"%s\"\n")
    (partial s/join "\";\"")
    (partial map (fn [s] (.replaceAll s "\"" "'")))
    )
   v))

(defn go []
  (print-fn ["Vereinsname"
             "Adressat"
             "Öffentliche Adresse"
             "Aktiv in Stadtteil(en)"
             "Koordinaten"
             "öffentlicher Kontakt"
             "Logos"
             "Internetseite"
             "Ziel des Vereins"
             "Engagementbereiche/Aktivitäten"])
  ((comp
    (partial run! (fn [line]
                      #_[a0 b1 c2 d3 e4 f5 g6 h7 i8 j9]
                      (let [v
                            [(get line 0 "") #_"Vereinsname"
                             ""              #_"Adressat"
                             (get line 1 "") #_"Öffentliche Adresse"
                             "" #_(get line 2 "") #_"Aktiv in Stadtteil(en)"
                             (get line 2 "") #_"Koordinaten"
                             "" #_(get line 4 "") #_"öffentlicher Kontakt"
                             "" #_(get line 5 "") #_"Logos"
                             "" #_(get line 6 "") #_"Internetseite"
                             "" #_(get line 7 "") #_"Ziel des Vereins"
                             (get line 3 "") #_"8 Engagementbereiche/Aktivitäten"
                             ]]
                        (print-fn v))))
    #_(partial take 2))
   rooms))
