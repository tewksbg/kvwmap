-- Updateskript f�r die Datenbankstruktur, die kvwmap f�r Postgres mit PostGIS ben�tigt.
--
-- Wenn schon eine kvwmapsp Datenbank in postgis existiert, k�nnen mit diesen Skripten
-- �nderungen im Datenmodell von einer zur anderen Version leicht vorgenommen werden

--#--------------------------------------------------------------------------------------
--# 14.06.2005 �nderungen von Version 1.4.3 nach 1.4.4
--# Verl�ngerung des Datentypen varchar f�r das Attribut BlattNr in Baulastentabellen
BEGIN;
ALTER TABLE alb_f_baulasten ADD COLUMN blattnr_new varchar(10);
UPDATE alb_f_baulasten SET blattnr_new = CAST(blattnr AS varchar(10));
ALTER TABLE alb_f_baulasten DROP COLUMN blattnr;
ALTER TABLE alb_f_baulasten RENAME blattnr_new TO blattnr; 

ALTER TABLE alb_x_f_baulasten ADD COLUMN blattnr_new varchar(10);
UPDATE alb_x_f_baulasten SET blattnr_new = CAST(blattnr AS varchar(10));
ALTER TABLE alb_x_f_baulasten DROP COLUMN blattnr;
ALTER TABLE alb_x_f_baulasten RENAME blattnr_new TO blattnr; 
COMMIT;

--#------------------------------------------------------------------------------------------
--# 19.07.2005 �nderungen von Version 1.4.4 nach 1.4.5
--# �ndern der Tabelle fp_punkte

--# Achtung, die Tabellen fp_punkte und fp_puntke_temp m�ssen identisch sein. Wer sich unsicher ist
--# L�scht am besten die Tabelle fp_punkte aus Version 1.4.4 und f�gt sie neu ein mit dem gleichen
--# Statement wie fp_punkte_temp nur anderem Name, siehe unten bei Hinzuf�gen fp_punkte_temp

ALTER TABLE fp_punkte ADD COLUMN pktnr varchar(5);
ALTER TABLE fp_punkte ADD COLUMN art int4 DEFAULT 0;
ALTER TABLE fp_punkte ADD COLUMN datei varchar(50);
ALTER TABLE fp_punkte ADD COLUMN blatt int4 DEFAULT 0;
ALTER TABLE fp_punkte ADD COLUMN verhandelt int4 DEFAULT 0;
ALTER TABLE fp_punkte ADD COLUMN vermarkt int4 DEFAULT 0;

--# Hinzuf�gen der Tabelle fp_punkte_temp f�r das tempor�re Einlesen von Koordinaten der ALK-Punktdatei 
CREATE TABLE fp_punkte_temp
(
  pkz char(16) NOT NULL PRIMARY KEY,
  rw varchar(11),
  hw varchar(11),
  hoe varchar(9),
  s varchar(4),
  zst varchar(7),
  vma varchar(3),
  bem varchar(4),
  ent varchar(15),
  unt varchar(15),
  zuo varchar(15),
  tex varchar(15),
  ls varchar(3),
  lg varchar(1),
  lz varchar(1),
  lbj varchar(3),
  lah varchar(9),
  hs varchar(15),
  hg varchar(15),
  hz varchar(15),
  hbj varchar(15),
  hah varchar(15),
  pktnr varchar(5),
  art int4 DEFAULT 0,
  datei varchar(50),
  blatt int4 DEFAULT 0,
  verhandelt int4 DEFAULT 0,
  vermarkt int4 DEFAULT 0
) 
WITH OIDS;

SELECT AddGeometryColumn('public', 'fp_punkte_temp','koordinaten',2398,'POINT', 3);
CREATE INDEX fp_punkte_temp_koordinaten_gist ON fp_punkte_temp USING GIST (koordinaten GIST_GEOMETRY_OPS);

--###################################################################################
--# 09.08.2005 Hinzuf�gen der Tabelle f�r die Zuordnung von Festpunkten zu Antr�gen
CREATE TABLE fp_punkte2antraege
(
  pkz char(16) NOT NULL,
  antrag_nr varchar(8) NOT NULL,
  zeitstempel timestamp,
  CONSTRAINT fp_punkte2antraege_pkey PRIMARY KEY (pkz, antrag_nr)
) 
WITHOUT OIDS;

--################################################################################
--# 27.09.2005 Hinzuf�gen der Tabelle f�r Metadaten
--# letzte �nderung 2005-11-29_pk
CREATE TABLE md_metadata
(
  id serial NOT NULL,
  mdfileid varchar(255) NOT NULL,
  mdlang varchar(25) NOT NULL DEFAULT 'de'::character varying,
  mddatest date NOT NULL DEFAULT ('now'::text)::date,
  mdcontact int4,
  spatrepinfo int4,
  refsysinfo int4,
  mdextinfo int4,
  dataidinfo int4,
  continfo int4,
  distinfo int4,
  idtype text,
  restitle varchar(256),
  idabs text,
  tpcat varchar(255),
  reseddate date,
  validfrom date,
  validtill date,
  westbl varchar(25),
  eastbl varchar(25),
  southbl varchar(25),
  northbl varchar(25),
  identcode text,
  rporgname text,
  postcode int4,
  city text,
  delpoint text,
  adminarea text,
  country text,
  linkage text,
  servicetype text,
  spatialtype text,
  serviceversion varchar(255),
  vector_scale int4,
  databinding bool,
  solution varchar(255),
  status text,
  onlinelinke text,
  cyclus text,
  sparefsystem text,
  sformat text,
  sformatversion text,
  download text,
  onlinelink text,
  accessrights text,
  datalang varchar(25),
  CONSTRAINT md_metadata_pkey PRIMARY KEY (id)
) 
WITH OIDS;
COMMENT ON TABLE md_metadata IS 'Metadatendokumente';

SELECT AddGeometryColumn('public', 'md_metadata','umring',2398,'POLYGON', 2);
CREATE INDEX md_metadata_umring_gist ON md_metadata USING GIST (umring GIST_GEOMETRY_OPS);

--###########################################################################
--# 26.10.2005 Hinzuf�gen der Tabelle f�r die Qualit�t der Flurst�cksfl�chen
CREATE TABLE q_alknflst
(
  objnr varchar(7) NOT NULL DEFAULT ''::character varying,
  verhandelt integer NOT NULL DEFAULT 0,
  vermarkt integer NOT NULL DEFAULT 0,
  CONSTRAINT q_alknflst_pkey PRIMARY KEY (objnr),
  CONSTRAINT "fkFSONR" FOREIGN KEY (objnr) REFERENCES alkobjekte (objnr) ON UPDATE NO ACTION ON DELETE CASCADE
);

--############################################################################
--# 26.10.2005 Hinzuf�gen der Tabelle f�r die Qualit�t der Flurst�cksgrenzen
CREATE TABLE q_alkngrenze
(
  anfang varchar(7),
  ende varchar(7),
  verhandelt int2 NOT NULL DEFAULT 0,
  lz int2,
  lg int2
) 
WITH OIDS;

--##################################################
--# 09.11.2005 Hinzuf�gen der Tabelle f�r Notizen
CREATE TABLE q_notizen
(
  notiz text,
  kategorie varchar(100),
  person varchar(100),
  datum date
) 
WITH OIDS;
SELECT AddGeometryColumn('public', 'q_notizen','position',2398,'POINT', 2);
CREATE INDEX q_notizen_position_gist ON q_notizen USING GIST (position GIST_GEOMETRY_OPS);

--##################################################
--# Tabelle f�r Fehlerellipsen
--#letzte �nderung 2005-11-29 Korduan
CREATE TABLE q_fehlerellipsen
(
  pkz varchar(15) NOT NULL,
  rw numeric(15,4),
  hw numeric(15,4),
  hoe numeric(8,4),
  mfge numeric(6,2),
  ls integer,
  phi numeric(5,2),
  a numeric(6,2),
  b numeric(6,2),
  CONSTRAINT q_fehlerellipsen_pkey PRIMARY KEY (pkz)
)
WITH OIDS;
SELECT AddGeometryColumn('public', 'q_fehlerellipsen','position',2398,'POINT', 2);
CREATE INDEX q_fehlerellipsen_position_gist ON q_fehlerellipsen USING GIST (position GIST_GEOMETRY_OPS);

--# Hinzuf�gen der Tabelle md_keywords
--#letzte �nderung 2005-11-26_pk
CREATE TABLE md_keywords
(
  id serial NOT NULL,
  keyword varchar(255) NOT NULL,
  keytyp varchar(25),
  thesaname int4,
  CONSTRAINT md_keywords_pkey PRIMARY KEY (id)
) 
WITHOUT OIDS;
COMMENT ON TABLE md_keywords IS 'Beschreibende Schlagw�rter';

--# Hinzuf�gen der Tabelle md_keywords2metadata f�r die Verkn�pfung zwischen Metadaten und Schlagw�rtern
--#letzte �nderung 2005-11-26_pk
CREATE TABLE md_keywords2metadata
(
  keyword_id int4 NOT NULL,
  metadata_id int4 NOT NULL,
  CONSTRAINT md_keywords2metadata_pkey PRIMARY KEY (keyword_id, metadata_id),
  CONSTRAINT "fkKWD" FOREIGN KEY (keyword_id) REFERENCES md_keywords (id) ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT "fkMD" FOREIGN KEY (metadata_id) REFERENCES md_metadata (id) ON UPDATE NO ACTION ON DELETE CASCADE
) 
WITHOUT OIDS;

--# �ndern des Datentyps der Spalten koorrw und koorhw in den Tabellen alb_ und alb_x_flurstuecke
--# 2005-12-02_pk
ALTER TABLE alb_flurstuecke ADD COLUMN koorrw_new numeric(12,3);
UPDATE alb_flurstuecke SET koorrw_new = CAST(koorrw AS numeric(12,3));
ALTER TABLE alb_flurstuecke DROP COLUMN koorrw;
ALTER TABLE alb_flurstuecke ADD COLUMN koorrw numeric(12,3);
ALTER TABLE alb_flurstuecke ALTER COLUMN koorrw SET NOT NULL;
ALTER TABLE alb_flurstuecke ALTER COLUMN koorrw SET DEFAULT 0;
UPDATE alb_flurstuecke SET koorrw = CAST (koorrw_new AS numeric(12,3));
ALTER TABLE alb_flurstuecke DROP COLUMN koorrw_new;

--# 2005-12-02_pk
ALTER TABLE alb_flurstuecke ADD COLUMN koorhw_new numeric(12,3);
UPDATE alb_flurstuecke SET koorhw_new = CAST(koorhw AS numeric(12,3));
ALTER TABLE alb_flurstuecke DROP COLUMN koorhw;
ALTER TABLE alb_flurstuecke ADD COLUMN koorhw numeric(12,3);
ALTER TABLE alb_flurstuecke ALTER COLUMN koorhw SET NOT NULL;
ALTER TABLE alb_flurstuecke ALTER COLUMN koorhw SET DEFAULT 0;
UPDATE alb_flurstuecke SET koorhw = CAST (koorhw_new AS numeric(12,3));
ALTER TABLE alb_flurstuecke DROP COLUMN koorhw_new;

--# Hinzuf�gen der Spalte lfd_nr_name_alt zur Tabelle alb_x_g_namen
--# 2005-12-07
ALTER TABLE alb_x_g_namen ADD COLUMN lfd_nr_name_alt int4;
ALTER TABLE alb_x_g_namen ALTER COLUMN lfd_nr_name_alt SET NOT NULL;
ALTER TABLE alb_x_g_namen ALTER COLUMN lfd_nr_name_alt SET DEFAULT 0;

