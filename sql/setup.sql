--   This program is free software; you can redistribute it and/or modify  *
--   it under the terms of the is licensed under the BSD 3-Clause "New" or
--   "Revised" License.
CREATE TABLE soil (
 id           serial,   
 project      varchar(50), 
 target       varchar(50), 
 point        varchar(50) NOT NULL UNIQUE,
 sample       varchar(50) UNIQUE,
 duplicate    varchar(50),
 blank        varchar(50),
 standard     varchar(50),
 resample     varchar(50),
 type0        varchar(50),
 utme         numeric(15,7) NOT NULL,
 utmn         numeric(15,7) NOT NULL,
 elev         numeric(7,3) NOT NULL, 
 geom         geometry(POINTZ,32723), --Adjust to project SRID
 datum 	  varchar(50) NOT NULL DEFAULT 'WGS84',
 _zone 	  integer NOT NULL DEFAULT 23,--Adjust to Project UTM ZONE
 ns 		  varchar(2) NOT NULL DEFAULT 'S', --S  South e N  North
 prfltype     varchar(50),              
 depthm       numeric(7,2),          
 colour       varchar(50),
 sampletype   varchar(50),
 granul       varchar(50),
 morpho       varchar(50),
 fragments    varchar(50),
 magnetism    varchar(50),
 vegetation   text,
 weigth 	  numeric(6,2),
 resp 	  varchar(50), 
 _date        date,                 
 obs          text,  
 sampled      boolean,  
 tstp         timestamp NOT NULL DEFAULT now(),
 who          varchar(50)  NOT NULL
);

CREATE TABLE strmsed (
 id           serial,   
 project      varchar(50), 
 target       varchar(50), 
 point        varchar(50) NOT NULL UNIQUE,
 sample       varchar(50) UNIQUE,
 duplicate    varchar(50),
 blank        varchar(50),
 standard     varchar(50),
 resample     varchar(50),
 type0        varchar(50),
 utme         numeric(15,7) NOT NULL,
 utmn         numeric(15,7) NOT NULL,
 elev         numeric(7,3) NOT NULL, 
 geom         geometry(POINTZ,32723), --Adjust to project SRID
 datum 	  varchar(50) NOT NULL DEFAULT 'WGS84',
 _zone 	  integer NOT NULL DEFAULT 23,--Adjust to Project UTM ZONE
 ns 		  varchar(2) NOT NULL DEFAULT 'S', --S  South e N  North
 descr	  text, 
 concentrad   boolean, 
 fragments    text,
 matrix	  text,
 comp_frag    text,
 compactatn   text,
 environ	  text,
 resp 	  varchar(50), 
 _date        date,                 
 obs          text,  
 colected     boolean,  
 tstp         timestamp NOT NULL DEFAULT now(),
 who          varchar(50)  NOT NULL
);

CREATE TABLE augerheader (
 id         serial,   
 project  	varchar(50), 
 target     varchar(50), 
 drillhole  varchar(100) NOT NULL UNIQUE,
 utme    	numeric(15,7) NOT NULL,
 utmn    	numeric(15,7) NOT NULL,
 elev     	numeric(7,3) NOT NULL, 
 geom       geometry(POINTZ,32723), --Adjust to project SRID
 datum 	varchar(50) NOT NULL DEFAULT 'WGS84',
 _zone 	integer NOT NULL DEFAULT 23,--Adjust to Project UTM ZONE
 ns 		varchar(2) NOT NULL DEFAULT 'S', --S  South e N  North
 resp     	varchar(50), 
 _start   	date,  
 _end      	date,               
 totdpth  	numeric(6,3),  
 status   	integer NOT NULL DEFAULT 0,
 stpat   	integer NOT NULL DEFAULT 0,
 obs      	text,
 tstp     	timestamp NOT NULL DEFAULT now(),
 who      	varchar(50)  NOT NULL
);

CREATE TABLE augerinterval (
   id          serial,   
   drillhole   varchar(100) NOT NULL,
   sample      varchar(100),
   advance     numeric(7,2)NOT NULL,
   _from       numeric(7,2)NOT NULL,  
   _to         numeric(7,2)NOT NULL, 
   waterat     numeric(7,2),   
   descr       text,
   weight      numeric(7,3),
   diametre	   numeric(7,3),
   lithocode   varchar(50),
   resp 	   varchar(50),                     
   tstp        timestamp NOT NULL DEFAULT now(),
   who         varchar(50)  NOT NULL,
   UNIQUE(drillhole,sample,_from)
 );
CREATE TABLE geopoint (
   id         serial,   
   project    varchar(50), 
   target     varchar(50), 
   ptgeo      varchar(100) NOT NULL UNIQUE,
   utme       numeric(15,7) NOT NULL,
   utmn       numeric(15,7) NOT NULL,
   elev       numeric(7,3) NOT NULL, 
   geom       geometry(POINTZ,32723), --Adjust to project SRID
   datum 	  varchar(50) NOT NULL DEFAULT 'WGS84',
   _zone 	  integer NOT NULL DEFAULT 23,--Adjust to Project UTM ZONE
   ns 	  varchar(2) NOT NULL DEFAULT 'S', --S  South e N  North
   outcrptype varchar(50),
   morpho	  varchar(50),
   lithology  varchar(200),
   descr      text,
   lithocode  varchar(15),
   resp 	  varchar(50), 
   _date      date,                  
   tstp       timestamp NOT NULL DEFAULT now(),
   who        varchar(50)  NOT NULL
);



CREATE TABLE rock (
   id           serial,   
   ptgeo        varchar(100) NOT NULL,
   sample       varchar(100) UNIQUE,
   duplicate    varchar(100),
   blank        varchar(100),
   standard     varchar(100),
   resample     varchar(100),
   sampletype2  varchar(100),
   outcrop      varchar(100),
   litho 	    varchar(100),
   descr 	    text,
   magnetism    varchar(100),
   resp 	    varchar(50),              
   obs          text,  
   sampled      boolean,  
   tstp         timestamp NOT NULL DEFAULT now(),
   who          varchar(50)  NOT NULL
);

CREATE TABLE geoptadd (
   id           serial,   
   ptgeo        varchar(100) NOT NULL UNIQUE,
   type3	    varchar(50),
--type 	Mineralization, alteration, structural
   descr	    text,
   intensity    varchar(50),
   rank         integer,
   mineral1     varchar(200),
   mineral2     varchar(200),
   mineral3     varchar(200),
   alteration   varchar(100),
   minerlztn    varchar(100),
   dip          numeric(6,2),
   dipdir       numeric(6,2),
   type1        varchar(50),
   type2        varchar(50),
   resp 	    varchar(50),                
   tstp         timestamp NOT NULL DEFAULT now(),
   who          varchar(50)  NOT NULL
);


CREATE USER gdatasystems WITH PASSWORD 'secret';
GRANT SELECT,INSERT,UPDATE,DELETE ON soil TO gdatasystems;
GRANT SELECT,UPDATE ON soil_id_seq TO gdatasystems;
GRANT SELECT,INSERT,UPDATE,DELETE ON strmsed TO gdatasystems;
GRANT SELECT,UPDATE ON strmsed_id_seq TO gdatasystems;
GRANT SELECT,INSERT,UPDATE,DELETE ON augerheader TO gdatasystems;
GRANT SELECT,UPDATE ON augerheader_id_seq TO gdatasystems;
GRANT SELECT,INSERT,UPDATE,DELETE ON augerinterval TO gdatasystems;
GRANT SELECT,UPDATE ON augerinterval_id_seq TO gdatasystems;
GRANT SELECT,INSERT,UPDATE,DELETE ON geopoint TO gdatasystems;
GRANT SELECT,UPDATE ON geopoint_id_seq TO gdatasystems;
GRANT SELECT,INSERT,UPDATE,DELETE ON rock TO gdatasystems;
GRANT SELECT,UPDATE ON rock_id_seq TO gdatasystems;
GRANT SELECT,INSERT,UPDATE,DELETE ON geoptadd TO gdatasystems;
GRANT SELECT,UPDATE ON geoptadd_id_seq TO gdatasystems;

