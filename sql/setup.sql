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



CREATE USER gdatasystems WITH PASSWORD 'secret';
GRANT SELECT,INSERT,UPDATE,DELETE ON soil TO gdatasystems;
GRANT SELECT,UPDATE ON soil_id_seq TO gdatasystems;
GRANT SELECT,INSERT,UPDATE,DELETE ON strmsed TO gdatasystems;
GRANT SELECT,UPDATE ON strmsed_id_seq TO gdatasystems;
GRANT SELECT,INSERT,UPDATE,DELETE ON augerheader TO gdatasystems;
GRANT SELECT,UPDATE ON augerheader_id_seq TO gdatasystems;
GRANT SELECT,INSERT,UPDATE,DELETE ON augerinterval TO gdatasystems;
GRANT SELECT,UPDATE ON augerinterval_id_seq TO gdatasystems;

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
INSERT INTO lookup VALUES('magnetism',1,'NONE');        
INSERT INTO lookup VALUES('magnetism',2,'WEAK');        
INSERT INTO lookup VALUES('magnetism',3,'MODERATE');        
INSERT INTO lookup VALUES('magnetism',4,'STRONG');        

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

INSERT INTO litho VALUES('lithocode',1,'ORGSOL','A Horizon');
INSERT INTO pal (pal_code,r,g,b) VALUES('ORGSOL',8,7,4);
INSERT INTO litho VALUES('lithocode',1,'PDLIT','B Horizon');
INSERT INTO pal (pal_code,r,g,b) VALUES('PDLIT',108,166,214);
INSERT INTO litho VALUES('lithocode',1,'SPRLT','C Horizon');
INSERT INTO pal (pal_code,r,g,b) VALUES('SPRLT',228,184,74);
INSERT INTO litho VALUES('lithocode',1,'SPRCK','Saprock');
INSERT INTO pal (pal_code,r,g,b) VALUES('SPRCK',250,115,14);
