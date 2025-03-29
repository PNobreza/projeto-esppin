-- -----------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------
-- SCHEMA: _referencia
-- -----------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------

DROP SCHEMA IF EXISTS _referencia CASCADE;
CREATE SCHEMA IF NOT EXISTS _referencia AUTHORIZATION postgres;
COMMENT ON SCHEMA _referencia	IS 'Dados de Referência: Critérios, Indicadores e Variáveis.';
GRANT USAGE ON SCHEMA _referencia TO n2espindesenv;
GRANT ALL ON SCHEMA _referencia TO postgres;


SET search_path TO _referencia, public;

DROP VIEW   IF  EXISTS _referencia.vw_h_criteriosindicadores_socamb;
DROP VIEW   IF  EXISTS _referencia.vwindicadorref_socamb;
DROP TABLE IF  EXISTS _referencia.dbindicadorref_socamb;
DROP VIEW   IF EXISTS _referencia.vwcriterioref_socamb;
DROP TABLE  IF EXISTS _referencia.dbcriterioref_socamb;
DROP VIEW   IF EXISTS _referencia.vwdimensaoaspecto_socamb;
DROP TABLE  IF EXISTS _referencia.dbdimensaoaspecto_socamb;
DROP FUNCTION IF EXISTS _referencia.fn_carimbaversao(varchar(10));
DROP TABLE  IF EXISTS _referencia.dbcontroleversao;


-- -----------------------------------------------------------------------------------------
-- Table: _referencia.dbcontroleversao
-- -----------------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS _referencia.dbcontroleversao
(
    id 				    SERIAL NOT NULL ,
    metodo 			    character varying(10),
    versao 			    character varying(8),
    CONSTRAINT pk_dbcontroleversao PRIMARY KEY (id),

    CONSTRAINT unq_metodoversao UNIQUE (metodo, versao) INCLUDE(metodo, versao)
)
TABLESPACE pg_default;
ALTER TABLE IF EXISTS _referencia.dbcontroleversao OWNER to postgres;
GRANT ALL ON TABLE _referencia.dbcontroleversao TO n2espindesenv;
GRANT ALL ON TABLE _referencia.dbcontroleversao TO postgres;
GRANT ALL ON SEQUENCE _referencia.dbcontroleversao_id_seq TO n2espindesenv; 
INSERT INTO _referencia.dbcontroleversao (metodo,versao) VALUES
('SOCAMB', '20241001'),
('INSTIT', '20241001'),
('OUTROS', '20241001'),
('CONGRU', '20241001')
;


CREATE FUNCTION _referencia.fn_carimbaversao(varchar(10)) RETURNS varchar(10) AS '
    SELECT MAX(versao) FROM _referencia.dbcontroleversao AS dbcv WHERE dbcv.metodo = $1 ;
' LANGUAGE SQL;
ALTER FUNCTION _referencia.fn_carimbaversao OWNER to postgres;
GRANT ALL ON FUNCTION _referencia.fn_carimbaversao TO n2espindesenv;
GRANT ALL ON FUNCTION _referencia.fn_carimbaversao TO postgres;



