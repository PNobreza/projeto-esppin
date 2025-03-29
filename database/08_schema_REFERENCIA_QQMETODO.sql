-- -----------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------
-- SCHEMA: _referencia - QUAQUER METODOLOGIA
-- -----------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------


SET search_path TO _referencia, public;

/*
DROP VIEW   IF  EXISTS _referencia.vw_treview_criteriosindicadores_instit;
DROP VIEW   IF  EXISTS _referencia.vw_h_criteriosindicadores_instit;
DROP VIEW   IF  EXISTS _referencia.vwindicadorref_instit;
DROP TABLE IF  EXISTS _referencia.dbindicadorref_instit;
*/

DROP VIEW   IF EXISTS _referencia.vw_treeview_referencia;
DROP VIEW   IF EXISTS _referencia.vw_hierarq_referencia;
DROP TABLE  IF EXISTS _referencia.dbreferencia;
DROP TABLE  IF EXISTS _referencia.dbmetodologia;

-- -----------------------------------------------------------------------------------------
-- Table: _REFERENCIA.DBMETODOLOGIA
-- -----------------------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS _referencia.dbmetodologia
(
    id 				    SERIAL NOT NULL ,
    nome                VARCHAR(100) NOT NULL,
    sigla               VARCHAR(20) NOT NULL,
    ativo 			    character(1) DEFAULT 'S'::bpchar,
    CONSTRAINT pk_dbmetodologia PRIMARY KEY (id)
)
TABLESPACE pg_default;

ALTER TABLE IF EXISTS _referencia.dbmetodologia OWNER to postgres;
GRANT ALL ON TABLE _referencia.dbmetodologia TO n2espindesenv;
GRANT ALL ON TABLE _referencia.dbmetodologia TO postgres;
GRANT ALL ON SEQUENCE _referencia.dbmetodologia_id_seq TO n2espindesenv; 

INSERT INTO _referencia.dbmetodologia (sigla,nome) VALUES
('SOCAMB', 'Sócio-Ambiental'),
('INSTIT', 'Institucional'),
('SOCIAL', 'Social'),
('AMBIENTAL', 'Ambiental')
;