CREATE TABLE lookup (
field 	varchar(100),
code 	      integer, 
text1 	varchar(200),
UNIQUE(field,code)
); 
INSERT INTO lookup VALUES('type0',1,'ORIGINAL');        
INSERT INTO lookup VALUES('type0',2,'QAQC');        
INSERT INTO lookup VALUES('status',1,'LOCATION');        
INSERT INTO lookup VALUES('status',2,'EXECUTING');        
INSERT INTO lookup VALUES('status',3,'HALTED');        
INSERT INTO lookup VALUES('status',4,'CONCLUDED');        
INSERT INTO lookup VALUES('status',5,'CANCELED');        
INSERT INTO lookup VALUES('stpat',1,'OTHER');        
INSERT INTO lookup VALUES('stpat',2,'FRESH ROCK');        
INSERT INTO lookup VALUES('stpat',3,'WATER TABLE');        
INSERT INTO lookup VALUES('stpat',4,'DEPTH');        
INSERT INTO lookup VALUES('ns',1,'S');
INSERT INTO lookup VALUES('ns',2,'N');
INSERT INTO lookup VALUES('prfltype',1,'HOR. B');        
INSERT INTO lookup VALUES('prfltype',2,'HOR. A');        
INSERT INTO lookup VALUES('prfltype',3,'REGOLITH');        
INSERT INTO lookup VALUES('sampletype',1,'GRID');        
INSERT INTO lookup VALUES('sampletype',2,'PUNCTUAL');        
INSERT INTO lookup VALUES('granul',1,'CLAY');        
INSERT INTO lookup VALUES('granul',2,'SILT');        
INSERT INTO lookup VALUES('granul',3,'SAND');        
INSERT INTO lookup VALUES('granul',4,'PEBBLE');        
INSERT INTO lookup VALUES('granul',5,'GRAVEL');        
INSERT INTO lookup VALUES('morpho',1,'FLATLAND');        
INSERT INTO lookup VALUES('morpho',2,'PLATEAU');        
INSERT INTO lookup VALUES('morpho',3,'VALE');        
INSERT INTO lookup VALUES('morpho',4,'SLOPE');        
INSERT INTO lookup VALUES('fragments',1,'NONE');        
INSERT INTO lookup VALUES('fragments',2,'LITTLE');        
INSERT INTO lookup VALUES('fragments',3,'MEDIUM');        
INSERT INTO lookup VALUES('fragments',4,'ABUNDANT');             
INSERT INTO lookup VALUES('colour',1,'WHITE');        
INSERT INTO lookup VALUES('colour',2,'BEIGE');         
INSERT INTO lookup VALUES('colour',3,'YELLOW');        
INSERT INTO lookup VALUES('colour',4,'ORANGE');        
INSERT INTO lookup VALUES('colour',5,'GREEN');        
INSERT INTO lookup VALUES('colour',6,'GREENISH');        
INSERT INTO lookup VALUES('colour',7,'REDISH');         
INSERT INTO lookup VALUES('colour',8,'RED');        
INSERT INTO lookup VALUES('colour',9,'BROWN');        
INSERT INTO lookup VALUES('colour',10,'DARK GRAY');        
INSERT INTO lookup VALUES('colour',11,'GRAY');        
INSERT INTO lookup VALUES('colour',12,'LIGHT GRAY');        
INSERT INTO lookup VALUES('colour',13,'BLACK');        
INSERT INTO lookup VALUES('Vegetation',1,'N.A.');        
INSERT INTO lookup VALUES('Vegetation',2,'GRASSLAND');        
INSERT INTO lookup VALUES('Vegetation',3,'SAVANNA');        
INSERT INTO lookup VALUES('Vegetation',4,'WOODLAND');        
INSERT INTO lookup VALUES('Vegetation',5,'JUNGLE');        
INSERT INTO lookup VALUES('Vegetation',6,'RIPARIAN FORREST');        
INSERT INTO lookup VALUES('Vegetation',7,'BOREAL FORREST');        
INSERT INTO lookup VALUES('Vegetation',8,'TUNDRA');        
INSERT INTO lookup VALUES('Vegetation',9,'DESERT'); 
INSERT INTO lookup VALUES('sampletype2',1,'OUTCROP');        
INSERT INTO lookup VALUES('sampletype2',2,'GRAB');        
INSERT INTO lookup VALUES('sampletype2',3,'CHIP ROCK');        
INSERT INTO lookup VALUES('alteration',1,'NONE');        
INSERT INTO lookup VALUES('alteration',2,'POTASSIC');        
INSERT INTO lookup VALUES('alteration',3,'PHYLLIC/SERICITIC');       
INSERT INTO lookup VALUES('alteration',4,'PROPYLITIC');        
INSERT INTO lookup VALUES('alteration',5,'ARGILIC');        
INSERT INTO lookup VALUES('alteration',6,'CHLORITIC');        
INSERT INTO lookup VALUES('alteration',7,'SILICATION');        
INSERT INTO lookup VALUES('alteration',8,'SILICIFICATION');        
INSERT INTO lookup VALUES('alteration',9,'CARBONATIZATION');        
INSERT INTO lookup VALUES('alteration',10,'GREISENIZATION');           
INSERT INTO lookup VALUES('alteration',11,'HEMATIZATION');        
INSERT INTO lookup VALUES('mineralztn',1,'NONE');        
INSERT INTO lookup VALUES('mineralztn',2,'WEAK');        
INSERT INTO lookup VALUES('mineralztn',3,'MODERATE');        
INSERT INTO lookup VALUES('mineralztn',4,'STRONG');        
INSERT INTO lookup VALUES('magnetism',1,'NONE');        
INSERT INTO lookup VALUES('magnetism',2,'WEAK');        
INSERT INTO lookup VALUES('magnetism',3,'MODERATE');        
INSERT INTO lookup VALUES('magnetism',4,'STRONG');        
INSERT INTO lookup VALUES('type3',1,'MINERALIZATION');        
INSERT INTO lookup VALUES('type3',2,'ALTERATION');        
INSERT INTO lookup VALUES('type3',3,'STRUCTURAL');        
INSERT INTO lookup VALUES('rank',1,'1');       
INSERT INTO lookup VALUES('rank',2,'2');       
INSERT INTO lookup VALUES('rank',3,'3');       
INSERT INTO lookup VALUES('type1',1,'N.A.');        
INSERT INTO lookup VALUES('type1',2,'S0');        
INSERT INTO lookup VALUES('type1',3,'SN');        
INSERT INTO lookup VALUES('type1',4,'SN+1');        
INSERT INTO lookup VALUES('type1',5,'SN+2');        
INSERT INTO lookup VALUES('type1',6,'SN-1');       
INSERT INTO lookup VALUES('type1',7,'SN-2');        
INSERT INTO lookup VALUES('type1',8,'SC');        
INSERT INTO lookup VALUES('type1',9,'FRACTURE');        
INSERT INTO lookup VALUES('type1',10,'DIKE');        
INSERT INTO lookup VALUES('type1',11,'VEIN');        
INSERT INTO lookup VALUES('type1',12,'LINEATION');        
INSERT INTO lookup VALUES('type1',13,'FAULT');        
INSERT INTO lookup VALUES('type1',14,'FOLD AXIS');        
INSERT INTO lookup VALUES('type2',1,'N.A.');       
INSERT INTO lookup VALUES('type2',2,'NORMAL FAULT');       
INSERT INTO lookup VALUES('type2',3,'REVERSE FAULT');       
INSERT INTO lookup VALUES('type2',4,'STRIKE-SLIP FAULT');       
INSERT INTO lookup VALUES('type2',5,'OBLIQUE FAULT');       
INSERT INTO lookup VALUES('type2',6,'THRUST FAULT');       
INSERT INTO lookup VALUES('type2',7,'MINERAL LINEATION');       
INSERT INTO lookup VALUES('type2',8,'GRAIN LINEATION');        
INSERT INTO lookup VALUES('type2',9,'PLATELET LINEATION');       
INSERT INTO lookup VALUES('type2',10,'CRENULATION LINEATION');       
INSERT INTO lookup VALUES('type2',11,'INTERSECTION LINEATION');       
INSERT INTO lookup VALUES('type2',12,'OPEN FRACTURE');       
INSERT INTO lookup VALUES('type2',13,'CLOSED FRACTURE');       
INSERT INTO lookup VALUES('type2',14,'FILLED FRACTURE');       
INSERT INTO lookup VALUES('intensity',1,'N.A.');       
INSERT INTO lookup VALUES('intensity',2,'WEAK');        
INSERT INTO lookup VALUES('intensity',3,'MODERATE');        
INSERT INTO lookup VALUES('intensity',4,'STRONG'); 
INSERT INTO lookup VALUES('mineral',1,'Abelsonite');
INSERT INTO lookup VALUES('mineral',2,'Abenakiite-(Ce)');
INSERT INTO lookup VALUES('mineral',3,'Abernathyite');
INSERT INTO lookup VALUES('mineral',4,'Abhurite');
INSERT INTO lookup VALUES('mineral',5,'Abswurmbachite');
INSERT INTO lookup VALUES('mineral',6,'Actinolite');
INSERT INTO lookup VALUES('mineral',7,'Acuminite');
INSERT INTO lookup VALUES('mineral',8,'Adamite');
INSERT INTO lookup VALUES('mineral',9,'Adamsite-(Y)');
INSERT INTO lookup VALUES('mineral',10,'Adelite');
INSERT INTO lookup VALUES('mineral',11,'Admontite');
INSERT INTO lookup VALUES('mineral',12,'Aegirine');
INSERT INTO lookup VALUES('mineral',13,'Aenigmatite');
INSERT INTO lookup VALUES('mineral',14,'Aerinite');
INSERT INTO lookup VALUES('mineral',15,'Aerugite');
INSERT INTO lookup VALUES('mineral',16,'Aeschynite-(Ce)');
INSERT INTO lookup VALUES('mineral',17,'Aeschynite-(Nd)');
INSERT INTO lookup VALUES('mineral',18,'Aeschynite-(Y)');
INSERT INTO lookup VALUES('mineral',19,'Aetites');
INSERT INTO lookup VALUES('mineral',20,'Afghanite');
INSERT INTO lookup VALUES('mineral',21,'Afwillite');
INSERT INTO lookup VALUES('mineral',22,'Agardite');
INSERT INTO lookup VALUES('mineral',23,'Agrellite');
INSERT INTO lookup VALUES('mineral',24,'Agrinierite');
INSERT INTO lookup VALUES('mineral',25,'Aguilarite');
INSERT INTO lookup VALUES('mineral',26,'Aheylite');
INSERT INTO lookup VALUES('mineral',27,'Ahlfeldite');
INSERT INTO lookup VALUES('mineral',28,'Aikinite');
INSERT INTO lookup VALUES('mineral',29,'Ajoite');
INSERT INTO lookup VALUES('mineral',30,'Akaganéite');
INSERT INTO lookup VALUES('mineral',31,'Akatoreite');
INSERT INTO lookup VALUES('mineral',32,'Akdalaite');
INSERT INTO lookup VALUES('mineral',33,'Åkermanite');
INSERT INTO lookup VALUES('mineral',34,'Aksaite');
INSERT INTO lookup VALUES('mineral',35,'Alabandite');
INSERT INTO lookup VALUES('mineral',36,'Alamosite');
INSERT INTO lookup VALUES('mineral',37,'Alarsite');
INSERT INTO lookup VALUES('mineral',38,'Albite');
INSERT INTO lookup VALUES('mineral',39,'Alforsite');
INSERT INTO lookup VALUES('mineral',40,'Algodonite');
INSERT INTO lookup VALUES('mineral',41,'Aliettite');
INSERT INTO lookup VALUES('mineral',42,'Allanite');
INSERT INTO lookup VALUES('mineral',43,'Alloclasite');
INSERT INTO lookup VALUES('mineral',44,'Allophane');
INSERT INTO lookup VALUES('mineral',45,'Almandine');
INSERT INTO lookup VALUES('mineral',46,'Alstonite');
INSERT INTO lookup VALUES('mineral',47,'Altaite');
INSERT INTO lookup VALUES('mineral',48,'Aluminite');
INSERT INTO lookup VALUES('mineral',49,'Aluminium');
INSERT INTO lookup VALUES('mineral',50,'Alunite');
INSERT INTO lookup VALUES('mineral',51,'Alunogen');
INSERT INTO lookup VALUES('mineral',52,'Amblygonite');
INSERT INTO lookup VALUES('mineral',53,'Ameghinite');
INSERT INTO lookup VALUES('mineral',54,'Amphibole');
INSERT INTO lookup VALUES('mineral',55,'Analcite');
INSERT INTO lookup VALUES('mineral',56,'Anatase');
INSERT INTO lookup VALUES('mineral',57,'Andalusite');
INSERT INTO lookup VALUES('mineral',58,'Andesine');
INSERT INTO lookup VALUES('mineral',59,'Andradite');
INSERT INTO lookup VALUES('mineral',60,'Anglesite');
INSERT INTO lookup VALUES('mineral',61,'Anhydrite');
INSERT INTO lookup VALUES('mineral',62,'Ankerite');
INSERT INTO lookup VALUES('mineral',63,'Annabergite');
INSERT INTO lookup VALUES('mineral',64,'Anorthite');
INSERT INTO lookup VALUES('mineral',65,'Anorthoclase');
INSERT INTO lookup VALUES('mineral',66,'Anthophyllite');
INSERT INTO lookup VALUES('mineral',67,'Antigorite');
INSERT INTO lookup VALUES('mineral',68,'Antimony');
INSERT INTO lookup VALUES('mineral',69,'Antitaenite');
INSERT INTO lookup VALUES('mineral',70,'Antlerite');
INSERT INTO lookup VALUES('mineral',71,'Apatite');
INSERT INTO lookup VALUES('mineral',72,'Apophyllite');
INSERT INTO lookup VALUES('mineral',73,'Aragonite');
INSERT INTO lookup VALUES('mineral',74,'Archerite');
INSERT INTO lookup VALUES('mineral',75,'Arctite');
INSERT INTO lookup VALUES('mineral',76,'Arcubisite');
INSERT INTO lookup VALUES('mineral',77,'Arfvedsonite');
INSERT INTO lookup VALUES('mineral',78,'Argentite');
INSERT INTO lookup VALUES('mineral',79,'Argutite');
INSERT INTO lookup VALUES('mineral',80,'Armalcolite');
INSERT INTO lookup VALUES('mineral',81,'Arsenic');
INSERT INTO lookup VALUES('mineral',82,'Arsenopyrite');
INSERT INTO lookup VALUES('mineral',83,'Arthurite');
INSERT INTO lookup VALUES('mineral',84,'Artinite');
INSERT INTO lookup VALUES('mineral',85,'Artroeite');
INSERT INTO lookup VALUES('mineral',86,'Asisite');
INSERT INTO lookup VALUES('mineral',87,'Astrophyllite');
INSERT INTO lookup VALUES('mineral',88,'Atacamite');
INSERT INTO lookup VALUES('mineral',89,'Atheneite');
INSERT INTO lookup VALUES('mineral',90,'Aubertite');
INSERT INTO lookup VALUES('mineral',91,'Augelite');
INSERT INTO lookup VALUES('mineral',92,'Augite');
INSERT INTO lookup VALUES('mineral',93,'Aurichalcite');
INSERT INTO lookup VALUES('mineral',94,'Auricupride');
INSERT INTO lookup VALUES('mineral',95,'Aurostibite');
INSERT INTO lookup VALUES('mineral',96,'Autunite');
INSERT INTO lookup VALUES('mineral',97,'Axinite');
INSERT INTO lookup VALUES('mineral',98,'Azurite');
INSERT INTO lookup VALUES('mineral',99,'Babingtonite');
INSERT INTO lookup VALUES('mineral',100,'Baddeleyite');
INSERT INTO lookup VALUES('mineral',101,'Baotite');
INSERT INTO lookup VALUES('mineral',102,'Barite');
INSERT INTO lookup VALUES('mineral',103,'Barstowite');
INSERT INTO lookup VALUES('mineral',104,'Barytocalcite');
INSERT INTO lookup VALUES('mineral',105,'Bastnäsit');
INSERT INTO lookup VALUES('mineral',106,'Bazzite');
INSERT INTO lookup VALUES('mineral',107,'Benitoite');
INSERT INTO lookup VALUES('mineral',108,'Bensonite');
INSERT INTO lookup VALUES('mineral',109,'Bentorite');
INSERT INTO lookup VALUES('mineral',110,'Berryite');
INSERT INTO lookup VALUES('mineral',111,'Berthierite');
INSERT INTO lookup VALUES('mineral',112,'Bertrandite');
INSERT INTO lookup VALUES('mineral',113,'Beryl');
INSERT INTO lookup VALUES('mineral',114,'Beryllonite');
INSERT INTO lookup VALUES('mineral',115,'Biotite');
INSERT INTO lookup VALUES('mineral',116,'Birnessite');
INSERT INTO lookup VALUES('mineral',117,'Bismite');
INSERT INTO lookup VALUES('mineral',118,'Bismuth');
INSERT INTO lookup VALUES('mineral',119,'Bismuthinite');
INSERT INTO lookup VALUES('mineral',120,'Bixbyite');
INSERT INTO lookup VALUES('mineral',121,'Blödite');
INSERT INTO lookup VALUES('mineral',122,'Blossite');
INSERT INTO lookup VALUES('mineral',123,'Boehmite');
INSERT INTO lookup VALUES('mineral',124,'Boracite');
INSERT INTO lookup VALUES('mineral',125,'Borax');
INSERT INTO lookup VALUES('mineral',126,'Bornite');
INSERT INTO lookup VALUES('mineral',127,'Botryogen');
INSERT INTO lookup VALUES('mineral',128,'Boulangerite');
INSERT INTO lookup VALUES('mineral',129,'Bournonite');
INSERT INTO lookup VALUES('mineral',130,'Brammallite');
INSERT INTO lookup VALUES('mineral',131,'Brassite');
INSERT INTO lookup VALUES('mineral',132,'Braunite');
INSERT INTO lookup VALUES('mineral',133,'Brazilianite');
INSERT INTO lookup VALUES('mineral',134,'Breithauptite');
INSERT INTO lookup VALUES('mineral',135,'Brewsterite');
INSERT INTO lookup VALUES('mineral',136,'Brianite');
INSERT INTO lookup VALUES('mineral',137,'Briartite');
INSERT INTO lookup VALUES('mineral',138,'Brochantite');
INSERT INTO lookup VALUES('mineral',139,'Brookite');
INSERT INTO lookup VALUES('mineral',140,'Bromargyrite');
INSERT INTO lookup VALUES('mineral',141,'Bromellite');
INSERT INTO lookup VALUES('mineral',142,'Bronzite');
INSERT INTO lookup VALUES('mineral',143,'Brucite');
INSERT INTO lookup VALUES('mineral',144,'Brushite');
INSERT INTO lookup VALUES('mineral',145,'Buddingtonite');
INSERT INTO lookup VALUES('mineral',146,'Buergerite');
INSERT INTO lookup VALUES('mineral',147,'Bukovskyite');
INSERT INTO lookup VALUES('mineral',148,'Bytownite');
INSERT INTO lookup VALUES('mineral',149,'Cabriite');
INSERT INTO lookup VALUES('mineral',150,'Cadmium');
INSERT INTO lookup VALUES('mineral',151,'Cafetite');
INSERT INTO lookup VALUES('mineral',152,'Calaverite');
INSERT INTO lookup VALUES('mineral',153,'Calcite');
INSERT INTO lookup VALUES('mineral',154,'Cancrinite');
INSERT INTO lookup VALUES('mineral',155,'Calderite');
INSERT INTO lookup VALUES('mineral',156,'Caledonite');
INSERT INTO lookup VALUES('mineral',157,'Cancrinite');
INSERT INTO lookup VALUES('mineral',158,'Canfieldite');
INSERT INTO lookup VALUES('mineral',159,'Carnallite');
INSERT INTO lookup VALUES('mineral',160,'Carnotite');
INSERT INTO lookup VALUES('mineral',161,'Carobbiite');
INSERT INTO lookup VALUES('mineral',162,'Carrollite');
INSERT INTO lookup VALUES('mineral',163,'Cassiterite');
INSERT INTO lookup VALUES('mineral',164,'Cavansite');
INSERT INTO lookup VALUES('mineral',165,'Celadonite');
INSERT INTO lookup VALUES('mineral',166,'Celestine');
INSERT INTO lookup VALUES('mineral',167,'Celsian');
INSERT INTO lookup VALUES('mineral',168,'Cementite');
INSERT INTO lookup VALUES('mineral',169,'Cerite');
INSERT INTO lookup VALUES('mineral',170,'Cerussite');
INSERT INTO lookup VALUES('mineral',171,'Cesbronite');
INSERT INTO lookup VALUES('mineral',172,'Ceylonite');
INSERT INTO lookup VALUES('mineral',173,'Chabazite');
INSERT INTO lookup VALUES('mineral',174,'Chalcanthite');
INSERT INTO lookup VALUES('mineral',175,'Chalcocite');
INSERT INTO lookup VALUES('mineral',176,'Chalcopyrite');
INSERT INTO lookup VALUES('mineral',177,'Challacolloite');
INSERT INTO lookup VALUES('mineral',178,'Chaoite');
INSERT INTO lookup VALUES('mineral',179,'Chapmanite');
INSERT INTO lookup VALUES('mineral',180,'Charoite');
INSERT INTO lookup VALUES('mineral',181,'Childrenite');
INSERT INTO lookup VALUES('mineral',182,'Chlorargyrite');
INSERT INTO lookup VALUES('mineral',183,'Chlorastrolite');
INSERT INTO lookup VALUES('mineral',184,'Chlorite');
INSERT INTO lookup VALUES('mineral',185,'Chloritoid');
INSERT INTO lookup VALUES('mineral',186,'Chondrodite');
INSERT INTO lookup VALUES('mineral',187,'Chromite');
INSERT INTO lookup VALUES('mineral',188,'Chromium');
INSERT INTO lookup VALUES('mineral',189,'Chrysoberyl');
INSERT INTO lookup VALUES('mineral',190,'Chrysocolla');
INSERT INTO lookup VALUES('mineral',191,'Cinnabar');
INSERT INTO lookup VALUES('mineral',192,'Clarkeite');
INSERT INTO lookup VALUES('mineral',193,'Clinochrysotile');
INSERT INTO lookup VALUES('mineral',194,'Clinoclase');
INSERT INTO lookup VALUES('mineral',195,'Clinohedrite');
INSERT INTO lookup VALUES('mineral',196,'Clinohumite');
INSERT INTO lookup VALUES('mineral',197,'Clinoptilolite');
INSERT INTO lookup VALUES('mineral',198,'Clinozoisite');
INSERT INTO lookup VALUES('mineral',199,'Clintonite');
INSERT INTO lookup VALUES('mineral',200,'Cobaltite');
INSERT INTO lookup VALUES('mineral',201,'Coesite');
INSERT INTO lookup VALUES('mineral',202,'Coffinite');
INSERT INTO lookup VALUES('mineral',203,'Colemanite');
INSERT INTO lookup VALUES('mineral',204,'Coloradoite');
INSERT INTO lookup VALUES('mineral',205,'Columbite');
INSERT INTO lookup VALUES('mineral',206,'Combeite');
INSERT INTO lookup VALUES('mineral',207,'Connellite');
INSERT INTO lookup VALUES('mineral',208,'Cooperite');
INSERT INTO lookup VALUES('mineral',209,'Copiapite');
INSERT INTO lookup VALUES('mineral',210,'Copper');
INSERT INTO lookup VALUES('mineral',211,'Corderoite');
INSERT INTO lookup VALUES('mineral',212,'Cordierite');
INSERT INTO lookup VALUES('mineral',213,'Corundum');
INSERT INTO lookup VALUES('mineral',214,'Covellite');
INSERT INTO lookup VALUES('mineral',215,'Creedite');
INSERT INTO lookup VALUES('mineral',216,'Cristobalite');
INSERT INTO lookup VALUES('mineral',217,'Crocoite');
INSERT INTO lookup VALUES('mineral',218,'Cronstedtite');
INSERT INTO lookup VALUES('mineral',219,'Crookesite');
INSERT INTO lookup VALUES('mineral',220,'Crossite');
INSERT INTO lookup VALUES('mineral',221,'Cryolite');
INSERT INTO lookup VALUES('mineral',222,'Cumberlandite');
INSERT INTO lookup VALUES('mineral',223,'Cummingtonite');
INSERT INTO lookup VALUES('mineral',224,'Cuprite');
INSERT INTO lookup VALUES('mineral',225,'Cyanotrichite');
INSERT INTO lookup VALUES('mineral',226,'Cylindrite');
INSERT INTO lookup VALUES('mineral',227,'Danburite');
INSERT INTO lookup VALUES('mineral',228,'Datolite');
INSERT INTO lookup VALUES('mineral',229,'Davidite');
INSERT INTO lookup VALUES('mineral',230,'Dawsonite');
INSERT INTO lookup VALUES('mineral',231,'Delvauxite');
INSERT INTO lookup VALUES('mineral',232,'Descloizite');
INSERT INTO lookup VALUES('mineral',233,'Diadochite');
INSERT INTO lookup VALUES('mineral',234,'Diamond');
INSERT INTO lookup VALUES('mineral',235,'Diaspore');
INSERT INTO lookup VALUES('mineral',236,'Dickite');
INSERT INTO lookup VALUES('mineral',237,'Digenite');
INSERT INTO lookup VALUES('mineral',238,'Diopside');
INSERT INTO lookup VALUES('mineral',239,'Dioptase');
INSERT INTO lookup VALUES('mineral',240,'Djurleite');
INSERT INTO lookup VALUES('mineral',241,'Dolomite');
INSERT INTO lookup VALUES('mineral',242,'Domeykite');
INSERT INTO lookup VALUES('mineral',243,'Dumortierite');
INSERT INTO lookup VALUES('mineral',244,'Edingtonite');
INSERT INTO lookup VALUES('mineral',245,'Ekanite');
INSERT INTO lookup VALUES('mineral',246,'Elbaite');
INSERT INTO lookup VALUES('mineral',247,'Elsmoreite');
INSERT INTO lookup VALUES('mineral',248,'Emery (mineral)');
INSERT INTO lookup VALUES('mineral',249,'Empressite');
INSERT INTO lookup VALUES('mineral',250,'Enargite');
INSERT INTO lookup VALUES('mineral',251,'Enstatite');
INSERT INTO lookup VALUES('mineral',252,'Eosphorite');
INSERT INTO lookup VALUES('mineral',253,'Epidote');
INSERT INTO lookup VALUES('mineral',254,'Epsomite');
INSERT INTO lookup VALUES('mineral',255,'Erythrite');
INSERT INTO lookup VALUES('mineral',256,'Esperite');
INSERT INTO lookup VALUES('mineral',257,'Ettringite');
INSERT INTO lookup VALUES('mineral',258,'Euchroite');
INSERT INTO lookup VALUES('mineral',259,'Euclase');
INSERT INTO lookup VALUES('mineral',260,'Eucryptite');
INSERT INTO lookup VALUES('mineral',261,'Eudialyte');
INSERT INTO lookup VALUES('mineral',262,'Euxenite');
INSERT INTO lookup VALUES('mineral',263,'Fabianite');
INSERT INTO lookup VALUES('mineral',264,'Fayalite');
INSERT INTO lookup VALUES('mineral',265,'Feldspar');
INSERT INTO lookup VALUES('mineral',266,'Feldspathoid');
INSERT INTO lookup VALUES('mineral',267,'Ferberite');
INSERT INTO lookup VALUES('mineral',268,'Fergusonite');
INSERT INTO lookup VALUES('mineral',269,'Feroxyhyte');
INSERT INTO lookup VALUES('mineral',270,'Ferrierite');
INSERT INTO lookup VALUES('mineral',271,'Ferrihydrite');
INSERT INTO lookup VALUES('mineral',272,'Ferro-anthophyllite');
INSERT INTO lookup VALUES('mineral',273,'Ferrocolumbite');
INSERT INTO lookup VALUES('mineral',274,'Ferrohortonolite');
INSERT INTO lookup VALUES('mineral',275,'Ferrotantalite');
INSERT INTO lookup VALUES('mineral',276,'Fergusonite');
INSERT INTO lookup VALUES('mineral',277,'Fichtelite');
INSERT INTO lookup VALUES('mineral',278,'Fluorapatite');
INSERT INTO lookup VALUES('mineral',279,'Fluorcaphite');
INSERT INTO lookup VALUES('mineral',280,'Fluorichterite');
INSERT INTO lookup VALUES('mineral',281,'Fluorite');
INSERT INTO lookup VALUES('mineral',282,'Fluorspar');
INSERT INTO lookup VALUES('mineral',283,'Fornacite');
INSERT INTO lookup VALUES('mineral',284,'Forsterite');
INSERT INTO lookup VALUES('mineral',285,'Franckeite');
INSERT INTO lookup VALUES('mineral',286,'Frankhawthorneite');
INSERT INTO lookup VALUES('mineral',287,'Franklinite');
INSERT INTO lookup VALUES('mineral',288,'Freibergite');
INSERT INTO lookup VALUES('mineral',289,'Freieslebenite');
INSERT INTO lookup VALUES('mineral',290,'Fukuchilite');
INSERT INTO lookup VALUES('mineral',291,'Gadolinite');
INSERT INTO lookup VALUES('mineral',292,'Gahnite');
INSERT INTO lookup VALUES('mineral',293,'Galaxite');
INSERT INTO lookup VALUES('mineral',294,'Galena');
INSERT INTO lookup VALUES('mineral',295,'Garnet');
INSERT INTO lookup VALUES('mineral',296,'Garnierite');
INSERT INTO lookup VALUES('mineral',297,'Gaylussite');
INSERT INTO lookup VALUES('mineral',298,'Gehlenite');
INSERT INTO lookup VALUES('mineral',299,'Geigerite');
INSERT INTO lookup VALUES('mineral',300,'Geocronite');
INSERT INTO lookup VALUES('mineral',301,'Germanite');
INSERT INTO lookup VALUES('mineral',302,'Gersdorffite');
INSERT INTO lookup VALUES('mineral',303,'Gibbsite');
INSERT INTO lookup VALUES('mineral',304,'Gismondine');
INSERT INTO lookup VALUES('mineral',305,'Glauberite');
INSERT INTO lookup VALUES('mineral',306,'Glaucochroite');
INSERT INTO lookup VALUES('mineral',307,'Glaucodot');
INSERT INTO lookup VALUES('mineral',308,'Glauconite');
INSERT INTO lookup VALUES('mineral',309,'Glaucophane');
INSERT INTO lookup VALUES('mineral',310,'Gmelinite');
INSERT INTO lookup VALUES('mineral',311,'Goethite');
INSERT INTO lookup VALUES('mineral',312,'Gold');
INSERT INTO lookup VALUES('mineral',313,'Goslarite');
INSERT INTO lookup VALUES('mineral',314,'Graftonite');
INSERT INTO lookup VALUES('mineral',315,'Graphite');
INSERT INTO lookup VALUES('mineral',316,'Greenockite');
INSERT INTO lookup VALUES('mineral',317,'Greigite');
INSERT INTO lookup VALUES('mineral',318,'Grossular');
INSERT INTO lookup VALUES('mineral',319,'Grunerite');
INSERT INTO lookup VALUES('mineral',320,'Guanine');
INSERT INTO lookup VALUES('mineral',321,'Gummite');
INSERT INTO lookup VALUES('mineral',322,'Gunningite');
INSERT INTO lookup VALUES('mineral',323,'Gypsum');
INSERT INTO lookup VALUES('mineral',324,'Haggertyite');
INSERT INTO lookup VALUES('mineral',325,'Haidingerite');
INSERT INTO lookup VALUES('mineral',326,'Halite');
INSERT INTO lookup VALUES('mineral',327,'Halloysite');
INSERT INTO lookup VALUES('mineral',328,'Halotrichite');
INSERT INTO lookup VALUES('mineral',329,'Hanksite');
INSERT INTO lookup VALUES('mineral',330,'Hapkeite');
INSERT INTO lookup VALUES('mineral',331,'Hardystonite');
INSERT INTO lookup VALUES('mineral',332,'Harmotome');
INSERT INTO lookup VALUES('mineral',333,'Hauerite');
INSERT INTO lookup VALUES('mineral',334,'Hausmannite');
INSERT INTO lookup VALUES('mineral',335,'Hauyne');
INSERT INTO lookup VALUES('mineral',336,'Hawleyite');
INSERT INTO lookup VALUES('mineral',337,'Haxonite');
INSERT INTO lookup VALUES('mineral',338,'Heazlewoodite');
INSERT INTO lookup VALUES('mineral',339,'Hectorite');
INSERT INTO lookup VALUES('mineral',340,'Hedenbergite');
INSERT INTO lookup VALUES('mineral',341,'Hellyerite');
INSERT INTO lookup VALUES('mineral',342,'Hematite');
INSERT INTO lookup VALUES('mineral',343,'Hemimorphite');
INSERT INTO lookup VALUES('mineral',344,'Herbertsmithite');
INSERT INTO lookup VALUES('mineral',345,'Herderite');
INSERT INTO lookup VALUES('mineral',346,'Hessite');
INSERT INTO lookup VALUES('mineral',347,'Hessonite');
INSERT INTO lookup VALUES('mineral',348,'Heulandite');
INSERT INTO lookup VALUES('mineral',349,'Hibonite');
INSERT INTO lookup VALUES('mineral',350,'Hilgardite');
INSERT INTO lookup VALUES('mineral',351,'Hisingerite');
INSERT INTO lookup VALUES('mineral',352,'Holmquistite');
INSERT INTO lookup VALUES('mineral',353,'Homilite');
INSERT INTO lookup VALUES('mineral',354,'Hopeite');
INSERT INTO lookup VALUES('mineral',355,'Hornblende');
INSERT INTO lookup VALUES('mineral',356,'Howlite');
INSERT INTO lookup VALUES('mineral',357,'Hübnerite');
INSERT INTO lookup VALUES('mineral',358,'Humite');
INSERT INTO lookup VALUES('mineral',359,'Hutchinsonite');
INSERT INTO lookup VALUES('mineral',360,'Hyalophane');
INSERT INTO lookup VALUES('mineral',361,'Hydrogrossular');
INSERT INTO lookup VALUES('mineral',362,'Hydromagnesite');
INSERT INTO lookup VALUES('mineral',363,'Hydroxylapatite');
INSERT INTO lookup VALUES('mineral',364,'Hydrozincite');
INSERT INTO lookup VALUES('mineral',365,'Hypersthene');
INSERT INTO lookup VALUES('mineral',366,'Idocrase');
INSERT INTO lookup VALUES('mineral',367,'Idrialite');
INSERT INTO lookup VALUES('mineral',368,'Ikaite');
INSERT INTO lookup VALUES('mineral',369,'Illite');
INSERT INTO lookup VALUES('mineral',370,'Ilmenite');
INSERT INTO lookup VALUES('mineral',371,'Ilvaite');
INSERT INTO lookup VALUES('mineral',372,'Iodargyrite');
INSERT INTO lookup VALUES('mineral',373,'Iron');
INSERT INTO lookup VALUES('mineral',374,'Ivanukite');
INSERT INTO lookup VALUES('mineral',375,'Jacobsite');
INSERT INTO lookup VALUES('mineral',376,'Jadarite');
INSERT INTO lookup VALUES('mineral',377,'Jadeite');
INSERT INTO lookup VALUES('mineral',378,'Jamesonite');
INSERT INTO lookup VALUES('mineral',379,'Jarosewichite');
INSERT INTO lookup VALUES('mineral',380,'Jarosite');
INSERT INTO lookup VALUES('mineral',381,'Jeffersonite');
INSERT INTO lookup VALUES('mineral',382,'Jerrygibbsite');
INSERT INTO lookup VALUES('mineral',383,'Juonniite');
INSERT INTO lookup VALUES('mineral',384,'Jurbanite');
INSERT INTO lookup VALUES('mineral',385,'Kalinite');
INSERT INTO lookup VALUES('mineral',386,'Kalsilite');
INSERT INTO lookup VALUES('mineral',387,'Kamacite');
INSERT INTO lookup VALUES('mineral',388,'Kambaldaite');
INSERT INTO lookup VALUES('mineral',389,'Kankite');
INSERT INTO lookup VALUES('mineral',390,'Kaolinite');
INSERT INTO lookup VALUES('mineral',391,'Kassite');
INSERT INTO lookup VALUES('mineral',392,'Keilite');
INSERT INTO lookup VALUES('mineral',393,'Kermesite');
INSERT INTO lookup VALUES('mineral',394,'Kernite');
INSERT INTO lookup VALUES('mineral',395,'Kerolite');
INSERT INTO lookup VALUES('mineral',396,'Kieserite');
INSERT INTO lookup VALUES('mineral',397,'Kinoite');
INSERT INTO lookup VALUES('mineral',398,'Knebelite');
INSERT INTO lookup VALUES('mineral',399,'Knorringite');
INSERT INTO lookup VALUES('mineral',400,'Kobellite');
INSERT INTO lookup VALUES('mineral',401,'Kogarkoite');
INSERT INTO lookup VALUES('mineral',402,'Kolbeckite');
INSERT INTO lookup VALUES('mineral',403,'Kornerupine');
INSERT INTO lookup VALUES('mineral',404,'Kratochvilite');
INSERT INTO lookup VALUES('mineral',405,'Kremersite');
INSERT INTO lookup VALUES('mineral',406,'Krennerite');
INSERT INTO lookup VALUES('mineral',407,'Kukharenkoite-(Ce)');
INSERT INTO lookup VALUES('mineral',408,'Kutnohorite');
INSERT INTO lookup VALUES('mineral',409,'Kyanite');
INSERT INTO lookup VALUES('mineral',410,'Labradorite');
INSERT INTO lookup VALUES('mineral',411,'Lanarkite');
INSERT INTO lookup VALUES('mineral',412,'Langbeinite');
INSERT INTO lookup VALUES('mineral',413,'Lansfordite');
INSERT INTO lookup VALUES('mineral',414,'Lanthanite');
INSERT INTO lookup VALUES('mineral',415,'Laumontite');
INSERT INTO lookup VALUES('mineral',416,'Laurite');
INSERT INTO lookup VALUES('mineral',417,'Lawsonite');
INSERT INTO lookup VALUES('mineral',418,'Lazulite');
INSERT INTO lookup VALUES('mineral',419,'Lazurite');
INSERT INTO lookup VALUES('mineral',420,'Lead');
INSERT INTO lookup VALUES('mineral',421,'Leadhillite');
INSERT INTO lookup VALUES('mineral',422,'Legrandite');
INSERT INTO lookup VALUES('mineral',423,'Lepidocrocite');
INSERT INTO lookup VALUES('mineral',424,'Lepidolite');
INSERT INTO lookup VALUES('mineral',425,'Leucite');
INSERT INTO lookup VALUES('mineral',426,'Leucophanite');
INSERT INTO lookup VALUES('mineral',427,'Leucoxene');
INSERT INTO lookup VALUES('mineral',428,'Levyne');
INSERT INTO lookup VALUES('mineral',429,'Lewisite');
INSERT INTO lookup VALUES('mineral',430,'Libethenite');
INSERT INTO lookup VALUES('mineral',431,'Linarite');
INSERT INTO lookup VALUES('mineral',432,'Liroconite');
INSERT INTO lookup VALUES('mineral',433,'Litharge');
INSERT INTO lookup VALUES('mineral',434,'Lithiophilite');
INSERT INTO lookup VALUES('mineral',435,'Livingstonite');
INSERT INTO lookup VALUES('mineral',436,'Lizardite');
INSERT INTO lookup VALUES('mineral',437,'Lollingite');
INSERT INTO lookup VALUES('mineral',438,'Lonsdaleite');
INSERT INTO lookup VALUES('mineral',439,'Loparite-(Ce)');
INSERT INTO lookup VALUES('mineral',440,'Lopezite');
INSERT INTO lookup VALUES('mineral',441,'Lorandite');
INSERT INTO lookup VALUES('mineral',442,'Lorenzenite');
INSERT INTO lookup VALUES('mineral',443,'Ludwigite');
INSERT INTO lookup VALUES('mineral',444,'Lyonsite');
INSERT INTO lookup VALUES('mineral',445,'Mackinawite');
INSERT INTO lookup VALUES('mineral',446,'Maghemite');
INSERT INTO lookup VALUES('mineral',447,'Magnesite');
INSERT INTO lookup VALUES('mineral',448,'Magnesioferrite');
INSERT INTO lookup VALUES('mineral',449,'Magnetite');
INSERT INTO lookup VALUES('mineral',450,'Majorite');
INSERT INTO lookup VALUES('mineral',451,'Malachite');
INSERT INTO lookup VALUES('mineral',452,'Malacolite');
INSERT INTO lookup VALUES('mineral',453,'Magnesioferrite');
INSERT INTO lookup VALUES('mineral',454,'Manganite');
INSERT INTO lookup VALUES('mineral',455,'Manganocolumbite');
INSERT INTO lookup VALUES('mineral',456,'Manganotantalite');
INSERT INTO lookup VALUES('mineral',457,'Marcasite');
INSERT INTO lookup VALUES('mineral',458,'Margaritasite');
INSERT INTO lookup VALUES('mineral',459,'Margarite');
INSERT INTO lookup VALUES('mineral',460,'Mascagnite');
INSERT INTO lookup VALUES('mineral',461,'Massicot');
INSERT INTO lookup VALUES('mineral',462,'McKelveyite');
INSERT INTO lookup VALUES('mineral',463,'Meionite');
INSERT INTO lookup VALUES('mineral',464,'Melaconite');
INSERT INTO lookup VALUES('mineral',465,'Melanite');
INSERT INTO lookup VALUES('mineral',466,'Melilite');
INSERT INTO lookup VALUES('mineral',467,'Melonite');
INSERT INTO lookup VALUES('mineral',468,'Mendozite');
INSERT INTO lookup VALUES('mineral',469,'Meneghinite');
INSERT INTO lookup VALUES('mineral',470,'Mercury');
INSERT INTO lookup VALUES('mineral',471,'Mesolite');
INSERT INTO lookup VALUES('mineral',472,'Metacinnabarite');
INSERT INTO lookup VALUES('mineral',473,'Metatorbernite');
INSERT INTO lookup VALUES('mineral',474,'Miargyrite');
INSERT INTO lookup VALUES('mineral',475,'Mica');
INSERT INTO lookup VALUES('mineral',476,'Microcline');
INSERT INTO lookup VALUES('mineral',477,'Microlite');
INSERT INTO lookup VALUES('mineral',478,'Millerite');
INSERT INTO lookup VALUES('mineral',479,'Mimetite');
INSERT INTO lookup VALUES('mineral',480,'Minium');
INSERT INTO lookup VALUES('mineral',481,'Mirabilite');
INSERT INTO lookup VALUES('mineral',482,'Mixite');
INSERT INTO lookup VALUES('mineral',483,'Moganite');
INSERT INTO lookup VALUES('mineral',484,'Mohite');
INSERT INTO lookup VALUES('mineral',485,'Moissanite');
INSERT INTO lookup VALUES('mineral',486,'Molybdenite');
INSERT INTO lookup VALUES('mineral',487,'Monazite');
INSERT INTO lookup VALUES('mineral',488,'Monohydrocalcite');
INSERT INTO lookup VALUES('mineral',489,'Monticellite');
INSERT INTO lookup VALUES('mineral',490,'Montmorillonite');
INSERT INTO lookup VALUES('mineral',491,'Moolooite');
INSERT INTO lookup VALUES('mineral',492,'Mordenite');
INSERT INTO lookup VALUES('mineral',493,'Mottramite');
INSERT INTO lookup VALUES('mineral',494,'Mullite');
INSERT INTO lookup VALUES('mineral',495,'Murdochite');
INSERT INTO lookup VALUES('mineral',496,'Muscovite');
INSERT INTO lookup VALUES('mineral',497,'Nabesite');
INSERT INTO lookup VALUES('mineral',498,'Nacrite');
INSERT INTO lookup VALUES('mineral',499,'Nagyagite');
INSERT INTO lookup VALUES('mineral',500,'Nahcolite');
INSERT INTO lookup VALUES('mineral',501,'Native copper');
INSERT INTO lookup VALUES('mineral',502,'Natrolite');
INSERT INTO lookup VALUES('mineral',503,'Natron');
INSERT INTO lookup VALUES('mineral',504,'Natrophilite');
INSERT INTO lookup VALUES('mineral',505,'Nekrasovite');
INSERT INTO lookup VALUES('mineral',506,'Nelenite');
INSERT INTO lookup VALUES('mineral',507,'Nenadkevichite');
INSERT INTO lookup VALUES('mineral',508,'Nepheline');
INSERT INTO lookup VALUES('mineral',509,'Nephrite');
INSERT INTO lookup VALUES('mineral',510,'Neptunite');
INSERT INTO lookup VALUES('mineral',511,'Nickel');
INSERT INTO lookup VALUES('mineral',512,'Nickeline');
INSERT INTO lookup VALUES('mineral',513,'Niedermayrite');
INSERT INTO lookup VALUES('mineral',514,'Niningerite');
INSERT INTO lookup VALUES('mineral',515,'Niobite');
INSERT INTO lookup VALUES('mineral',516,'Niobite-tantalite');
INSERT INTO lookup VALUES('mineral',517,'Nissonite');
INSERT INTO lookup VALUES('mineral',518,'Nitratine');
INSERT INTO lookup VALUES('mineral',519,'Nitre');
INSERT INTO lookup VALUES('mineral',520,'Nontronite');
INSERT INTO lookup VALUES('mineral',521,'Nosean');
INSERT INTO lookup VALUES('mineral',522,'Nsutite');
INSERT INTO lookup VALUES('mineral',523,'Nyerereite');
INSERT INTO lookup VALUES('mineral',524,'Oligoclase');
INSERT INTO lookup VALUES('mineral',525,'Olivine');
INSERT INTO lookup VALUES('mineral',526,'Olivenite');
INSERT INTO lookup VALUES('mineral',527,'Omphacite');
INSERT INTO lookup VALUES('mineral',528,'Ordonezite');
INSERT INTO lookup VALUES('mineral',529,'Oregonite');
INSERT INTO lookup VALUES('mineral',530,'Orpiment');
INSERT INTO lookup VALUES('mineral',531,'Orthochrysotile');
INSERT INTO lookup VALUES('mineral',532,'Orthoclase');
INSERT INTO lookup VALUES('mineral',533,'Osarizawaite');
INSERT INTO lookup VALUES('mineral',534,'Osmium');
INSERT INTO lookup VALUES('mineral',535,'Osumilite');
INSERT INTO lookup VALUES('mineral',536,'Otavite');
INSERT INTO lookup VALUES('mineral',537,'Ottrelite');
INSERT INTO lookup VALUES('mineral',538,'Overite');
INSERT INTO lookup VALUES('mineral',539,'Painite');
INSERT INTO lookup VALUES('mineral',540,'Palladium');
INSERT INTO lookup VALUES('mineral',541,'Palygorskite');
INSERT INTO lookup VALUES('mineral',542,'Papagoite');
INSERT INTO lookup VALUES('mineral',543,'Parachrysotile');
INSERT INTO lookup VALUES('mineral',544,'Paragonite');
INSERT INTO lookup VALUES('mineral',545,'Pararealgar');
INSERT INTO lookup VALUES('mineral',546,'Parisite');
INSERT INTO lookup VALUES('mineral',547,'Partheite');
INSERT INTO lookup VALUES('mineral',548,'Pectolite');
INSERT INTO lookup VALUES('mineral',549,'Pelagosite');
INSERT INTO lookup VALUES('mineral',550,'Pentlandite');
INSERT INTO lookup VALUES('mineral',551,'Periclase');
INSERT INTO lookup VALUES('mineral',552,'Perovskite');
INSERT INTO lookup VALUES('mineral',553,'Petalite');
INSERT INTO lookup VALUES('mineral',554,'Petzite');
INSERT INTO lookup VALUES('mineral',555,'Pezzottaite');
INSERT INTO lookup VALUES('mineral',556,'Pharmacosiderite');
INSERT INTO lookup VALUES('mineral',557,'Phenakite');
INSERT INTO lookup VALUES('mineral',558,'Phillipsite');
INSERT INTO lookup VALUES('mineral',559,'Phlogopite');
INSERT INTO lookup VALUES('mineral',560,'Phoenicochroite');
INSERT INTO lookup VALUES('mineral',561,'Phosgenite');
INSERT INTO lookup VALUES('mineral',562,'Phosphophyllite');
INSERT INTO lookup VALUES('mineral',563,'Pigeonite');
INSERT INTO lookup VALUES('mineral',564,'Plagioclase');
INSERT INTO lookup VALUES('mineral',565,'Platinum');
INSERT INTO lookup VALUES('mineral',566,'Polarite');
INSERT INTO lookup VALUES('mineral',567,'Pollucite');
INSERT INTO lookup VALUES('mineral',568,'Polybasite');
INSERT INTO lookup VALUES('mineral',569,'Potassium alum');
INSERT INTO lookup VALUES('mineral',570,'Polycrase');
INSERT INTO lookup VALUES('mineral',571,'Polydymite');
INSERT INTO lookup VALUES('mineral',572,'Polyhalite');
INSERT INTO lookup VALUES('mineral',573,'Powellite');
INSERT INTO lookup VALUES('mineral',574,'Prehnite');
INSERT INTO lookup VALUES('mineral',575,'Proustite');
INSERT INTO lookup VALUES('mineral',576,'Psilomelane');
INSERT INTO lookup VALUES('mineral',577,'Purpurite');
INSERT INTO lookup VALUES('mineral',578,'Pumpellyite');
INSERT INTO lookup VALUES('mineral',579,'Pyrargyrite');
INSERT INTO lookup VALUES('mineral',580,'Pyrite');
INSERT INTO lookup VALUES('mineral',581,'Pyrochlore');
INSERT INTO lookup VALUES('mineral',582,'Pyrolusite');
INSERT INTO lookup VALUES('mineral',583,'Pyromorphite');
INSERT INTO lookup VALUES('mineral',584,'Pyrope');
INSERT INTO lookup VALUES('mineral',585,'Pyrophyllite');
INSERT INTO lookup VALUES('mineral',586,'Pyroxene');
INSERT INTO lookup VALUES('mineral',587,'Pyroxferroite');
INSERT INTO lookup VALUES('mineral',588,'Pyrrhotite');
INSERT INTO lookup VALUES('mineral',589,'Quartz');
INSERT INTO lookup VALUES('mineral',590,'Quenstedtite');
INSERT INTO lookup VALUES('mineral',591,'Rambergite');
INSERT INTO lookup VALUES('mineral',592,'Rammelsbergite');
INSERT INTO lookup VALUES('mineral',593,'Realgar');
INSERT INTO lookup VALUES('mineral',594,'Renierite');
INSERT INTO lookup VALUES('mineral',595,'Rheniite');
INSERT INTO lookup VALUES('mineral',596,'Rhodium');
INSERT INTO lookup VALUES('mineral',597,'Rhodochrosite');
INSERT INTO lookup VALUES('mineral',598,'Rhodonite');
INSERT INTO lookup VALUES('mineral',599,'Rhomboclase');
INSERT INTO lookup VALUES('mineral',600,'Rickardite');
INSERT INTO lookup VALUES('mineral',601,'Riebeckite');
INSERT INTO lookup VALUES('mineral',602,'Romanèchite');
INSERT INTO lookup VALUES('mineral',603,'Robertsite');
INSERT INTO lookup VALUES('mineral',604,'Rosasite');
INSERT INTO lookup VALUES('mineral',605,'Roscoelite');
INSERT INTO lookup VALUES('mineral',606,'Rosenbergite');
INSERT INTO lookup VALUES('mineral',607,'Routhierite');
INSERT INTO lookup VALUES('mineral',608,'Ruthenium');
INSERT INTO lookup VALUES('mineral',609,'Rutherfordine');
INSERT INTO lookup VALUES('mineral',610,'Rutile');
INSERT INTO lookup VALUES('mineral',611,'Rynersonite');
INSERT INTO lookup VALUES('mineral',612,'Sabatierite');
INSERT INTO lookup VALUES('mineral',613,'Sabieite');
INSERT INTO lookup VALUES('mineral',614,'Sabinaite');
INSERT INTO lookup VALUES('mineral',615,'Safflorite');
INSERT INTO lookup VALUES('mineral',616,'Sal ammoniac');
INSERT INTO lookup VALUES('mineral',617,'Saliotite');
INSERT INTO lookup VALUES('mineral',618,'Samarskite');
INSERT INTO lookup VALUES('mineral',619,'Samsonite');
INSERT INTO lookup VALUES('mineral',620,'Sanbornite');
INSERT INTO lookup VALUES('mineral',621,'Saneroite');
INSERT INTO lookup VALUES('mineral',622,'Sanidine');
INSERT INTO lookup VALUES('mineral',623,'Santite');
INSERT INTO lookup VALUES('mineral',624,'Saponite');
INSERT INTO lookup VALUES('mineral',625,'Sapphirine');
INSERT INTO lookup VALUES('mineral',626,'Sassolite');
INSERT INTO lookup VALUES('mineral',627,'Sauconite');
INSERT INTO lookup VALUES('mineral',628,'Scapolite');
INSERT INTO lookup VALUES('mineral',629,'Scheelite');
INSERT INTO lookup VALUES('mineral',630,'Schoepite');
INSERT INTO lookup VALUES('mineral',631,'Schorl');
INSERT INTO lookup VALUES('mineral',632,'Schreibersite');
INSERT INTO lookup VALUES('mineral',633,'Schwertmannite');
INSERT INTO lookup VALUES('mineral',634,'Scolecite');
INSERT INTO lookup VALUES('mineral',635,'Scorodite');
INSERT INTO lookup VALUES('mineral',636,'Scorzalite');
INSERT INTO lookup VALUES('mineral',637,'Seamanite');
INSERT INTO lookup VALUES('mineral',638,'Seeligerite');
INSERT INTO lookup VALUES('mineral',639,'Segelerite');
INSERT INTO lookup VALUES('mineral',640,'Sekaninaite');
INSERT INTO lookup VALUES('mineral',641,'Selenide');
INSERT INTO lookup VALUES('mineral',642,'Selenite');
INSERT INTO lookup VALUES('mineral',643,'Selenium');
INSERT INTO lookup VALUES('mineral',644,'Seligmannite');
INSERT INTO lookup VALUES('mineral',645,'Sellaite');
INSERT INTO lookup VALUES('mineral',646,'Senarmontite');
INSERT INTO lookup VALUES('mineral',647,'Sepiolite');
INSERT INTO lookup VALUES('mineral',648,'Serpentine');
INSERT INTO lookup VALUES('mineral',649,'Shattuckite');
INSERT INTO lookup VALUES('mineral',650,'Siderite');
INSERT INTO lookup VALUES('mineral',651,'Siderotil');
INSERT INTO lookup VALUES('mineral',652,'Siegenite');
INSERT INTO lookup VALUES('mineral',653,'Sillimanite');
INSERT INTO lookup VALUES('mineral',654,'Silver');
INSERT INTO lookup VALUES('mineral',655,'Simetite');
INSERT INTO lookup VALUES('mineral',656,'Simonellite');
INSERT INTO lookup VALUES('mineral',657,'Skutterudite');
INSERT INTO lookup VALUES('mineral',658,'Smaltite');
INSERT INTO lookup VALUES('mineral',659,'Smectite');
INSERT INTO lookup VALUES('mineral',660,'Smithsonite');
INSERT INTO lookup VALUES('mineral',661,'Soda niter');
INSERT INTO lookup VALUES('mineral',662,'Sodalite');
INSERT INTO lookup VALUES('mineral',663,'Sperrylite');
INSERT INTO lookup VALUES('mineral',664,'Spessartite');
INSERT INTO lookup VALUES('mineral',665,'Sphalerite');
INSERT INTO lookup VALUES('mineral',666,'Sphene');
INSERT INTO lookup VALUES('mineral',667,'Spinel');
INSERT INTO lookup VALUES('mineral',668,'Spodumene');
INSERT INTO lookup VALUES('mineral',669,'Spurrite');
INSERT INTO lookup VALUES('mineral',670,'Stannite');
INSERT INTO lookup VALUES('mineral',671,'Staurolite');
INSERT INTO lookup VALUES('mineral',672,'Steacyite');
INSERT INTO lookup VALUES('mineral',673,'Steatite(talc)');
INSERT INTO lookup VALUES('mineral',674,'Stephanite');
INSERT INTO lookup VALUES('mineral',675,'Stibnite');
INSERT INTO lookup VALUES('mineral',676,'Stichtite');
INSERT INTO lookup VALUES('mineral',677,'Stilbite');
INSERT INTO lookup VALUES('mineral',678,'Stilleite');
INSERT INTO lookup VALUES('mineral',679,'Stolzite');
INSERT INTO lookup VALUES('mineral',680,'Stromeyerite');
INSERT INTO lookup VALUES('mineral',681,'Strontianite');
INSERT INTO lookup VALUES('mineral',682,'Struvite');
INSERT INTO lookup VALUES('mineral',683,'Studtite');
INSERT INTO lookup VALUES('mineral',684,'Sugilite');
INSERT INTO lookup VALUES('mineral',685,'Sulfur');
INSERT INTO lookup VALUES('mineral',686,'Sussexite');
INSERT INTO lookup VALUES('mineral',687,'Sylvanite');
INSERT INTO lookup VALUES('mineral',688,'Sylvite');
INSERT INTO lookup VALUES('mineral',689,'Tachyhydrite');
INSERT INTO lookup VALUES('mineral',690,'Taenite');
INSERT INTO lookup VALUES('mineral',691,'Talc');
INSERT INTO lookup VALUES('mineral',692,'Tantalite');
INSERT INTO lookup VALUES('mineral',693,'Tantite');
INSERT INTO lookup VALUES('mineral',694,'Tanzanite');
INSERT INTO lookup VALUES('mineral',695,'Tarapacaite');
INSERT INTO lookup VALUES('mineral',696,'Tausonite');
INSERT INTO lookup VALUES('mineral',697,'Teallite');
INSERT INTO lookup VALUES('mineral',698,'Tellurite');
INSERT INTO lookup VALUES('mineral',699,'Tellurium');
INSERT INTO lookup VALUES('mineral',700,'Tellurobismuthite');
INSERT INTO lookup VALUES('mineral',701,'Temagamite');
INSERT INTO lookup VALUES('mineral',702,'Tennantite');
INSERT INTO lookup VALUES('mineral',703,'Tenorite');
INSERT INTO lookup VALUES('mineral',704,'Tephroite');
INSERT INTO lookup VALUES('mineral',705,'Terlinguaite');
INSERT INTO lookup VALUES('mineral',706,'Teruggite');
INSERT INTO lookup VALUES('mineral',707,'Tetradymite');
INSERT INTO lookup VALUES('mineral',708,'Tetrahedrite');
INSERT INTO lookup VALUES('mineral',709,'Thaumasite');
INSERT INTO lookup VALUES('mineral',710,'Thenardite');
INSERT INTO lookup VALUES('mineral',711,'Thomasclarkite');
INSERT INTO lookup VALUES('mineral',712,'Thomsenolite');
INSERT INTO lookup VALUES('mineral',713,'Thorianite');
INSERT INTO lookup VALUES('mineral',714,'Thorite');
INSERT INTO lookup VALUES('mineral',715,'Thortveitite');
INSERT INTO lookup VALUES('mineral',716,'Thuringite');
INSERT INTO lookup VALUES('mineral',717,'Tiemannite');
INSERT INTO lookup VALUES('mineral',718,'Tin');
INSERT INTO lookup VALUES('mineral',719,'Tincalconite');
INSERT INTO lookup VALUES('mineral',720,'Titanite');
INSERT INTO lookup VALUES('mineral',721,'Titanowodginite');
INSERT INTO lookup VALUES('mineral',722,'Todorokite');
INSERT INTO lookup VALUES('mineral',723,'Tokyoite');
INSERT INTO lookup VALUES('mineral',724,'Topaz');
INSERT INTO lookup VALUES('mineral',725,'Torbernite');
INSERT INTO lookup VALUES('mineral',726,'Tourmaline');
INSERT INTO lookup VALUES('mineral',727,'Tremolite');
INSERT INTO lookup VALUES('mineral',728,'Trevorite');
INSERT INTO lookup VALUES('mineral',729,'Tridymite');
INSERT INTO lookup VALUES('mineral',730,'Triphylite');
INSERT INTO lookup VALUES('mineral',731,'Triplite');
INSERT INTO lookup VALUES('mineral',732,'Triploidite');
INSERT INTO lookup VALUES('mineral',733,'Trona');
INSERT INTO lookup VALUES('mineral',734,'Tsavorite');
INSERT INTO lookup VALUES('mineral',735,'Tschermigite');
INSERT INTO lookup VALUES('mineral',736,'Tugtupite');
INSERT INTO lookup VALUES('mineral',737,'Tungstite');
INSERT INTO lookup VALUES('mineral',738,'Tyrolite');
INSERT INTO lookup VALUES('mineral',739,'Turquoise');
INSERT INTO lookup VALUES('mineral',740,'Tusionite');
INSERT INTO lookup VALUES('mineral',741,'Tyuyamunite');
INSERT INTO lookup VALUES('mineral',742,'Uchucchacuaite');
INSERT INTO lookup VALUES('mineral',743,'Uklonskovite');
INSERT INTO lookup VALUES('mineral',744,'Ulexite');
INSERT INTO lookup VALUES('mineral',745,'Ullmannite');
INSERT INTO lookup VALUES('mineral',746,'Ulvospinel');
INSERT INTO lookup VALUES('mineral',747,'Umangite');
INSERT INTO lookup VALUES('mineral',748,'Umber');
INSERT INTO lookup VALUES('mineral',749,'Umbite');
INSERT INTO lookup VALUES('mineral',750,'Upalite');
INSERT INTO lookup VALUES('mineral',751,'Uraninite');
INSERT INTO lookup VALUES('mineral',752,'Uranophane');
INSERT INTO lookup VALUES('mineral',753,'Uranopilite');
INSERT INTO lookup VALUES('mineral',754,'Uvarovite');
INSERT INTO lookup VALUES('mineral',755,'Vaesite');
INSERT INTO lookup VALUES('mineral',756,'Valentinite');
INSERT INTO lookup VALUES('mineral',757,'Vanadinite');
INSERT INTO lookup VALUES('mineral',758,'Variscite');
INSERT INTO lookup VALUES('mineral',759,'Vaterite');
INSERT INTO lookup VALUES('mineral',760,'Vauquelinite');
INSERT INTO lookup VALUES('mineral',761,'Vauxite');
INSERT INTO lookup VALUES('mineral',762,'Vermiculite');
INSERT INTO lookup VALUES('mineral',763,'Vesuvianite');
INSERT INTO lookup VALUES('mineral',764,'Villiaumite');
INSERT INTO lookup VALUES('mineral',765,'Violarite');
INSERT INTO lookup VALUES('mineral',766,'Vivianite');
INSERT INTO lookup VALUES('mineral',767,'Volborthite');
INSERT INTO lookup VALUES('mineral',768,'Wad');
INSERT INTO lookup VALUES('mineral',769,'Wagnerite');
INSERT INTO lookup VALUES('mineral',770,'Wardite');
INSERT INTO lookup VALUES('mineral',771,'Warwickite');
INSERT INTO lookup VALUES('mineral',772,'Wavellite');
INSERT INTO lookup VALUES('mineral',773,'Weddellite');
INSERT INTO lookup VALUES('mineral',774,'Weilite');
INSERT INTO lookup VALUES('mineral',775,'Weissite');
INSERT INTO lookup VALUES('mineral',776,'Weloganite');
INSERT INTO lookup VALUES('mineral',777,'Whewellite');
INSERT INTO lookup VALUES('mineral',778,'Whitlockite');
INSERT INTO lookup VALUES('mineral',779,'Willemite');
INSERT INTO lookup VALUES('mineral',780,'Wiluite');
INSERT INTO lookup VALUES('mineral',781,'Witherite');
INSERT INTO lookup VALUES('mineral',782,'Wolframite');
INSERT INTO lookup VALUES('mineral',783,'Wollastonite');
INSERT INTO lookup VALUES('mineral',784,'Wulfenite');
INSERT INTO lookup VALUES('mineral',785,'Wurtzite');
INSERT INTO lookup VALUES('mineral',786,'Wüstite');
INSERT INTO lookup VALUES('mineral',787,'Wyartite');
INSERT INTO lookup VALUES('mineral',788,'Xenotime');
INSERT INTO lookup VALUES('mineral',789,'Xifengite');
INSERT INTO lookup VALUES('mineral',790,'Xonotlite');
INSERT INTO lookup VALUES('mineral',791,'Yeelimite');
INSERT INTO lookup VALUES('mineral',792,'Ytterbite');
INSERT INTO lookup VALUES('mineral',793,'Yttrialite');
INSERT INTO lookup VALUES('mineral',794,'Yttrium(III) oxide');
INSERT INTO lookup VALUES('mineral',795,'Yttrocerite');
INSERT INTO lookup VALUES('mineral',796,'Yttrocolumbite');
INSERT INTO lookup VALUES('mineral',797,'Zabuyelite');
INSERT INTO lookup VALUES('mineral',798,'Zaccagnaite');
INSERT INTO lookup VALUES('mineral',799,'Zaherite');
INSERT INTO lookup VALUES('mineral',800,'Zajacite-(Ce)');
INSERT INTO lookup VALUES('mineral',801,'Zakharovite');
INSERT INTO lookup VALUES('mineral',802,'Zanazziite');
INSERT INTO lookup VALUES('mineral',803,'Zaratite');
INSERT INTO lookup VALUES('mineral',804,'Zeolite');
INSERT INTO lookup VALUES('mineral',805,'Zhanghengite');
INSERT INTO lookup VALUES('mineral',806,'Zharchikhite');
INSERT INTO lookup VALUES('mineral',807,'Zektzerite');
INSERT INTO lookup VALUES('mineral',808,'Zhemchuzhnikovite');
INSERT INTO lookup VALUES('mineral',809,'Zhonghuacerite-(Ce)');
INSERT INTO lookup VALUES('mineral',810,'Ziesite');
INSERT INTO lookup VALUES('mineral',811,'Zimbabweite');
INSERT INTO lookup VALUES('mineral',812,'Zinalsite');
INSERT INTO lookup VALUES('mineral',813,'Zinc-melanterite');
INSERT INTO lookup VALUES('mineral',814,'Zincite');
INSERT INTO lookup VALUES('mineral',815,'Zincobotryogen');
INSERT INTO lookup VALUES('mineral',816,'Zincochromite');
INSERT INTO lookup VALUES('mineral',817,'Zinkenite');
INSERT INTO lookup VALUES('mineral',818,'Zinnwaldite');
INSERT INTO lookup VALUES('mineral',819,'Zippeite');
INSERT INTO lookup VALUES('mineral',820,'Zircon');
INSERT INTO lookup VALUES('mineral',821,'Zirconolite');
INSERT INTO lookup VALUES('mineral',822,'Zircophyllite');
INSERT INTO lookup VALUES('mineral',823,'Zirkelite');
INSERT INTO lookup VALUES('mineral',824,'Zoisite');
INSERT INTO lookup VALUES('mineral',825,'Zunyite');     