--################################################################################
--# �nderungen von Version 1.5 zu 1.5.1

--# Hinzuf�gen des Prim�rschl�ssels f�r die Tabellen der Flurst�cke
--# 2005-12-13 Korduan
ALTER TABLE alb_flurstuecke
  ADD CONSTRAINT alb_flurstuecke_pkey PRIMARY KEY(flurstkennz);
  
ALTER TABLE alb_x_flurstuecke
  ADD CONSTRAINT alb_x_flurstuecke_pkey PRIMARY KEY(flurstkennz);

--# Hinzuf�gen der Tabelle alb_tmp_adressen f�r die Flurst�ckssuche �ber postgres-Datenbank
CREATE TABLE alb_tmp_adressen
(
  quelle char(3) NOT NULL DEFAULT ''::bpchar,
  gemeinde int4 NOT NULL DEFAULT 0,
  gemeindename varchar(255),
  strasse varchar(5) NOT NULL DEFAULT ''::character varying,
  strassenname varchar(255),
  hausnr varchar(8) NOT NULL DEFAULT ''::character varying,
  CONSTRAINT alb_tmp_adressen_pkey PRIMARY KEY (gemeinde, strasse, hausnr)
) 
WITH OIDS;

--# �nderungen von Version 1.5.5 zu 1.5.6
--# �ndern des Datentyps der Spalten koorrw und koorhw in den Tabellen alb_x_flurstuecke
--# F�r alle, die es f�r alb_x_flurstuecke noch nicht gemacht haben und nicht in phpPgAdmin oder pgAdminIII machen k�nnen
--# 2006-01-16_pk
ALTER TABLE alb_x_flurstuecke ADD COLUMN koorrw_new numeric(12,3);
UPDATE alb_x_flurstuecke SET koorrw_new = CAST(koorrw AS numeric(12,3));
ALTER TABLE alb_x_flurstuecke DROP COLUMN koorrw;
ALTER TABLE alb_x_flurstuecke ADD COLUMN koorrw numeric(12,3);
ALTER TABLE alb_x_flurstuecke ALTER COLUMN koorrw SET NOT NULL;
ALTER TABLE alb_x_flurstuecke ALTER COLUMN koorrw SET DEFAULT 0;
UPDATE alb_x_flurstuecke SET koorrw = CAST (koorrw_new AS numeric(12,3));
ALTER TABLE alb_x_flurstuecke DROP COLUMN koorrw_new;

--# 2005-12-02_pk
ALTER TABLE alb_x_flurstuecke ADD COLUMN koorhw_new numeric(12,3);
UPDATE alb_x_flurstuecke SET koorhw_new = CAST(koorhw AS numeric(12,3));
ALTER TABLE alb_x_flurstuecke DROP COLUMN koorhw;
ALTER TABLE alb_x_flurstuecke ADD COLUMN koorhw numeric(12,3);
ALTER TABLE alb_x_flurstuecke ALTER COLUMN koorhw SET NOT NULL;
ALTER TABLE alb_x_flurstuecke ALTER COLUMN koorhw SET DEFAULT 0;
UPDATE alb_x_flurstuecke SET koorhw = CAST (koorhw_new AS numeric(12,3));
ALTER TABLE alb_x_flurstuecke DROP COLUMN koorhw_new;

--# 2006-01-26_pk
CREATE TABLE bau_akten
(
  feld1 int4,
  feld2 int4,
  feld3 int4,
  feld4 varchar(255),
  feld5 varchar(255),
  feld6 varchar(255),
  feld7 varchar(255),
  feld8 varchar(255),
  feld9 varchar(255),
  feld10 varchar(255),
  feld11 varchar(255),
  feld12 varchar(20),
  feld13 varchar(20),
  feld14 varchar(20),
  feld15 varchar(10),
  feld16 varchar(10),
  feld17 varchar(20),
  feld18 varchar(20),
  feld19 varchar(30),
  feld20 varchar(30),
  feld21 varchar(30),
  feld22 varchar(6),
  feld23 int4,
  feld24 varchar(30),
  dummy varchar(1)
) 
WITH OIDS;

--# Hinzuf�gen der Tabellen bau_verfahrensart und bau_vorhaben, in denen die zur Auswahl stehenden Werte f�r das Vorhaben und die Verfahrensart bei der Bauauskunftssuche gespeichert sind
CREATE TABLE bau_verfahrensart
(
  verfahrensart text,
  id serial NOT NULL
) 
WITHOUT OIDS;

CREATE TABLE bau_vorhaben
(
  vorhaben text,
  id serial NOT NULL
) 
WITHOUT OIDS;

--# 2006-02-07
--# Tabelle zur Speicherung der Gemarkungsnummer-zu-Gemarkungsschl�ssel-Beziehung f�r die Bauauskunft

CREATE TABLE bau_gemarkungen
(
  nummer int8 NOT NULL,
  schluessel int8 NOT NULL
) 
WITH OIDS;

--# 2006-02-03

CREATE TABLE q_notiz_kategorien
(
  id serial NOT NULL,
  kategorie text,
  CONSTRAINT q_notiz_kategorien_pkey PRIMARY KEY (id)
) 
WITH OIDS;

CREATE TABLE q_notiz_kategorie2stelle
(
  stelle int8 NOT NULL,
  kat_id int8 NOT NULL,
  lesen bool NOT NULL DEFAULT false,
  anlegen bool NOT NULL DEFAULT false,
  aendern bool DEFAULT false
) 
WITH OIDS;


--# �nderungen von 1.5.7 nach 1.5.8
--# 2006-02-20
--# �nderung der Namen der Geometriespalten in den Tabellen der Festpunkte fp_punkte und fp_punkte_temp
ALTER TABLE fp_punkte_temp RENAME COLUMN koordinaten TO the_geom;
ALTER TABLE fp_punkte RENAME COLUMN koordinaten TO the_geom;
UPDATE geometry_columns SET f_geometry_column='the_geom' WHERE f_table_name LIKE 'fp_punkte%';

--# �nderung der Namen der Geometriespalten in der Tabelle der Notizen q_notizen
ALTER TABLE q_notizen RENAME COLUMN position TO the_geom;
UPDATE geometry_columns SET f_geometry_column='the_geom' WHERE f_table_name = 'q_notizen';

--# �nderung der Namen der Geometriespalten in der Tabelle der Notizen q_fehlerellipsen
ALTER TABLE q_fehlerellipsen RENAME COLUMN position TO the_geom;
UPDATE geometry_columns SET f_geometry_column='the_geom' WHERE f_table_name = 'q_fehlerellipsen';

--# �nderung der Namen der Geometriespalten in der Tabelle der Notizen bw_bodenrichtwertzonen
ALTER TABLE bw_bodenrichtwertzonen RENAME COLUMN umring TO the_geom;
UPDATE geometry_columns SET f_geometry_column='the_geom' WHERE f_table_name = 'bw_bodenrichtwertzonen' AND f_geometry_column='umring';

--# �nderung der Namen der Geometriespalten in der Tabelle der Notizen n_nachweise
ALTER TABLE n_nachweise RENAME COLUMN umring TO the_geom;
UPDATE geometry_columns SET f_geometry_column='the_geom' WHERE f_table_name = 'n_nachweise';

--# �nderung der Namen der Geometriespalten in der Tabelle der Notizen md_metadata
ALTER TABLE md_metadata RENAME COLUMN umring TO the_geom;
UPDATE geometry_columns SET f_geometry_column='the_geom' WHERE f_table_name = 'md_metadata';

--# �nderung der Namen der Geometriespalten in der Tabelle der Notizen ve_versiegelung
ALTER TABLE ve_versiegelung RENAME COLUMN umring TO the_geom;
UPDATE geometry_columns SET f_geometry_column='the_geom' WHERE f_table_name = 've_versiegelung';

--# �nderungen von 1.5.9 nach 1.6
--# 2006-06-21
--# �ndern des Geometrietyps der Spalte the_geom der Tabelle q_notizen und l�schen des geotype-constraints

UPDATE geometry_columns SET type = 'POLYGON' WHERE f_table_name = 'q_notizen';
ALTER TABLE q_notizen DROP CONSTRAINT enforce_geotype_position;

--# Hinzuf�gen einer Tabelle u_polygon zur Speicherung von Polygonen

CREATE TABLE u_polygon
(
  id serial NOT NULL,
  CONSTRAINT u_polygon_pkey PRIMARY KEY (id)
) 
WITH OIDS;

SELECT AddGeometryColumn('public', 'u_polygon','the_geom',2398,'MULTIPOLYGON', 2);
CREATE INDEX u_polygon_the_geom_gist ON u_polygon USING GIST (the_geom GIST_GEOMETRY_OPS);

--# �nderungen von 1.6.0 nach 1.6.1
--# 2006-07-24
--# Tabelle zur Speicherung der Bauleitplanungs�nderungen

CREATE TABLE bp_aenderungen
(
  id serial NOT NULL,
  username varchar(255),
  datum date,
  hinweis varchar(255),
  bemerkung varchar(255),
  loeschdatum timestamp,
  loeschusername varchar(255),
  CONSTRAINT bp_aenderungen_pkey PRIMARY KEY (id)
) 
WITH OIDS;

SELECT AddGeometryColumn('public', 'bp_aenderungen','the_geom',2398,'POLYGON', 2);
CREATE INDEX bp_aenderungen_the_geom_gist ON bp_aenderungen USING GIST (the_geom GIST_GEOMETRY_OPS);

--# �nderungen von 1.6.0 nach 1.6.1
--# 2006-07-26
--# Tabelle zur Speicherung der Jagdbezirke
CREATE TABLE jagdbezirke
(
  id int4 NOT NULL,
  art varchar, -- m�gliche Werte gjb, ejb, tjb
  jagdbezirk int4,
  gemeinde int4,
  flaeche float4,
  befriedet bool,
  unterteilt bool,
  enklave bool,
  CONSTRAINT jagdbezirke_pkey PRIMARY KEY (id),
  CONSTRAINT art CHECK (art::text = 'gjb'::text OR art::text = 'ejb'::text OR art::text = 'tjb'::text)
) 
WITH OIDS;
COMMENT ON TABLE jagdbezirke IS 'Befriedete und unbefriedete, unterteilte und nicht unterteilte Jagdbezirke, Eigenjagdbezirke oder Teiljagdbezirke';
COMMENT ON COLUMN jagdbezirke.art IS 'm�gliche Werte gjb, ejb, tjb';
SELECT AddGeometryColumn('public', 'jagdbezirke','the_geom',2398,'POLYGON', 2);
CREATE INDEX jagdbezirke_the_geom_gist ON jagdbezirke USING GIST (the_geom GIST_GEOMETRY_OPS);

--# Tabelle zur Speicherung der Jagdpaechter
CREATE TABLE jagdpaechter
(
  id serial NOT NULL,
  name varchar(255),
  weiteres varchar(255),
  CONSTRAINT jagdpaechter_pkey PRIMARY KEY (id)
) 
WITH OIDS;
COMMENT ON TABLE jagdpaechter IS 'Paechter von Jagdbezirken';

