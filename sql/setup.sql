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
INSERT INTO lookup VALUES('Srid',32724,'WGS84_24S');        
INSERT INTO lookup VALUES('Srid',32723,'WGS84_23S');        
INSERT INTO lookup VALUES('Srid',27223,'WGS84_22S');        
INSERT INTO lookup VALUES('Srid',32721,'WGS84_21S');        
INSERT INTO lookup VALUES('Srid',32720,'WGS84_20S');        
INSERT INTO lookup VALUES('Srid',32120,'WGS84_20N');        
INSERT INTO lookup VALUES('Srid',32121,'WGS84_21N');        
INSERT INTO lookup VALUES('Srid',32122,'WGS84_22N');        
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
INSERT INTO lookup VALUES('outcrop',1,'OUTCROP');        
INSERT INTO lookup VALUES('outcrop',2,'SUB-OUTCROP');        
INSERT INTO lookup VALUES('outcrop',3,'BLOCK');        
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