-- -----------------------------------------------------------------------------------------
-- Table: _referencia.dbdimensaoaspecto_socamb
-- -----------------------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS _referencia.dbdimensaoaspecto_socamb
(
    id 				    SERIAL NOT NULL ,
    nome 			    character varying(50),
    sigla 			    character varying(20),
    ativo 			    character(1) DEFAULT 'S'::bpchar,
    versao              VARCHAR(8) DEFAULT _referencia.fn_carimbaversao('SOCAMB'),
    inc_data 			TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    inc_idusuario 		integer,
    alt_data 			TIMESTAMP WITHOUT TIME ZONE,
    alt_idusuario 		integer,
    exc_data 			TIMESTAMP WITHOUT TIME ZONE,
    exc_idusuario 		integer,
    CONSTRAINT pk_dbdimensaoaspecto_socamb PRIMARY KEY (id),

    CONSTRAINT fk_dbdimensaoaspecto_socamb_user_inc FOREIGN KEY (inc_idusuario)
        REFERENCES _adm.system_users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
	
    CONSTRAINT fk_dbdimensaoaspecto_socamb_user_alt FOREIGN KEY (alt_idusuario)
        REFERENCES _adm.system_users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
	
    CONSTRAINT fk_dbdimensaoaspecto_socamb_user_exc FOREIGN KEY (exc_idusuario)
        REFERENCES _adm.system_users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
TABLESPACE pg_default;

ALTER TABLE IF EXISTS _referencia.dbdimensaoaspecto_socamb OWNER to postgres;
GRANT ALL ON TABLE _referencia.dbdimensaoaspecto_socamb TO n2espindesenv;
GRANT ALL ON TABLE _referencia.dbdimensaoaspecto_socamb TO postgres;
GRANT ALL ON SEQUENCE _referencia.dbdimensaoaspecto_socamb_id_seq TO n2espindesenv; 

INSERT INTO _referencia.dbdimensaoaspecto_socamb (sigla,nome,inc_idusuario) VALUES
('DA01C000I000', 'Impactos Ecológicos - Eficiência Tecnológica', 1),
('DA02C000I000', 'Impactos Ecológicos - Qualidade Ambiental', 1),
('DA03C000I000', 'Impactos Sócio-Ambientais - Respeito ao Consumidor', 1),
('DA04C000I000', 'Impactos Sócio-Ambientais - Trabalho & Emprego', 1),
('DA05C000I000', 'Impactos Sócio-Ambientais - Renda', 1),
('DA06C000I000', 'Impactos Sócio-Ambientais - Saúde', 1),
('DA07C000I000', 'Impactos Sócio-Ambientais - Gestão e Administração', 1)
;

-- -----------------------------------------------------------------------------------------
-- View: _referencia.vwdimensaoaspecto_socamb
-- -----------------------------------------------------------------------------------------

CREATE OR REPLACE VIEW _referencia.vwdimensaoaspecto_socamb
 AS
 SELECT 
    dbda.id,
    dbda.nome,
    dbda.sigla,
    dbda.ativo,
    dbda.versao,
    dbda.inc_data,
    dbda.inc_idusuario,
    dbda.alt_data,
    dbda.alt_idusuario,
    dbda.exc_data,
    dbda.exc_idusuario
   FROM _referencia.dbdimensaoaspecto_socamb dbda
   WHERE dbda.exc_data IS NULL
   AND dbda.ativo = 'S'
   AND dbda.versao = _referencia.fn_carimbaversao('SOCAMB')
;

ALTER TABLE _referencia.vwdimensaoaspecto_socamb  OWNER TO postgres;
GRANT ALL ON TABLE _referencia.vwdimensaoaspecto_socamb TO n2espindesenv;
GRANT ALL ON TABLE _referencia.vwdimensaoaspecto_socamb TO postgres;




-- -----------------------------------------------------------------------------------------
-- Table: _referencia.DBCRITERIOREF_SOCAMB
-- -----------------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS _referencia.dbcriterioref_socamb
(
    id 				    SERIAL NOT NULL ,
    iddimaspecto        INTEGER NOT NULL,
    nome 			    character varying(100),
    sigla 			    character varying(20),
    valorimportancia    NUMERIC(4,3) DEFAULT 0.100 ,
    versao              VARCHAR(8) DEFAULT _referencia.fn_carimbaversao('SOCAMB'),
    ativo 			    character(1) DEFAULT 'S'::bpchar,
    inc_data 			TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    inc_idusuario 		integer,
    alt_data 			TIMESTAMP WITHOUT TIME ZONE,
    alt_idusuario 		integer,
    exc_data 			TIMESTAMP WITHOUT TIME ZONE,
    exc_idusuario 		integer,
    CONSTRAINT pk_dbcriterioref_socamb PRIMARY KEY (id),

    CONSTRAINT fk_dbcriterioref_socamb_dbdimensaoaspecto_socamb FOREIGN KEY (iddimaspecto)
        REFERENCES _referencia.dbdimensaoaspecto_socamb (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,

    CONSTRAINT fk_dbcriterioref_socamb_user_inc FOREIGN KEY (inc_idusuario)
        REFERENCES _adm.system_users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
	
    CONSTRAINT fk_dbcriterioref_socamb_user_alt FOREIGN KEY (alt_idusuario)
        REFERENCES _adm.system_users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
	
    CONSTRAINT fk_dbcriterioref_socamb_user_exc FOREIGN KEY (exc_idusuario)
        REFERENCES _adm.system_users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
TABLESPACE pg_default;

ALTER TABLE IF EXISTS _referencia.dbcriterioref_socamb OWNER to postgres;
GRANT ALL ON TABLE _referencia.dbcriterioref_socamb TO n2espindesenv;
GRANT ALL ON TABLE _referencia.dbcriterioref_socamb TO postgres;
GRANT ALL ON SEQUENCE _referencia.dbcriterioref_socamb_id_seq TO n2espindesenv; 



-- -------------------------------------------------------------------------------------
/* Impactos Ecológicos - Eficiência Tecnológica */
-- -------------------------------------------------------------------------------------
insert into _referencia.dbcriterioref_socamb (iddimaspecto,nome,valorimportancia ) VALUES 
(1, 'MUDANCA NO USO DIRETO DA TERRA', '0.05'),
(1, 'MUDANCA NO USO INDIRETO DA TERRA', '0.05'),
(1, 'CONSUMO DE AGUA', '0.05'),
(1, 'USO DE INSUMOS AGRICOLAS', '0.05'),
(1, 'USO DE INSUMOS VETERINARIOS E MATERIAS-PRIMAS', '0.05'),
(1, 'CONSUMO DE ENERGIA', '0.05'),
(1, 'GERACAO PROPRIA, APROVEITAMENTO, REUSO E AUTONOMIA', '0.025');

-- -------------------------------------------------------------------------------------
/* Impactos Ecológicos - Qualidade Ambiental */
-- -------------------------------------------------------------------------------------
insert into _referencia.dbcriterioref_socamb (iddimaspecto,nome,valorimportancia ) VALUES 
(2, 'EMISSOES A ATMOSFERA', '0.02'),         
(2, 'QUALIDADE DO SOLO', '0.05'),                                                               
(2, 'QUALIDADE DA AGUA', '0.05'),                                                                  
(2, 'CONSERVACAO DA BIODIVERSIDADE E RECUPERACAO AMBIENTAL', '0.05');                              

-- -------------------------------------------------------------------------------------
/* Impactos Socio-Ambientais - Respeito ao Consumidor */
-- -------------------------------------------------------------------------------------
insert into _referencia.dbcriterioref_socamb (iddimaspecto,nome,valorimportancia ) VALUES 
(3, 'QUALIDADE DO PRODUTO', '0.05'),
(3, 'CAPITAL SOCIAL', '0.02'),                                                               
(3, 'BEM-ESTAR E SAUDE ANIMAL', '0.02');                                                           
-- -------------------------------------------------------------------------------------
/* Impactos Socio-Ambientais - Trabalho / Emprego */
-- -------------------------------------------------------------------------------------
insert into _referencia.dbcriterioref_socamb (iddimaspecto,nome,valorimportancia ) VALUES 
(4, 'CAPACITACAO', '0.02'),                                                                        
(4, 'QUALIFICACAO E OFERTA DE TRABALHO', '0.02'),                                                  
(4, 'QUALIDADE DO EMPREGO / OCUPACAO', '0.05'),
(4, 'OPORTUNIDADE, EMANCIPACAO E RECOMPENSA EQUITATIVA ENTRE GENEROS, GERACOES E ETNIAS', '0.02'); 
-- -------------------------------------------------------------------------------------
/* Impactos Socio-Ambientais - Renda */
-- -------------------------------------------------------------------------------------
insert into _referencia.dbcriterioref_socamb (iddimaspecto,nome,valorimportancia ) VALUES 
(5, 'GERACAO DE RENDA', '0.05'),
(5, 'VALOR DA PROPRIEDADE', '0.02');                                                               
-- -------------------------------------------------------------------------------------
/* Impactos Socio-Ambientais - Saúde */
-- -------------------------------------------------------------------------------------
insert into _referencia.dbcriterioref_socamb (iddimaspecto,nome,valorimportancia ) VALUES 
(6, 'SEGURANCA E SAUDE OCUPACIONAL', '0.025'),
(6, 'SEGURANCA ALIMENTAR', '0.05');                                                                
-- -------------------------------------------------------------------------------------
/* Impactos Socio-Ambientais - Gestão e Administração */
-- -------------------------------------------------------------------------------------
insert into _referencia.dbcriterioref_socamb (iddimaspecto,nome,valorimportancia ) VALUES 
(7, 'DEDICACAO E PERFIL DO RESPONSAVEL', '0.05'),
(7, 'CONDICAO DE COMERCIALIZACAO', '0.05'),                                                  
(7, 'DISPOSICAO DE RESIDUOS', '0.02'),                                                        
(7, 'GESTAO DE INSUMOS QUIMICOS', '0.02'),                                                         
(7, 'RELACIONAMENTO INSTITUCIONAL', '0.02');                                                       

UPDATE _referencia.dbcriterioref_socamb 
SET sigla = 'DA'||substring((iddimaspecto+100)::varchar,2,2)||'C'||substring( (id+1000)::varchar,2,3)||'I000' 
WHERE sigla IS NULL;



-- -----------------------------------------------------------------------------------------
-- Table: _REFERENCIA.VWCRITERIOREF_SOCAMB
-- -----------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW _referencia.vwcriterioref_socamb
AS
SELECT 
        dbcrsa.id 				    ,
        dbcrsa.iddimaspecto         ,
        vwdasa.nome                 AS nome_dimensaoaspecto,
        vwdasa.sigla                AS sigla_dimensaoaspecto,
        dbcrsa.nome 			    ,
        dbcrsa.sigla 			    ,
        dbcrsa.valorimportancia     ,
        dbcrsa.versao 			    ,
        dbcrsa.ativo 			    ,
        dbcrsa.inc_data 			,
        dbcrsa.inc_idusuario 		,
        dbcrsa.alt_data 			,
        dbcrsa.alt_idusuario 		,
        dbcrsa.exc_data 			,
        dbcrsa.exc_idusuario 		
FROM _referencia.dbcriterioref_socamb dbcrsa
JOIN _referencia.vwdimensaoaspecto_socamb vwdasa ON ( dbcrsa.iddimaspecto = vwdasa.id )
WHERE dbcrsa.ativo = 'S' 
  AND dbcrsa.exc_data IS NULL
  AND dbcrsa.versao = _referencia.fn_carimbaversao('SOCAMB')
ORDER BY dbcrsa.sigla ASC
; 
ALTER TABLE IF EXISTS _referencia.vwcriterioref_socamb OWNER to postgres;
GRANT ALL ON TABLE _referencia.vwcriterioref_socamb TO n2espindesenv;
GRANT ALL ON TABLE _referencia.vwcriterioref_socamb TO postgres;



-- -----------------------------------------------------------------------------------------
-- Table: _referencia.DBINDICADORREF_SOCAMB
-- -----------------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS _referencia.dbindicadorref_socamb
(
    id 				    SERIAL NOT NULL ,
    idcriterio          INTEGER NOT NULL,
    nome 			    character varying(150),
    sigla 			    character varying(20),
    valorimportancia    NUMERIC(4,3) DEFAULT 0.100 ,
    versao              VARCHAR(8) DEFAULT _referencia.fn_carimbaversao('SOCAMB'),
    ativo 			    character(1) DEFAULT 'S'::bpchar,
    inc_data 			TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    inc_idusuario 		integer,
    alt_data 			TIMESTAMP WITHOUT TIME ZONE,
    alt_idusuario 		integer,
    exc_data 			TIMESTAMP WITHOUT TIME ZONE,
    exc_idusuario 		integer,
    CONSTRAINT pk_dbindicadorref_socamb PRIMARY KEY (id),

    CONSTRAINT fk_dbindicadorref_socamb_dbcriterioref_socamb FOREIGN KEY (idcriterio)
        REFERENCES _referencia.dbcriterioref_socamb (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,

    CONSTRAINT fk_dbindicadorref_socamb_user_inc FOREIGN KEY (inc_idusuario)
        REFERENCES _adm.system_users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
	
    CONSTRAINT fk_dbindicadorref_socamb_user_alt FOREIGN KEY (alt_idusuario)
        REFERENCES _adm.system_users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
	
    CONSTRAINT fk_dbindicadorref_socamb_user_exc FOREIGN KEY (exc_idusuario)
        REFERENCES _adm.system_users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
TABLESPACE pg_default;

ALTER TABLE IF EXISTS _referencia.dbindicadorref_socamb OWNER to postgres;
GRANT ALL ON TABLE _referencia.dbindicadorref_socamb TO n2espindesenv;
GRANT ALL ON TABLE _referencia.dbindicadorref_socamb TO postgres;
GRANT ALL ON SEQUENCE _referencia.dbindicadorref_socamb_id_seq TO n2espindesenv; 


-- -----------------------------------------------------------------------------------------
-- View: _referencia.VWINDICADORREF_SOCAMB
-- -----------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW  _referencia.vwindicadorref_socamb
AS
SELECT 
    dbindsa.id 				    ,
    vwcrsa.iddimaspecto         ,
    vwdasa.sigla                AS sigla_dimensaoaspecto,
    vwdasa.nome                 AS nome_dimensaoaspecto,
    dbindsa.idcriterio          ,
    vwcrsa.sigla                AS sigla_criterio,
    vwcrsa.nome                 AS nome_criterio,
    dbindsa.nome 			    ,
    dbindsa.sigla 			    ,
    dbindsa.valorimportancia    ,
    dbindsa.versao              ,
    dbindsa.ativo 			    ,
    dbindsa.inc_data 			,
    dbindsa.inc_idusuario 		,
    dbindsa.alt_data 			,
    dbindsa.alt_idusuario 		,
    dbindsa.exc_data 			,
    dbindsa.exc_idusuario 		
FROM _referencia.dbindicadorref_socamb dbindsa
JOIN _referencia.vwcriterioref_socamb vwcrsa ON ( dbindsa.idcriterio = vwcrsa.id )
JOIN _referencia.vwdimensaoaspecto_socamb vwdasa ON ( vwcrsa.iddimaspecto = vwdasa.id )
WHERE dbindsa.ativo = 'S' 
  AND dbindsa.exc_data IS NULL
  AND dbindsa.versao = _referencia.fn_carimbaversao('SOCAMB')
ORDER BY dbindsa.sigla ASC
; 
ALTER TABLE IF EXISTS _referencia.vwindicadorref_socamb OWNER to postgres;
GRANT ALL ON TABLE _referencia.vwindicadorref_socamb TO n2espindesenv;
GRANT ALL ON TABLE _referencia.vwindicadorref_socamb TO postgres;



insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (1, '', 'ESTOQUE DE CARBONO', '0.25');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (1, '', 'PREVENCAO DE INCENDIOS', '0.25');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (1, '', 'BIODIVERSIDADE PRODUTIVA', '0.25');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (1, '', 'PRODUTIVIDADE POR UNIDADE DE AREA (EFEITO POUPA TERRA)', '0.25');

insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (2, '', 'COMPETICAO COM PRODUCAO DE ALIMENTOS', '-0.25');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (2, '', 'COMPETICAO PELA PROPRIEDADE DA TERRA', '-0.25');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (2, '', 'PRESSAO DE DESLOCAMENTO SOBRE AREAS NAO AGRICOLAS', '-0.25');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (2, '', 'INTERFERENCIA SOBRE A POSSE E USOS PELAS COMUNIDADES LOCAIS', '-0.25');

insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (3, '', 'AGUA PARA IRRIGACAO', '-0.2');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (3, '', 'USO ALEM DA DISPONIBILIDADE TEMPORARIA', '-0.2');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (3, '', 'COMPROMETIMENTO DO USO POR CONTAMINACAO', '-0.2');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (3, '', 'COMPROMETIMENTO DA CAPTACAO / ARMAZENAMENTO', '-0.2');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (3, '', 'AGUA PARA PROCESSAMENTE (INCLUSIVE DESSENDENTACAO)', '-0.2');

insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (4, '', 'FERTILIZANTES - CONDICIONADORES DE SOLO', '-0.1');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (4, '', 'FERTILIZANTES - ADUBOS QUIMICOS', '-0.2');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (4, '', 'PESTICIDAS - FREQUENCIA DE APLICACAO', '-0.2');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (4, '', 'PESTICIDAS - VARIEDADE DE INGREDIENTES ATIVOS (NAO ALTERNADOS)', '-0.2');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (4, '', 'PESTICIDAS - TOXICICIDADE', '-0.3');

insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (5, '', 'USO DE MATERIAS-PRIMAS - MATERIAS-PRIMAS BASICAS', '-0.1');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (5, '', 'USO DE MATERIAS-PRIMAS - ADITIVOS AGROINDUSTRIAIS', '-0.1');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (5, '', 'USO DE MATERIAS-PRIMAS - MATERIAS-PRIMAS PARA PROCESSO', '-0.1');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (5, '', 'USO DE INSUMOS - RACOES E SUPLEMENTOS', '-0.2');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (5, '', 'USO DE INSUMOS - FENO, SILAGEM, FORRAGEM', '-0.2');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (5, '', 'USO DE INSUMOS - PRODUTOS VETERINARIOS', '-0.3');

insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (6, '', 'FONTES DE ENERGIA - BIO-COMBUSTIVEIS', '-0.1');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (6, '', 'FONTES DE ENERGIA - BIOMASSA (LENHA, BAGACOS, ETC)', '-0.1');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (6, '', 'FONTES DE ENERGIA - COMBUSTIVEIS FOSSEIS', '-0.3');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (6, '', 'FONTES DE ENERGIA - ELETRICIDADE', '-0.5');

insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (7, '', 'AUTONOMIA MATERIAL E ENERGETICA - (CO)GERACAO MOTRIZ OU ELETRICA (SOLAR, EOLICA, HIDRO, BIOGAS)', '0.3');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (7, '', 'AUTONOMIA MATERIAL E ENERGETICA - APROVEITAMENTO TERMICO (CONSUMO ENERGETICO EVITADO)', '0.15');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (7, '', 'AUTONOMIA MATERIAL E ENERGETICA - CONTROLE BIOLOGICO | MANEJO ECOLOGICO DE PRAGAS E DOENCAS', '0.15');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (7, '', 'AUTONOMIA MATERIAL E ENERGETICA - ADUBO VERDE | FIXACAO BIOLOGICA N | INOCULACAO MICORRIZICA', '0.15');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (7, '', 'AUTONOMIA MATERIAL E ENERGETICA - ADUBO ORGANICO | ESTERCO | ESTRUME | COMPOSTAGEM | FORMULADOS ORGANICOMINERAIS', '0.25');

insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (8, '', 'EMISSOES A ATMOSFERA - ODORES', '-0.1');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (8, '', 'EMISSOES A ATMOSFERA - RUIDOS', '-0.1');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (8, '', 'EMISSOES A ATMOSFERA - GASES DE EFEITO ESTUFA', '-0.4');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (8, '', 'EMISSOES A ATMOSFERA - MATERIAL PARTICULADO | FUMACA', '-0.4');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (9, '', 'QUALIDADE DO SOLO - EROSAO', '-0.25');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (9, '', 'QUALIDADE DO SOLO - COMPACTACAO', '-0.25');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (9, '', 'QUALIDADE DO SOLO - PERDA DE NUTRIENTES', '-0.25');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (9, '', 'QUALIDADE DO SOLO - PERDA DE MATERIA ORGANICA', '-0.25');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (10, '', 'QUALIDADE DA AGUA - TURBIDEZ', '-0.2');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (10, '', 'QUALIDADE DA AGUA - ASSOREAMENTO DE CORPOS DAGUA', '-0.2');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (10, '', 'QUALIDADE DA AGUA - ESPUMAS | OLEOS | RESIDUOS SOLIDOS', '-0.2');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (10, '', 'QUALIDADE DA AGUA - CARGA ORGANICA (EFLUENTES, ESGOTOS, ESTERCOS, ETC)', '-0.2');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (10, '', 'QUALIDADE DA AGUA - EXPOSICAO A CONTAMINACAO DIRETA | INDIRETA POR AGROTOXICOS', '-0.2');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (11, '', 'CONSERVACAO DA BIODIVERSIDADE - FAUNA SILVESTRE', '0.1');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (11, '', 'CONSERVACAO DA BIODIVERSIDADE - VEGETACAO NATIVA', '0.1');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (11, '', 'CONSERVACAO DA BIODIVERSIDADE - ESPECIES | VARIEDADES TRADICIONAIS (CABOCLAS)', '0.1');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (11, '', 'RECUPERACAO AMBIENTAL - RESERVA LEGAL', '0.2');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (11, '', 'RECUPERACAO AMBIENTAL - AREAS DE PRESERVACAO PERMANENTE', '0.2');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (11, '', 'RECUPERACAO AMBIENTAL - SOLOS DEGRADADOS', '0.15');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (11, '', 'RECUPERACAO AMBIENTAL - ECOSSISTEMAS DEGRADADOS', '0.15');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (12, '', 'QUALIDADE DO PRODUTO - PROCEDIMENTOS DE POS-COLHEITA', '0.2');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (12, '', 'QUALIDADE DO PRODUTO - DISPONIBILIDADE DE FONTES DE INSUMOS', '0.15');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (12, '', 'QUALIDADE DO PRODUTO - IDONEIDADE DOS FORNECEDORES DE INSUMOS', '0.15');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (12, '', 'QUALIDADE DO PRODUTO - REDUCAO DE RESIDUOS QUIMICOS', '0.25');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (12, '', 'QUALIDADE DO PRODUTO - REDUCAO DE CONTAMINANTES BIOLOGICOS', '0.25');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (13, '', 'ENGAJAMENTO EM MOVIMENTOS SOCIAIS', '0.2');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (13, '', 'INTEGRACAO CULTURAL ENTRE OS COLABORADORES E FAMILIARES', '0.2');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (13, '', 'CAPTACAO DE DEMANDAS DA COMUNIDADE', '0.15');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (13, '', 'PROJETOS DE EXTENSAO COMUNITARIA | EDUCACAO AMBIENTAL', '0.15');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (13, '', 'PROGRAMAS DE TRANSFERENCIA DE CONHECIMENTOS E TECNOLOGIAS', '0.15');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (13, '', 'CONSERVACAO DO PATRIMONIO HISTORICO | ARTISTICO | CULTURAL', '0.15');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (14, '', 'ACOES QUE MINIMIZEM O SOFRIMENTO, O ESTRESSE E A DOR', '0.1');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (14, '', 'CONDUTA ETICA DE MANEJO, DESCARTE E PRE-ABATE | ABATE', '0.1');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (14, '', 'CONDICOES P/ EXPRESSAR COMPORTAMENTOS NATURAIS DA ESPECIE', '0.1');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (14, '', 'ACESSO A AGUA, ALIMENTO E SUPLEMENTOS DE QUALIDADE', '0.2');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (14, '', 'CONFORTO TERMICO E SALUBRIDADE DOS AMBIENTES DE MANEJO', '0.2');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (14, '', 'SEGURANCA E MANEJO SANITARIO PREVENTIVO', '0.15');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (14, '', 'LOTACAO ADEQUADA NAS INSTALACOES E AREAS EXTERNAS', '0.15');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (15, '', 'NIVEL DE CAPACITACAO - BASICO', '0.1');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (15, '', 'NIVEL DE CAPACITACAO - TECNICO', '0.1');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (15, '', 'NIVEL DE CAPACITACAO - SUPERIOR', '0.1');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (15, '', 'TIPO DE CAPACITACAO - EDUCACAO FORMAL', '0.2');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (15, '', 'TIPO DE CAPACITACAO - ESPECIALIZACAO', '0.25');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (15, '', 'TIPO DE CAPACITACAO - LOCAL DE CURTA DURACAO', '0.25');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (16, '', 'CONDICAO DE CONTRATACAO - PERMANENTE', '0.1');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (16, '', 'CONDICAO DE CONTRATACAO - PARCEIRO | MEEIRO', '0.1');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (16, '', 'QUALIFICACAO REQUERIDA PARA O TRABALHO - BRACAL', '0.1');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (16, '', 'QUALIFICACAO REQUERIDA PARA O TRABALHO - TECNICO SUPERIOR', '0.2');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (16, '', 'CONDICAO DE CONTRATACAO - TEMPORARIO', '0.05');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (16, '', 'CONDICAO DE CONTRATACAO - FAMILIAR', '0.15');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (16, '', 'QUALIFICACAO REQUERIDA PARA O TRABALHO - TECNICO MEDIO', '0.15');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (16, '', 'QUALIFICACAO REQUERIDA PARA O TRABALHO - BRACAL ESPECIALIZADO', '0.15');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (17, '', 'LEGISLACAO TRABALHISTA - REGISTRO', '0.2');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (17, '', 'LEGISLACAO TRABALHISTA - PREVENCAO DE JORNADA > 44HS', '0.2');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (17, '', 'LEGISLACAO TRABALHISTA - CONTRIBUICAO PREVIDENCIARIA', '0.2');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (17, '', 'LEGISLACAO TRABALHISTA - PREVENCAO DO TRABALHO INFANTIL', '0.2');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (17, '', 'BENEFICIOS TRABALHISTAS - AUXILIO MORADIA', '0.05');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (17, '', 'BENEFICIOS TRABALHISTAS - AUXILIO TRANSPORTE', '0.05');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (17, '', 'BENEFICIOS TRABALHISTAS - AUXILIO ALIMENTACAO', '0.05');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (17, '', 'BENEFICIOS TRABALHISTAS - AUXILIO SAUDE (COMPLEMENTAR)', '0.05');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (18, '', 'EQUIDADE ETNICA - RESPEITO MUTUO E VALORIZACAO CULTURAL', '0.125');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (18, '', 'EQUIDADE ETNICA - EQUIDADE DE OPORTUNIDADES ENTRE ETNIAS', '0.125');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (18, '', 'EQUIDADE DE GENEROS - EMANCIPACAO E RECONHECIMENTO DAS ESCOLHAS DAS MULHERES', '0.125');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (18, '', 'EQUIDADE DE GERACOES - RECOMPENSA EQUITATIVA DAS ATIVIDADES PRODUTIVAS DOS JOVENS', '0.125');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (18, '', 'EQUIDADE DE GENEROS - RECOMPENSA EQUITATIVA DAS ATIVIDADES PRODUTIVAS DAS MULHERES', '0.125');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (18, '', 'EQUIDADE DE GERACOES - EMANCIPACAO E RECONHECIMENTO DAS ESCOLHAS DOS JOVENS E IDOSOS', '0.125');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (18, '', 'EQUIDADE DE GENEROS - OPORTUNIDADE DE ENVOLVIMENTO E VALORIZACAO DA PARTICIPACAO DAS MULHERES', '0.125');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (18, '', 'EQUIDADE DE GERACOES - OPORTUNIDADE DE ENVOLVIMENTO E VALORIZACAO DA PARTICIPACAO DOS JOVENS E IDOSOS', '0.125');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (19, '', 'ATRIBUTOS DE RENDA - MONTANTE', '0.2');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (19, '', 'ATRIBUTOS DE RENDA - DIVERSIDADE DE FONTES DE RENDA', '0.2');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (19, '', 'ATRIBUTOS DE RENDA - SEGURANCA (GARANTIA DE OBTENCAO)', '0.2');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (19, '', 'ATRIBUTOS DE RENDA - ESTABILIDADE (REDUCAO DA SAZONALIDADE)', '0.2');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (19, '', 'ATRIBUTOS DE RENDA - DISTRIBUICAO (REMUNERACOES E BENEFICIOS)', '0.2');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (20, '', 'VALORIZACAO DA PROPRIEDADE - PRECOS DE PRODUTOS E SERVICOS', '0.2');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (20, '', 'VALORIZACAO DA PROPRIEDADE - CONFORMIDADE COM LEGISLACAO', '0.15');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (20, '', 'VALORIZACAO DA PROPRIEDADE - INFRA-ESTRUTURA | POLITICA TRIBUTARIA ETC', '0.15');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (20, '', 'VALORIZACAO DA PROPRIEDADE - INVESTIMENTO EM BENFEITORIAS', '0.25');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (20, '', 'VALORIZACAO DA PROPRIEDADE - CONSERVACAO DOS RECURSOS NATURAIS', '0.25');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (21, '', 'EXPOSICAO A PERICULOSIDADES E FATORES DE INSALUBRIDADES - RUIDO', '-0.1');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (21, '', 'EXPOSICAO A PERICULOSIDADES E FATORES DE INSALUBRIDADES - VIBRACAO', '-0.1');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (21, '', 'EXPOSICAO A PERICULOSIDADES E FATORES DE INSALUBRIDADES - AGENTES BIOLOGICOS', '-0.1');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (21, '', 'EXPOSICAO A PERICULOSIDADES E FATORES DE INSALUBRIDADES - AGENTES QUIMICOS', '-0.2');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (21, '', 'EXPOSICAO A PERICULOSIDADES E FATORES DE INSALUBRIDADES - PERICULOSIDADE', '-0.3');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (21, '', 'EXPOSICAO A PERICULOSIDADES E FATORES DE INSALUBRIDADES - CALOR | FRIO | UMIDADE', '-0.05');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (21, '', 'EXPOSICAO A PERICULOSIDADES E FATORES DE INSALUBRIDADES - ACIDENTES ERGONOMICOS (QUEDAS, MAQUINAS)', '-0.15');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (22, '', 'SEGURANCA ALIMENTAR - GARANTIA DA PRODUCAO', '0.3');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (22, '', 'SEGURANCA ALIMENTAR - QUANTIDADE DE ALIMENTO', '0.3');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (22, '', 'SEGURANCA ALIMENTAR - QUALIDADE NUTRICIONAL DO ALIMENTO', '0.4');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (23, '', 'DEDICACAO DO RESPONSAVEL - CAPACITACAO DIRIGIDA A ATIVIDADE', '0.2');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (23, '', 'DEDICACAO DO RESPONSAVEL - HORAS DE PERMANENCIA NO ESTABELECIMENTO', '0.2');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (23, '', 'DEDICACAO DO RESPONSAVEL - ENGAJAMENTO FAMILIAR', '0.15');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (23, '', 'DEDICACAO DO RESPONSAVEL - USO DE SISTEMA CONTABIL', '0.15');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (23, '', 'DEDICACAO DO RESPONSAVEL - MODELO FORMAL DE PLANEJAMENTO', '0.15');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (23, '', 'DEDICACAO DO RESPONSAVEL - SISTEMA DE CERTIFICACAO | ROTULAGEM', '0.15');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (24, '', 'COMERCIALIZACAO - COOPERACAO COM OUTROS PRODUTORES LOCAIS', '0.1');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (24, '', 'COMERCIALIZACAO - TRANSPORTE PROPRIO', '0.15');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (24, '', 'COMERCIALIZACAO - ARMAZENAMENTO LOCAL', '0.15');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (24, '', 'COMERCIALIZACAO - PROCESSAMENTO LOCAL', '0.15');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (24, '', 'COMERCIALIZACAO - PROPAGANDA | MARCA PROPRIA', '0.15');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (24, '', 'COMERCIALIZACAO - VENDA DIRETA | ANTECIPADA | COOPERADA', '0.15');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (24, '', 'COMERCIALIZACAO - ENCADEAMENTO COM PRODUTOS | ATIVIDADES | SERVICOS ANTERIORES', '0.15');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (25, '', 'TRATAMENTO DE RESIDUOS DOMESTICOS - COLETA SELETIVA', '0.2');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (25, '', 'TRATAMENTO DE RESIDUOS DA PRODUCAO - REAPROVEITAMENTO', '0.2');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (25, '', 'TRATAMENTO DE RESIDUOS DOMESTICOS - DISPOSICAO SANITARIA', '0.2');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (25, '', 'TRATAMENTO DE RESIDUOS DOMESTICOS - COMPOSTAGEM | REAPROVEITAMENTO', '0.2');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (25, '', 'TRATAMENTO DE RESIDUOS DA PRODUCAO - DESTINACAO OU TRATAMENTO FINAL', '0.2');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (26, '', 'GESTAO DE INSUMOS QUIMICOS - ARMAZENAMENTO', '0.2');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (26, '', 'GESTAO DE INSUMOS QUIMICOS - REGISTRO DE TRATAMENTOS', '0.15');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (26, '', 'GESTAO DE INSUMOS QUIMICOS - DISPOSICAO FINAL ADEQUADA DE RECIPIENTES E EMBALAGENS', '0.15');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (26, '', 'GESTAO DE INSUMOS QUIMICOS - UTILIZACAO DE EQUIPAMENTOS DE PROTECAO INDIVIDUAL', '0.25');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (26, '', 'GESTAO DE INSUMOS QUIMICOS - CALIBRACAO E VERIFICACAO DE EQUIPAMENTOS DE APLICACAO', '0.25');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (27, '', 'ALCANCE INSTITUCIONAL - FILIACAO TECNOLOGICA NOMINAL', '0.25');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (27, '', 'ALCANCE INSTITUCIONAL - ASSOCIATIVISMO | COOPERATIVISMO', '0.25');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (27, '', 'ALCANCE INSTITUCIONAL - UTILIZACAO DE ASSISTENCIA TECNICA', '0.25');
insert into _referencia.dbindicadorref_socamb (idcriterio,sigla,nome,valorimportancia ) VALUES (27, '', 'ALCANCE INSTITUCIONAL - UTILIZACAO DE ASSESSORIA LEGAL | VISTORIA', '0.25');

WITH joined AS (
    SELECT  ind.id AS idind, ind.idcriterio AS idcrt, crt.iddimaspecto AS idda,
            'DA'||substring((iddimaspecto+100)::varchar,2,2)||'C'||substring( (ind.idcriterio+1000)::varchar, 2,3)||'I'||substring( (ind.id+1000)::varchar, 2,3 ) as sigla
    FROM _referencia.dbindicadorref_socamb AS ind
    JOIN _referencia.dbcriterioref_socamb AS crt ON ( ind.idcriterio = crt.id )
    ORDER BY 3, 2, 1
) 
UPDATE _referencia.dbindicadorref_socamb AS isa SET sigla = jo.sigla 
FROM joined AS jo
WHERE isa.id = jo.idind
;  



-- -----------------------------------------------------------------------------------------
-- View: _referencia.vw_h_criteriosindicadores_socamb
-- -----------------------------------------------------------------------------------------

CREATE OR REPLACE VIEW "_referencia".vw_h_criteriosindicadores_socamb
AS WITH dimaspecto_cte AS (
         SELECT DISTINCT vwdimensaoaspecto_socamb.id AS iddimaspecto,
            (('Dimensão: '::text || rtrim(SUBSTRING(upper(unaccent(vwdimensaoaspecto_socamb.nome::text)) FROM 1 FOR POSITION(('-'::text) IN (upper(unaccent(vwdimensaoaspecto_socamb.nome::text)))) - 1))) || ' | Aspecto: '::text) || rtrim(SUBSTRING(upper(unaccent(vwdimensaoaspecto_socamb.nome::text)) FROM POSITION(('-'::text) IN (upper(unaccent(vwdimensaoaspecto_socamb.nome::text)))) + 1 FOR length(upper(unaccent(vwdimensaoaspecto_socamb.nome::text))))) AS hierarquia,
            vwdimensaoaspecto_socamb.sigla,
            vwdimensaoaspecto_socamb.id * 1000000 AS ch
           FROM _referencia.vwdimensaoaspecto_socamb
        ), criterio_cte AS (
         SELECT DISTINCT c.iddimaspecto,
            c.id AS idcriterio,
            c.valorimportancia,
            'Criterio: '::text || c.nome::text AS hierarquia,
            c.sigla,
            c.iddimaspecto * 1000000 + c.id * 1000 AS ch
           FROM _referencia.vwcriterioref_socamb c
          ORDER BY c.iddimaspecto, c.id
        ), indicador_cte AS (
         SELECT DISTINCT i.iddimaspecto,
            i.idcriterio,
            i.id AS idindicador,
            i.valorimportancia,
            'Indicador: '::text || i.nome::text AS hierarquia,
            i.sigla,
            i.iddimaspecto * 1000000 + i.idcriterio * 1000 + i.id AS ch
           FROM _referencia.vwindicadorref_socamb i
          ORDER BY i.iddimaspecto, i.idcriterio, i.id
        )
 SELECT ch,
    hierarquia,
    valorimportancia,
    sigla,
    iddimaspecto,
    idcriterio,
    idindicador,
    nivel
   FROM ( SELECT d.hierarquia,
            d.sigla,
            d.ch,
            NULL::numeric(4,3) AS valorimportancia,
            d.iddimaspecto,
            NULL::integer AS idcriterio,
            NULL::integer AS idindicador,
            1 AS nivel
           FROM dimaspecto_cte d
        UNION ALL
         SELECT c.hierarquia,
            c.sigla,
            c.ch,
            c.valorimportancia,
            NULL::integer AS iddimaspecto,
            c.idcriterio,
            NULL::integer AS idindicador,
            2 AS nivel
           FROM criterio_cte c
        UNION ALL
         SELECT i.hierarquia,
            i.sigla,
            i.ch,
            i.valorimportancia,
            NULL::integer AS iddimaspecto,
            NULL::integer AS idcriterio,
            i.idindicador,
            3 AS nivel
           FROM indicador_cte i) arvore
  ORDER BY ch;
  
ALTER TABLE IF EXISTS _referencia.vw_h_criteriosindicadores_socamb OWNER to postgres;
GRANT ALL ON TABLE _referencia.vw_h_criteriosindicadores_socamb TO n2espindesenv;
GRANT ALL ON TABLE _referencia.vw_h_criteriosindicadores_socamb TO postgres;


-- -----------------------------------------------------------------------------------------
-- View: _referencia.vw_h_criteriosindicadores_socamb
-- -----------------------------------------------------------------------------------------
CREATE VIEW _referencia.vw_treview_criteriosindicadores_socamb AS
SELECT  ch,
        sigla, 
        CASE
            WHEN nivel = 1 THEN ''
            WHEN nivel = 2 THEN '|'||repeat('_',(-1+nivel)*3)
            ELSE repeat(' ',(-1+nivel)*3)||'|'||repeat('_',(-2+nivel)*3)
        END || hierarquia as hierarquia, 
        valorimportancia, 
        nivel
FROM _referencia.vw_h_criteriosindicadores_socamb
;
ALTER TABLE IF EXISTS _referencia.vw_treview_criteriosindicadores_socamb OWNER to postgres;
GRANT ALL ON TABLE _referencia.vw_treview_criteriosindicadores_socamb TO n2espindesenv;
GRANT ALL ON TABLE _referencia.vw_treview_criteriosindicadores_socamb TO postgres;