--# Tabelle zur Speicherung der Zuordnung der Paechter zur den Jagdbezirken
CREATE TABLE jagdpaechter2bezirke
(
  bezirkid int4 NOT NULL,
  paechterid int4 NOT NULL,
  CONSTRAINT jagdpaechter2bezirke_pkey PRIMARY KEY (bezirkid, paechterid)
) 
WITH OIDS;

--# Tabelle zur Speicherung der Jagdabschussplanung
CREATE TABLE jagdabschussplanung
(
  bezirkid int4 NOT NULL,
  von int4 NOT NULL,
  bis int4 NOT NULL,
  rehwild int4,
  damwild int4,
  schwarzwild int4,
  muffelwild int4,
  antragsdatum date,
  genehmigung varchar(20),
  wiederspruchsdatum date,
  CONSTRAINT jagdabschussplanung_pkey PRIMARY KEY (bezirkid, von, bis)
) 
WITH OIDS;

--# �nderungen von 1.6.2 nach 1.6.3

ALTER TABLE jagdbezirke DROP CONSTRAINT enforce_geotype_the_geom;
ALTER TABLE jagdbezirke ADD CONSTRAINT enforce_geotype_the_geom CHECK (geometrytype(the_geom) = 'POLYGON'::text OR geometrytype(the_geom) = 'MULTIPOLYGON'::text OR the_geom IS NULL);

--# �nderungen von 1.6.3 nach 1.6.4

ALTER TABLE bw_bodenrichtwertzonen ALTER bodenwert TYPE float4;

alter table q_notizen rename column kategorie to kategorie_id;

ALTER TABLE jagdbezirke DROP COLUMN gemeinde;
ALTER TABLE jagdbezirke DROP COLUMN enklave;
ALTER TABLE jagdbezirke DROP COLUMN befriedet;
ALTER TABLE jagdbezirke DROP COLUMN unterteilt;
ALTER TABLE jagdbezirke ADD COLUMN name varchar(255);

--# �nderungen von 1.6.5 nach 1.6.6

alter table n_nachweise alter column blattnummer type varchar;

--# Zus�tzliche Funktionen zum Selektieren von einzelnen        
-- Liniensegmenten aus einem Polygon 2007-07-17 pk             
-- Die Funktionen m�ssen in dieser Reihenfolge erzeugt werden! 

-- Function: linefrompoly(geometry)
-- Liefert eine LINESTRING Gemetrie von einer MULTIPOLYGON oder POLYGON Geometrie zur�ck
-- DROP FUNCTION linefrompoly(geometry); 
CREATE OR REPLACE FUNCTION linefrompoly(geometry)
  RETURNS geometry AS
  $BODY$SELECT st_geomfromtext(replace(replace(replace(asText($1),'MULTIPOLYGON','LINESTRING'),'(((','('),')))',')'),srid($1))$BODY$
  LANGUAGE 'sql' IMMUTABLE STRICT;
ALTER FUNCTION linefrompoly(geometry) OWNER TO postgres;
COMMENT ON FUNCTION linefrompoly(geometry) IS 'Liefert eine LINESTRING Gemetrie von einer MULTIPOLYGON oder POLYGON Geometrie zur�ck';

-- Function: linen(geometry, int4)
-- Liefert die n-te Linien innerhalb eines Polygon als Geometry zur�ck
-- DROP FUNCTION linen(geometry, int4);
CREATE OR REPLACE FUNCTION linen(geometry, int4)
  RETURNS geometry AS
  $BODY$SELECT st_geomfromtext('LINESTRING('||X(pointn(linefrompoly($1),$2))||' '||Y(pointn(linefrompoly($1),$2))||','||X(pointn(linefrompoly($1),$2+1))||' '||Y(pointn(linefrompoly($1),$2+1))||')',srid($1))$BODY$
  LANGUAGE 'sql' IMMUTABLE STRICT;
ALTER FUNCTION linen(geometry, int4) OWNER TO postgres;
COMMENT ON FUNCTION linen(geometry, int4) IS 'Liefert die n-te Linien innerhalb eines Polygon als Geometry zur�ck';

-- Function: snapline(geometry, geometry)
-- Liefert die einzelne Kante eines LINESTRINGS mit der Geometry1, welche am dichtesten am Punkt mit der Geometrie 2 liegt als Geometry
-- DROP FUNCTION snapline(geometry, geometry);
CREATE OR REPLACE FUNCTION snapline(geometry, geometry)
  RETURNS geometry AS
  $BODY$DECLARE
  i integer;
  mindist float;
  rs RECORD;
  output geometry;
  BEGIN
    mindist = 1000;
    FOR i IN 1..NumPoints($1) LOOP
      SELECT INTO rs linen($1,i) AS linegeom, distance(linen($1,i),$2) AS dist;
      IF rs.dist < mindist THEN
        BEGIN
          mindist := rs.dist;
          output := rs.linegeom;
        END;
      END IF;
    END LOOP;
    RETURN output;
  END;$BODY$
  LANGUAGE 'plpgsql' VOLATILE;
ALTER FUNCTION snapline(geometry, geometry) OWNER TO postgres;
COMMENT ON FUNCTION snapline(geometry, geometry) IS 'Liefert die einzelne Kante eines LINESTRINGS mit der Geometry1, welche am dichtesten am Punkt mit der Geometrie 2 liegt als Geometry';

-- Beispiel zur Abfrage der Geb�udekante des gegebenen Objektes, welches am dichtesten zum gegebenen Punkt liegt und dessen Azimutwinkel.
-- SELECT AsText(snapline(linefrompoly(the_geom),st_geomfromtext('Point(4516219.4 6013803.0)',2398))) AS Segment
-- ,azimuth(pointn(snapline(linefrompoly(the_geom),st_geomfromtext('Point(4516219.4 6013803.0)',2398)),1),pointn(snapline(linefrompoly(the_geom),st_geomfromtext('Point(4516219.4 6013803.0)',2398)),2)) AS winkel
-- FROM alkobj_e_fla WHERE objnr = 'D0009O1'

--# Anlegen der Tabellen f�r die Fachscale Anliegerbeitr�ge

CREATE TABLE anliegerbeitraege_bereiche
(
  id serial NOT NULL,
  flaeche real,
  kommentar character varying(255),
  CONSTRAINT anliegerbeitraege_bereiche_pkey PRIMARY KEY (id)
) 
WITH OIDS;
SELECT AddGeometryColumn('public', 'anliegerbeitraege_bereiche','the_geom',2398,'GEOMETRY', 2);

CREATE TABLE anliegerbeitraege_strassen
(
  id serial NOT NULL,
  CONSTRAINT anliegerbeitraege_strassen_pkey PRIMARY KEY (id)
) 
WITH OIDS;
SELECT AddGeometryColumn('public', 'anliegerbeitraege_strassen','the_geom',2398,'GEOMETRY', 2);


--# Anlegen der Tabelle zum Speichern von beliebigen Polygonen

CREATE TABLE frei_polygon
(
  id serial NOT NULL,
  kommentar character varying(255)
) 
WITH OIDS;
SELECT AddGeometryColumn('public', 'frei_polygon','the_geom',2398,'GEOMETRY', 2);

--# Tabellen f�r Dokumente
CREATE TABLE doc_doc2geoname
(
  doc_id int8 NOT NULL,
  geoname_id int8 NOT NULL
) 
WITHOUT OIDS;

CREATE TABLE doc_documents
(
  id serial NOT NULL,
  filename varchar(255),
  CONSTRAINT doc_documents_pkey PRIMARY KEY (id)
) 
WITHOUT OIDS;

CREATE TABLE doc_tempwords
(
  begriff varchar(75)
) 
WITHOUT OIDS;

CREATE TABLE doc_words
(
  begriff varchar(75) NOT NULL
) 
WITHOUT OIDS;

CREATE TABLE gaz_begriffe
(
  id serial NOT NULL,
  bezeichnung varchar(75) NOT NULL,
  kurzbezeichnung varchar(50),
  ueberbegriff int4,
  CONSTRAINT gaz_begriffe_pkey PRIMARY KEY (id)
) 
WITH OIDS;
SELECT AddGeometryColumn('public', 'gaz_begriffe', 'wgs_geom', 4326, 'POINT', 2);
CREATE INDEX gaz_begriffe_gist ON gaz_begriffe USING GIST (wgs_geom GIST_GEOMETRY_OPS );

CREATE TABLE shp_import_tables
(
  tabellenname character varying(255) NOT NULL
) 
WITH OIDS;

----# �nderungen von 1.6.6 nach 1.6.7

-- Tabelle f�r Adress�nderungen

CREATE TABLE alb_g_namen_temp
(
  neu_name3 character varying(52),
  neu_name4 character varying(52),
  user_id integer,
  datum timestamp without time zone,
  name1 character varying(52),
  name2 character varying(52),
  name3 character varying(52),
  name4 character varying(52)
)
WITH OIDS;

-- Tabelle f�r Metainformationen

CREATE TABLE tabelleninfo
(
  thema character varying(10),
  datum character varying(10)
)
WITH OIDS;

-- Entfernen des epsg-code-constraints f�r die tempor�re Festpunkttabelle

ALTER TABLE fp_punkte_temp DROP CONSTRAINT enforce_srid_koordinaten;

-- Erzeugen einer zweiten Festpunkt-Tabelle f�r die Punkte im 5. Streifen

CREATE TABLE fp_punkte2
(
  pkz char(16) NOT NULL PRIMARY KEY,
  rw varchar(11),
  hw varchar(11),
  hoe varchar(9),
  s varchar(4),
  zst varchar(7),
  vma varchar(3),
  bem varchar(4),
  ent varchar(15),
  unt varchar(15),
  zuo varchar(15),
  tex varchar(25),
  ls varchar(3),
  lg varchar(1),
  lz varchar(1),
  lbj varchar(3),
  lah varchar(9),
  hs varchar(15),
  hg varchar(15),
  hz varchar(15),
  hbj varchar(15),
  hah varchar(15),
  pktnr varchar(5),
  art int4 DEFAULT 0,
  datei varchar(50),
  verhandelt int4 DEFAULT 0,
  vermarkt int4 DEFAULT 0
) 
WITH OIDS;
SELECT AddGeometryColumn('public', 'fp_punkte2','the_geom',2399,'POINT', 3);
CREATE INDEX fp_punkte2_the_geom_gist ON fp_punkte2 USING GIST (the_geom GIST_GEOMETRY_OPS);


----# �nderungen von 1.6.7 nach 1.6.8

ALTER TABLE fp_punkte_temp ALTER tex TYPE character varying(18);
ALTER TABLE fp_punkte ALTER tex TYPE character varying(18);


----# �nderungen von 1.6.8 nach 1.6.9

-- Tabelle f�r andere Dokumentarten in der Nachweisverwaltung

CREATE TABLE n_dokumentarten
(
   id serial NOT NULL, 
   art character varying(100)
) 
WITH OIDS;

-- Tabelle f�r die Zuordnung von Nachweisen zu anderen Dokumentarten

CREATE TABLE n_nachweise2dokumentarten
(
   nachweis_id integer NOT NULL, 
   dokumentart_id integer NOT NULL
) 
WITH OIDS;

-- Tabelle f�r die Aliasnamen der Koordinatensysteme
CREATE TABLE spatial_ref_sys_alias
(
  srid integer NOT NULL,
  alias character varying(256),
  CONSTRAINT spatial_ref_sys_alias_pkey PRIMARY KEY (srid)
)
WITH OIDS;


----# �nderungen von 1.6.9 nach 1.7.0