GRANT SELECT ON lookup TO gdatasystems;    
CREATE FUNCTION getloo1(fi character varying, _id integer) RETURNS text
    LANGUAGE plpgsql
    AS $_$
  DECLARE
     fie ALIAS FOR $1;
	 cod ALIAS FOR $2;
     res lookup.text1%TYPE;
  BEGIN
     SELECT INTO res text1 FROM lookup 
	 WHERE field = fie AND code=cod;
     return res ;
  END;
$_$;

CREATE TABLE litho (
field 	varchar(50) NOT NULL,
cat  	integer NOT NULL,
code 	varchar(10) NOT NULL,
text1 	varchar(200),
UNIQUE(field,cat,code)
); 


GRANT SELECT ON litho TO gdatasystems;
CREATE FUNCTION getlitho(fi character varying, _id character varying) RETURNS text
    LANGUAGE plpgsql
    AS $_$
  DECLARE
     fie ALIAS FOR $1;
	 cod ALIAS FOR $2;
     res lookup.text1%TYPE;
  BEGIN
     SELECT INTO res text1 FROM lookup 
	 WHERE field = fie AND code=cod;
     return res ;
  END;
$_$;

CREATE TABLE pal(
pal_code  varchar(20) UNIQUE NOT NULL,
r         int,
g         int,
b         int,
a         int
);
GRANT SELECT ON pal TO gdatasystems;

