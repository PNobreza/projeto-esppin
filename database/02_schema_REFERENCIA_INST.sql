-- -----------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------
-- SCHEMA: _referencia - INSTITUCIONAL
-- -----------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------


SET search_path TO _referencia, public;

DROP VIEW   IF  EXISTS _referencia.vw_treview_criteriosindicadores_instit;
DROP VIEW   IF  EXISTS _referencia.vw_h_criteriosindicadores_instit;
DROP VIEW   IF  EXISTS _referencia.vwindicadorref_instit;
DROP TABLE IF  EXISTS _referencia.dbindicadorref_instit;
DROP VIEW   IF EXISTS _referencia.vwcriterioref_instit;
DROP TABLE  IF EXISTS _referencia.dbcriterioref_instit;
DROP VIEW   IF EXISTS _referencia.vwdimensaoaspecto_instit;
DROP TABLE  IF EXISTS _referencia.dbdimensaoaspecto_instit;


-- -----------------------------------------------------------------------------------------
-- Table: _referencia.dbdimensaoaspecto_instit
-- -----------------------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS _referencia.dbdimensaoaspecto_instit
(
    id 				    SERIAL NOT NULL ,
    nome 			    character varying(50),
    sigla 			    character varying(20),
    ativo 			    character(1) DEFAULT 'S'::bpchar,
    versao              VARCHAR(8) DEFAULT _referencia.fn_carimbaversao('INSTIT'),
    inc_data 			TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    inc_idusuario 		integer,
    alt_data 			TIMESTAMP WITHOUT TIME ZONE,
    alt_idusuario 		integer,
    exc_data 			TIMESTAMP WITHOUT TIME ZONE,
    exc_idusuario 		integer,
    CONSTRAINT pk_dbdimensaoaspecto_instit PRIMARY KEY (id),

    CONSTRAINT fk_dbdimensaoaspecto_instit_user_inc FOREIGN KEY (inc_idusuario)
        REFERENCES _adm.system_users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
	
    CONSTRAINT fk_dbdimensaoaspecto_instit_user_alt FOREIGN KEY (alt_idusuario)
        REFERENCES _adm.system_users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
	
    CONSTRAINT fk_dbdimensaoaspecto_instit_user_exc FOREIGN KEY (exc_idusuario)
        REFERENCES _adm.system_users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
TABLESPACE pg_default;

ALTER TABLE IF EXISTS _referencia.dbdimensaoaspecto_instit OWNER to postgres;
GRANT ALL ON TABLE _referencia.dbdimensaoaspecto_instit TO n2espindesenv;
GRANT ALL ON TABLE _referencia.dbdimensaoaspecto_instit TO postgres;
GRANT ALL ON SEQUENCE _referencia.dbdimensaoaspecto_instit_id_seq TO n2espindesenv; 

INSERT INTO _referencia.dbdimensaoaspecto_instit (sigla,nome,inc_idusuario) VALUES
('DA01C000I000', 'Capacidade Relacional', 1),
('DA02C000I000', 'Capacidade Científica-Tecnológica', 1),
('DA03C000I000', 'Capacidade Organizacional', 1),
('DA04C000I000', 'Produtos de P&D', 1)
;

-- -----------------------------------------------------------------------------------------
-- View: _referencia.vwdimensaoaspecto_instit
-- -----------------------------------------------------------------------------------------

CREATE OR REPLACE VIEW _referencia.vwdimensaoaspecto_instit
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
   FROM _referencia.dbdimensaoaspecto_instit dbda
   WHERE dbda.exc_data IS NULL
   AND dbda.ativo = 'S'
   AND dbda.versao = _referencia.fn_carimbaversao('INSTIT')
;

ALTER TABLE _referencia.vwdimensaoaspecto_instit  OWNER TO postgres;
GRANT ALL ON TABLE _referencia.vwdimensaoaspecto_instit TO n2espindesenv;
GRANT ALL ON TABLE _referencia.vwdimensaoaspecto_instit TO postgres;



-- -----------------------------------------------------------------------------------------
-- Table: _referencia.DBCRITERIOREF_instit
-- -----------------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS _referencia.dbcriterioref_instit
(
    id 				    SERIAL NOT NULL ,
    iddimaspecto        INTEGER NOT NULL,
    nome 			    character varying(100),
    sigla 			    character varying(20),
    valorimportancia    NUMERIC(4,3) DEFAULT 0.100 ,
    versao              VARCHAR(8) DEFAULT _referencia.fn_carimbaversao('INSTIT'),
    ativo 			    character(1) DEFAULT 'S'::bpchar,
    inc_data 			TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    inc_idusuario 		integer,
    alt_data 			TIMESTAMP WITHOUT TIME ZONE,
    alt_idusuario 		integer,
    exc_data 			TIMESTAMP WITHOUT TIME ZONE,
    exc_idusuario 		integer,
    CONSTRAINT pk_dbcriterioref_instit PRIMARY KEY (id),

    CONSTRAINT fk_dbcriterioref_instit_dbdimensaoaspecto_instit FOREIGN KEY (iddimaspecto)
        REFERENCES _referencia.dbdimensaoaspecto_instit (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,

    CONSTRAINT fk_dbcriterioref_instit_user_inc FOREIGN KEY (inc_idusuario)
        REFERENCES _adm.system_users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
	
    CONSTRAINT fk_dbcriterioref_instit_user_alt FOREIGN KEY (alt_idusuario)
        REFERENCES _adm.system_users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
	
    CONSTRAINT fk_dbcriterioref_instit_user_exc FOREIGN KEY (exc_idusuario)
        REFERENCES _adm.system_users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
TABLESPACE pg_default;

ALTER TABLE IF EXISTS _referencia.dbcriterioref_instit OWNER to postgres;
GRANT ALL ON TABLE _referencia.dbcriterioref_instit TO n2espindesenv;
GRANT ALL ON TABLE _referencia.dbcriterioref_instit TO postgres;
GRANT ALL ON SEQUENCE _referencia.dbcriterioref_instit_id_seq TO n2espindesenv; 


-- -------------------------------------------------------------------------------------
/* Capacidade Relacional */
-- -------------------------------------------------------------------------------------
insert into _referencia.dbcriterioref_instit (iddimaspecto,nome,valorimportancia ) VALUES 
(1, 'RELAÇÕES DE EQUIPE / REDE DE PESQUISA', '0.5'),
(1, 'RELAÇÕES COM INTERLOCURTORES (BENEFICIARIOS, PARCEIROS, FORNECEDORES E FINANCIADORES)', '0.5')
;
-- -------------------------------------------------------------------------------------
/* Capacidade Cientifica-Tecnologica */
-- -------------------------------------------------------------------------------------
insert into _referencia.dbcriterioref_instit (iddimaspecto,nome,valorimportancia ) VALUES 
(2, 'INSTALAÇÕES (MÉTODOS E MEIOS)', '0.5'),         
(2, 'RECURSOS DO PROJETO', '0.5')                                                               
;                              
-- -------------------------------------------------------------------------------------
/* Caácodade Organizacional */
-- -------------------------------------------------------------------------------------
insert into _referencia.dbcriterioref_instit (iddimaspecto,nome,valorimportancia ) VALUES 
(3, 'EQUIPE / REDE DE PESQUISA', '0.5'),         
(3, 'TRANSFERÊNCIA EXTENSAO', '0.5')                                                               
;                              
-- -------------------------------------------------------------------------------------
/* Produtos de P&D */
-- -------------------------------------------------------------------------------------
insert into _referencia.dbcriterioref_instit (iddimaspecto,nome,valorimportancia ) VALUES 
(4, 'PRODUTOS DE P & D', '0.5'),         
(4, 'PRODUTOS TECNOLÓGICOS', '0.5')                                                               
;                              

UPDATE _referencia.dbcriterioref_instit 
SET sigla = 'DA'||substring((iddimaspecto+100)::varchar,2,2)||'C'||substring( (id+1000)::varchar,2,3)||'I000' 
WHERE sigla IS NULL;


-- -----------------------------------------------------------------------------------------
-- Table: _referencia.VWCRITERIOREF_instit
-- -----------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW _referencia.vwcriterioref_instit
AS
SELECT 
        dbcrins.id 				    ,
        dbcrins.iddimaspecto         ,
        vwdains.nome                 AS nome_dimensaoaspecto,
        vwdains.sigla                AS sigla_dimensaoaspecto,
        dbcrins.nome 			    ,
        dbcrins.sigla 			    ,
        dbcrins.valorimportancia    ,
        dbcrins.versao 			    ,
        dbcrins.ativo 			    ,
        dbcrins.inc_data 			,
        dbcrins.inc_idusuario 		,
        dbcrins.alt_data 			,
        dbcrins.alt_idusuario 		,
        dbcrins.exc_data 			,
        dbcrins.exc_idusuario 		
FROM _referencia.dbcriterioref_instit dbcrins
JOIN _referencia.vwdimensaoaspecto_instit vwdains ON ( dbcrins.iddimaspecto = vwdains.id )
WHERE dbcrins.ativo = 'S' AND dbcrins.exc_data IS NULL
ORDER BY dbcrins.sigla ASC
; 
ALTER TABLE IF EXISTS _referencia.vwcriterioref_instit OWNER to postgres;
GRANT ALL ON TABLE _referencia.vwcriterioref_instit TO n2espindesenv;
GRANT ALL ON TABLE _referencia.vwcriterioref_instit TO postgres;



-- -----------------------------------------------------------------------------------------
-- Table: _referencia.DBINDICADORREF_instit
-- -----------------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS _referencia.dbindicadorref_instit
(
    id 				    SERIAL NOT NULL ,
    idcriterio          INTEGER NOT NULL,
    nome 			    character varying(150),
    sigla 			    character varying(20),
    valorimportancia    NUMERIC(4,3) DEFAULT 0.100 ,
    versao              VARCHAR(8) DEFAULT _referencia.fn_carimbaversao('INSTIT'),
    ativo 			    character(1) DEFAULT 'S'::bpchar,
    inc_data 			TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    inc_idusuario 		integer,
    alt_data 			TIMESTAMP WITHOUT TIME ZONE,
    alt_idusuario 		integer,
    exc_data 			TIMESTAMP WITHOUT TIME ZONE,
    exc_idusuario 		integer,
    CONSTRAINT pk_dbindicadorref_instit PRIMARY KEY (id),

    CONSTRAINT fk_dbindicadorref_instit_dbcriterioref_instit FOREIGN KEY (idcriterio)
        REFERENCES _referencia.dbcriterioref_instit (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,

    CONSTRAINT fk_dbindicadorref_instit_user_inc FOREIGN KEY (inc_idusuario)
        REFERENCES _adm.system_users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
	
    CONSTRAINT fk_dbindicadorref_instit_user_alt FOREIGN KEY (alt_idusuario)
        REFERENCES _adm.system_users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
	
    CONSTRAINT fk_dbindicadorref_instit_user_exc FOREIGN KEY (exc_idusuario)
        REFERENCES _adm.system_users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
TABLESPACE pg_default;

ALTER TABLE IF EXISTS _referencia.dbindicadorref_instit OWNER to postgres;
GRANT ALL ON TABLE _referencia.dbindicadorref_instit TO n2espindesenv;
GRANT ALL ON TABLE _referencia.dbindicadorref_instit TO postgres;
GRANT ALL ON SEQUENCE _referencia.dbindicadorref_instit_id_seq TO n2espindesenv; 


-- -----------------------------------------------------------------------------------------
-- View: _referencia.VWINDICADORREF_instit
-- -----------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW  _referencia.vwindicadorref_instit
AS
SELECT 
    dbindinst.id 				  ,
    vwcrinst.iddimaspecto         ,
    vwdainst.sigla                AS sigla_dimensaoaspecto,
    vwdainst.nome                 AS nome_dimensaoaspecto,
    dbindinst.idcriterio          ,
    vwcrinst.sigla                AS sigla_criterio,
    vwcrinst.nome                 AS nome_criterio,
    dbindinst.nome 			      ,
    dbindinst.sigla 			  ,
    dbindinst.valorimportancia    ,
    dbindinst.versao              ,
    dbindinst.ativo 			  ,
    dbindinst.inc_data 		      ,
    dbindinst.inc_idusuario 	  ,
    dbindinst.alt_data 			  ,
    dbindinst.alt_idusuario 	  ,
    dbindinst.exc_data 			  ,
    dbindinst.exc_idusuario 		
FROM _referencia.dbindicadorref_instit dbindinst
JOIN _referencia.vwcriterioref_instit vwcrinst ON ( dbindinst.idcriterio = vwcrinst.id )
JOIN _referencia.vwdimensaoaspecto_instit vwdainst ON ( vwcrinst.iddimaspecto = vwdainst.id )
WHERE dbindinst.ativo = 'S' 
AND dbindinst.exc_data IS NULL
AND dbindinst.versao = _referencia.fn_carimbaversao('INSTIT')
ORDER BY dbindinst.sigla ASC
; 
ALTER TABLE IF EXISTS _referencia.vwindicadorref_instit OWNER to postgres;
GRANT ALL ON TABLE _referencia.vwindicadorref_instit TO n2espindesenv;
GRANT ALL ON TABLE _referencia.vwindicadorref_instit TO postgres;


-- CRITERIO 1
-- insert into _referencia.dbcriterioref_instit (iddimaspecto,nome,valorimportancia,inc_idusuario ) VALUES (1, 'RELAÇÕES DE EQUIPE / REDE DE PESQUISA', 0.5, 1);
-- indicador 01
insert into _referencia.dbindicadorref_instit (idcriterio,sigla,nome,valorimportancia,inc_idusuario ) VALUES (1, '', 'DIVERSIDADE DE ESPECIALIDADES', 0.25, 1);
-- indicador 02
insert into _referencia.dbindicadorref_instit (idcriterio,sigla,nome,valorimportancia,inc_idusuario ) VALUES (1, '', 'INTERDISCIPLINIDADE (CO-AUTORIAS)', 0.25, 1);
-- indicador 03
insert into _referencia.dbindicadorref_instit (idcriterio,sigla,nome,valorimportancia,inc_idusuario ) VALUES (1, '', 'KNOW-HOW (REFERENCIAL CONCEITUAL / METODOLOGICO)', 0.25, 1);
-- indicador 04
insert into _referencia.dbindicadorref_instit (idcriterio,sigla,nome,valorimportancia,inc_idusuario ) VALUES (1, '', 'GRUPOS DE ESTUDO / PESQUISA FORMALIZADOS', 0.25, 1);
-- indicador 05
insert into _referencia.dbindicadorref_instit (idcriterio,sigla,nome,valorimportancia,inc_idusuario ) VALUES (1, '', 'EVENTOS TECNICO-CIENTIFICOS FORMAIS REALIZADOS', 0.25, 1);
-- indicador 06
insert into _referencia.dbindicadorref_instit (idcriterio,sigla,nome,valorimportancia,inc_idusuario ) VALUES (1, '', 'ADOÇÃO / APROPRIAÇÃO METODOLÓGICA POR MEMBROS DA REDE', 0.25, 1);


-- CRITERIO 2
-- insert into _referencia.dbcriterioref_instit (iddimaspecto,nome,valorimportancia,inc_idusuario ) VALUES (1, 'RELAÇÕES COM INTERLOCURTORES (BENEFICIARIOS, PARCEIROS, FORNECEDORES E FINANCIADORES)', 0.5, 1);
-- indicador 07
insert into _referencia.dbindicadorref_instit (idcriterio,sigla,nome,valorimportancia,inc_idusuario ) VALUES (2, '', 'DIVERSIDADE DE INTERLOCUTORES', -0.25, 1);
-- indicador 08
insert into _referencia.dbindicadorref_instit (idcriterio,sigla,nome,valorimportancia,inc_idusuario ) VALUES (2, '', 'INTERATIVIDADE ENTRE INTERLOCUTORES (AÇÕES E ATIVIDADES)', -0.25, 1);
-- indicador 09
insert into _referencia.dbindicadorref_instit (idcriterio,sigla,nome,valorimportancia,inc_idusuario ) VALUES (2, '', 'KNOW-HOW (REFERENCIAL OPERACIONAL)', -0.25, 1);
-- indicador 10
insert into _referencia.dbindicadorref_instit (idcriterio,sigla,nome,valorimportancia,inc_idusuario ) VALUES (2, '', 'FONTES DE RECURSOS / CONTRATAÇÃO INSTITUCIONAL', -0.25, 1);
-- indicador 11
insert into _referencia.dbindicadorref_instit (idcriterio,sigla,nome,valorimportancia,inc_idusuario ) VALUES (2, '', 'REDES DE INTERAÇÕES COMUNITÁRIAS (NÃO CIENTÍFICAS)', -0.25, 1);
-- indicador 12
insert into _referencia.dbindicadorref_instit (idcriterio,sigla,nome,valorimportancia,inc_idusuario ) VALUES (2, '', 'INSERÇÃO NO MERCADO (COMERCIO OU CESSAO DE PRODUTOS / TECNOLOGIAS)', -0.25, 1);


-- CRITERIO 3
-- insert into _referencia.dbcriterioref_instit (iddimaspecto,nome,valorimportancia ) VALUES (2, 'INSTALAÇÕES (MÉTODOS E MEIOS)', '0.5');
-- indicador 13
insert into _referencia.dbindicadorref_instit (idcriterio,sigla,nome,valorimportancia,inc_idusuario ) VALUES (3, '', 'INFRAESTRUTURA INSTITUCIONAL (NÚMERO DE UNIDADES)', -0.2, 1);
-- indicador 14
insert into _referencia.dbindicadorref_instit (idcriterio,sigla,nome,valorimportancia,inc_idusuario ) VALUES (3, '', 'INFRAESTRUTURA OPERACIONAL (ÁREA FÍSICA)', -0.2, 1);
-- indicador 15
insert into _referencia.dbindicadorref_instit (idcriterio,sigla,nome,valorimportancia,inc_idusuario ) VALUES (3, '', 'INSTRUMENTAL OPERACIONAL (SITUAÇÃO E MANUTENÇÃO)', -0.2, 1);
-- indicador 16
insert into _referencia.dbindicadorref_instit (idcriterio,sigla,nome,valorimportancia,inc_idusuario ) VALUES (3, '', 'INSTRUMENTAL BIBLIOGRÁFICO', -0.2, 1);
-- indicador 17
insert into _referencia.dbindicadorref_instit (idcriterio,sigla,nome,valorimportancia,inc_idusuario ) VALUES (3, '', 'INFORMATIZAÇÃO / AUTOMAÇÃO / TECNOLOGIA DA INFORMAÇÃO', -0.2, 1);
-- indicador 18
insert into _referencia.dbindicadorref_instit (idcriterio,sigla,nome,valorimportancia,inc_idusuario ) VALUES (3, '', 'COMPARTILHAMENTO DA INFRAESTRUTURA', -0.2, 1);


-- CRITERIO 4
-- insert into _referencia.dbcriterioref_instit (iddimaspecto,nome,valorimportancia ) VALUES (2, 'RECURSOS DO PROJETO', '0.5');
-- indicador 19
insert into _referencia.dbindicadorref_instit (idcriterio,sigla,nome,valorimportancia,inc_idusuario ) VALUES (4, '', 'INFRAESTRUTURA (AMPLIAÇÃO DA ÁREA FÍSICA)', -0.2, 1);
-- indicador 20
insert into _referencia.dbindicadorref_instit (idcriterio,sigla,nome,valorimportancia,inc_idusuario ) VALUES (4, '', 'INSTRUMENTAL OPERACIONAL (INCLUSIVE INFORMATIZAÇÃO / AUTOMAÇÃO / TECNOLOGIA DA INFORMAÇÃO)', -0.2, 1);
-- indicador 21
insert into _referencia.dbindicadorref_instit (idcriterio,sigla,nome,valorimportancia,inc_idusuario ) VALUES (4, '', 'INSTRUMENTAL BIBLIOGRÁFICO (AQUISIÇÃO)', -0.2, 1);
-- indicador 22
insert into _referencia.dbindicadorref_instit (idcriterio,sigla,nome,valorimportancia,inc_idusuario ) VALUES (4, '', 'CONTRATAÇÃO DE CONSULTORES, BOLSISTAS, PESQUISADORES VISITANTES', -0.2, 1);
-- indicador 23
insert into _referencia.dbindicadorref_instit (idcriterio,sigla,nome,valorimportancia,inc_idusuario ) VALUES (4, '', 'CUSTEIO DE DIÁRIAS, TRASLADOS E ESTADIAS', -0.2, 1);


-- CRITERIO 5
-- insert into _referencia.dbcriterioref_instit (iddimaspecto,nome,valorimportancia ) VALUES (3, 'EQUIPE / REDE DE PESQUISA', '0.5');
-- indicador 24
insert into _referencia.dbindicadorref_instit (idcriterio,sigla,nome,valorimportancia,inc_idusuario ) VALUES (5, '', 'CURSOS E TREINAMENTOS', -0.1, 1);
-- indicador 25
insert into _referencia.dbindicadorref_instit (idcriterio,sigla,nome,valorimportancia,inc_idusuario ) VALUES (5, '', 'REALIZAÇÃO DE EXPERIMENTOS, AVALIAÇÕES, EXPEDIÇÕES, ENSAIOS', -0.1, 1);
-- indicador 26
insert into _referencia.dbindicadorref_instit (idcriterio,sigla,nome,valorimportancia,inc_idusuario ) VALUES (5, '', 'IMPLEMENTAÇÃO DE BANCOS DE DADOS, PLATAFORMAS DE INFORMAÇÃO CODIFICADA', -0.1, 1);
-- indicador 27
insert into _referencia.dbindicadorref_instit (idcriterio,sigla,nome,valorimportancia,inc_idusuario ) VALUES (5, '', 'PARTICIPAÇÃO EM EVENTOS TÉCNICO-CIENTÍFICOS', -0.2, 1);
-- indicador 28
insert into _referencia.dbindicadorref_instit (idcriterio,sigla,nome,valorimportancia,inc_idusuario ) VALUES (5, '', 'ORGANIZAÇÃO DE EVENTOS TÉCNICO-CIENTÍFICOS', -0.2, 1);
-- indicador 29
insert into _referencia.dbindicadorref_instit (idcriterio,sigla,nome,valorimportancia,inc_idusuario ) VALUES (5, '', 'ADOÇÃO DE SISTEMAS DE GESTÃO E DE QUALIDADE', -0.3, 1);


-- CRITERIO 6
-- insert into _referencia.dbcriterioref_instit (iddimaspecto,nome,valorimportancia ) VALUES (3, 'TRANSFERÊNCIA EXTENSAO', '0.5');                              
-- indicador 30
insert into _referencia.dbindicadorref_instit (idcriterio,sigla,nome,valorimportancia,inc_idusuario ) VALUES (6, '', 'CURSOS E TREINAMENTOS PARA PÚBLICO EXTERNO', -0.1, 1);
-- indicador 31
insert into _referencia.dbindicadorref_instit (idcriterio,sigla,nome,valorimportancia,inc_idusuario ) VALUES (6, '', 'NÚMERO DE PARTICIPANTES', -0.1, 1);
-- indicador 32
insert into _referencia.dbindicadorref_instit (idcriterio,sigla,nome,valorimportancia,inc_idusuario ) VALUES (6, '', 'CRIAÇÃO DE UNIDADES DEMONSTRATIVAS', -0.3, 1);
-- indicador 33
insert into _referencia.dbindicadorref_instit (idcriterio,sigla,nome,valorimportancia,inc_idusuario ) VALUES (6, '', 'NÚMERO DE EXPOSIÇÕES NA MÍDIA / ARTIGOS DE DIVULGAÇÃO', -0.5, 1);
-- indicador 34
insert into _referencia.dbindicadorref_instit (idcriterio,sigla,nome,valorimportancia,inc_idusuario ) VALUES (6, '', 'PROJETOS DE EXTENSÃO / DESENVOLVIMENTO LOCAL', -0.5, 1);
-- indicador 35
insert into _referencia.dbindicadorref_instit (idcriterio,sigla,nome,valorimportancia,inc_idusuario ) VALUES (6, '', 'DISCIPLINAS EM CURSOS DE GRADUAÇÃO E PÓS-GRADUAÇÃO', -0.5, 1);


-- CRITERIO 7
-- insert into _referencia.dbcriterioref_instit (iddimaspecto,nome,valorimportancia ) VALUES (4, 'PRODUTOS DE P & D', '0.5');
-- indicador 36
insert into _referencia.dbindicadorref_instit (idcriterio,sigla,nome,valorimportancia,inc_idusuario ) VALUES (7, '', 'APRESENTAÇÕES EM CONGRESSOS', 0.3, 1);
-- indicador 37
insert into _referencia.dbindicadorref_instit (idcriterio,sigla,nome,valorimportancia,inc_idusuario ) VALUES (7, '', 'ARTIGOS INDEXADOS', 0.15, 1);
-- indicador 38
insert into _referencia.dbindicadorref_instit (idcriterio,sigla,nome,valorimportancia,inc_idusuario ) VALUES (7, '', 'ÍNDICE DE IMPACTO TOTAL (WEB-OF-SCIENCE)', 0.15, 1);
-- indicador 39
insert into _referencia.dbindicadorref_instit (idcriterio,sigla,nome,valorimportancia,inc_idusuario ) VALUES (7, '', 'TESES, DISSERTAÇÕES, TCCS', 0.15, 1);
-- indicador 40
insert into _referencia.dbindicadorref_instit (idcriterio,sigla,nome,valorimportancia,inc_idusuario ) VALUES (7, '', 'LIVROS/CAPÍTULOS, BOLETINS, GUIAS, MANUAIS, CD-ROMS, WEBSITES, OUTRAS MÍDIAS, MAPAS, ETC.', 0.25, 1);


-- CRITERIO 8
-- insert into _referencia.dbcriterioref_instit (iddimaspecto,nome,valorimportancia ) VALUES (4, 'PRODUTOS TECNOLÓGICOS', '0.5');                              
-- indicador 41
insert into _referencia.dbindicadorref_instit (idcriterio,sigla,nome,valorimportancia,inc_idusuario ) VALUES (8, '', 'PATENTES / REGISTROS', -0.1, 1);
-- indicador 42
insert into _referencia.dbindicadorref_instit (idcriterio,sigla,nome,valorimportancia,inc_idusuario ) VALUES (8, '', 'VARIEDADES / LINHAGENS', -0.1, 1);
-- indicador 43
insert into _referencia.dbindicadorref_instit (idcriterio,sigla,nome,valorimportancia,inc_idusuario ) VALUES (8, '', 'NOVAS PRÁTICAS METODOLÓGICAS', -0.4, 1);
-- indicador 44
insert into _referencia.dbindicadorref_instit (idcriterio,sigla,nome,valorimportancia,inc_idusuario ) VALUES (8, '', 'PRODUTOS TECNOLÓGICOS', -0.4, 1);
-- indicador 45
insert into _referencia.dbindicadorref_instit (idcriterio,sigla,nome,valorimportancia,inc_idusuario ) VALUES (8, '', 'MARCOS REGULATÓRIOS (LEIS, NORMAS)', -0.25, 1);

WITH joined AS (
    SELECT  ind.id AS idind, ind.idcriterio AS idcrt, crt.iddimaspecto AS idda,
            'DA'||substring((crt.iddimaspecto+100)::varchar,2,2)||'C'||substring( (ind.idcriterio+1000)::varchar, 2,3)||'I'||substring( (ind.id+1000)::varchar, 2,3 ) as sigla
    FROM _referencia.dbindicadorref_instit AS ind
    JOIN _referencia.dbcriterioref_instit AS crt ON ( ind.idcriterio = crt.id )
    ORDER BY 3, 2, 1
) 
UPDATE _referencia.dbindicadorref_instit AS isa SET sigla = jo.sigla 
FROM joined AS jo
WHERE isa.id = jo.idind
;  


-- -----------------------------------------------------------------------------------------
-- View: _referencia.VW_H_CRITERIOSINDICADORES_INSTIT
-- -----------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW _referencia.vw_h_criteriosindicadores_instit AS
-- CTEs para cada nível, com colunas de ordenação adicionais
WITH dimaspecto_cte AS (
    SELECT DISTINCT
        id AS iddimaspecto,
        'Dimensão | Aspecto: ' || nome AS hierarquia,
        sigla,
        id * 1000000 AS ch -- Coluna de ordenação
    FROM _referencia.vwdimensaoaspecto_instit
),
criterio_cte AS (
    SELECT DISTINCT
        c.iddimaspecto,
	    c.id AS idcriterio,
	    c.valorimportancia,
        'Criterio: ' || c.nome AS hierarquia,
        c.sigla AS sigla,
        (iddimaspecto * 1000000) + (c.id * 1000)  AS ch -- Coluna de ordenação para estado
    FROM _referencia.vwcriterioref_instit c
    ORDER BY c.iddimaspecto, c.id
),
indicador_cte AS (
    SELECT DISTINCT
	    i.iddimaspecto,
        i.idcriterio,
        i.id AS idindicador,
	    i.valorimportancia,
        'Indicador: ' || i.nome AS hierarquia,
        i.sigla,
        (iddimaspecto * 1000000) + (i.idcriterio * 1000) + (i.id )  AS ch -- Coluna de ordenação para cidade
    FROM _referencia.vwindicadorref_instit i
    ORDER BY i.iddimaspecto, i.idcriterio, i.id
)
-- Construindo a árvore com joins em cada nível
SELECT ch, hierarquia, valorimportancia, sigla, iddimaspecto, idcriterio, idindicador, nivel
FROM (
    -- Nível de Dimensao/Aspecto
    SELECT d.hierarquia, d.sigla, d.ch, null::numeric(4,3) AS valorimportancia, d.iddimaspecto, null::integer as idcriterio, null::integer as idindicador, 1 as nivel
    FROM dimaspecto_cte d
    
    UNION ALL

    -- Nível de Criterio
    SELECT c.hierarquia, c.sigla, c.ch, c.valorimportancia, null::integer as iddimaspecto, c.idcriterio, null::integer as idindicador, 2 as nivel
    FROM criterio_cte c

    UNION ALL

    -- Nível de Indicador
    SELECT i.hierarquia, i.sigla, i.ch, i.valorimportancia, null::integer as iddimaspecto, null::integer as idcriterio, i.idindicador, 3 as nivel
    FROM indicador_cte i
) AS arvore
ORDER BY ch
;
ALTER TABLE IF EXISTS _referencia.vw_h_criteriosindicadores_instit OWNER to postgres;
GRANT ALL ON TABLE _referencia.vw_h_criteriosindicadores_instit TO n2espindesenv;
GRANT ALL ON TABLE _referencia.vw_h_criteriosindicadores_instit TO postgres;



-- -----------------------------------------------------------------------------------------
-- View: _referencia.VW_TREVIEW_CRITERIOSINDICADORES_INSTIT
-- -----------------------------------------------------------------------------------------
CREATE VIEW _referencia.vw_treview_criteriosindicadores_instit AS
SELECT  ch,
        sigla, 
        CASE
            WHEN nivel = 1 THEN ''
            WHEN nivel = 2 THEN '|'||repeat('_',(-1+nivel)*3)
            ELSE repeat(' ',(-1+nivel)*3)||'|'||repeat('_',(-2+nivel)*3)
        END || hierarquia as hierarquia, 
        valorimportancia, 
        nivel
FROM _referencia.vw_h_criteriosindicadores_instit
;
ALTER TABLE IF EXISTS _referencia.vw_treview_criteriosindicadores_instit OWNER to postgres;
GRANT ALL ON TABLE _referencia.vw_treview_criteriosindicadores_instit TO n2espindesenv;
GRANT ALL ON TABLE _referencia.vw_treview_criteriosindicadores_instit TO postgres;