--###########################
--# Tabellen f�r Jagdkataster
--# 2008-06-18 mh
--# Tabelle zur Speicherung der Jagdbezirke

--######################### 
--# bei Bedarf alte Tabellen l�schen (dann die "--" davor wegnehmen)
--#
--DROP TABLE jagdbezirke;
--DROP TABLE jagdpaechter;
--DROP TABLE jagdpaechter2bezirke;
--DROP TABLE jagdabschussplanung;
--#
--# sind schon Daten in der Tabelle jagdbezirke vorhanden, m�ssen diese in die neue Tabelle �berspielt werden

CREATE TABLE jagdbezirke
(
  id varchar(10) NOT NULL,
  art varchar(15),
  flaeche numeric,
  name varchar(50),
  concode varchar(5),
  conname varchar(40),
  CONSTRAINT jagdbezirke_pkey PRIMARY KEY (oid)
) 
WITH OIDS;
ALTER TABLE jagdbezirke OWNER TO postgres;
COMMENT ON COLUMN jagdbezirke.concode IS 'entspricht tbJagdbezirk.BCode in condition';
COMMENT ON COLUMN jagdbezirke.conname IS 'entspricht tbJagdbezirk.BBezeichnung in condition';
SELECT AddGeometryColumn('public', 'jagdbezirke','the_geom',2398,'MULTIPOLYGON', 2);
CREATE INDEX jagdbezirke_the_geom_gist ON jagdbezirke USING GIST (the_geom GIST_GEOMETRY_OPS);
ALTER TABLE jagdbezirke DROP CONSTRAINT enforce_geotype_the_geom;
ALTER TABLE jagdbezirke ADD CONSTRAINT enforce_geotype_the_geom CHECK (geometrytype(the_geom) = 'POLYGON'::text OR geometrytype(the_geom) = 'MULTIPOLYGON'::text OR the_geom IS NULL);


--# Tabelle zur Speicherung der Jagdpaechter


CREATE TABLE jagdpaechter
(
  id int4 NOT NULL,
  anrede varchar(10),
  nachname varchar(50),
  vorname varchar(50),
  geburtstag varchar(20),
  geburtsort varchar(50),
  strasse varchar(50),
  plz varchar(5),
  ort varchar(50),
  telefon varchar(50),
  CONSTRAINT jagdpaechter_pkey PRIMARY KEY (id)
) 
WITH OIDS;
COMMENT ON TABLE jagdpaechter IS 'Paechter von Jagdbezirken';
COMMENT ON COLUMN jagdpaechter.id IS 'entspricht Waffenbesitzer.Code in condition';


--# Tabelle zur Speicherung der Zuordnung der Paechter zur den Jagdbezirken


CREATE TABLE jagdpaechter2bezirke
(
  bezirkid int4 NOT NULL,
  paechterid int4 NOT NULL,
  CONSTRAINT jagdpaechter2bezirke_pkey PRIMARY KEY (oid)
) 
WITH OIDS;


--# View zu den Jagdbezirken

CREATE OR REPLACE VIEW jagdbezirk_paechter AS 
 SELECT jb.oid, jb.id, jb.name, jb.art, jb.flaeche, 
        CASE
            WHEN count(jpb.paechterid) = 0 THEN 'keine condition-Daten'::text
            ELSE count(jpb.paechterid)::text || ' P&auml;chter    (anzeigen ->)'::text
        END AS anzahl_paechter, jpb.bezirkid, jb.concode, jb.the_geom
   FROM jagdbezirke jb
   LEFT JOIN jagdpaechter2bezirke jpb ON jb.concode::text = jpb.paechterid::text
  GROUP BY jb.oid, jb.id, jb.name, jb.art, jb.flaeche, jpb.bezirkid, jb.concode, jb.the_geom;

ALTER TABLE jagdbezirk_paechter OWNER TO postgres;






----# �nderungen von 1.7.2 nach 1.7.3


-- neue Tabelle bw_zonen zur Speicherung der BRWs

CREATE TABLE bw_zonen (
  old_oid int4,				-- aus der alten Tabelle (nur f�r Verkn�pfung zwischen alt und neu) 
  zonennr int4 NOT NULL DEFAULT 0,	-- aus der alten Tabelle 
  standort varchar(255),		-- aus der alten Tabelle (muss �berarbeitet werden)
  richtwertdefinition varchar(50),	-- aus der alten Tabelle (muss �berarbeitet werden)
  
  gemeinde int4,
  gemarkung int4,
  ortsteilname character varying(100),
  postleitzahl int4,
  zonentyp character varying(256),
  gutachterausschuss int4,
  bodenrichtwertnummer int4,
  oertliche_bezeichnung character varying(256),
  bodenrichtwert float4,
  stichtag date,
  basiskarte character varying(6),
  entwicklungszustand character varying(1),
  beitragszustand character varying(9),
  nutzungsart character varying(7),
  ergaenzende_nutzung character varying(30), 
  bauweise character varying(3),
  geschosszahl character varying(9),
  grundflaechenzahl float4,
  geschossflaechenzahl float4,
  baumassenzahl float4,
  flaeche float4,
  tiefe int4,
  breite int4,
  wegeerschliessung character varying(4),
  ackerzahl int4,
  gruenlandzahl int4,
  aufwuchs character varying(4),
  verfahrensgrund character varying(3),
  verfahrensgrund_zusatz character varying(1),
  bemerkungen character varying(256)
)
WITH OIDS;

SELECT AddGeometryColumn('public', 'bw_zonen','textposition',25833,'POINT', 2);
CREATE INDEX bw_zonen_textposition_gist ON bw_zonen USING GIST (textposition GIST_GEOMETRY_OPS);

SELECT AddGeometryColumn('public', 'bw_zonen','the_geom',25833,'POLYGON', 2);
CREATE INDEX bw_zonen_the_geom_gist ON bw_zonen USING GIST (the_geom GIST_GEOMETRY_OPS);


-- das checkconstraint aendern wg. Datenuebernahme von Multipolygonen

ALTER TABLE bw_zonen DROP CONSTRAINT enforce_geotype_the_geom;
ALTER TABLE bw_zonen ADD CONSTRAINT enforce_geotype_the_geom CHECK (geometrytype(the_geom) = 'POLYGON'::text OR geometrytype(the_geom) = 'MULTIPOLYGON'::text OR the_geom IS NULL);

----------------------------------------
-- Daten aus alter Tabelle �bertragen --

INSERT INTO bw_zonen 
SELECT oid, zonennr, standort, richtwertdefinition, gemeinde_id, NULL, NULL, NULL, NULL, 1234, NULL, NULL, bodenwert, datum, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, st_transform(the_geom, 25833) FROM bw_bodenrichtwertzonen;

set add_missing_from = on;  -- war bei mir notwendig zu setzen sonst Fehlermeldung "Missing FROM-clause entry for table ..." H.S.

UPDATE bw_zonen SET verfahrensgrund = 'SAN', verfahrensgrund_zusatz = 'A'
WHERE bw_bodenrichtwertzonen.sanierungsgebiete = 'Sanierungsanfangswert' 
AND old_oid = bw_bodenrichtwertzonen.oid;

UPDATE bw_zonen SET verfahrensgrund = 'SAN', verfahrensgrund_zusatz = 'E'
WHERE bw_bodenrichtwertzonen.sanierungsgebiete = 'Sanierungsendwert' 
AND old_oid = bw_bodenrichtwertzonen.oid;

UPDATE bw_zonen SET beitragszustand = 'frei' 
WHERE bw_bodenrichtwertzonen.erschliessungsart = '(vollerschlossen)'
AND old_oid = bw_bodenrichtwertzonen.oid;

UPDATE bw_zonen SET beitragszustand = 'frei' 
WHERE bw_bodenrichtwertzonen.erschliessungsart = '[ortsuebliche Erschl.]'
AND old_oid = bw_bodenrichtwertzonen.oid;

UPDATE bw_zonen SET beitragszustand = 'pflichtig' 
WHERE bw_bodenrichtwertzonen.erschliessungsart = 'ohne'
AND old_oid = bw_bodenrichtwertzonen.oid;

UPDATE bw_zonen SET 
textposition = st_transform(bw_bodenrichtwertzonen.textposition, 25833)
WHERE old_oid = bw_bodenrichtwertzonen.oid;

-- Daten aus alter Tabelle �bertragen --
----------------------------------------


-- View zum Austausch der BRWs

CREATE OR REPLACE VIEW bw_boris_view AS 
 SELECT bw.oid as oid, 13 AS landesschluessel, bw.gemeinde, g.gemeindename, gm.gemkgname, bw.ortsteilname, bw.postleitzahl, bw.zonentyp, bw.gutachterausschuss, bw.bodenrichtwertnummer, bw.oertliche_bezeichnung, bw.bodenrichtwert, round(bw.bodenrichtwert::double precision) AS bw_darstellung, bw.stichtag, 25833 AS clbs, x(bw.textposition) AS rechtswert, y(bw.textposition) AS hochwert, bw.basiskarte, bw.entwicklungszustand, bw.beitragszustand, bw.nutzungsart, bw.ergaenzende_nutzung, bw.bauweise, bw.geschosszahl, bw.grundflaechenzahl, bw.geschossflaechenzahl, bw.baumassenzahl, bw.flaeche, bw.tiefe, bw.breite, bw.wegeerschliessung, bw.ackerzahl, bw.gruenlandzahl, bw.aufwuchs, bw.verfahrensgrund, bw.verfahrensgrund_zusatz, bw.bemerkungen, bw.textposition, bw.the_geom
   FROM bw_zonen bw
   LEFT JOIN alb_v_gemeinden g ON bw.gemeinde = g.gemeinde
   LEFT JOIN alb_v_gemarkungen gm ON bw.gemarkung = gm.gemkgschl;


----# �nderungen von 1.7.4 nach 1.7.5


CREATE SEQUENCE bw_zonen_bodenrichtwertnummer_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;
 
ALTER TABLE bw_zonen ALTER COLUMN bodenrichtwertnummer SET DEFAULT nextval('public.bw_zonen_bodenrichtwertnummer_seq'::text);

DROP VIEW bw_boris_view;

ALTER TABLE bw_zonen ALTER beitragszustand TYPE character varying(22);

CREATE OR REPLACE VIEW bw_boris_view AS 
 SELECT bw.oid as oid, 13 AS landesschluessel, bw.gemeinde, g.gemeindename, gm.gemkgname, bw.ortsteilname, bw.postleitzahl, bw.zonentyp, bw.gutachterausschuss, bw.bodenrichtwertnummer, bw.oertliche_bezeichnung, bw.bodenrichtwert, round(bw.bodenrichtwert::double precision) AS bw_darstellung, bw.stichtag, 25833 AS clbs, x(bw.textposition) AS rechtswert, y(bw.textposition) AS hochwert, bw.basiskarte, bw.entwicklungszustand, bw.beitragszustand, bw.nutzungsart, bw.ergaenzende_nutzung, bw.bauweise, bw.geschosszahl, bw.grundflaechenzahl, bw.geschossflaechenzahl, bw.baumassenzahl, bw.flaeche, bw.tiefe, bw.breite, bw.wegeerschliessung, bw.ackerzahl, bw.gruenlandzahl, bw.aufwuchs, bw.verfahrensgrund, bw.verfahrensgrund_zusatz, bw.bemerkungen, bw.textposition, bw.the_geom
   FROM bw_zonen bw
   LEFT JOIN alb_v_gemeinden g ON bw.gemeinde = g.gemeinde
   LEFT JOIN alb_v_gemarkungen gm ON bw.gemarkung = gm.gemkgschl;
   