INSERT INTO litho VALUES('lithocode',1,'UNCS','Unconsolidated material');
INSERT INTO pal (pal_code,r,g,b) VALUES('UNCS',253,244,63);
INSERT INTO litho VALUES('lithocode',1,'ALUV','Alluvium');
INSERT INTO pal (pal_code,r,g,b) VALUES('ALUV',255,255,137);
INSERT INTO litho VALUES('lithocode',1,'FLPLN','Flood plain');
INSERT INTO pal (pal_code,r,g,b) VALUES('FLPLN',255,255,213);
INSERT INTO litho VALUES('lithocode',1,'LVEE','Levee');
INSERT INTO pal (pal_code,r,g,b) VALUES('LVEE',255,250,233);
INSERT INTO litho VALUES('lithocode',1,'DELT','Delta');
INSERT INTO pal (pal_code,r,g,b) VALUES('DELT',255,250,200);
INSERT INTO litho VALUES('lithocode',1,'ALLFN','Alluvial fan');
INSERT INTO pal (pal_code,r,g,b) VALUES('ALLFN',255,255,183);
INSERT INTO litho VALUES('lithocode',1,'ALLTER','Alluvial terrace');
INSERT INTO pal (pal_code,r,g,b) VALUES('ALLTER',250,238,122);
INSERT INTO litho VALUES('lithocode',1,'LAKE','Lake or marine sediment');
INSERT INTO pal (pal_code,r,g,b) VALUES('LAKE',244,239,228);
INSERT INTO litho VALUES('lithocode',1,'PLAYA','Playa');
INSERT INTO pal (pal_code,r,g,b) VALUES('PLAYA',241,229,223);
INSERT INTO litho VALUES('lithocode',1,'MDFLT','Mud flat');
INSERT INTO pal (pal_code,r,g,b) VALUES('MDFLT',228,208,190);
INSERT INTO litho VALUES('lithocode',1,'BCHSND','Beach sand');
INSERT INTO pal (pal_code,r,g,b) VALUES('BCHSND',228,216,190);
INSERT INTO litho VALUES('lithocode',1,'TERRC','Terrace');
INSERT INTO pal (pal_code,r,g,b) VALUES('TERRC',255,246,217);
INSERT INTO litho VALUES('lithocode',1,'EOLMTRL','Eolian material');
INSERT INTO pal (pal_code,r,g,b) VALUES('EOLMTRL',224,197,158);
INSERT INTO litho VALUES('lithocode',1,'DUNSND','Dune sand');
INSERT INTO pal (pal_code,r,g,b) VALUES('DUNSND',224,210,180);
INSERT INTO litho VALUES('lithocode',1,'SNDSHT','Sand sheet');
INSERT INTO pal (pal_code,r,g,b) VALUES('SNDSHT',219,204,169);
INSERT INTO litho VALUES('lithocode',1,'LOES','Loess');
INSERT INTO pal (pal_code,r,g,b) VALUES('LOES',245,225,189);
INSERT INTO litho VALUES('lithocode',1,'VOLCASH','Volcanic ash');
INSERT INTO pal (pal_code,r,g,b) VALUES('VOLCASH',224,176,158);
INSERT INTO litho VALUES('lithocode',1,'MWMTR','Mass wasting material');
INSERT INTO pal (pal_code,r,g,b) VALUES('MWMTR',207,187,143);
INSERT INTO litho VALUES('lithocode',1,'COLLV','Colluvium');
INSERT INTO pal (pal_code,r,g,b) VALUES('COLLV',225,227,195);
INSERT INTO litho VALUES('lithocode',1,'MUDFL','Mudflow');
INSERT INTO pal (pal_code,r,g,b) VALUES('MUDFL',229,219,179);
INSERT INTO litho VALUES('lithocode',1,'LAHAR','Lahar');
INSERT INTO pal (pal_code,r,g,b) VALUES('LAHAR',220,213,180);
INSERT INTO litho VALUES('lithocode',1,'DBRFL','Debris flow');
INSERT INTO pal (pal_code,r,g,b) VALUES('DBRFL',211,202,159);
INSERT INTO litho VALUES('lithocode',1,'LNDSLD','Landslide');
INSERT INTO pal (pal_code,r,g,b) VALUES('LNDSLD',201,190,137);
INSERT INTO litho VALUES('lithocode',1,'TLUS','Talus');
INSERT INTO pal (pal_code,r,g,b) VALUES('TLUS',188,175,108);
INSERT INTO litho VALUES('lithocode',1,'GLCDRFT','Glacial drift');
INSERT INTO pal (pal_code,r,g,b) VALUES('GLCDRFT',191,167,67);
INSERT INTO litho VALUES('lithocode',1,'TILL','Till');
INSERT INTO pal (pal_code,r,g,b) VALUES('TILL',210,194,124);
INSERT INTO litho VALUES('lithocode',1,'MORN','Moraine');
INSERT INTO pal (pal_code,r,g,b) VALUES('MORN',255,238,191);
INSERT INTO litho VALUES('lithocode',1,'STRGLC','Stratified glacial sediment');
INSERT INTO pal (pal_code,r,g,b) VALUES('STRGLC',255,229,157);
INSERT INTO litho VALUES('lithocode',1,'OUTGLC','Glacial outwash sediment');
INSERT INTO pal (pal_code,r,g,b) VALUES('OUTGLC',255,223,133);
INSERT INTO litho VALUES('lithocode',1,'SUBGLC','Sub/supra-glacial sediment');
INSERT INTO pal (pal_code,r,g,b) VALUES('SUBGLC',254,230,112);
INSERT INTO litho VALUES('lithocode',1,'GLCLAC','Glaciolacustrine sediment');
INSERT INTO pal (pal_code,r,g,b) VALUES('GLCLAC',254,226,88);
INSERT INTO litho VALUES('lithocode',1,'GLCMRN','Glacial-marine sediment');
INSERT INTO pal (pal_code,r,g,b) VALUES('GLCMRN',254,219,46);
INSERT INTO litho VALUES('lithocode',1,'BIOROC','Biogenic rock');
INSERT INTO pal (pal_code,r,g,b) VALUES('BIOROC',247,243,161);
INSERT INTO litho VALUES('lithocode',1,'PEAT','Peat');
INSERT INTO pal (pal_code,r,g,b) VALUES('PEAT',255,207,129);
INSERT INTO litho VALUES('lithocode',1,'CORL','Coral');
INSERT INTO pal (pal_code,r,g,b) VALUES('CORL',255,204,153);
INSERT INTO litho VALUES('lithocode',1,'RESID','Residuum');
INSERT INTO pal (pal_code,r,g,b) VALUES('RESID',255,227,137);
INSERT INTO litho VALUES('lithocode',1,'CLAY','Clay or mud');
INSERT INTO pal (pal_code,r,g,b) VALUES('CLAY',255,219,103);
INSERT INTO litho VALUES('lithocode',1,'SILT','Silt');
INSERT INTO pal (pal_code,r,g,b) VALUES('SILT',255,211,69);
INSERT INTO litho VALUES('lithocode',1,'SND ','Sand');
INSERT INTO pal (pal_code,r,g,b) VALUES('SND ',255,203,35);
INSERT INTO litho VALUES('lithocode',1,'GRVL','Gravel');
INSERT INTO pal (pal_code,r,g,b) VALUES('GRVL',236,180,0);
INSERT INTO litho VALUES('lithocode',1,'SEDRCK','Sedimentary rock');
INSERT INTO pal (pal_code,r,g,b) VALUES('SEDRCK',146,220,183);
INSERT INTO litho VALUES('lithocode',1,'CLSTRCK','Clastic rock');
INSERT INTO pal (pal_code,r,g,b) VALUES('CLSTRCK',217,253,211);
INSERT INTO litho VALUES('lithocode',1,'MDSTN','Mudstone');
INSERT INTO pal (pal_code,r,g,b) VALUES('MDSTN',207,239,223);
INSERT INTO litho VALUES('lithocode',1,'CLYSTN','Claystone');
INSERT INTO pal (pal_code,r,g,b) VALUES('CLYSTN',213,230,204);
INSERT INTO litho VALUES('lithocode',1,'BNTNT','Bentonite');
INSERT INTO pal (pal_code,r,g,b) VALUES('BNTNT',192,208,192);
INSERT INTO litho VALUES('lithocode',1,'SHL','Shale');
INSERT INTO pal (pal_code,r,g,b) VALUES('SHL',172,228,200);
INSERT INTO litho VALUES('lithocode',1,'BLSHL','Black shale');
INSERT INTO pal (pal_code,r,g,b) VALUES('BLSHL',219,254,188);
INSERT INTO litho VALUES('lithocode',1,'OILSHL','Oil shale');
INSERT INTO pal (pal_code,r,g,b) VALUES('OILSHL',187,255,221);
INSERT INTO litho VALUES('lithocode',1,'ARGLT','Argillite');
INSERT INTO pal (pal_code,r,g,b) VALUES('ARGLT',225,240,216);
INSERT INTO litho VALUES('lithocode',1,'SLTSTN','Siltstone');
INSERT INTO pal (pal_code,r,g,b) VALUES('SLTSTN',214,254,154);
INSERT INTO litho VALUES('lithocode',1,'FINE','Fine-grained mixed clastic rock');
INSERT INTO pal (pal_code,r,g,b) VALUES('FINE',149,255,202);
INSERT INTO litho VALUES('lithocode',1,'SNDSTN','Sandstone');
INSERT INTO pal (pal_code,r,g,b) VALUES('SNDSTN',205,255,217);
INSERT INTO litho VALUES('lithocode',1,'ARNT','Arenite');
INSERT INTO pal (pal_code,r,g,b) VALUES('ARNT',166,252,170);
INSERT INTO litho VALUES('lithocode',1,'OQTZT','Orthoquartzite');
INSERT INTO pal (pal_code,r,g,b) VALUES('OQTZT',203,239,206);
INSERT INTO litho VALUES('lithocode',1,'CALCARNT','Calcarenite');
INSERT INTO pal (pal_code,r,g,b) VALUES('CALCARNT',154,206,254);
INSERT INTO litho VALUES('lithocode',1,'ARKS','Arkose');
INSERT INTO pal (pal_code,r,g,b) VALUES('ARKS',105,207,156);
INSERT INTO litho VALUES('lithocode',1,'WACK','Wacke');
INSERT INTO pal (pal_code,r,g,b) VALUES('WACK',189,219,241);
INSERT INTO litho VALUES('lithocode',1,'GRYWCK','Graywacke');
INSERT INTO pal (pal_code,r,g,b) VALUES('GRYWCK',184,234,195);
INSERT INTO litho VALUES('lithocode',1,'MEDIUM','Medium-grained mixed clastic rock');
INSERT INTO pal (pal_code,r,g,b) VALUES('MEDIUM',144,165,101);
INSERT INTO litho VALUES('lithocode',1,'CGLMRT','Conglomerate');
INSERT INTO pal (pal_code,r,g,b) VALUES('CGLMRT',183,217,204);
INSERT INTO litho VALUES('lithocode',1,'SEDBRCC','Sedimentary breccia');
INSERT INTO pal (pal_code,r,g,b) VALUES('SEDBRCC',167,186,134);
INSERT INTO litho VALUES('lithocode',1,'COARSE','Coarse-grained mixed clastic rock');
INSERT INTO pal (pal_code,r,g,b) VALUES('COARSE',165,170,173);
INSERT INTO litho VALUES('lithocode',1,'OILSTN','Olistostrome');
INSERT INTO pal (pal_code,r,g,b) VALUES('OILSTN',141,190,205);
INSERT INTO litho VALUES('lithocode',1,'MLNGE','Melange');
INSERT INTO pal (pal_code,r,g,b) VALUES('MLNGE',187,192,197);
INSERT INTO litho VALUES('lithocode',1,'CARBNT','Carbonate rock');
INSERT INTO pal (pal_code,r,g,b) VALUES('CARBNT',86,224,252);
INSERT INTO litho VALUES('lithocode',1,'LMSTN','Limestone');
INSERT INTO pal (pal_code,r,g,b) VALUES('LMSTN',67,175,249);
INSERT INTO litho VALUES('lithocode',1,'DOLSTN','Dolostone');
INSERT INTO pal (pal_code,r,g,b) VALUES('DOLSTN',107,195,255);
INSERT INTO litho VALUES('lithocode',1,'MXCARB','Mixed carbonate/clastic rock');
INSERT INTO pal (pal_code,r,g,b) VALUES('MXCARB',56,180,177);
INSERT INTO litho VALUES('lithocode',1,'MXVLCCLS','Mixed volcanic/clastic rock');
INSERT INTO pal (pal_code,r,g,b) VALUES('MXVLCCLS',96,204,191);
INSERT INTO litho VALUES('lithocode',1,'PHSPHT','Phosphorite');
INSERT INTO pal (pal_code,r,g,b) VALUES('PHSPHT',191,227,220);
INSERT INTO litho VALUES('lithocode',1,'CHMRCK','Chemical sedimentary rock');
INSERT INTO pal (pal_code,r,g,b) VALUES('CHMRCK',205,222,255);
INSERT INTO litho VALUES('lithocode',1,'EVAP','Evaporite');
INSERT INTO pal (pal_code,r,g,b) VALUES('EVAP',1,156,205);
INSERT INTO litho VALUES('lithocode',1,'CHERT','Chert');
INSERT INTO pal (pal_code,r,g,b) VALUES('CHERT',154,191,192);
INSERT INTO litho VALUES('lithocode',1,'NVCLT','Novaculite');
INSERT INTO pal (pal_code,r,g,b) VALUES('NVCLT',192,174,182);
INSERT INTO litho VALUES('lithocode',1,'IRNFRM','Iron formation');
INSERT INTO pal (pal_code,r,g,b) VALUES('IRNFRM',185,149,152);
INSERT INTO litho VALUES('lithocode',1,'EXHLT','Exhalite');
INSERT INTO pal (pal_code,r,g,b) VALUES('EXHLT',217,194,163);
INSERT INTO litho VALUES('lithocode',1,'COAL','Coal');
INSERT INTO pal (pal_code,r,g,b) VALUES('COAL',130,0,65);
INSERT INTO litho VALUES('lithocode',1,'MXCOALCLT','Mixed coal and clastic rock');
INSERT INTO pal (pal_code,r,g,b) VALUES('MXCOALCLT',110,73,9);
INSERT INTO litho VALUES('lithocode',1,'PLTRCK','Plutonic rock');
INSERT INTO pal (pal_code,r,g,b) VALUES('PLTRCK',252,110,124);
INSERT INTO litho VALUES('lithocode',1,'APLT','Aplite');
INSERT INTO pal (pal_code,r,g,b) VALUES('APLT',255,193,183);
INSERT INTO litho VALUES('lithocode',1,'PRPHY','Porphyry');
INSERT INTO pal (pal_code,r,g,b) VALUES('PRPHY',255,225,232);
INSERT INTO litho VALUES('lithocode',1,'LMPRT','Lampophyre');
INSERT INTO pal (pal_code,r,g,b) VALUES('LMPRT',228,88,145);
INSERT INTO litho VALUES('lithocode',1,'PEGM','Pegmatite');
INSERT INTO pal (pal_code,r,g,b) VALUES('PEGM',255,239,243);
INSERT INTO litho VALUES('lithocode',1,'GROID','Granitoid');
INSERT INTO pal (pal_code,r,g,b) VALUES('GROID',221,41,114);
INSERT INTO litho VALUES('lithocode',1,'ALKFDGRN','Alkali-feldspar granite');
INSERT INTO pal (pal_code,r,g,b) VALUES('ALKFDGRN',255,209,220);
INSERT INTO litho VALUES('lithocode',1,'GRNT','Granite');
INSERT INTO pal (pal_code,r,g,b) VALUES('GRNT',249,181,187);
INSERT INTO litho VALUES('lithocode',1,'PERALGRNT','Peraluminous granite');
INSERT INTO pal (pal_code,r,g,b) VALUES('PERALGRNT',248,190,174);
INSERT INTO litho VALUES('lithocode',1,'METALGRN','Metaluminous granite');
INSERT INTO pal (pal_code,r,g,b) VALUES('METALGRN',255,179,197);
INSERT INTO litho VALUES('lithocode',1,'SBALGRN','Subaluminous granite');
INSERT INTO pal (pal_code,r,g,b) VALUES('SBALGRN',255,111,107);
INSERT INTO litho VALUES('lithocode',1,'PERALKGRN','Peralkaline granite');
INSERT INTO pal (pal_code,r,g,b) VALUES('PERALKGRN',252,82,98);
INSERT INTO litho VALUES('lithocode',1,'GRND','Granodiorite');
INSERT INTO pal (pal_code,r,g,b) VALUES('GRND',233,121,166);
INSERT INTO litho VALUES('lithocode',1,'TONAL','Tonalite');
INSERT INTO pal (pal_code,r,g,b) VALUES('TONAL',252,182,182);
INSERT INTO litho VALUES('lithocode',1,'TRNDJ','Trondhjemite');
INSERT INTO pal (pal_code,r,g,b) VALUES('TRNDJ',255,167,188);
INSERT INTO litho VALUES('lithocode',1,'ALKFDSYEN','Alkali-feldpar syenite');
INSERT INTO pal (pal_code,r,g,b) VALUES('ALKFDSYEN',244,60,108);
INSERT INTO litho VALUES('lithocode',1,'QTZSYEN','Quartz syenite');
INSERT INTO pal (pal_code,r,g,b) VALUES('QTZSYEN',251,35,56);
INSERT INTO litho VALUES('lithocode',1,'SYEN','Syenite');
INSERT INTO pal (pal_code,r,g,b) VALUES('SYEN',244,26,135);
INSERT INTO litho VALUES('lithocode',1,'QZTMNZN','Quartz monzonite');
INSERT INTO pal (pal_code,r,g,b) VALUES('QZTMNZN',255,99,136);
INSERT INTO litho VALUES('lithocode',1,'MNZN','Monzonite');
INSERT INTO pal (pal_code,r,g,b) VALUES('MNZN',255,39,90);
INSERT INTO litho VALUES('lithocode',1,'QZTMNZD','Quartz monzodiorite');
INSERT INTO pal (pal_code,r,g,b) VALUES('QZTMNZD',255,129,159);
INSERT INTO litho VALUES('lithocode',1,'MNZD','Monzodiorite');
INSERT INTO pal (pal_code,r,g,b) VALUES('MNZD',255,169,157);
INSERT INTO litho VALUES('lithocode',1,'QDIOR','Quartz diorite');
INSERT INTO pal (pal_code,r,g,b) VALUES('QDIOR',232,28,0);
INSERT INTO litho VALUES('lithocode',1,'DIOR','Diorite');
INSERT INTO pal (pal_code,r,g,b) VALUES('DIOR',255,51,23);
INSERT INTO litho VALUES('lithocode',1,'DIAB','Diabase');
INSERT INTO pal (pal_code,r,g,b) VALUES('DIAB',214,0,0);
INSERT INTO litho VALUES('lithocode',1,'GBBRID','Gabbroid');
INSERT INTO pal (pal_code,r,g,b) VALUES('GBBRID',172,0,0);
INSERT INTO litho VALUES('lithocode',1,'QMZGBRR','Quartz monzogabbro');
INSERT INTO pal (pal_code,r,g,b) VALUES('QMZGBRR',255,111,91);
INSERT INTO litho VALUES('lithocode',1,'MNZGBBR','Monzogabbro');
INSERT INTO pal (pal_code,r,g,b) VALUES('MNZGBBR',227,119,173);
INSERT INTO litho VALUES('lithocode',1,'QZTGBBR','Quartz gabbro');
INSERT INTO pal (pal_code,r,g,b) VALUES('QZTGBBR',237,167,202);
INSERT INTO litho VALUES('lithocode',1,'CBBR','Gabbro');
INSERT INTO pal (pal_code,r,g,b) VALUES('CBBR',233,147,190);
INSERT INTO litho VALUES('lithocode',1,'NORI','Norite');
INSERT INTO pal (pal_code,r,g,b) VALUES('NORI',255,214,209);
INSERT INTO litho VALUES('lithocode',1,'TROC','Troctolite');
INSERT INTO pal (pal_code,r,g,b) VALUES('TROC',255,191,206);
INSERT INTO litho VALUES('lithocode',1,'ANORTH','Anorthosite');
INSERT INTO pal (pal_code,r,g,b) VALUES('ANORTH',255,149,174);
INSERT INTO litho VALUES('lithocode',1,'ALKINTRCK','Alkalic intrusive rock');
INSERT INTO pal (pal_code,r,g,b) VALUES('ALKINTRCK',255,111,145);
INSERT INTO litho VALUES('lithocode',1,'NEPHSYEN','Nepheline syenite');
INSERT INTO pal (pal_code,r,g,b) VALUES('NEPHSYEN',255,27,81);
INSERT INTO litho VALUES('lithocode',1,'UMRCK','Ultramafic intrusive rock');
INSERT INTO pal (pal_code,r,g,b) VALUES('UMRCK',232,0,55);
INSERT INTO litho VALUES('lithocode',1,'PERDTT','Peridotite');
INSERT INTO pal (pal_code,r,g,b) VALUES('PERDTT',206,0,49);
INSERT INTO litho VALUES('lithocode',1,'DUNT','Dunite');
INSERT INTO pal (pal_code,r,g,b) VALUES('DUNT',176,0,42);
INSERT INTO litho VALUES('lithocode',1,'KIMB','Kimberlite');
INSERT INTO pal (pal_code,r,g,b) VALUES('KIMB',193,1,10);
INSERT INTO litho VALUES('lithocode',1,'PYRXNT','Pyroxenite');
INSERT INTO pal (pal_code,r,g,b) VALUES('PYRXNT',148,0,35);
INSERT INTO litho VALUES('lithocode',1,'HRNBDT','Hornblendite');
INSERT INTO pal (pal_code,r,g,b) VALUES('HRNBDT',163,1,9);
INSERT INTO litho VALUES('lithocode',1,'CRBNTT','Intrusive carbonatite');
INSERT INTO pal (pal_code,r,g,b) VALUES('CRBNTT',117,1,7);
INSERT INTO litho VALUES('lithocode',1,'VLCRCK','Volcanic rock');
INSERT INTO pal (pal_code,r,g,b) VALUES('VLCRCK',255,183,222);
INSERT INTO litho VALUES('lithocode',1,'GLSSY','Glassy volcanic rock');
INSERT INTO pal (pal_code,r,g,b) VALUES('GLSSY',255,195,228);
INSERT INTO litho VALUES('lithocode',1,'OBSDN','Obsidian');
INSERT INTO pal (pal_code,r,g,b) VALUES('OBSDN',255,209,234);
INSERT INTO litho VALUES('lithocode',1,'VTRPHYR','Vitrophyre');
INSERT INTO pal (pal_code,r,g,b) VALUES('VTRPHYR',255,195,248);
INSERT INTO litho VALUES('lithocode',1,'PUMC','Pumice');
INSERT INTO pal (pal_code,r,g,b) VALUES('PUMC',255,229,243);
INSERT INTO litho VALUES('lithocode',1,'PYROCLT','Pyroclastic');
INSERT INTO pal (pal_code,r,g,b) VALUES('PYROCLT',255,224,222);
INSERT INTO litho VALUES('lithocode',1,'TUFF','Tuff');
INSERT INTO pal (pal_code,r,g,b) VALUES('TUFF',249,211,211);
INSERT INTO litho VALUES('lithocode',1,'WELTUF','Welded tuff');
INSERT INTO pal (pal_code,r,g,b) VALUES('WELTUF',255,243,201);
INSERT INTO litho VALUES('lithocode',1,'ASHFLTUF','Ash-flow tuff');
INSERT INTO pal (pal_code,r,g,b) VALUES('ASHFLTUF',255,239,217);
INSERT INTO litho VALUES('lithocode',1,'IGNBRT','Ignimbrite');
INSERT INTO pal (pal_code,r,g,b) VALUES('IGNBRT',255,229,195);
INSERT INTO litho VALUES('lithocode',1,'VOLCBRCC','Volcanic breccia');
INSERT INTO pal (pal_code,r,g,b) VALUES('VOLCBRCC',255,213,157);
INSERT INTO litho VALUES('lithocode',1,'LAVAFL','Lava flow');
INSERT INTO pal (pal_code,r,g,b) VALUES('LAVAFL',255,162,39);
INSERT INTO litho VALUES('lithocode',1,'BMDSUIT','Bimodal suite');
INSERT INTO pal (pal_code,r,g,b) VALUES('BMDSUIT',255,193,111);
INSERT INTO litho VALUES('lithocode',1,'FELSVLCRCK','Felsic volcanic rock');
INSERT INTO pal (pal_code,r,g,b) VALUES('FELSVLCRCK',244,139,0);
INSERT INTO litho VALUES('lithocode',1,'ALKFDRHYO','Alkali-feldspar rhyolite');
INSERT INTO pal (pal_code,r,g,b) VALUES('ALKFDRHYO',254,220,126);
INSERT INTO litho VALUES('lithocode',1,'RHYO','Rhyolite');
INSERT INTO pal (pal_code,r,g,b) VALUES('RHYO',254,204,104);
INSERT INTO litho VALUES('lithocode',1,'RHYDCT','Rhyodacite');
INSERT INTO pal (pal_code,r,g,b) VALUES('RHYDCT',254,198,42);
INSERT INTO litho VALUES('lithocode',1,'DCT','Dacite');
INSERT INTO pal (pal_code,r,g,b) VALUES('DCT',254,205,172);
INSERT INTO litho VALUES('lithocode',1,'ALKFDTRACH','Alkali-feldspar trachyte');
INSERT INTO pal (pal_code,r,g,b) VALUES('ALKFDTRACH',254,183,134);
INSERT INTO litho VALUES('lithocode',1,'TRCHT','Trachyte');
INSERT INTO pal (pal_code,r,g,b) VALUES('TRCHT',254,160,96);
INSERT INTO litho VALUES('lithocode',1,'QZTLTT','Quartz latite');
INSERT INTO pal (pal_code,r,g,b) VALUES('QZTLTT',254,135,54);
INSERT INTO litho VALUES('lithocode',1,'LTT','Latite');
INSERT INTO pal (pal_code,r,g,b) VALUES('LTT',254,117,24);
INSERT INTO litho VALUES('lithocode',1,'INTVLCRCK','Intermediate volcanic rock');
INSERT INTO pal (pal_code,r,g,b) VALUES('INTVLCRCK',235,96,1);
INSERT INTO litho VALUES('lithocode',1,'THRANDST','Trachyandesite');
INSERT INTO pal (pal_code,r,g,b) VALUES('THRANDST',201,82,1);
INSERT INTO litho VALUES('lithocode',1,'ANDST','Andesite');
INSERT INTO pal (pal_code,r,g,b) VALUES('ANDST',177,72,1);
INSERT INTO litho VALUES('lithocode',1,'MFVLCRCK','Mafic volcanic rock');
INSERT INTO pal (pal_code,r,g,b) VALUES('MFVLCRCK',147,60,1);
INSERT INTO litho VALUES('lithocode',1,'TRCBSLT','Trachybasalt');
INSERT INTO pal (pal_code,r,g,b) VALUES('TRCBSLT',236,213,198);
INSERT INTO litho VALUES('lithocode',1,'BSLT','Basalt');
INSERT INTO pal (pal_code,r,g,b) VALUES('BSLT',221,179,151);
INSERT INTO litho VALUES('lithocode',1,'THOL','Tholeite');
INSERT INTO pal (pal_code,r,g,b) VALUES('THOL',211,157,121);
INSERT INTO litho VALUES('lithocode',1,'HWAIT','Hawaiite');
INSERT INTO pal (pal_code,r,g,b) VALUES('HWAIT',198,128,80);
INSERT INTO litho VALUES('lithocode',1,'ALKBSLT','Alkaline basalt');
INSERT INTO pal (pal_code,r,g,b) VALUES('ALKBSLT',169,101,55);
INSERT INTO litho VALUES('lithocode',1,'ALKVLCRCK','Alkalic volcanic rock');
INSERT INTO pal (pal_code,r,g,b) VALUES('ALKVLCRCK',194,65,0);
INSERT INTO litho VALUES('lithocode',1,'PHONOL','Phonolite');
INSERT INTO pal (pal_code,r,g,b) VALUES('PHONOL',95,57,31);
INSERT INTO litho VALUES('lithocode',1,'TEPHRT','Tephrite');
INSERT INTO pal (pal_code,r,g,b) VALUES('TEPHRT',133,79,43);
INSERT INTO litho VALUES('lithocode',1,'UTRMFT','Ultramafitite');
INSERT INTO pal (pal_code,r,g,b) VALUES('UTRMFT',160,53,0);
INSERT INTO litho VALUES('lithocode',1,'VCARBNTT','Volcanic carbonatite');
INSERT INTO pal (pal_code,r,g,b) VALUES('VCARBNTT',110,37,0);
INSERT INTO litho VALUES('lithocode',1,'METRCK','Metamorphic rock');
INSERT INTO pal (pal_code,r,g,b) VALUES('METRCK',167,167,255);
INSERT INTO litho VALUES('lithocode',1,'HRNFLS','Hornfels');
INSERT INTO pal (pal_code,r,g,b) VALUES('HRNFLS',234,175,255);
INSERT INTO litho VALUES('lithocode',1,'METSDRCK','Metasedimentary rock');
INSERT INTO pal (pal_code,r,g,b) VALUES('METSDRCK',125,255,125);
INSERT INTO litho VALUES('lithocode',1,'MTARGLT','Meta-argillite');
INSERT INTO pal (pal_code,r,g,b) VALUES('MTARGLT',201,255,201);
INSERT INTO litho VALUES('lithocode',1,'SLATE','Slate');
INSERT INTO pal (pal_code,r,g,b) VALUES('SLATE',230,205,255);
INSERT INTO litho VALUES('lithocode',1,'QRTZT','Quartzite');
INSERT INTO pal (pal_code,r,g,b) VALUES('QRTZT',159,255,159);
INSERT INTO litho VALUES('lithocode',1,'MTCONGL','Metaconglomerate');
INSERT INTO pal (pal_code,r,g,b) VALUES('MTCONGL',233,255,233);
INSERT INTO litho VALUES('lithocode',1,'MARBLE','Marble');
INSERT INTO pal (pal_code,r,g,b) VALUES('MARBLE',0,0,255);
INSERT INTO litho VALUES('lithocode',1,'MTVOLRCK','Metavolcanic rock');
INSERT INTO pal (pal_code,r,g,b) VALUES('MTVOLRCK',255,87,255);
INSERT INTO litho VALUES('lithocode',1,'FELMTRCK','Felsic metavolcanic rock');
INSERT INTO pal (pal_code,r,g,b) VALUES('FELMTRCK',255,141,255);
INSERT INTO litho VALUES('lithocode',1,'MTRHYO','Metarhyolite');
INSERT INTO pal (pal_code,r,g,b) VALUES('MTRHYO',255,167,255);
INSERT INTO litho VALUES('lithocode',1,'KRTPHY','Keratophyre');
INSERT INTO pal (pal_code,r,g,b) VALUES('KRTPHY',254,103,0);
INSERT INTO litho VALUES('lithocode',1,'INTMTRCK','Intermediate metavolcanic rock');
INSERT INTO pal (pal_code,r,g,b) VALUES('INTMTRCK',255,0,0);
INSERT INTO litho VALUES('lithocode',1,'MFMTRCK','Mafic metavolcanic rock');
INSERT INTO pal (pal_code,r,g,b) VALUES('MFMTRCK',185,59,104);
INSERT INTO litho VALUES('lithocode',1,'MTBSLT','Metabasalt');
INSERT INTO pal (pal_code,r,g,b) VALUES('MTBSLT',135,43,76);
INSERT INTO litho VALUES('lithocode',1,'SPLT','Spilite');
INSERT INTO pal (pal_code,r,g,b) VALUES('SPLT',201,85,126);
INSERT INTO litho VALUES('lithocode',1,'GRSTN','Greenstone');
INSERT INTO pal (pal_code,r,g,b) VALUES('GRSTN',0,128,0);
INSERT INTO litho VALUES('lithocode',1,'PHYLT','Phyllite');
INSERT INTO pal (pal_code,r,g,b) VALUES('PHYLT',180,207,228);
INSERT INTO litho VALUES('lithocode',1,'SCHST','Schist');
INSERT INTO pal (pal_code,r,g,b) VALUES('SCHST',219,219,231);
INSERT INTO litho VALUES('lithocode',1,'GRSCHST','Greenschist');
INSERT INTO pal (pal_code,r,g,b) VALUES('GRSCHST',237,237,243);
INSERT INTO litho VALUES('lithocode',1,'BLSCHST','Blueschist');
INSERT INTO pal (pal_code,r,g,b) VALUES('BLSCHST',192,192,192);
INSERT INTO litho VALUES('lithocode',1,'MICSCHST','Mica schist');
INSERT INTO pal (pal_code,r,g,b) VALUES('MICSCHST',177,177,177);
INSERT INTO litho VALUES('lithocode',1,'PLTSCHST','Pelitic schist');
INSERT INTO pal (pal_code,r,g,b) VALUES('PLTSCHST',202,202,220);
INSERT INTO litho VALUES('lithocode',1,'QFSCHST','Quartz-feldspar schist');
INSERT INTO pal (pal_code,r,g,b) VALUES('QFSCHST',162,162,192);
INSERT INTO litho VALUES('lithocode',1,'CALCFDSCHT','Calc-silicate schist');
INSERT INTO pal (pal_code,r,g,b) VALUES('CALCFDSCHT',182,182,206);
INSERT INTO litho VALUES('lithocode',1,'AMPSCHT','Amphibole schist');
INSERT INTO pal (pal_code,r,g,b) VALUES('AMPSCHT',150,150,150);
INSERT INTO litho VALUES('lithocode',1,'GRNFLS','Granofels');
INSERT INTO pal (pal_code,r,g,b) VALUES('GRNFLS',163,55,253);
INSERT INTO litho VALUES('lithocode',1,'GNSS','Gneiss');
INSERT INTO pal (pal_code,r,g,b) VALUES('GNSS',236,214,254);
INSERT INTO litho VALUES('lithocode',1,'FELGNSS','Felsic gneiss');
INSERT INTO pal (pal_code,r,g,b) VALUES('FELGNSS',224,188,254);
INSERT INTO litho VALUES('lithocode',1,'GRNGNSS','Granitic gneiss');
INSERT INTO pal (pal_code,r,g,b) VALUES('GRNGNSS',213,164,254);
INSERT INTO litho VALUES('lithocode',1,'BTTGNSS','Biotite gneiss');
INSERT INTO pal (pal_code,r,g,b) VALUES('BTTGNSS',200,134,254);
INSERT INTO litho VALUES('lithocode',1,'MAFGNSS','Mafic gneiss');
INSERT INTO pal (pal_code,r,g,b) VALUES('MAFGNSS',204,183,255);
INSERT INTO litho VALUES('lithocode',1,'ORGNSS','Orthogneiss');
INSERT INTO pal (pal_code,r,g,b) VALUES('ORGNSS',179,149,255);
INSERT INTO litho VALUES('lithocode',1,'PRGNSS','Paragneiss');
INSERT INTO pal (pal_code,r,g,b) VALUES('PRGNSS',144,99,255);
INSERT INTO litho VALUES('lithocode',1,'MIGMTT','Migmatite');
INSERT INTO pal (pal_code,r,g,b) VALUES('MIGMTT',159,0,202);
INSERT INTO litho VALUES('lithocode',1,'AMPHBLT','Amphibolite');
INSERT INTO pal (pal_code,r,g,b) VALUES('AMPHBLT',123,0,156);
INSERT INTO litho VALUES('lithocode',1,'GRANUL','Granulite');
INSERT INTO pal (pal_code,r,g,b) VALUES('GRANUL',106,0,106);
INSERT INTO litho VALUES('lithocode',1,'ECLGT','Eclogite');
INSERT INTO pal (pal_code,r,g,b) VALUES('ECLGT',206,157,255);
INSERT INTO litho VALUES('lithocode',1,'GREISSEN','Greisen');
INSERT INTO pal (pal_code,r,g,b) VALUES('GREISSEN',164,73,255);
INSERT INTO litho VALUES('lithocode',1,'SKARN','Skarn');
INSERT INTO pal (pal_code,r,g,b) VALUES('SKARN',129,3,255);
INSERT INTO litho VALUES('lithocode',1,'CACSILRCK','Calc-silicate rock');
INSERT INTO pal (pal_code,r,g,b) VALUES('CACSILRCK',70,0,140);
INSERT INTO litho VALUES('lithocode',1,'SERPTN','Serpentinite');
INSERT INTO pal (pal_code,r,g,b) VALUES('SERPTN',0,92,0);
INSERT INTO litho VALUES('lithocode',1,'TCTNT','Tectonite');
INSERT INTO pal (pal_code,r,g,b) VALUES('TCTNT',132,97,62);
INSERT INTO litho VALUES('lithocode',1,'TECMLNG','Tectonic melange');
INSERT INTO pal (pal_code,r,g,b) VALUES('TECMLNG',208,203,176);
INSERT INTO litho VALUES('lithocode',1,'TECBRCC','Tectonic breccia');
INSERT INTO pal (pal_code,r,g,b) VALUES('TECBRCC',176,167,120);
INSERT INTO litho VALUES('lithocode',1,'CATCLST','Cataclasite');
INSERT INTO pal (pal_code,r,g,b) VALUES('CATCLST',136,127,80);
INSERT INTO litho VALUES('lithocode',1,'PHYLNT','Phyllonite');
INSERT INTO pal (pal_code,r,g,b) VALUES('PHYLNT',172,127,80);
INSERT INTO litho VALUES('lithocode',1,'MYLNT','Mylonite');
INSERT INTO pal (pal_code,r,g,b) VALUES('MYLNT',109,80,51);
INSERT INTO litho VALUES('lithocode',1,'FLSGNSS','Flaser gneiss');
INSERT INTO pal (pal_code,r,g,b) VALUES('FLSGNSS',100,2,11);
INSERT INTO litho VALUES('lithocode',1,'AUGGNSS','Augen gneiss');
INSERT INTO pal (pal_code,r,g,b) VALUES('AUGGNSS',136,127,80);
INSERT INTO litho VALUES('lithocode',1,'ORGSOL','A Horizon');
INSERT INTO pal (pal_code,r,g,b) VALUES('ORGSOL',8,7,4);
INSERT INTO litho VALUES('lithocode',1,'PDLIT','B Horizon');
INSERT INTO pal (pal_code,r,g,b) VALUES('PDLIT',108,166,214);
INSERT INTO litho VALUES('lithocode',1,'SPRLT','C Horizon');
INSERT INTO pal (pal_code,r,g,b) VALUES('SPRLT',228,184,74);
INSERT INTO litho VALUES('lithocode',1,'SPRCK','Saprock');
INSERT INTO pal (pal_code,r,g,b) VALUES('SPRCK',250,115,14);