-- -----------------------------------------------------------------------------------------
-- Table: _REFERENCIA.DBREFERENCIA
-- -----------------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS _referencia.dbreferencia
(
    id 				    SERIAL NOT NULL ,
    id_autoref          BIGINT,
    idmetodologia       INTEGER NOT NULL,
    sigla 			    CHARACTER VARYING(20),
    nome 			    CHARACTER VARYING(200),
    valorimportancia    NUMERIC(4,3) DEFAULT 0.100 ,
    versao              VARCHAR(20),
    nivel               SMALLINT,
    ativo 			    CHARACTER(1) DEFAULT 'S'::bpchar,
    inc_data 			TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    inc_idusuario 		INTEGER,
    alt_data 			TIMESTAMP WITHOUT TIME ZONE,
    alt_idusuario 		INTEGER,
    exc_data 			TIMESTAMP WITHOUT TIME ZONE,
    exc_idusuario 		INTEGER,
    CONSTRAINT pk_dbreferencia PRIMARY KEY (id),

    CONSTRAINT fk_dbreferencia_autoreferencia FOREIGN KEY (id_autoref)
        REFERENCES _referencia.dbreferencia (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,

    CONSTRAINT fk_dbreferencia_dbmetodologia FOREIGN KEY (idmetodologia)
        REFERENCES _referencia.dbmetodologia (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,

    CONSTRAINT fk_dbreferencia_user_inc FOREIGN KEY (inc_idusuario)
        REFERENCES _adm.system_users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
	
    CONSTRAINT fk_dbreferencia_user_alt FOREIGN KEY (alt_idusuario)
        REFERENCES _adm.system_users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
	
    CONSTRAINT fk_dbreferencia_user_exc FOREIGN KEY (exc_idusuario)
        REFERENCES _adm.system_users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
TABLESPACE pg_default; --  DEFAULT _referencia.fn_carimbaversao('SOCAMB')
COMMENT ON TABLE  _referencia.dbreferencia            				    IS 'Tabela de Critérios/Indicadores de Referência, para Metodologias Escores';
COMMENT ON COLUMN _referencia.dbreferencia.id		     			    IS 'PK da tabela';
COMMENT ON COLUMN _referencia.dbreferencia.id_autoref 					IS 'Fk de Auto-Relacionamento: implementa hierarquia';
COMMENT ON COLUMN _referencia.dbreferencia.idmetodologia 			    IS 'Fk para DBMETODOLOGIA (métodos do Escores)';
COMMENT ON COLUMN _referencia.dbreferencia.sigla 					    IS 'Sigla da identificação do Aspesto/Criterio/Indicador';
COMMENT ON COLUMN _referencia.dbreferencia.nome 					    IS 'Nome do Aspesto/Criterio/Indicador';
COMMENT ON COLUMN _referencia.dbreferencia.valorimportancia 		    IS 'Valor/Peso de Importância';
COMMENT ON COLUMN _referencia.dbreferencia.versao 					    IS 'Versão do Registro na tabela';
COMMENT ON COLUMN _referencia.dbreferencia.nivel 					    IS 'Nível Hierarquico do Aspesto/Criterio/Indicador';
COMMENT ON COLUMN _referencia.dbreferencia.ativo 					    IS 'Flag de presença / situação do Registro na tabela';

ALTER TABLE IF EXISTS _referencia.dbreferencia OWNER to postgres;
GRANT ALL ON TABLE _referencia.dbreferencia TO n2espindesenv;
GRANT ALL ON TABLE _referencia.dbreferencia TO postgres;
GRANT ALL ON SEQUENCE _referencia.dbreferencia_id_seq TO n2espindesenv; 


INSERT INTO _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES
(null,1,'DA001C000I000', 'Impactos Ecológicos - Eficiência Tecnológica',null, '1',1,1),
(null,1,'DA002C000I000', 'Impactos Ecológicos - Qualidade Ambiental',null, '1',1, 1),
(null,1,'DA003C000I000', 'Impactos Sociais - Respeito ao Consumidor',null, '1',1, 1),
(null,1,'DA004C000I000', 'Impactos Sociais - Trabalho & Emprego',null, '1',1, 1),
(null,1,'DA005C000I000', 'Impactos Sociais - Renda',null, '1',1, 1),
(null,1,'DA006C000I000', 'Impactos Sociais - Saúde',null, '1',1, 1),
(null,1,'DA007C000I000', 'Impactos Sociais - Gestão e Administração',null, '1',1, 1)
;
-- -------------------------------------------------------------------------------------
/* Impactos Ecológicos - Eficiência Tecnológica */
-- -------------------------------------------------------------------------------------
INSERT INTO _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES
(1,1,null,'MUDANCA NO USO DIRETO DA TERRA', '0.05', '1',2,1),
(1,1,null,'MUDANCA NO USO INDIRETO DA TERRA', '0.05', '1',2,1),
(1,1,null,'CONSUMO DE AGUA', '0.05', '1',2,1),
(1,1,null,'USO DE INSUMOS AGRICOLAS', '0.05', '1',2,1),
(1,1,null,'USO DE INSUMOS VETERINARIOS E MATERIAS-PRIMAS', '0.05', '1',2,1),
(1,1,null,'CONSUMO DE ENERGIA', '0.05', '1',2,1),
(1,1,null,'GERACAO PROPRIA, APROVEITAMENTO, REUSO E AUTONOMIA', '0.025', '1',2,1);

UPDATE _referencia.dbreferencia AS dbr
SET sigla = ( SELECT substring(sigla,1,5) FROM _referencia.dbreferencia WHERE id = dbr.id_autoref )||
            'C'||substring( (id+1000)::varchar,2,3)||'I000' 
WHERE sigla IS NULL;
-- -------------------------------------------------------------------------------------
/* Impactos Ecológicos - Qualidade Ambiental */
-- -------------------------------------------------------------------------------------
INSERT INTO _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES
(2,1,null,'EMISSOES A ATMOSFERA', '0.02', '1',2,1),         
(2,1,null,'QUALIDADE DO SOLO', '0.05', '1',2,1),                                                               
(2,1,null,'QUALIDADE DA AGUA', '0.05', '1',2,1),                                                                  
(2,1,null,'CONSERVACAO DA BIODIVERSIDADE E RECUPERACAO AMBIENTAL', '0.05', '1',2,1);                              
UPDATE _referencia.dbreferencia AS dbr
SET sigla = ( SELECT substring(sigla,1,5) FROM _referencia.dbreferencia WHERE id = dbr.id_autoref )||
            'C'||substring( (id+1000)::varchar,2,3)||'I000' 
WHERE sigla IS NULL;
-- -------------------------------------------------------------------------------------
/* Impactos Socio-Ambientais - Respeito ao Consumidor */
-- -------------------------------------------------------------------------------------
INSERT INTO _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES
(3,1,null, 'QUALIDADE DO PRODUTO', '0.05', '1',2,1),
(3,1,null, 'CAPITAL SOCIAL', '0.02', '1',2,1),                                                               
(3,1,null, 'BEM-ESTAR E SAUDE ANIMAL', '0.02', '1',2,1);                                                           
UPDATE _referencia.dbreferencia AS dbr
SET sigla = ( SELECT substring(sigla,1,5) FROM _referencia.dbreferencia WHERE id = dbr.id_autoref )||
            'C'||substring( (id+1000)::varchar,2,3)||'I000' 
WHERE sigla IS NULL;
-- -------------------------------------------------------------------------------------
/* Impactos Socio-Ambientais - Trabalho / Emprego */
-- -------------------------------------------------------------------------------------
INSERT INTO _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES
(4,1,null, 'CAPACITACAO', '0.02', '1',2,1),                                                                        
(4,1,null, 'QUALIFICACAO E OFERTA DE TRABALHO', '0.02', '1',2,1),                                                  
(4,1,null, 'QUALIDADE DO EMPREGO / OCUPACAO', '0.05', '1',2,1),
(4,1,null, 'OPORTUNIDADE, EMANCIPACAO E RECOMPENSA EQUITATIVA ENTRE GENEROS, GERACOES E ETNIAS', '0.02', '1',2,1); 
UPDATE _referencia.dbreferencia AS dbr
SET sigla = ( SELECT substring(sigla,1,5) FROM _referencia.dbreferencia WHERE id = dbr.id_autoref )||
            'C'||substring( (id+1000)::varchar,2,3)||'I000' 
WHERE sigla IS NULL;
-- -------------------------------------------------------------------------------------
/* Impactos Socio-Ambientais - Renda */
-- -------------------------------------------------------------------------------------
INSERT INTO _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES
(5,1,null, 'GERACAO DE RENDA', '0.05', '1',2,1),
(5,1,null, 'VALOR DA PROPRIEDADE', '0.02', '1',2,1);                                                               
UPDATE _referencia.dbreferencia AS dbr
SET sigla = ( SELECT substring(sigla,1,5) FROM _referencia.dbreferencia WHERE id = dbr.id_autoref )||
            'C'||substring( (id+1000)::varchar,2,3)||'I000' 
WHERE sigla IS NULL;
-- -------------------------------------------------------------------------------------
/* Impactos Socio-Ambientais - Saúde */
-- -------------------------------------------------------------------------------------
INSERT INTO _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES
(6,1,null, 'SEGURANCA E SAUDE OCUPACIONAL', '0.025', '1',2,1),
(6,1,null, 'SEGURANCA ALIMENTAR', '0.05', '1',2,1);                                                                
UPDATE _referencia.dbreferencia AS dbr
SET sigla = ( SELECT substring(sigla,1,5) FROM _referencia.dbreferencia WHERE id = dbr.id_autoref )||
            'C'||substring( (id+1000)::varchar,2,3)||'I000' 
WHERE sigla IS NULL;
-- -------------------------------------------------------------------------------------
/* Impactos Socio-Ambientais - Gestão e Administração */
-- -------------------------------------------------------------------------------------
INSERT INTO _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES
(7,1,null, 'DEDICACAO E PERFIL DO RESPONSAVEL', '0.05', '1',2,1),
(7,1,null, 'CONDICAO DE COMERCIALIZACAO', '0.05', '1',2,1),                                                  
(7,1,null, 'DISPOSICAO DE RESIDUOS', '0.02', '1',2,1),                                                        
(7,1,null, 'GESTAO DE INSUMOS QUIMICOS', '0.02', '1',2,1),                                                         
(7,1,null, 'RELACIONAMENTO INSTITUCIONAL', '0.02', '1',2,1);
UPDATE _referencia.dbreferencia AS dbr
SET sigla = ( SELECT substring(sigla,1,5) FROM _referencia.dbreferencia WHERE id = dbr.id_autoref )||
            'C'||substring( (id+1000)::varchar,2,3)||'I000' 
WHERE sigla IS NULL;



insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (8,1, null, 'ESTOQUE DE CARBONO', '0.25', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (8,1, null, 'PREVENCAO DE INCENDIOS', '0.25', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (8,1, null, 'BIODIVERSIDADE PRODUTIVA', '0.25', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (8,1, null, 'PRODUTIVIDADE POR UNIDADE DE AREA (EFEITO POUPA TERRA)', '0.25', '1',3,1);

insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (9,1, null, 'COMPETICAO COM PRODUCAO DE ALIMENTOS', '-0.25', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (9,1, null, 'COMPETICAO PELA PROPRIEDADE DA TERRA', '-0.25', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (9,1, null, 'PRESSAO DE DESLOCAMENTO SOBRE AREAS NAO AGRICOLAS', '-0.25', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (9,1, null, 'INTERFERENCIA SOBRE A POSSE E USOS PELAS COMUNIDADES LOCAIS', '-0.25', '1',3,1);

insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (10,1, null, 'AGUA PARA IRRIGACAO', '-0.2', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (10,1, null, 'USO ALEM DA DISPONIBILIDADE TEMPORARIA', '-0.2', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (10,1, null, 'COMPROMETIMENTO DO USO POR CONTAMINACAO', '-0.2', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (10,1, null, 'COMPROMETIMENTO DA CAPTACAO / ARMAZENAMENTO', '-0.2', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (10,1, null, 'AGUA PARA PROCESSAMENTE (INCLUSIVE DESSENDENTACAO)', '-0.2', '1',3,1);

insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (11,1, null, 'FERTILIZANTES - CONDICIONADORES DE SOLO', '-0.1', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (11,1, null, 'FERTILIZANTES - ADUBOS QUIMICOS', '-0.2', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (11,1, null, 'PESTICIDAS - FREQUENCIA DE APLICACAO', '-0.2', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (11,1, null, 'PESTICIDAS - VARIEDADE DE INGREDIENTES ATIVOS (NAO ALTERNADOS)', '-0.2', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (11,1, null, 'PESTICIDAS - TOXICICIDADE', '-0.3', '1',3,1);

insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (12,1, null, 'USO DE MATERIAS-PRIMAS - MATERIAS-PRIMAS BASICAS', '-0.1', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (12,1, null, 'USO DE MATERIAS-PRIMAS - ADITIVOS AGROINDUSTRIAIS', '-0.1', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (12,1, null, 'USO DE MATERIAS-PRIMAS - MATERIAS-PRIMAS PARA PROCESSO', '-0.1', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (12,1, null, 'USO DE INSUMOS - RACOES E SUPLEMENTOS', '-0.2', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (12,1, null, 'USO DE INSUMOS - FENO, SILAGEM, FORRAGEM', '-0.2', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (12,1, null, 'USO DE INSUMOS - PRODUTOS VETERINARIOS', '-0.3', '1',3,1);

insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (13,1, null, 'FONTES DE ENERGIA - BIO-COMBUSTIVEIS', '-0.1', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (13,1, null, 'FONTES DE ENERGIA - BIOMASSA (LENHA, BAGACOS, ETC)', '-0.1', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (13,1, null, 'FONTES DE ENERGIA - COMBUSTIVEIS FOSSEIS', '-0.3', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (13,1, null, 'FONTES DE ENERGIA - ELETRICIDADE', '-0.5', '1',3,1);

insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (14,1, null, 'AUTONOMIA MATERIAL E ENERGETICA - (CO)GERACAO MOTRIZ OU ELETRICA (SOLAR, EOLICA, HIDRO, BIOGAS)', '0.3', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (14,1, null, 'AUTONOMIA MATERIAL E ENERGETICA - APROVEITAMENTO TERMICO (CONSUMO ENERGETICO EVITADO)', '0.15', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (14,1, null, 'AUTONOMIA MATERIAL E ENERGETICA - CONTROLE BIOLOGICO | MANEJO ECOLOGICO DE PRAGAS E DOENCAS', '0.15', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (14,1, null, 'AUTONOMIA MATERIAL E ENERGETICA - ADUBO VERDE | FIXACAO BIOLOGICA N | INOCULACAO MICORRIZICA', '0.15', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (14,1, null, 'AUTONOMIA MATERIAL E ENERGETICA - ADUBO ORGANICO | ESTERCO | ESTRUME | COMPOSTAGEM | FORMULADOS ORGANICOMINERAIS', '0.25', '1',3,1);

insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (15,1, null, 'EMISSOES A ATMOSFERA - ODORES', '-0.1', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (15,1, null, 'EMISSOES A ATMOSFERA - RUIDOS', '-0.1', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (15,1, null, 'EMISSOES A ATMOSFERA - GASES DE EFEITO ESTUFA', '-0.4', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (15,1, null, 'EMISSOES A ATMOSFERA - MATERIAL PARTICULADO | FUMACA', '-0.4', '1',3,1);

insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (16,1, null, 'QUALIDADE DO SOLO - EROSAO', '-0.25', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (16,1, null, 'QUALIDADE DO SOLO - COMPACTACAO', '-0.25', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (16,1, null, 'QUALIDADE DO SOLO - PERDA DE NUTRIENTES', '-0.25', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (16,1, null, 'QUALIDADE DO SOLO - PERDA DE MATERIA ORGANICA', '-0.25', '1',3,1);

insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (17,1, null, 'QUALIDADE DA AGUA - TURBIDEZ', '-0.2', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (17,1, null, 'QUALIDADE DA AGUA - ASSOREAMENTO DE CORPOS DAGUA', '-0.2', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (17,1, null, 'QUALIDADE DA AGUA - ESPUMAS | OLEOS | RESIDUOS SOLIDOS', '-0.2', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (17,1, null, 'QUALIDADE DA AGUA - CARGA ORGANICA (EFLUENTES, ESGOTOS, ESTERCOS, ETC)', '-0.2', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (17,1, null, 'QUALIDADE DA AGUA - EXPOSICAO A CONTAMINACAO DIRETA | INDIRETA POR AGROTOXICOS', '-0.2', '1',3,1);

insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (18,1, null, 'CONSERVACAO DA BIODIVERSIDADE - FAUNA SILVESTRE', '0.1', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (18,1, null, 'CONSERVACAO DA BIODIVERSIDADE - VEGETACAO NATIVA', '0.1', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (18,1, null, 'CONSERVACAO DA BIODIVERSIDADE - ESPECIES | VARIEDADES TRADICIONAIS (CABOCLAS)', '0.1', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (18,1, null, 'RECUPERACAO AMBIENTAL - RESERVA LEGAL', '0.2', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (18,1, null, 'RECUPERACAO AMBIENTAL - AREAS DE PRESERVACAO PERMANENTE', '0.2', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (18,1, null, 'RECUPERACAO AMBIENTAL - SOLOS DEGRADADOS', '0.15', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (18,1, null, 'RECUPERACAO AMBIENTAL - ECOSSISTEMAS DEGRADADOS', '0.15', '1',3,1);

insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (19,1, null, 'QUALIDADE DO PRODUTO - PROCEDIMENTOS DE POS-COLHEITA', '0.2', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (19,1, null, 'QUALIDADE DO PRODUTO - DISPONIBILIDADE DE FONTES DE INSUMOS', '0.15', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (19,1, null, 'QUALIDADE DO PRODUTO - IDONEIDADE DOS FORNECEDORES DE INSUMOS', '0.15', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (19,1, null, 'QUALIDADE DO PRODUTO - REDUCAO DE RESIDUOS QUIMICOS', '0.25', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (19,1, null, 'QUALIDADE DO PRODUTO - REDUCAO DE CONTAMINANTES BIOLOGICOS', '0.25', '1',3,1);

insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (20,1, null, 'ENGAJAMENTO EM MOVIMENTOS SOCIAIS', '0.2', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (20,1, null, 'INTEGRACAO CULTURAL ENTRE OS COLABORADORES E FAMILIARES', '0.2', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (20,1, null, 'CAPTACAO DE DEMANDAS DA COMUNIDADE', '0.15', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (20,1, null, 'PROJETOS DE EXTENSAO COMUNITARIA | EDUCACAO AMBIENTAL', '0.15', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (20,1, null, 'PROGRAMAS DE TRANSFERENCIA DE CONHECIMENTOS E TECNOLOGIAS', '0.15', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (20,1, null, 'CONSERVACAO DO PATRIMONIO HISTORICO | ARTISTICO | CULTURAL', '0.15', '1',3,1);

insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (21,1, null, 'ACOES QUE MINIMIZEM O SOFRIMENTO, O ESTRESSE E A DOR', '0.1', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (21,1, null, 'CONDUTA ETICA DE MANEJO, DESCARTE E PRE-ABATE | ABATE', '0.1', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (21,1, null, 'CONDICOES P/ EXPRESSAR COMPORTAMENTOS NATURAIS DA ESPECIE', '0.1', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (21,1, null, 'ACESSO A AGUA, ALIMENTO E SUPLEMENTOS DE QUALIDADE', '0.2', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (21,1, null, 'CONFORTO TERMICO E SALUBRIDADE DOS AMBIENTES DE MANEJO', '0.2', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (21,1, null, 'SEGURANCA E MANEJO SANITARIO PREVENTIVO', '0.15', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (21,1, null, 'LOTACAO ADEQUADA NAS INSTALACOES E AREAS EXTERNAS', '0.15', '1',3,1);

insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (22,1, null, 'NIVEL DE CAPACITACAO - BASICO', '0.1', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (22,1, null, 'NIVEL DE CAPACITACAO - TECNICO', '0.1', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (22,1, null, 'NIVEL DE CAPACITACAO - SUPERIOR', '0.1', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (22,1, null, 'TIPO DE CAPACITACAO - EDUCACAO FORMAL', '0.2', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (22,1, null, 'TIPO DE CAPACITACAO - ESPECIALIZACAO', '0.25', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (22,1, null, 'TIPO DE CAPACITACAO - LOCAL DE CURTA DURACAO', '0.25', '1',3,1);

insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (23,1, null, 'CONDICAO DE CONTRATACAO - PERMANENTE', '0.1', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (23,1, null, 'CONDICAO DE CONTRATACAO - PARCEIRO | MEEIRO', '0.1', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (23,1, null, 'QUALIFICACAO REQUERIDA PARA O TRABALHO - BRACAL', '0.1', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (23,1, null, 'QUALIFICACAO REQUERIDA PARA O TRABALHO - TECNICO SUPERIOR', '0.2', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (23,1, null, 'CONDICAO DE CONTRATACAO - TEMPORARIO', '0.05', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (23,1, null, 'CONDICAO DE CONTRATACAO - FAMILIAR', '0.15', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (23,1, null, 'QUALIFICACAO REQUERIDA PARA O TRABALHO - TECNICO MEDIO', '0.15', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (23,1, null, 'QUALIFICACAO REQUERIDA PARA O TRABALHO - BRACAL ESPECIALIZADO', '0.15', '1',3,1);

insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (24,1, null, 'LEGISLACAO TRABALHISTA - REGISTRO', '0.2', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (24,1, null, 'LEGISLACAO TRABALHISTA - PREVENCAO DE JORNADA > 44HS', '0.2', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (24,1, null, 'LEGISLACAO TRABALHISTA - CONTRIBUICAO PREVIDENCIARIA', '0.2', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (24,1, null, 'LEGISLACAO TRABALHISTA - PREVENCAO DO TRABALHO INFANTIL', '0.2', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (24,1, null, 'BENEFICIOS TRABALHISTAS - AUXILIO MORADIA', '0.05', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (24,1, null, 'BENEFICIOS TRABALHISTAS - AUXILIO TRANSPORTE', '0.05', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (24,1, null, 'BENEFICIOS TRABALHISTAS - AUXILIO ALIMENTACAO', '0.05', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (24,1, null, 'BENEFICIOS TRABALHISTAS - AUXILIO SAUDE (COMPLEMENTAR)', '0.05', '1',3,1);

insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (25,1, null, 'EQUIDADE ETNICA - RESPEITO MUTUO E VALORIZACAO CULTURAL', '0.125', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (25,1, null, 'EQUIDADE ETNICA - EQUIDADE DE OPORTUNIDADES ENTRE ETNIAS', '0.125', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (25,1, null, 'EQUIDADE DE GENEROS - EMANCIPACAO E RECONHECIMENTO DAS ESCOLHAS DAS MULHERES', '0.125', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (25,1, null, 'EQUIDADE DE GERACOES - RECOMPENSA EQUITATIVA DAS ATIVIDADES PRODUTIVAS DOS JOVENS', '0.125', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (25,1, null, 'EQUIDADE DE GENEROS - RECOMPENSA EQUITATIVA DAS ATIVIDADES PRODUTIVAS DAS MULHERES', '0.125', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (25,1, null, 'EQUIDADE DE GERACOES - EMANCIPACAO E RECONHECIMENTO DAS ESCOLHAS DOS JOVENS E IDOSOS', '0.125', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (25,1, null, 'EQUIDADE DE GENEROS - OPORTUNIDADE DE ENVOLVIMENTO E VALORIZACAO DA PARTICIPACAO DAS MULHERES', '0.125', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (25,1, null, 'EQUIDADE DE GERACOES - OPORTUNIDADE DE ENVOLVIMENTO E VALORIZACAO DA PARTICIPACAO DOS JOVENS E IDOSOS', '0.125', '1',3,1);

insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (26,1, null, 'ATRIBUTOS DE RENDA - MONTANTE', '0.2', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (26,1, null, 'ATRIBUTOS DE RENDA - DIVERSIDADE DE FONTES DE RENDA', '0.2', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (26,1, null, 'ATRIBUTOS DE RENDA - SEGURANCA (GARANTIA DE OBTENCAO)', '0.2', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (26,1, null, 'ATRIBUTOS DE RENDA - ESTABILIDADE (REDUCAO DA SAZONALIDADE)', '0.2', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (26,1, null, 'ATRIBUTOS DE RENDA - DISTRIBUICAO (REMUNERACOES E BENEFICIOS)', '0.2', '1',3,1);

insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (27,1, null, 'VALORIZACAO DA PROPRIEDADE - PRECOS DE PRODUTOS E SERVICOS', '0.2', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (27,1, null, 'VALORIZACAO DA PROPRIEDADE - CONFORMIDADE COM LEGISLACAO', '0.15', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (27,1, null, 'VALORIZACAO DA PROPRIEDADE - INFRA-ESTRUTURA | POLITICA TRIBUTARIA ETC', '0.15', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (27,1, null, 'VALORIZACAO DA PROPRIEDADE - INVESTIMENTO EM BENFEITORIAS', '0.25', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (27,1, null, 'VALORIZACAO DA PROPRIEDADE - CONSERVACAO DOS RECURSOS NATURAIS', '0.25', '1',3,1);

insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (28,1, null, 'EXPOSICAO A PERICULOSIDADES E FATORES DE INSALUBRIDADES - RUIDO', '-0.1', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (28,1, null, 'EXPOSICAO A PERICULOSIDADES E FATORES DE INSALUBRIDADES - VIBRACAO', '-0.1', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (28,1, null, 'EXPOSICAO A PERICULOSIDADES E FATORES DE INSALUBRIDADES - AGENTES BIOLOGICOS', '-0.1', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (28,1, null, 'EXPOSICAO A PERICULOSIDADES E FATORES DE INSALUBRIDADES - AGENTES QUIMICOS', '-0.2', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (28,1, null, 'EXPOSICAO A PERICULOSIDADES E FATORES DE INSALUBRIDADES - PERICULOSIDADE', '-0.3', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (28,1, null, 'EXPOSICAO A PERICULOSIDADES E FATORES DE INSALUBRIDADES - CALOR | FRIO | UMIDADE', '-0.05', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (28,1, null, 'EXPOSICAO A PERICULOSIDADES E FATORES DE INSALUBRIDADES - ACIDENTES ERGONOMICOS (QUEDAS, MAQUINAS)', '-0.15', '1',3,1);

insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (29,1, null, 'SEGURANCA ALIMENTAR - GARANTIA DA PRODUCAO', '0.3', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (29,1, null, 'SEGURANCA ALIMENTAR - QUANTIDADE DE ALIMENTO', '0.3', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (29,1, null, 'SEGURANCA ALIMENTAR - QUALIDADE NUTRICIONAL DO ALIMENTO', '0.4', '1',3,1);

insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (30,1, null, 'DEDICACAO DO RESPONSAVEL - CAPACITACAO DIRIGIDA A ATIVIDADE', '0.2', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (30,1, null, 'DEDICACAO DO RESPONSAVEL - HORAS DE PERMANENCIA NO ESTABELECIMENTO', '0.2', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (30,1, null, 'DEDICACAO DO RESPONSAVEL - ENGAJAMENTO FAMILIAR', '0.15', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (30,1, null, 'DEDICACAO DO RESPONSAVEL - USO DE SISTEMA CONTABIL', '0.15', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (30,1, null, 'DEDICACAO DO RESPONSAVEL - MODELO FORMAL DE PLANEJAMENTO', '0.15', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (30,1, null, 'DEDICACAO DO RESPONSAVEL - SISTEMA DE CERTIFICACAO | ROTULAGEM', '0.15', '1',3,1);

insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (31,1, null, 'COMERCIALIZACAO - COOPERACAO COM OUTROS PRODUTORES LOCAIS', '0.1', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (31,1, null, 'COMERCIALIZACAO - TRANSPORTE PROPRIO', '0.15', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (31,1, null, 'COMERCIALIZACAO - ARMAZENAMENTO LOCAL', '0.15', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (31,1, null, 'COMERCIALIZACAO - PROCESSAMENTO LOCAL', '0.15', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (31,1, null, 'COMERCIALIZACAO - PROPAGANDA | MARCA PROPRIA', '0.15', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (31,1, null, 'COMERCIALIZACAO - VENDA DIRETA | ANTECIPADA | COOPERADA', '0.15', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (31,1, null, 'COMERCIALIZACAO - ENCADEAMENTO COM PRODUTOS | ATIVIDADES | SERVICOS ANTERIORES', '0.15', '1',3,1);

insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (32,1, null, 'TRATAMENTO DE RESIDUOS DOMESTICOS - COLETA SELETIVA', '0.2', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (32,1, null, 'TRATAMENTO DE RESIDUOS DA PRODUCAO - REAPROVEITAMENTO', '0.2', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (32,1, null, 'TRATAMENTO DE RESIDUOS DOMESTICOS - DISPOSICAO SANITARIA', '0.2', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (32,1, null, 'TRATAMENTO DE RESIDUOS DOMESTICOS - COMPOSTAGEM | REAPROVEITAMENTO', '0.2', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (32,1, null, 'TRATAMENTO DE RESIDUOS DA PRODUCAO - DESTINACAO OU TRATAMENTO FINAL', '0.2', '1',3,1);

insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (33,1, null, 'GESTAO DE INSUMOS QUIMICOS - ARMAZENAMENTO', '0.2', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (33,1, null, 'GESTAO DE INSUMOS QUIMICOS - REGISTRO DE TRATAMENTOS', '0.15', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (33,1, null, 'GESTAO DE INSUMOS QUIMICOS - DISPOSICAO FINAL ADEQUADA DE RECIPIENTES E EMBALAGENS', '0.15', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (33,1, null, 'GESTAO DE INSUMOS QUIMICOS - UTILIZACAO DE EQUIPAMENTOS DE PROTECAO INDIVIDUAL', '0.25', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (33,1, null, 'GESTAO DE INSUMOS QUIMICOS - CALIBRACAO E VERIFICACAO DE EQUIPAMENTOS DE APLICACAO', '0.25', '1',3,1);

insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (34,1, null, 'ALCANCE INSTITUCIONAL - FILIACAO TECNOLOGICA NOMINAL', '0.25', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (34,1, null, 'ALCANCE INSTITUCIONAL - ASSOCIATIVISMO | COOPERATIVISMO', '0.25', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (34,1, null, 'ALCANCE INSTITUCIONAL - UTILIZACAO DE ASSISTENCIA TECNICA', '0.25', '1',3,1);
insert into _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES (34,1, null, 'ALCANCE INSTITUCIONAL - UTILIZACAO DE ASSESSORIA LEGAL | VISTORIA', '0.25', '1',3,1);

UPDATE _referencia.dbreferencia AS dbr
SET sigla = ( SELECT substring(sigla,1,9) FROM _referencia.dbreferencia WHERE id = dbr.id_autoref )||
            'I'||substring( (id+1000)::varchar,2,3) 
WHERE sigla IS NULL
AND   nivel = 3;



-- -----------------------------------------------------------------------------------------
-- View: _REFERENCIA.VW_HIERARQ_REFERENCIA
-- -----------------------------------------------------------------------------------------

CREATE OR REPLACE VIEW _referencia.vw_hierarq_referencia
AS WITH dimaspecto_cte AS (
        SELECT DISTINCT da.idmetodologia, da.id AS iddimaspecto,
        CASE
          WHEN (da.idmetodologia = 1)
            THEN
              (('Dimensão: '::text || rtrim(SUBSTRING(upper(unaccent(da.nome::text)) FROM 1 FOR POSITION(('-'::text) IN (upper(unaccent(da.nome::text)))) - 1))) || 
              ' | Aspecto: '::text) || rtrim(SUBSTRING(upper(unaccent(da.nome::text)) FROM POSITION(('-'::text) IN (upper(unaccent(da.nome::text)))) + 1 FOR length(upper(unaccent(da.nome::text))))) 
          WHEN (da.idmetodologia = 2)
            THEN
              'Dimensão: INSTITUCIONAL | Aspecto: ' || upper(unaccent(da.nome))   
          ELSE
            upper(unaccent(da.nome))
        END AS hierarquia,
            da.sigla AS ch,
			      da.nivel
        FROM _referencia.dbreferencia da
        WHERE da.nivel = 1 
    ), criterio_cte AS (
        SELECT DISTINCT c.idmetodologia, c.id_autoref AS iddimaspecto,
            c.id AS idcriterio,
            c.valorimportancia,
            'Criterio: '::text || c.nome::text AS hierarquia,
            c.sigla AS ch,
			      c.nivel
        FROM _referencia.dbreferencia c
        WHERE c.nivel = 2
        ORDER BY c.id_autoref
    ), indicador_cte AS (
        SELECT DISTINCT i.idmetodologia, i.id_autoref AS idcriterio,
            i.id AS idindicador,
            i.valorimportancia,
            'Indicador: '::text || i.nome::text AS hierarquia,
            i.sigla AS ch,
			      i.nivel
        FROM _referencia.dbreferencia i
        WHERE i.nivel = 3
        ORDER BY i.id_autoref
)
 SELECT coalesce(iddimaspecto,idcriterio,idindicador) as id,
        idmetodologia, 
        ch,
        hierarquia,
        valorimportancia,
        iddimaspecto,
        idcriterio,
        idindicador,
        nivel
   FROM ( SELECT  d.idmetodologia,  
                  d.ch,
                  d.hierarquia,
                  NULL::numeric(4,3) AS valorimportancia,
                  d.iddimaspecto,
                  NULL::integer AS idcriterio,
                  NULL::integer AS idindicador,
                  d.nivel
          FROM dimaspecto_cte d
        UNION ALL
          SELECT  c.idmetodologia,  
                  c.ch,
                  c.hierarquia,
                  c.valorimportancia,
                  NULL::integer AS iddimaspecto,
                  c.idcriterio,
                  NULL::integer AS idindicador,
                  c.nivel
          FROM criterio_cte c
        UNION ALL
          SELECT  i.idmetodologia,  
                  i.ch,
                  i.hierarquia,
                  i.valorimportancia,
                  NULL::integer AS iddimaspecto,
                  NULL::integer AS idcriterio,
                  i.idindicador,
                  i.nivel
          FROM indicador_cte i) arvore
  ORDER BY idmetodologia, ch;
  
ALTER TABLE IF EXISTS _referencia.vw_hierarq_referencia OWNER to postgres;
GRANT ALL ON TABLE _referencia.vw_hierarq_referencia TO n2espindesenv;
GRANT ALL ON TABLE _referencia.vw_hierarq_referencia TO postgres;



-- -----------------------------------------------------------------------------------------
-- View: _REFERENCIA.VW_TREEVIEW_REFERENCIA
-- -----------------------------------------------------------------------------------------
CREATE VIEW _referencia.vw_treeview_referencia AS
SELECT  idmetodologia, 
        ch,
        CASE
            WHEN nivel = 1 THEN ''
            WHEN nivel = 2 THEN '|'||repeat('_',(-1+nivel)*3)
            ELSE repeat(' ',(-1+nivel)*3)||'|'||repeat('_',(-2+nivel)*3)
        END || hierarquia as hierarquia, 
        valorimportancia, 
        nivel
FROM _referencia.vw_hierarq_referencia
;
ALTER TABLE IF EXISTS _referencia.vw_treeview_referencia OWNER to postgres;
GRANT ALL ON TABLE _referencia.vw_treeview_referencia TO n2espindesenv;
GRANT ALL ON TABLE _referencia.vw_treeview_referencia TO postgres;