ALTER TABLE jagdbezirke ADD COLUMN jb_zuordnung integer;
ALTER TABLE jagdbezirke ADD COLUMN status boolean;   


----# �nderungen von 1.7.5 nach 1.7.6

ALTER TABLE jagdbezirke ALTER COLUMN jb_zuordnung TYPE character varying(10);
ALTER TABLE jagdbezirke ALTER COLUMN id TYPE character varying(10);


CREATE OR REPLACE FUNCTION linefrompoly(geometry)
  RETURNS geometry AS
$BODY$SELECT 
	geomfromtext(
		replace(
			replace(
				replace(
					replace(
						replace(
							asText($1),'MULTIPOLYGON','MULTILINESTRING'
						),'POLYGON','MULTILINESTRING'
					), '(((', '(('
				), ')))', '))'
			), ')),((', '),('
		), srid($1)
	)$BODY$
  LANGUAGE 'sql' IMMUTABLE STRICT;
COMMENT ON FUNCTION linefrompoly(geometry) IS 'Liefert eine LINESTRING Gemetrie von einer MULTIPOLYGON oder POLYGON Geometrie zur�ck';


----# �nderungen von 1.7.6 nach 1.8.0

-- Tabelle zur Speicherung von Umringspolygonen aus uko-Dateien

CREATE TABLE uko_polygon
(
  id serial NOT NULL,
  username character varying(25)
)
WITH OIDS;
select AddGeometryColumn ('public','uko_polygon','the_geom',2398,'GEOMETRY',2);  -- oder 2399


----# �nderungen von 1.8.0 nach 1.9.0

-- ACHTUNG: DIE FUNKTION linefrompoly (siehe �nderungen von 1.7.5 nach 1.7.6) MUSS IN ALLEN DATENBANKEN ANGELEGT WERDEN, AUF DIE LAYER ZUGREIFEN, F�R DIE DER PUNKTFANG ZUR VERF�GUNG STEHEN SOLL!!!

ALTER TABLE tabelleninfo ALTER COLUMN thema TYPE character varying(20);

-- !!!!!!!!hier m�ssen die Schl�ssel angepasst werden !!!!!!!!!!!!
INSERT INTO tabelleninfo VALUES ('adressaend0019', 1234);
INSERT INTO tabelleninfo VALUES ('adressaend0021', 1324);

ALTER TABLE uko_polygon ADD COLUMN dateiname character varying(50);

ALTER TABLE public.bw_zonen DROP COLUMN old_oid;
ALTER TABLE public.bw_zonen DROP COLUMN zonennr;
ALTER TABLE public.bw_zonen DROP COLUMN standort;
ALTER TABLE public.bw_zonen DROP COLUMN richtwertdefinition;


----# �nderungen von 1.9.0 nach 1.10.0

ALTER TABLE public.n_nachweise ALTER COLUMN stammnr TYPE character varying(15);
ALTER TABLE public.n_nachweise ADD COLUMN fortfuehrung integer;
ALTER TABLE public.n_nachweise ADD COLUMN rissnummer character varying(20);
ALTER TABLE public.n_nachweise ADD COLUMN bemerkungen text;


----# �nderungen von 1.10.0 nach 1.11.0

CREATE SCHEMA custom_shapes;	-- kann auch anders hei�en, ist der config.php �ber CUSTOM_SHAPE_SCHEMA definierbar


DROP VIEW public.bw_boris_view;

ALTER TABLE public.bw_zonen ALTER COLUMN ortsteilname TYPE character varying(60);
ALTER TABLE public.bw_zonen ALTER COLUMN basiskarte TYPE character varying(8);
ALTER TABLE public.bw_zonen ALTER COLUMN entwicklungszustand TYPE character varying(2);
UPDATE public.bw_zonen SET entwicklungszustand = 'LF' WHERE entwicklungszustand = 'L';
UPDATE public.bw_zonen SET beitragszustand = '1' WHERE beitragszustand = 'frei';
UPDATE public.bw_zonen SET beitragszustand = '3' WHERE beitragszustand = 'pflichtig';
UPDATE public.bw_zonen SET beitragszustand = '2' WHERE beitragszustand = 'orts�blich erschlossen';
ALTER TABLE public.bw_zonen ALTER COLUMN beitragszustand TYPE character varying(1);
ALTER TABLE public.bw_zonen ALTER COLUMN tiefe TYPE varchar(8);
ALTER TABLE public.bw_zonen ALTER COLUMN flaeche TYPE varchar(12);
ALTER TABLE public.bw_zonen ALTER COLUMN breite TYPE varchar(8);
UPDATE public.bw_zonen SET bauweise = 'dh' WHERE bauweise = 'DH';
UPDATE public.bw_zonen SET bauweise = 'eh' WHERE bauweise = 'EH';
UPDATE public.bw_zonen SET bauweise = 're' WHERE bauweise = 'REH';
UPDATE public.bw_zonen SET bauweise = 'rh' WHERE bauweise = 'RH';
UPDATE public.bw_zonen SET bauweise = 'rm' WHERE bauweise = 'RMH';
ALTER TABLE public.bw_zonen ALTER COLUMN bauweise TYPE character varying(2);
ALTER TABLE public.bw_zonen ADD COLUMN erschliessungsverhaeltnisse integer;
ALTER TABLE public.bw_zonen ALTER COLUMN verfahrensgrund TYPE character varying(4);
UPDATE public.bw_zonen SET verfahrensgrund = 'Entw' WHERE verfahrensgrund = 'ENT';
UPDATE public.bw_zonen SET verfahrensgrund = 'San' WHERE verfahrensgrund = 'SAN';
ALTER TABLE public.bw_zonen ALTER COLUMN verfahrensgrund_zusatz TYPE character varying(2);
UPDATE public.bw_zonen SET verfahrensgrund_zusatz = 'SU' WHERE verfahrensgrund_zusatz = 'A' AND verfahrensgrund = 'San';
UPDATE public.bw_zonen SET verfahrensgrund_zusatz = 'EU' WHERE verfahrensgrund_zusatz = 'A' AND verfahrensgrund = 'Entw';
UPDATE public.bw_zonen SET verfahrensgrund_zusatz = 'SB' WHERE verfahrensgrund_zusatz = 'E' AND verfahrensgrund = 'San';
UPDATE public.bw_zonen SET verfahrensgrund_zusatz = 'EB' WHERE verfahrensgrund_zusatz = 'E' AND verfahrensgrund = 'Entw';
UPDATE public.bw_zonen SET aufwuchs = NULL WHERE aufwuchs = 'ohne';
UPDATE public.bw_zonen SET aufwuchs = 'mA' WHERE aufwuchs = 'mit';
ALTER TABLE public.bw_zonen ALTER COLUMN aufwuchs TYPE character varying(2);
ALTER TABLE public.bw_zonen ADD COLUMN bedarfswert real;
ALTER TABLE public.bw_zonen ADD COLUMN bodenart character varying(6);
ALTER TABLE public.bw_zonen ALTER COLUMN ackerzahl TYPE varchar(7);
ALTER TABLE public.bw_zonen ALTER COLUMN gruenlandzahl TYPE varchar(7);
UPDATE public.bw_zonen SET wegeerschliessung = '0' WHERE wegeerschliessung = 'ohne';
UPDATE public.bw_zonen SET wegeerschliessung = '1' WHERE wegeerschliessung = 'mit';
ALTER TABLE public.bw_zonen ALTER COLUMN wegeerschliessung TYPE character varying(1);


CREATE OR REPLACE VIEW public.bw_boris_view AS 
 SELECT bw.oid, 13 AS landesschluessel, bw.gemeinde, g.gemeindename, gm.gemkgname, bw.ortsteilname, bw.postleitzahl, bw.zonentyp, bw.gutachterausschuss, bw.bodenrichtwertnummer, bw.oertliche_bezeichnung, bw.bodenrichtwert, round(bw.bodenrichtwert::double precision) AS bw_darstellung, bw.stichtag, bw.bedarfswert, 25833 AS bezug, x(bw.textposition) AS rechtswert, y(bw.textposition) AS hochwert, bw.basiskarte, bw.entwicklungszustand, bw.beitragszustand, bw.nutzungsart, bw.ergaenzende_nutzung, bw.bauweise, bw.geschosszahl, bw.grundflaechenzahl, bw.geschossflaechenzahl, bw.baumassenzahl, bw.flaeche, bw.tiefe, bw.breite, bw.wegeerschliessung, bw.erschliessungsverhaeltnisse, bw.ackerzahl, bw.gruenlandzahl, bw.aufwuchs, bw.verfahrensgrund, bw.verfahrensgrund_zusatz, bw.bemerkungen, 0 as umdart, 'http://pfad/zur/umrechungstabelle/tabelle'||stichtag||'.pdf' as urt, bw.textposition, bw.the_geom
   FROM bw_zonen bw
   LEFT JOIN alb_v_gemeinden g ON bw.gemeinde = g.gemeinde
   LEFT JOIN alb_v_gemarkungen gm ON bw.gemarkung = gm.gemkgschl;

-- �ndert die Spalte kategorie_id der Tabelle q_notizen auf den Datentyp integer und indiziert Fremdschl�ssel in q_notizen und q_notiz_kategorie2stelle
ALTER TABLE q_notizen ADD COLUMN temp integer;
UPDATE q_notizen SET temp = kategorie_id::integer;
ALTER TABLE q_notizen DROP COLUMN kategorie_id;
ALTER TABLE q_notizen RENAME COLUMN temp TO kategorie_id;
CREATE INDEX q_notizen_kategorie_id_idx ON q_notizen USING btree (kategorie_id);
CREATE INDEX q_notiz_kategorie2stelle_stelle_idx ON q_notiz_kategorie2stelle USING btree (stelle);
CREATE INDEX q_notiz_kategorie2stelle_kat_id_idx ON q_notiz_kategorie2stelle USING btree (stelle);
ALTER TABLE q_notiz_kategorie2stelle ADD CONSTRAINT q_notiz_kategorie2stelle_pkey PRIMARY KEY(stelle, kat_id);

-- verl�ngert die Spalten name in den ALB Tabellen
DROP VIEW alb_eigentuemer;

ALTER TABLE alb_g_namen ALTER COLUMN name1 TYPE character varying(60);
ALTER TABLE alb_g_namen ALTER COLUMN name2 TYPE character varying(60);
ALTER TABLE alb_g_namen ALTER COLUMN name3 TYPE character varying(60);
ALTER TABLE alb_g_namen ALTER COLUMN name4 TYPE character varying(60);

ALTER TABLE alb_x_g_namen ALTER COLUMN name1 TYPE character varying(60);
ALTER TABLE alb_x_g_namen ALTER COLUMN name2 TYPE character varying(60);
ALTER TABLE alb_x_g_namen ALTER COLUMN name3 TYPE character varying(60);
ALTER TABLE alb_x_g_namen ALTER COLUMN name4 TYPE character varying(60);

CREATE OR REPLACE VIEW alb_eigentuemer AS 
 SELECT a.flurstkennz, c.name1, c.name2, c.name3, c.name4
   FROM alb_g_buchungen a, alb_g_eigentuemer b, alb_g_namen c
  WHERE a.blatt::text = b.blatt::text AND a.bezirk = b.bezirk AND b.lfd_nr_name = c.lfd_nr_name;

