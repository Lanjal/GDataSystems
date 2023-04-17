CREATE TABLE soil (
 id           serial,   
 projeto      varchar(50), 
 alvo         varchar(50), 
 ponto        varchar(100) NOT NULL UNIQUE,
 amostra      varchar(100) UNIQUE,
 duplicata    varchar(100),
 branco       varchar(100),
 padrao       varchar(100),
 reamostra    varchar(100),
 tipo         varchar(100),
 utme         numeric(15,7)	not null,
 utmn         numeric(15,7)  not null,
 elev         numeric(7,3) not null, 
 geom         geometry(POINTZ,32723), --Mudar para o SRID do projeto
 datum 		  varchar(50) NOT NULL DEFAULT 'WGS84',
 _zone 		  integer NOT NULL DEFAULT 23,--Mudar para a ZONA do projeto
 ns 		  varchar(2) NOT NULL DEFAULT 'S', --S  para hemisfério Sul e N para hemisfério Norte
 tipoperfil   varchar(100),              
 profm        numeric(7,2),          
 cor          varchar(100),
 tipoamostr   varchar(100),
 granul       varchar(100),
 relevo       varchar(100),
 fragmentos   varchar(100),
 magnetismo   varchar(100),
 vegetacao    text,
 peso 		  numeric(6,2),
 resp 		  varchar(50), 
 _data        date,                 
 obs          text,  
 coletado     boolean,  
 tstp         timestamp not null DEFAULT now(),
 who          varchar(50)  not null
);
-- *****************************************************************************************
CREATE TABLE sedcor (
 id           serial,   
 projeto      varchar(50), 
 alvo         varchar(50), 
 ponto        varchar(100) NOT NULL UNIQUE,
 amostra      varchar(100) UNIQUE,
 duplicata    varchar(100),
 branco       varchar(100),
 padrao       varchar(100),
 reamostra    varchar(100),
 tipo         varchar(100),
 utme         numeric(15,7)	not null,
 utmn         numeric(15,7)  not null,
 elev         numeric(7,3) not null, 
 geom         geometry(POINTZ,32723), --Mudar para o SRID do projeto
 datum 		  varchar(50) NOT NULL DEFAULT 'WGS84',
 _zone 		  integer NOT NULL DEFAULT 23,--Mudar para a ZONA do projeto
 ns 		  varchar(2) NOT NULL DEFAULT 'S', --S  para hemisfério Sul e N para hemisfério Norte
 descri		  text, 
 concentrad   boolean, 
 fragmentos   text,
 matriz		  text,
 comp_frag    text,
 compactaca   text,
 ambiente	  text,
 resp 		  varchar(50), 
 _data        date,                 
 obs          text,  
 coletado     boolean,  
 tstp         timestamp not null DEFAULT now(),
 who          varchar(50)  not null
);

-- Altere os valores de usuariosolo e usuariosed e senhas 
-- de acordo com os usuário que usarão o sistema

CREATE USER usuariosolo WITH PASSWORD 'senhaSecreta';
GRANT SELECT,INSERT,UPDATE,DELETE ON soil TO usuariosolo;
GRANT SELECT,UPDATE ON soil_id_seq TO usuariosolo;

CREATE USER usuariosed WITH PASSWORD 'senhaSecreta';
GRANT SELECT,INSERT,UPDATE,DELETE ON sedcor TO usuariosed;
GRANT SELECT,UPDATE ON sedcor_id_seq TO usuariosed;