----# �nderungen von 1.11.0 nach 1.12.0

ALTER TABLE n_nachweise2antraege ALTER COLUMN antrag_id TYPE character varying(11);

ALTER TABLE fp_punkte2antraege ALTER COLUMN antrag_nr TYPE character varying(11);

ALTER TABLE public.jagdbezirke ADD COLUMN verzicht boolean NOT NULL DEFAULT false;

DROP VIEW jagdbezirk_paechter;

CREATE VIEW jagdbezirk_paechter AS
 SELECT jb.oid, jb.id, jb.name, jb.art, jb.flaeche, jpb.bezirkid, jb.concode, jb.jb_zuordnung, jb.status, jb.verzicht, jb.the_geom
   FROM jagdbezirke jb
   LEFT JOIN jagdpaechter2bezirke jpb ON jb.concode::text = jpb.bezirkid::text
  GROUP BY jb.oid, jb.id, jb.name, jb.art, jb.flaeche, jpb.bezirkid, jb.concode, jb.jb_zuordnung, jb.status, jb.verzicht, jb.the_geom;
  
 
DROP VIEW public.bw_boris_view;

ALTER TABLE public.bw_zonen ALTER COLUMN grundflaechenzahl TYPE varchar(9);

ALTER TABLE public.bw_zonen ALTER COLUMN geschossflaechenzahl TYPE varchar(11);

ALTER TABLE public.bw_zonen ALTER COLUMN baumassenzahl TYPE varchar(9);

CREATE OR REPLACE VIEW public.bw_boris_view AS 
 SELECT bw.oid, 13 AS landesschluessel, bw.gemeinde, g.gemeindename, gm.gemkgname, bw.ortsteilname, bw.postleitzahl, bw.zonentyp, bw.gutachterausschuss, bw.bodenrichtwertnummer, bw.oertliche_bezeichnung, bw.bodenrichtwert, round(bw.bodenrichtwert::double precision) AS bw_darstellung, bw.stichtag, bw.bedarfswert, 25833 AS bezug, x(bw.textposition) AS rechtswert, y(bw.textposition) AS hochwert, bw.basiskarte, bw.entwicklungszustand, bw.beitragszustand, bw.nutzungsart, bw.ergaenzende_nutzung, bw.bauweise, bw.geschosszahl, bw.grundflaechenzahl, bw.geschossflaechenzahl, bw.baumassenzahl, bw.flaeche, bw.tiefe, bw.breite, bw.wegeerschliessung, bw.erschliessungsverhaeltnisse, bw.ackerzahl, bw.gruenlandzahl, bw.aufwuchs, bw.verfahrensgrund, bw.verfahrensgrund_zusatz, bw.bemerkungen, 0 AS umdart, ('http://pfad/zur/umrechungstabelle/tabelle'::text || bw.stichtag) || '.pdf'::text AS urt, bw.textposition, bw.the_geom
   FROM bw_zonen bw
   LEFT JOIN alb_v_gemeinden g ON bw.gemeinde = g.gemeinde
   LEFT JOIN alb_v_gemarkungen gm ON bw.gemarkung = gm.gemkgschl;
   
ALTER TABLE uko_polygon ADD COLUMN userid integer;



----# �nderungen von 1.12.0 nach 1.13.0


update n_nachweise set datum = split_part(datum, '-', 1)||'-'||split_part(datum, '-', 2)||'-01' WHERE split_part(datum, '-', 3) = '00';
update n_nachweise set datum = split_part(datum, '-', 1)||'-01'||split_part(datum, '-', 3) WHERE split_part(datum, '-', 2) = '00';
update n_nachweise set datum = substr(datum, 1, 4)||'-'||substr(datum, 5) WHERE character_length(split_part(datum, '-', 1)) = 6;
update n_nachweise set datum = split_part(datum, '-', 1)||'01-01' WHERE split_part(datum, '-', 2) = '0101';


CREATE OR REPLACE FUNCTION chartodate(value character varying)
  RETURNS date AS
$BODY$
SELECT CAST($1 AS date);

$BODY$
  LANGUAGE 'sql' IMMUTABLE STRICT;


ALTER TABLE n_nachweise
   ALTER COLUMN datum TYPE date USING chartodate(datum);


DROP FUNCTION chartodate(character varying);


UPDATE bw_zonen SET zonentyp = 'Ackerlandfl�chen' WHERE zonentyp = 'Ackerland';
UPDATE bw_zonen SET zonentyp = 'Forstfl�chen' WHERE zonentyp = 'forstwirtschaftliche Fl�che';
UPDATE bw_zonen SET zonentyp = 'Gewerbefl�chen' WHERE zonentyp = 'Gewerbegebiet';
UPDATE bw_zonen SET zonentyp = 'Sanierungsfl�chen' WHERE zonentyp = 'Sanierungsgebiet';
UPDATE bw_zonen SET zonentyp = 'Gr�nlandfl�chen' WHERE zonentyp = 'Gr�nland';

ALTER TABLE bw_zonen ADD COLUMN brwu real;
ALTER TABLE bw_zonen ADD COLUMN brws real;
ALTER TABLE bw_zonen ADD COLUMN brwb real;


DROP VIEW bw_boris_view;

CREATE OR REPLACE VIEW boris205_view AS 
SELECT bw.oid, bw.gemeinde::text || '0000'::text AS gesl, g.gemeindename AS gena, bw.gutachterausschuss AS gasl, gm.gemkgschl AS genu, bw.ortsteilname AS ortst, bw.bodenrichtwertnummer AS wnum, 
       CASE
           WHEN bw.brwu IS NOT NULL THEN bw.brwu
           WHEN bw.brwb IS NOT NULL THEN bw.brwb
           ELSE bw.bodenrichtwert
       END AS brw, bw.stichtag AS stag, 1 AS brke, 1000 AS basma, '25833'::text AS bezug, bw.entwicklungszustand AS entw, bw.beitragszustand AS beit, bw.nutzungsart AS nuta, bw.ergaenzende_nutzung AS ergnuta, bw.bauweise AS bauw, bw.geschosszahl AS gez, bw.geschossflaechenzahl AS wgfz, bw.grundflaechenzahl AS grz, bw.baumassenzahl AS bmz, bw.flaeche AS flae, bw.tiefe AS gtie, bw.breite AS gbrei, bw.verfahrensgrund AS verg, 
       CASE
           WHEN bw.brwu IS NOT NULL AND bw.verfahrensgrund::text = 'San'::text THEN 'SU'::character varying
           WHEN bw.brwu IS NOT NULL AND bw.verfahrensgrund::text = 'Entw'::text THEN 'EU'::character varying
           WHEN bw.brwb IS NOT NULL AND bw.verfahrensgrund::text = 'San'::text THEN 'SB'::character varying
           WHEN bw.brwb IS NOT NULL AND bw.verfahrensgrund::text = 'Entw'::text THEN 'EB'::character varying
           ELSE bw.verfahrensgrund_zusatz
       END AS verf, bw.bodenart AS bod, bw.ackerzahl AS acza, bw.gruenlandzahl AS grza, 'link_zur_umrechnungstabelle'::text AS lumnum, bw.zonentyp AS typ, bw.the_geom
  FROM bw_zonen bw
  LEFT JOIN alb_v_gemeinden g ON bw.gemeinde = g.gemeinde
  LEFT JOIN alb_v_gemarkungen gm ON bw.gemarkung = gm.gemkgschl;
	

----# �nderungen von 1.13.0 nach 2.0.0

ALTER TABLE spatial_ref_sys_alias ADD COLUMN minx integer;
ALTER TABLE spatial_ref_sys_alias ADD COLUMN miny integer;
ALTER TABLE spatial_ref_sys_alias ADD COLUMN maxx integer;
ALTER TABLE spatial_ref_sys_alias ADD COLUMN maxy integer;

CREATE INDEX spatial_ref_sys_srid_idx
  ON spatial_ref_sys
  USING btree
  (srid);

CREATE INDEX spatial_ref_sys_alias_srid_idx
  ON spatial_ref_sys_alias
  USING btree
  (srid);

---- BORIS ----

CREATE SCHEMA bodenrichtwerte;

SET default_with_oids = true;

CREATE TABLE bodenrichtwerte.bw_zonen (   
     gemeinde integer,
     gemarkung integer,
     ortsteilname character varying(60),
     postleitzahl integer,
     zonentyp character varying(256),
     gutachterausschuss integer,
     bodenrichtwertnummer serial,
     oertliche_bezeichnung character varying(256),
     bodenrichtwert real,
     stichtag date,
     basiskarte character varying(8),
     entwicklungszustand character varying(2),
     beitragszustand character varying(1),
     nutzungsart character varying(7),
     ergaenzende_nutzung character varying(30),
     bauweise character varying(2),
     geschosszahl character varying(9),
     grundflaechenzahl character varying(9),
     geschossflaechenzahl character varying(11),
     baumassenzahl character varying(9),
     flaeche character varying(12),
     tiefe character varying(8),
     breite character varying(8),
     wegeerschliessung character varying(1),
     ackerzahl character varying(7),
     gruenlandzahl character varying(7),
     aufwuchs character varying(2),
     verfahrensgrund character varying(4),
     verfahrensgrund_zusatz character varying(2),
     bemerkungen character varying(256),
     erschliessungsverhaeltnisse integer,
     bedarfswert real,
     bodenart character varying(6),
     brwu real,
     brws real,
     brwb real
 )
 WITH OIDS;
 
 SELECT AddGeometryColumn('bodenrichtwerte', 'bw_zonen','textposition',25833,'POINT', 2);
 CREATE INDEX bw_zonen_textposition_gist ON bodenrichtwerte.bw_zonen USING GIST (textposition);
 
 SELECT AddGeometryColumn('bodenrichtwerte', 'bw_zonen','the_geom',25833,'GEOMETRY', 2);
 CREATE INDEX bw_zonen_the_geom_gist ON bodenrichtwerte.bw_zonen USING GIST (the_geom);
 
 
 -- View zum Austausch der BRWs
 -- Es wird eine Tabelle aemter_gemeinden o.�. vorausgesetzt
 
CREATE OR REPLACE VIEW bodenrichtwerte.bw_boris_view AS 
 SELECT (bw.gutachterausschuss || '_'::text) || lpad(bw.bodenrichtwertnummer::character(13)::text, 7, '0'::text) AS brwid, k.kreisname AS kreis_name, k.kreis AS kreis_schluessel, ag.amt_name AS gemeindeverband_name, k.kreis || ag.amt_schluessel::text AS gemeindeverband_schluessel, (k.kreis || ag.amt_schluessel::text) || bw.gemeinde AS gemeinde_schluessel, NULL::unknown AS gemeindeteil_schluessel, bw.gemeinde AS gesl, g.gemeindename AS gena, bw.gutachterausschuss AS gasl, NULL::unknown AS gabe, "substring"(bw.gemarkung::text, 3, 4) AS genu, NULL::unknown AS gema, bw.ortsteilname AS ortst, lpad(bw.bodenrichtwertnummer::character(13)::text, 7, '0'::text) AS wnum, 
        CASE
            WHEN bw.brwu IS NOT NULL THEN bw.brwu
            WHEN bw.brwb IS NOT NULL THEN bw.brwb
            ELSE bw.bodenrichtwert
        END AS brw, bw.stichtag AS stag, '1' AS brke, bw.bedarfswert AS bedw, bw.postleitzahl AS plz, bw.basiskarte AS basbe, '' AS basma, 'EPSG:25833' AS bezug, bw.entwicklungszustand AS entw, bw.beitragszustand AS beit, bw.nutzungsart AS nuta, bw.ergaenzende_nutzung AS ergnuta, bw.bauweise AS bauw, bw.geschosszahl AS gez, bw.geschossflaechenzahl AS wgfz, bw.grundflaechenzahl AS grz, bw.baumassenzahl AS bmz, bw.flaeche AS flae, bw.tiefe AS gtie, bw.breite AS gbrei, bw.erschliessungsverhaeltnisse AS erve, bw.verfahrensgrund AS verg, 
        CASE
            WHEN bw.brwu IS NOT NULL AND bw.verfahrensgrund::text = 'San'::text THEN 'SU'::character varying
            WHEN bw.brwu IS NOT NULL AND bw.verfahrensgrund::text = 'Entw'::text THEN 'EU'::character varying
            WHEN bw.brwb IS NOT NULL AND bw.verfahrensgrund::text = 'San'::text THEN 'SB'::character varying
            WHEN bw.brwb IS NOT NULL AND bw.verfahrensgrund::text = 'Entw'::text THEN 'EB'::character varying
            ELSE bw.verfahrensgrund_zusatz
        END AS verf, bw.bodenart AS bod, bw.ackerzahl AS acza, bw.gruenlandzahl AS grza, bw.aufwuchs AS aufw, bw.wegeerschliessung AS weer, bw.bemerkungen AS bem, '' AS frei, bw.oertliche_bezeichnung AS brzname, '0' AS umdart, ('http://pfad/zur/umrechungstabelle/tabelle'::text || bw.stichtag) || '.pdf'::text AS lumnum, bw.zonentyp AS typ, bw.stichtag + '1 day'::interval AS guelt_von, bw.stichtag + '2 years'::interval AS guelt_bis, bw.the_geom AS geometrie
   FROM alb_v_kreise k, bodenrichtwerte.bw_zonen bw
   LEFT JOIN alb_v_gemeinden g ON bw.gemeinde = g.gemeinde
   LEFT JOIN aemter_gemeinden ag ON ag.gemeinde_schluessel::integer = bw.gemeinde;

	
-- �berspielen der vorhandenen Daten

insert into bodenrichtwerte.bw_zonen 
select gemeinde, gemarkung, ortsteilname, postleitzahl, zonentyp, gutachterausschuss, bodenrichtwertnummer, oertliche_bezeichnung, bodenrichtwert, 
       stichtag, basiskarte, entwicklungszustand, beitragszustand, nutzungsart, 
       ergaenzende_nutzung, bauweise, geschosszahl, grundflaechenzahl, 
       geschossflaechenzahl, baumassenzahl, flaeche, tiefe, breite, 
       wegeerschliessung, ackerzahl, gruenlandzahl, aufwuchs, verfahrensgrund, 
       verfahrensgrund_zusatz, bemerkungen, erschliessungsverhaeltnisse, 
       bedarfswert, bodenart, brwu, brws, brwb, textposition, the_geom from bw_zonen

-- Updaten der Sequenz
SELECT setval('bodenrichtwerte.bw_zonen_bodenrichtwertnummer_seq', (select max(bodenrichtwertnummer)+1 from bodenrichtwerte.bw_zonen), true);
			 
-- L�schen der alten Tabelle bw_zonen und der Views

-- DROP VIEW bw_boris_view;
-- DROP VIEW boris205_view;
-- DROP TABLE bw_zonen;
			 
---- BORIS Ende ----

---- Jagdkataster ----

CREATE SCHEMA jagdkataster;


-- Tabelle Jagdbezirke
-- ####################### 

CREATE TABLE jagdkataster.jagdbezirke
(
  id character varying(10),
  art character varying(15),
  flaeche numeric,
  name character varying(50),
  concode character varying(5), -- entspricht tbJagdbezirk.BCode in condition
  conname character varying(40), -- entspricht tbJagdbezirk.BBezeichnung in condition
  jb_zuordnung character varying(10),
  status boolean,
  verzicht boolean NOT NULL DEFAULT false
)
WITH (
  OIDS=TRUE
);
ALTER TABLE jagdkataster.jagdbezirke
  ADD CONSTRAINT jagdbezirke_pkey PRIMARY KEY(oid);
COMMENT ON COLUMN jagdkataster.jagdbezirke.concode IS 'entspricht tbJagdbezirk.BCode in condition';
COMMENT ON COLUMN jagdkataster.jagdbezirke.conname IS 'entspricht tbJagdbezirk.BBezeichnung in condition';

SELECT AddGeometryColumn('jagdkataster', 'jagdbezirke','the_geom',2398,'GEOMETRY', 2);

CREATE INDEX jagdbezirke_the_geom_gist
  ON jagdkataster.jagdbezirke
  USING gist
  (the_geom );


-- Tabelle Jagdbezirkarten
-- #######################

CREATE TABLE jagdkataster.jagdbezirkart
(
  art character varying(10),
  bezeichnung character varying(30)
)
WITH (
  OIDS=TRUE
);

INSERT INTO jagdkataster.jagdbezirkart VALUES ('ejb', 'EJB im Verfahren');
INSERT INTO jagdkataster.jagdbezirkart VALUES ('ajb', 'Abgerundeter EJB');
INSERT INTO jagdkataster.jagdbezirkart VALUES ('gjb', 'Gemeinschaftlicher Jagdbezirk');
INSERT INTO jagdkataster.jagdbezirkart VALUES ('tjb', 'Teiljagdbezirk');
INSERT INTO jagdkataster.jagdbezirkart VALUES ('sf', 'Sonderfl�che');
INSERT INTO jagdkataster.jagdbezirkart VALUES ('agf', 'Angliederungsfl�che');
INSERT INTO jagdkataster.jagdbezirkart VALUES ('atf', 'Abtrennungsfl�che');
INSERT INTO jagdkataster.jagdbezirkart VALUES ('slf', 'Anpachtfl�che');
INSERT INTO jagdkataster.jagdbezirkart VALUES ('jbe', 'Enklave');
INSERT INTO jagdkataster.jagdbezirkart VALUES ('jbf', 'Jagdbezirksfreie Fl�che');




-- Tabelle Jagdpaechter
-- #######################

CREATE TABLE jagdkataster.jagdpaechter
(
  id integer NOT NULL, -- entspricht Waffenbesitzer.Code in condition
  anrede character varying(10),
  nachname character varying(50),
  vorname character varying(50),
  geburtstag character varying(20),
  geburtsort character varying(50),
  strasse character varying(50),
  plz character varying(5),
  ort character varying(50),
  telefon character varying(50)
)
WITH (
  OIDS=TRUE
);
ALTER TABLE jagdkataster.jagdpaechter
  ADD CONSTRAINT jagdpaechter_pkey PRIMARY KEY(id);
COMMENT ON COLUMN jagdkataster.jagdpaechter.id IS 'entspricht Waffenbesitzer.Code in condition';



-- Tabelle Zuordnung der Paechter zur den Jagdbezirken
-- #######################

CREATE TABLE jagdkataster.jagdpaechter2bezirke
(
  bezirkid integer NOT NULL,
  paechterid integer NOT NULL
)
WITH (
  OIDS=TRUE
);
ALTER TABLE jagdkataster.jagdpaechter2bezirke
  ADD CONSTRAINT jagdpaechter2bezirke_pkey PRIMARY KEY(oid);


-- View zu den Jagdbezirken
-- #######################

CREATE OR REPLACE VIEW jagdkataster.jagdbezirk_paechter AS 
 SELECT jb.oid, jb.id, jb.name, jb.art, jb.flaeche, jpb.bezirkid, jb.concode, jb.jb_zuordnung, jb.status, jb.the_geom
   FROM jagdkataster.jagdbezirke jb
   LEFT JOIN jagdkataster.jagdpaechter2bezirke jpb ON jb.concode = cast(jpb.bezirkid as text)
  GROUP BY jb.oid, jb.id, jb.name, jb.art, jb.flaeche, jpb.bezirkid, jb.concode, jb.jb_zuordnung, jb.status, jb.the_geom;
	

-- �berspielen der vorhandenen Daten

INSERT INTO jagdkataster.jagdbezirke
SELECT id, art, flaeche, name, concode, conname, jb_zuordnung, status, verzicht, the_geom FROM jagdbezirke;

INSERT INTO jagdkataster.jagdpaechter
SELECT id, anrede, nachname, vorname, geburtstag, geburtsort, strasse, plz, ort, telefon FROM jagdpaechter;

INSERT INTO jagdkataster.jagdpaechter2bezirke
SELECT bezirkid, paechterid FROM jagdpaechter2bezirke;

-- L�schen der alten Tabellen und der Sicht

--DROP VIEW jagdbezirk_paechter;
--DROP TABLE jagdbezirke;
--DROP TABLE jagdpaechter;
--DROP TABLE jagdbezirkart;
--DROP TABLE jagdpaechter2bezirke;
	
---- Jagdkataster Ende ----


---- Nachweisverwaltung ----

CREATE SCHEMA nachweisverwaltung;

-- Antraege
CREATE TABLE nachweisverwaltung.n_antraege (
    antr_nr varchar(11) NOT NULL PRIMARY KEY,
    vermart integer,
    vermstelle integer,
    datum date
);

-- Nachweise
CREATE TABLE nachweisverwaltung.n_nachweise (
    id serial NOT NULL PRIMARY KEY,
    flurid integer NOT NULL,
    blattnummer character varying NOT NULL,
    datum date,
    vermstelle character varying,
    gueltigkeit integer,
    link_datei character varying,
    art character(3),
    format character(2),
    stammnr character varying(15)
)
WITH OIDS;
SELECT AddGeometryColumn('nachweisverwaltung', 'n_nachweise','the_geom',2398,'GEOMETRY', 2);
CREATE INDEX n_nachweise_the_geom_gist ON nachweisverwaltung.n_nachweise USING GIST (the_geom);
ALTER TABLE nachweisverwaltung.n_nachweise ADD CONSTRAINT enforce_geotype_the_geom CHECK (geometrytype(the_geom) = 'POLYGON'::text OR geometrytype(the_geom) = 'MULTIPOLYGON'::text OR the_geom IS NULL);

ALTER TABLE nachweisverwaltung.n_nachweise ADD COLUMN fortfuehrung integer;
ALTER TABLE nachweisverwaltung.n_nachweise ADD COLUMN rissnummer character varying(20);
ALTER TABLE nachweisverwaltung.n_nachweise ADD COLUMN bemerkungen text;

-- Zuordnung der Nachweise zu den Antraegen
CREATE TABLE nachweisverwaltung.n_nachweise2antraege (
    nachweis_id integer,
    antrag_id character varying(11)
);
ALTER TABLE nachweisverwaltung.n_nachweise2antraege
  ADD CONSTRAINT n_nachweise2antraege_pkey PRIMARY KEY(nachweis_id, antrag_id);

-- Vermarkungsart
CREATE TABLE nachweisverwaltung.n_vermart (
    id serial NOT NULL PRIMARY KEY,
    art character varying(50)
);

-- Vermessungsstelle
CREATE TABLE nachweisverwaltung.n_vermstelle (
    id serial NOT NULL PRIMARY KEY,
    name character varying(255)
);

CREATE TABLE nachweisverwaltung.n_dokumentarten
(
   id serial NOT NULL, 
   art character varying(100)
) 
WITH OIDS;

-- Tabelle f�r die Zuordnung von Nachweisen zu anderen Dokumentarten

CREATE TABLE nachweisverwaltung.n_nachweise2dokumentarten
(
   nachweis_id integer NOT NULL, 
   dokumentart_id integer NOT NULL
) 
WITH OIDS;

--##########################################################
--# Tabellen f�r die Punktdatei des Liegenschaftskatasters #
--##########################################################

-- Festpunkte
CREATE TABLE nachweisverwaltung.fp_punkte
(
  pkz char(16) NOT NULL PRIMARY KEY,
  rw varchar(11),
  hw varchar(11),
  hoe varchar(9),
  s varchar(4),
  zst varchar(7),
  vma varchar(3),
  bem varchar(4),
  ent varchar(15),
  unt varchar(15),
  zuo varchar(15),
  tex varchar(18),
  ls varchar(3),
  lg varchar(1),
  lz varchar(1),
  lbj varchar(3),
  lah varchar(9),
  hs varchar(15),
  hg varchar(15),
  hz varchar(15),
  hbj varchar(15),
  hah varchar(15),
  pktnr varchar(5),
  art int4 DEFAULT 0,
  datei varchar(50),
  verhandelt int4 DEFAULT 0,
  vermarkt int4 DEFAULT 0
) 
WITH OIDS;
SELECT AddGeometryColumn('nachweisverwaltung', 'fp_punkte','the_geom',2398,'POINT', 3);
CREATE INDEX fp_punkte_the_geom_gist ON nachweisverwaltung.fp_punkte USING GIST (the_geom);

CREATE TABLE nachweisverwaltung.fp_punkte2
(
  pkz char(16) NOT NULL PRIMARY KEY,
  rw varchar(11),
  hw varchar(11),
  hoe varchar(9),
  s varchar(4),
  zst varchar(7),
  vma varchar(3),
  bem varchar(4),
  ent varchar(15),
  unt varchar(15),
  zuo varchar(15),
  tex varchar(25),
  ls varchar(3),
  lg varchar(1),
  lz varchar(1),
  lbj varchar(3),
  lah varchar(9),
  hs varchar(15),
  hg varchar(15),
  hz varchar(15),
  hbj varchar(15),
  hah varchar(15),
  pktnr varchar(5),
  art int4 DEFAULT 0,
  datei varchar(50),
  verhandelt int4 DEFAULT 0,
  vermarkt int4 DEFAULT 0
) 
WITH OIDS;
SELECT AddGeometryColumn('nachweisverwaltung', 'fp_punkte2','the_geom',2399,'POINT', 3);
CREATE INDEX fp_punkte2_the_geom_gist ON nachweisverwaltung.fp_punkte2 USING GIST (the_geom);

--####################################
--# Tempor�re Tabelle f�r Punktdatei #
--####################################
CREATE TABLE nachweisverwaltung.fp_punkte_temp
(
  pkz character(16) NOT NULL,
  rw character varying(11),
  hw character varying(11),
  hoe character varying(9),
  s character varying(4),
  zst character varying(7),
  vma character varying(3),
  bem character varying(4),
  ent character varying(15),
  unt character varying(15),
  zuo character varying(15),
  tex character varying(25),
  ls character varying(3),
  lg character varying(1),
  lz character varying(1),
  lbj character varying(3),
  lah character varying(9),
  hs character varying(15),
  hg character varying(15),
  hz character varying(15),
  hbj character varying(15),
  hah character varying(15),
  pktnr character varying(5),
  art integer DEFAULT 0,
  datei character varying(50),
  verhandelt integer DEFAULT 0,
  vermarkt integer DEFAULT 0,
  the_geom geometry,
  CONSTRAINT fp_punkte_temp_pkey PRIMARY KEY (pkz ),
  CONSTRAINT enforce_dims_koordinaten CHECK (st_ndims(the_geom) = 3),
  CONSTRAINT enforce_geotype_koordinaten CHECK (geometrytype(the_geom) = 'POINT'::text OR the_geom IS NULL)
)
WITH (
  OIDS=TRUE
);

--#####################################################
--# Tabelle f�r die Zuordnung der Punkte zu Auftr�gen #
--#####################################################

-- Table: fp_punkte2antraege

CREATE TABLE nachweisverwaltung.fp_punkte2antraege
(
  pkz char(16) NOT NULL,
  antrag_nr varchar(11) NOT NULL,
  zeitstempel timestamp,
  CONSTRAINT fp_punkte2antraege_pkey PRIMARY KEY (pkz, antrag_nr)
) 
WITHOUT OIDS;


-- �berspielen der vorhandenen Daten

INSERT INTO nachweisverwaltung.n_antraege SELECT * FROM n_antraege;

INSERT INTO nachweisverwaltung.n_nachweise SELECT * FROM n_nachweise;

INSERT INTO nachweisverwaltung.n_nachweise2antraege SELECT * FROM n_nachweise2antraege;

INSERT INTO nachweisverwaltung.n_vermart SELECT * FROM n_vermart;

INSERT INTO nachweisverwaltung.n_vermstelle SELECT * FROM n_vermstelle;

INSERT INTO nachweisverwaltung.n_dokumentarten SELECT * FROM n_dokumentarten;

INSERT INTO nachweisverwaltung.n_nachweise2dokumentarten SELECT * FROM n_nachweise2dokumentarten;

INSERT INTO nachweisverwaltung.fp_punkte SELECT pkz, rw, hw, hoe, s, zst, vma, bem, ent, unt, zuo, tex, ls, lg, lz, lbj, lah, hs, hg, hz, hbj, hah, pktnr, art, datei, verhandelt, vermarkt, the_geom FROM fp_punkte;

INSERT INTO nachweisverwaltung.fp_punkte2 SELECT * FROM fp_punkte2;

INSERT INTO nachweisverwaltung.fp_punkte_temp SELECT * FROM fp_punkte_temp;

-- Updaten der Sequenzen
SELECT setval('nachweisverwaltung.n_nachweise_id_seq', (select max(id)+1 from nachweisverwaltung.n_nachweise), true);
SELECT setval('nachweisverwaltung.n_dokumentarten_id_seq', (select max(id)+1 from nachweisverwaltung.n_dokumentarten), true);
SELECT setval('nachweisverwaltung.n_vermart_id_seq', (select max(id)+1 from nachweisverwaltung.n_vermart), true);
SELECT setval('nachweisverwaltung.n_vermstelle_id_seq', (select max(id)+1 from nachweisverwaltung.n_vermstelle), true);


-- L�schen der alten Tabellen

--DROP TABLE n_antraege;
--DROP TABLE n_nachweise;
--DROP TABLE n_nachweise2antraege;
--DROP TABLE n_vermart;
--DROP TABLE n_vermstelle;
--DROP TABLE n_dokumentarten;
--DROP TABLE n_nachweise2dokumentarten;
--DROP TABLE fp_punkte;
--DROP TABLE fp_punkte2;
--DROP TABLE fp_punkte_temp;

---- Nachweisverwaltung Ende ----


---- Anliegerbeitraege ----

CREATE SCHEMA anliegerbeitraege;

CREATE TABLE anliegerbeitraege.anliegerbeitraege_bereiche
(
  id serial NOT NULL,
  flaeche real,
  kommentar character varying(255),
  CONSTRAINT anliegerbeitraege_bereiche_pkey PRIMARY KEY (id)
) 
WITH OIDS;
SELECT AddGeometryColumn('anliegerbeitraege', 'anliegerbeitraege_bereiche','the_geom',2398,'GEOMETRY', 2);

CREATE TABLE anliegerbeitraege.anliegerbeitraege_strassen
(
  id serial NOT NULL,
  CONSTRAINT anliegerbeitraege_strassen_pkey PRIMARY KEY (id)
) 
WITH OIDS;
SELECT AddGeometryColumn('anliegerbeitraege', 'anliegerbeitraege_strassen','the_geom',2398,'GEOMETRY', 2);


-- �berspielen der vorhandenen Daten

INSERT INTO anliegerbeitraege.anliegerbeitraege_bereiche SELECT id, flaeche, kommentar, the_geom FROM anliegerbeitraege_bereiche;

INSERT INTO anliegerbeitraege.anliegerbeitraege_strassen SELECT * FROM anliegerbeitraege_strassen;

-- Updaten der Sequenzen
SELECT setval('anliegerbeitraege.anliegerbeitraege_bereiche_id_seq', (select max(id)+1 from anliegerbeitraege.anliegerbeitraege_bereiche), true);
SELECT setval('anliegerbeitraege.anliegerbeitraege_strassen_id_seq', (select max(id)+1 from anliegerbeitraege.anliegerbeitraege_strassen), true);



-- L�schen der alten Tabellen

--DROP TABLE anliegerbeitraege_bereiche;
--DROP TABLE anliegerbeitraege_strassen;

---- Anliegerbeitraege Ende ----


---- ProBauG ----

CREATE SCHEMA probaug;

--# Tabelle zur Speicherung der Gemarkungsnummer-zu-Gemarkungsschl�ssel-Beziehung f�r die Bauauskunft

CREATE TABLE probaug.bau_gemarkungen
(
  nummer int8 NOT NULL,
  schluessel int8 NOT NULL
) 
WITH OIDS;


--###########################
--# Tabelle f�r Bauaktendaten
--# 2006-01-26 pk
CREATE TABLE probaug.bau_akten
(
  feld1 integer,
  feld2 integer,
  feld3 integer,
  feld4 text,
  feld5 text,
  feld6 text,
  feld7 text,
  feld8 text,
  feld9 text,
  feld10 text,
  feld11 text,
  feld12 text,
  feld13 text,
  feld14 text,
  feld15 text,
  feld16 text,
  feld17 text,
  feld18 text,
  feld19 text,
  feld20 text,
  feld21 text,
  feld22 text,
  feld23 integer,
  feld24 text,
  feld25 text,
  feld26 text
)
WITH (
  OIDS=TRUE
);

--# Hinzuf�gen der Tabellen bau_verfahrensart und bau_vorhaben, in denen die zur Auswahl stehenden Werte f�r das Vorhaben und die Verfahrensart bei der Bauauskunftssuche gespeichert sind
CREATE TABLE probaug.bau_verfahrensart
(
  verfahrensart text,
  id serial NOT NULL
) 
WITH OIDS;

CREATE TABLE probaug.bau_vorhaben
(
  vorhaben text,
  id serial NOT NULL
) 
WITH OIDS;


-- �berspielen der vorhandenen Daten

INSERT INTO probaug.bau_gemarkungen SELECT * FROM bau_gemarkungen;
INSERT INTO probaug.bau_akten SELECT * FROM bau_akten;
INSERT INTO probaug.bau_verfahrensart SELECT * FROM bau_verfahrensart;
INSERT INTO probaug.bau_vorhaben SELECT * FROM bau_vorhaben;


-- Updaten der Sequenzen
SELECT setval('probaug.bau_verfahrensart_id_seq', (select max(id)+1 from probaug.bau_verfahrensart), true);
SELECT setval('probaug.bau_vorhaben_id_seq', (select max(id)+1 from probaug.bau_vorhaben), true);


-- L�schen der alten Tabellen

--DROP TABLE bau_gemarkungen;
--DROP TABLE bau_akten;
--DROP TABLE bau_verfahrensart;
--DROP TABLE bau_vorhaben;

---- ProBauG Ende ----
