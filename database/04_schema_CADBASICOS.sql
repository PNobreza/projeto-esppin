-- -----------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------
-- SCHEMA: _cadbasicos
-- -----------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------

DROP SCHEMA IF EXISTS _cadbasicos CASCADE;
CREATE SCHEMA IF NOT EXISTS _cadbasicos AUTHORIZATION postgres;
COMMENT ON SCHEMA _cadbasicos	IS 'Dados fundamentais: Parceiros, Beneficiarios, Projetos e Juizes/Experts e Rodada';
GRANT USAGE ON SCHEMA _cadbasicos TO n2espindesenv;
GRANT ALL ON SCHEMA _cadbasicos TO postgres;


-- -----------------------------------------------------------------------------------------
-- Novos Dominios
-- -----------------------------------------------------------------------------------------
DELETE FROM _global.dbcampodominio WHERE grupodominio IN ('moe', 'umr', 'uma', 'erv', 'strd');
INSERT INTO _global.dbcampodominio (grupodominio, descdominio, indicedominio, valordominio, inc_idusuario, aux, aux2) VALUES 
( 'moe', 'Descritor de Moeda', 1, 'Real', 1 , 'R$', NULL ),
( 'moe', 'Descritor de Moeda', 2, 'Dolar Americano', 1, 'US$', NULL ),
( 'moe', 'Descritor de Moeda', 3, 'Euro', 1, 'EU$', NULL ),
( 'moe', 'Descritor de Moeda', 4, 'Peso Argentino', 1, 'PA$', NULL ),  
( 'moe', 'Descritor de Moeda', 5, 'Peso Colombiano', 1, 'PC$', NULL ),
( 'moe', 'Descritor de Moeda', 6, 'Peso Panamenho', 1, 'PP$', NULL ),
( 'umr', 'Un. Medida Rendimento', 1, 'Ton/ha',1, NULL, NULL ),
( 'umr', 'Un. Medida Rendimento', 2, 'Sc/ha',1, NULL, NULL ),
( 'umr', 'Un. Medida Rendimento', 3, 'Kg/m2',1, NULL, NULL ),
( 'umr', 'Un. Medida Rendimento', 4, 'Ton/m3',1, NULL, NULL ),
( 'uma', 'Un. Medida Adoção', 1, 'ha Hectare',1, NULL, NULL ),
( 'uma', 'Un. Medida Adoção', 2, 'a Are 100m2',1, NULL, NULL ),
( 'uma', 'Un. Medida Adoção', 3, 'ca Centiare 1m2',1, NULL, NULL ),
( 'uma', 'Un. Medida Adoção', 4, 'Alq Alqueire',1, NULL, NULL ),
( 'uma', 'Un. Medida Adoção', 5, 'Alq Paulista 2,42ha',1, NULL, NULL ),
( 'uma', 'Un. Medida Adoção', 6, 'Alq Norte 2,72ha',1, NULL, NULL ),
( 'uma', 'Un. Medida Adoção', 7, 'Alq Baiano 96,8ha',1, NULL, NULL ),
( 'uma', 'Un. Medida Adoção', 8, 'Alq Fluminense 2,72ha',1, NULL, NULL ),
( 'uma', 'Un. Medida Adoção', 9, 'Alq CO 4,84ha',1, NULL, NULL ),
( 'erv', 'Expressao Rep Valores', 1, 'Mil',1, NULL, NULL ),
( 'erv', 'Expressao Rep Valores', 2, ' x10 Mil',1, NULL, NULL ),
( 'erv', 'Expressao Rep Valores', 3, ' x100 Mil',1, NULL, NULL ),
( 'erv', 'Expressao Rep Valores', 4, ' Mi',1, NULL, NULL ),
( 'erv', 'Expressao Rep Valores', 5, ' Bi', 1, NULL , NULL ),
( 'strd', 'Status Rodada', 1, 'Registrado',1, NULL, 'blue' ),
( 'strd', 'Status Rodada', 2, 'Em Configuração',1, NULL, 'orange' ),
( 'strd', 'Status Rodada', 3, 'Configurado',1, NULL, 'green' ),
( 'strd', 'Status Rodada', 4, 'Em Andamento',1, NULL, 'orange' ),
( 'strd', 'Status Rodada', 5, 'Suspensa', 1, NULL, 'red' ),
( 'strd', 'Status Rodada', 6, 'Encerrada', 1, NULL, 'red' ),
( 'strd', 'Status Rodada', 7, 'Concluída', 1, NULL,'green' ),	
( 'tfs ', 'Tipo de Fase',1,'Rodada',1,NULL,NULL ),
( 'tfs ', 'Tipo de Fase',2,'Outras',1,NULL,NULL )
;


SET search_path TO _cadbasicos, public;

ALTER TABLE IF EXISTS _cadbasicos.dbgrupoparcbenef DROP CONSTRAINT IF EXISTS un_tipopb_nome;
ALTER TABLE IF EXISTS _cadbasicos.dbgrupoparcbenef DROP CONSTRAINT IF EXISTS unq_tipopb_nome;
DROP VIEW   IF EXISTS _cadbasicos.vwprojetoparcbenef;
DROP VIEW   IF EXISTS _cadbasicos.vwprojetonaoparceiro;
DROP VIEW   IF EXISTS _cadbasicos.vwprojetobeneficiario;
DROP VIEW   IF EXISTS _cadbasicos.vwbeneficiario;
DROP VIEW   IF EXISTS _cadbasicos.vwprojetoparceiro;
DROP VIEW   IF EXISTS _cadbasicos.vwparceiro;
DROP VIEW   IF EXISTS _cadbasicos.vwparceiros;
DROP TABLE  IF EXISTS _cadbasicos.dbprojetoparceiro;
DROP TABLE  IF EXISTS _cadbasicos.dbprojetobeneficiario;
DROP VIEW   IF EXISTS _cadbasicos.vwprojeto;
DROP VIEW   IF EXISTS _cadbasicos.vwprojetos;
DROP TABLE  IF EXISTS _cadbasicos.dbprojeto;
DROP VIEW   IF EXISTS _cadbasicos.vwgrupoparcbenef;
DROP TABLE  IF EXISTS _cadbasicos.dbgrupoparcbenef;
DROP VIEW   IF EXISTS _cadbasicos.vwrodada;
DROP TABLE  IF EXISTS _cadbasicos.dbrodada;


-- -----------------------------------------------------------------------------------------
-- Table: _CADBASICOS.DBGRUPOPARCBENEF
-- -----------------------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS _cadbasicos.dbgrupoparcbenef
(
    id 				SERIAL NOT NULL ,
    tipopb 			integer NOT NULL,
    nome 			character varying(40),
    sigla 			character varying(20),
    ativo 			character(1) DEFAULT 'S'::bpchar,
    inc_data 			TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    inc_idusuario 		integer,
    alt_data 			TIMESTAMP WITHOUT TIME ZONE,
    alt_idusuario 		integer,
    exc_data 			TIMESTAMP WITHOUT TIME ZONE,
    exc_idusuario 		integer,
    CONSTRAINT pk_dbgrupoparcbenef PRIMARY KEY (id),

    CONSTRAINT unq_tipopb_nome UNIQUE (tipopb, nome) INCLUDE(tipopb, nome),
	
    CONSTRAINT fk_dbgrupoparcbenef_user_inc FOREIGN KEY (inc_idusuario)
        REFERENCES _adm.system_users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
	
    CONSTRAINT fk_dbgrupoparcbenef_user_alt FOREIGN KEY (alt_idusuario)
        REFERENCES _adm.system_users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
	
    CONSTRAINT fk_dbgrupoparcbenef_user_exc FOREIGN KEY (exc_idusuario)
        REFERENCES _adm.system_users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
TABLESPACE pg_default;

ALTER TABLE IF EXISTS _cadbasicos.dbgrupoparcbenef OWNER to postgres;
GRANT ALL ON TABLE _cadbasicos.dbgrupoparcbenef TO n2espindesenv;
GRANT ALL ON TABLE _cadbasicos.dbgrupoparcbenef TO postgres;
GRANT ALL ON SEQUENCE _cadbasicos.dbgrupoparcbenef_id_seq TO n2espindesenv; 

INSERT INTO _cadbasicos.dbgrupoparcbenef (tipopb, nome, sigla, ativo, inc_data, inc_idusuario, alt_data, alt_idusuario, exc_data, exc_idusuario) VALUES
(2, 'Agropecuária Santa Monica', 'AGRISANTA', 'S', '2024-10-25 08:22:45.078', 1, NULL, NULL, NULL, NULL),
(2, 'Agropecuária Água Clara', 'AGUACLARA', 'S', '2024-10-25 08:22:45.078', 1, NULL, NULL, NULL, NULL),
(1, 'Governo Argentino', 'ARGENTINA', 'S', '2024-10-25 08:23:19.755', 1, NULL, NULL, NULL, NULL),
(2, 'Rancho Boi Gordo', 'BoiGordo', 'S', '2024-10-25 08:22:45.078', 1, NULL, NULL, NULL, NULL),
(1, 'Governo Chileno', 'CHILE', 'S', '2024-10-25 08:23:34.766', 1, NULL, NULL, NULL, NULL),
(1, 'Governo Colombiano', 'COLÔMBIA', 'S', '2024-10-25 08:23:51.278', 1, NULL, NULL, NULL, NULL),
(2, 'Casa do Povo', 'CAPOVO', 'S', '2024-10-25 08:24:19.759', 1, NULL, NULL, NULL, NULL),
(2, 'Casa do Cheiroso', 'CACHEIRO', 'S', '2024-10-25 08:24:19.759', 1, '2024-10-28 10:12:59', 1, NULL, NULL),
(1, 'Instituto Bill Gates', 'iGATES', 'S', '2024-10-25 08:23:51.278', 1, NULL, NULL, NULL, NULL);



-- -----------------------------------------------------------------------------------------
-- View: _CADBASICOS.VWGRUPOPARCBENEF
-- -----------------------------------------------------------------------------------------

CREATE OR REPLACE VIEW _cadbasicos.vwgrupoparcbenef
 AS
 SELECT dgpb.id,
    dgpb.tipopb,
    t1.valordominio AS desctipopb,
    dgpb.nome,
    dgpb.sigla,
    dgpb.ativo,
    dgpb.inc_data,
    dgpb.inc_idusuario,
    dgpb.alt_data,
    dgpb.alt_idusuario,
    dgpb.exc_data,
    dgpb.exc_idusuario
   FROM _cadbasicos.dbgrupoparcbenef dgpb
     LEFT JOIN _global.dbcampodominio t1 ON t1.grupodominio = 'tpb'::bpchar AND t1.indicedominio = dgpb.tipopb
   WHERE dgpb.exc_data is NULL;     -- Paulo
   ;
   -- MNobre: entra ==>> WHERE dgpb.exc_data IS NULL;

ALTER TABLE _cadbasicos.vwgrupoparcbenef  OWNER TO postgres;
GRANT ALL ON TABLE _cadbasicos.vwgrupoparcbenef TO n2espindesenv;
GRANT ALL ON TABLE _cadbasicos.vwgrupoparcbenef TO postgres;


-- -----------------------------------------------------------------------------------------
-- View: _CADBASICOS.VWPARCEIRO
-- -----------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW _cadbasicos.vwparceiro
 AS
 SELECT id as   idparceiro,
                tipopb,
	            desctipopb,	
	            trim( both from nome ) || ' - ' || trim( both from sigla ) AS nomesigla,
	            trim( both from sigla ) || ' - ' || trim( both from nome ) AS siglanome,
	            sigla,
	            nome,
	            ativo,
	            inc_data,
	            inc_idusuario,
	            alt_data,
	            alt_idusuario,
	            exc_data,
	            exc_idusuario
 FROM _cadbasicos.vwgrupoparcbenef vwgpb
 WHERE vwgpb.tipopb = 2
 AND vwgpb.ativo = 'S'   -- Paulo
 ORDER BY nome ASC, sigla ASC
 ;
-- MNobre: não entra ==>> AND exc_data IS NULL

ALTER TABLE _cadbasicos.vwparceiro OWNER TO postgres;
GRANT ALL ON TABLE _cadbasicos.vwparceiro TO n2espindesenv;
GRANT ALL ON TABLE _cadbasicos.vwparceiro TO postgres;


-- -----------------------------------------------------------------------------------------
-- View: _CADBASICOS.VWBENEFICIARIO 
-- -----------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW _cadbasicos.vwbeneficiario
 AS
 SELECT id as   idbeneficiario,
                tipopb,
            	desctipopb,
            	trim( both from nome ) || ' - ' || trim( both from sigla ) AS nomesigla,
            	trim( both from sigla ) || ' - ' || trim( both from nome ) AS siglanome,
            	sigla,
            	nome,
            	ativo,
            	inc_data,
            	inc_idusuario,
            	alt_data,
            	alt_idusuario,
            	exc_data,
            	exc_idusuario
 FROM _cadbasicos.vwgrupoparcbenef vwgpb
 WHERE tipopb = 1
 AND vwgpb.ativo = 'S'   -- Paulo
 ORDER BY nome ASC, sigla ASC 
;
-- MNobre: não entra ==>> 	 AND exc_data IS NULL


ALTER TABLE _cadbasicos.vwbeneficiario OWNER TO postgres;
GRANT ALL ON TABLE _cadbasicos.vwbeneficiario TO n2espindesenv;
GRANT ALL ON TABLE _cadbasicos.vwbeneficiario TO postgres;


-- -----------------------------------------------------------------------------------------
-- Table: _CADBASICOS.DBPROJETO
-- -----------------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS _cadbasicos.dbprojeto
(
    id					        SERIAL NOT NULL ,
    sigla 				        VARCHAR(20) NOT NULL,
    nome 				        VARCHAR(100) NOT NULL,
    instituicao 			    VARCHAR(100) ,
    descricao 				    TEXT,
    impactos_esperados 			TEXT,
    unid_med_rendimento 		SMALLINT,
    unid_med_adocao 			SMALLINT,
    representacao_valores 		SMALLINT,
    representacao_moeda 		SMALLINT NOT NULL DEFAULT 0,
    orc_valor_total			    NUMERIC(12,2) NOT NULL DEFAULT 0.00,
    probab_exito			    NUMERIC(4,1) DEFAULT 100.0 ,
    ano_inicio_pesqdesenv		SMALLINT,
    ano_termino_pesqdesenv		SMALLINT,
    ano_inicio_adocao			SMALLINT,
    ano_termino_adocao			SMALLINT,
	
    ativo 				        CHAR(1) DEFAULT 'S'::bpchar,
	
    inc_data 				    TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    inc_idusuario 			    INTEGER NOT NULL,
    alt_data 				    TIMESTAMP WITHOUT TIME ZONE,
    alt_idusuario 			    INTEGER,
    exc_data 				    TIMESTAMP WITHOUT TIME ZONE,
    exc_idusuario 			    INTEGER,
	
    CONSTRAINT pk_dbprojeto PRIMARY KEY (id),

    CONSTRAINT unq_sigla_nome UNIQUE (sigla, nome) INCLUDE(sigla, nome),
	
    CONSTRAINT fk_dbprojeto_user_inc FOREIGN KEY (inc_idusuario)
        REFERENCES _adm.system_users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
	
    CONSTRAINT fk_dbprojeto_user_alt FOREIGN KEY (alt_idusuario)
        REFERENCES _adm.system_users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
	
    CONSTRAINT fk_dbprojeto_user_exc FOREIGN KEY (exc_idusuario)
        REFERENCES _adm.system_users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
TABLESPACE pg_default;
COMMENT ON TABLE  _cadbasicos.dbprojeto            				    IS 'Registro do PROJETOS';
COMMENT ON COLUMN _cadbasicos.dbprojeto.id		     			    IS 'PK';
COMMENT ON COLUMN _cadbasicos.dbprojeto.sigla 					    IS 'Sigla da identificação do Projeto';
COMMENT ON COLUMN _cadbasicos.dbprojeto.nome 						IS 'Nome ou Título do Projeto';
COMMENT ON COLUMN _cadbasicos.dbprojeto.instituicao 				IS 'Instituição promotora ou proprietária da proposta do Projeto';
COMMENT ON COLUMN _cadbasicos.dbprojeto.descricao 					IS 'Descrição: Objetivos, metas ou interesse do Projeto';
COMMENT ON COLUMN _cadbasicos.dbprojeto.impactos_esperados 		    IS 'Impactos (benefícios) esperados ou a serem alcançados pelo Projeto';

COMMENT ON COLUMN _cadbasicos.dbprojeto.unid_med_rendimento	        IS 'FK para dbdominio - UMR Unidade de Medida do Rendimento. Exemplo: Toneladas por Hectare';
COMMENT ON COLUMN _cadbasicos.dbprojeto.unid_med_adocao 			IS 'FK para dbdominio - UMA Unidade de Medida da Adoção. Exemplo: Hectare';
COMMENT ON COLUMN _cadbasicos.dbprojeto.representacao_valores 	    IS 'FK para dbdominio - ERV Expressão de Representação de Valores. Exemplo: valores expressos em 1.000 ou 10.000';
COMMENT ON COLUMN _cadbasicos.dbprojeto.representacao_moeda 		IS 'FK para dbdominio - MOE Expressão de Representação da Moeda dos Valores. Exemplo: valores expressos em R$ Reais ou US$ Dolares';
COMMENT ON COLUMN _cadbasicos.dbprojeto.orc_valor_total 			IS 'Valor Total do Orçamento (da Prosposta) do Projeto';
COMMENT ON COLUMN _cadbasicos.dbprojeto.probab_exito 				IS 'Percentual de Probalbilidade de êxito / sucesso do Projeto';

COMMENT ON COLUMN _cadbasicos.dbprojeto.ano_inicio_pesqdesenv		IS 'Ano de Inicio da fase de P&D - Pesquisa e Desenvolvimento';
COMMENT ON COLUMN _cadbasicos.dbprojeto.ano_termino_pesqdesenv	    IS 'Ano de Término da fase de P&D - Pesquisa e Desenvolvimento';
COMMENT ON COLUMN _cadbasicos.dbprojeto.ano_inicio_adocao			IS 'Ano de Inicio da fase de Adoção / Implementação';
COMMENT ON COLUMN _cadbasicos.dbprojeto.ano_termino_adocao		    IS 'Ano de Término da fase de Adoção / Implementação';
COMMENT ON COLUMN _cadbasicos.dbprojeto.ativo			 			IS 'Flag de registro (S)Ativo ou (N)Inativo';

ALTER TABLE IF EXISTS _cadbasicos.dbprojeto OWNER to postgres;
GRANT ALL ON TABLE _cadbasicos.dbprojeto TO n2espindesenv;
GRANT ALL ON TABLE _cadbasicos.dbprojeto TO postgres;
GRANT ALL ON SEQUENCE _cadbasicos.dbprojeto_id_seq TO n2espindesenv; 


INSERT INTO _cadbasicos.dbprojeto (sigla,nome,instituicao,representacao_moeda, representacao_valores, orc_valor_total, inc_idusuario) 
VALUES ('Prj BTF', 'Projeto Batata Frita', 'Embrapa', 2, 3, 3.4, 1),
('MANDIOCA', 'Melhoramento Genetico', 'Inst. de Pesquisa Agropec da BA', 2, NULL, 480000.0, 1),
('MANDIOCA', 'RNA da Mandioca Vermelha', 'CEPERG/MG', 2, NULL, 800000, 1),
('MANDIOCA', 'Filamento Gomoso da Mandioca', 'AGROCERES CERRADO / GO', 2, NULL, 130000, 1),
('MANDIOCA', 'Uso Pulgão como Bio-Larvicida', 'COMARGEN / MT', 2, NULL, 290000, 1),
('MANDIOCA', 'Laminação da Bact Chromium', 'Embrapa', 2, NULL, 760000, 1);
;


-- -----------------------------------------------------------------------------------------
-- View: _CADBASICOS.VWPROJETO
-- -----------------------------------------------------------------------------------------

-- "_cadbasicos".vwprojeto fonte

CREATE OR REPLACE VIEW "_cadbasicos".vwprojeto
AS SELECT dbprj.id,
    dbprj.sigla,
    dbprj.nome,
    (TRIM(BOTH FROM dbprj.nome) || ' - '::text) || TRIM(BOTH FROM dbprj.sigla) AS nomesiglaprojeto,
    (TRIM(BOTH FROM dbprj.sigla) || ' - '::text) || TRIM(BOTH FROM dbprj.nome) AS siglanomeprojeto,
    dbprj.instituicao,
    dbprj.descricao,
    dbprj.impactos_esperados,
    dbprj.unid_med_rendimento AS indice_umr,
    dbdomumr.grupodominio AS grpdominio_umr,
    dbdomumr.descdominio AS descdominio_umr,
    dbdomumr.valordominio AS valordominio_umr,
    dbprj.unid_med_adocao AS indice_uma,
    dbdomuma.grupodominio AS grpdominio_uma,
    dbdomuma.descdominio AS descdominio_uma,
    dbdomuma.valordominio AS valordominio_uma,
    dbprj.representacao_valores AS indice_erv,
    dbdomerv.grupodominio AS grpdominio_erv,
    dbdomerv.descdominio AS descdominio_erv,
    dbdomerv.valordominio AS valordominio_erv,
    dbprj.representacao_moeda AS indice_moe,
    dbdommoe.grupodominio AS grpdominio_moe,
    dbdommoe.descdominio AS descdominio_moe,
    dbdommoe.valordominio AS valordominio_moe,
    dbdommoe.aux AS simbolo_moe,
    dbprj.orc_valor_total,
    dbdommoe.aux::text || to_char(dbprj.orc_valor_total, '9G999G990D99'::text) AS formatvalortotal,
    ((dbdommoe.aux::text || ' '::text) || dbprj.orc_valor_total::text) || COALESCE(dbdomerv.valordominio, ''::text) AS valortotalprojeto,
    dbprj.probab_exito::text || '%'::text AS percprobabexito,
    dbprj.ano_inicio_pesqdesenv,
    dbprj.ano_termino_pesqdesenv,
    dbprj.ano_inicio_adocao,
    dbprj.ano_termino_adocao,
    dbprj.ativo,
    dbprj.inc_data,
    dbprj.inc_idusuario,
    dbprj.alt_data,
    dbprj.alt_idusuario,
    dbprj.exc_data,
    dbprj.exc_idusuario,
    
    (( SELECT count(vpb.tipopb) AS count
           FROM _cadbasicos.vwprojetoparcbenef vpb
          WHERE vpb.idprojeto = dbprj.id
          and vpb.tipopb = 1))::text AS qtd_beneficiarios,
          
    (( SELECT count(vpb.tipopb) AS count
           FROM _cadbasicos.vwprojetoparcbenef vpb
          WHERE vpb.idprojeto = dbprj.id
          and vpb.tipopb = 2))::text AS qtd_parceiros
    
   FROM _cadbasicos.dbprojeto dbprj
     LEFT JOIN _global.dbcampodominio dbdommoe ON dbdommoe.grupodominio = 'moe'::bpchar AND dbdommoe.indicedominio = dbprj.representacao_moeda
     LEFT JOIN _global.dbcampodominio dbdomumr ON dbdomumr.grupodominio = 'umr'::bpchar AND dbdomumr.indicedominio = dbprj.unid_med_rendimento
     LEFT JOIN _global.dbcampodominio dbdomuma ON dbdomuma.grupodominio = 'uma'::bpchar AND dbdomuma.indicedominio = dbprj.unid_med_adocao
     LEFT JOIN _global.dbcampodominio dbdomerv ON dbdomerv.grupodominio = 'erv'::bpchar AND dbdomerv.indicedominio = dbprj.representacao_valores
  WHERE dbprj.exc_data IS NULL;  -- Paulo

ALTER TABLE IF EXISTS _cadbasicos.vwprojeto OWNER to postgres;
GRANT ALL ON TABLE _cadbasicos.vwprojeto TO n2espindesenv;
GRANT ALL ON TABLE _cadbasicos.vwprojeto TO postgres;



-- -----------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------
-- Table: _CADBASICOS.DBPROJETOPARCEIRO
-- -----------------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS _cadbasicos.dbprojetoparceiro
(
    id						SERIAL NOT NULL ,
	idprojeto				BIGINT NOT NULL,
	idparceiro				BIGINT NOT NULL,		
	
	CONSTRAINT pk_dbprojetoparceiro PRIMARY KEY (id),
	
    CONSTRAINT fk_dbprojetoparceiro_dbprojeto FOREIGN KEY (idprojeto)
        REFERENCES _cadbasicos.dbprojeto (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE,
	
    CONSTRAINT fk_dbprojetoparceiro_dbgrupoparcbenef FOREIGN KEY (idparceiro)
        REFERENCES _cadbasicos.dbgrupoparcbenef (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
TABLESPACE pg_default;
COMMENT ON TABLE  _cadbasicos.dbprojetoparceiro          				IS 'Registro da Associação de Parceiros ao PROJETO';
COMMENT ON COLUMN _cadbasicos.dbprojetoparceiro.id		     			IS 'PK da tabela';
COMMENT ON COLUMN _cadbasicos.dbprojetoparceiro.idprojeto				IS 'Fk para Projeto';
COMMENT ON COLUMN _cadbasicos.dbprojetoparceiro.idparceiro				IS 'Fk para tabela agrupadora: Parceiros';

ALTER TABLE IF EXISTS _cadbasicos.dbprojetoparceiro OWNER to postgres;
GRANT ALL ON TABLE _cadbasicos.dbprojetoparceiro TO n2espindesenv;
GRANT ALL ON TABLE _cadbasicos.dbprojetoparceiro TO postgres;
GRANT ALL ON SEQUENCE _cadbasicos.dbprojetoparceiro_id_seq TO n2espindesenv;


-- -----------------------------------------------------------------------------------------
-- View: _CADBASICOS.VWPROJETOPARCEIRO 
-- -----------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW _cadbasicos.vwprojetoparceiro
AS
	SELECT	dbprjparc.id,
			dbprjparc.idprojeto,
			vwprj.nomesiglaprojeto,
			vwprj.sigla 			AS siglaprojeto,
			vwprj.nome				AS nomeprojeto,
			vwparc.idparceiro,
			vwparc.tipopb,
			vwparc.nome				AS nomeparceiro,
			vwparc.nomesigla 		AS nomesiglaparceiro,
			vwparc.sigla			AS siglaparceiro
	FROM _cadbasicos.dbprojetoparceiro AS dbprjparc
	JOIN _cadbasicos.vwprojeto 		AS vwprj ON ( dbprjparc.idprojeto = vwprj.id )
	JOIN _cadbasicos.vwparceiro AS vwparc ON ( dbprjparc.idparceiro = vwparc.idparceiro  )
	ORDER BY vwparc.sigla ASC, vwparc.nome ASC 
;
-- MNobre: não entra ==>> 	WHERE vwprj.exc_data IS NULL	

ALTER TABLE _cadbasicos.vwprojetoparceiro OWNER TO postgres;
GRANT ALL ON TABLE _cadbasicos.vwprojetoparceiro TO n2espindesenv;
GRANT ALL ON TABLE _cadbasicos.vwprojetoparceiro TO postgres;

-- -----------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------
-- Table: _CADBASICOS.DBPROJETOBENEFICIARIO
-- -----------------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS _cadbasicos.dbprojetobeneficiario
(
    id						SERIAL NOT NULL ,
	idprojeto				BIGINT NOT NULL,
	idbeneficiario			BIGINT NOT NULL,		
	percparticipacao		NUMERIC(4,1) DEFAULT 100.0 ,
	
	CONSTRAINT pk_dbprojetobeneficiario PRIMARY KEY (id),
	
    CONSTRAINT fk_dbprojetobeneficiario_dbprojeto FOREIGN KEY (idprojeto)
        REFERENCES _cadbasicos.dbprojeto (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE,
	
    CONSTRAINT fk_dbprojetobeneficiario_dbgrupoparcbenef FOREIGN KEY (idbeneficiario)
        REFERENCES _cadbasicos.dbgrupoparcbenef (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
TABLESPACE pg_default;
COMMENT ON TABLE  _cadbasicos.dbprojetobeneficiario          				IS 'Registro da Associação de Beneficiarios ao PROJETO';
COMMENT ON COLUMN _cadbasicos.dbprojetobeneficiario.id		     			IS 'PK da tabela';
COMMENT ON COLUMN _cadbasicos.dbprojetobeneficiario.idprojeto				IS 'Fk para Projeto';
COMMENT ON COLUMN _cadbasicos.dbprojetobeneficiario.idbeneficiario			IS 'Fk para tabela agrupadora: Beneficiários';
COMMENT ON COLUMN _cadbasicos.dbprojetobeneficiario.percparticipacao			IS 'Percentual de participação do Beneficiário, no resultado do Projeto';

ALTER TABLE IF EXISTS _cadbasicos.dbprojetobeneficiario OWNER to postgres;
GRANT ALL ON TABLE _cadbasicos.dbprojetobeneficiario TO n2espindesenv;
GRANT ALL ON TABLE _cadbasicos.dbprojetobeneficiario TO postgres;
GRANT ALL ON SEQUENCE _cadbasicos.dbprojetobeneficiario_id_seq TO n2espindesenv;



-- -----------------------------------------------------------------------------------------
-- View: _CADBASICOS.VWPROJETOBENEFICIARIO
-- -----------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW _cadbasicos.vwprojetobeneficiario
AS
	SELECT	dbprjbenef.id,
			dbprjbenef.idprojeto,
			vwprj.nomesiglaprojeto			AS nomesiglaprojeto,
			vwprj.sigla 				    AS siglaprojeto,
			vwprj.nome				        AS nomeprojeto,
			vwbenef.idbeneficiario,
			vwbenef.tipopb,
			vwbenef.nome				AS nomebeneficiario,            
			vwbenef.nomesigla 			AS nomesiglabeneficiario,
            vwbenef.sigla				AS siglabeneficiario,
			dbprjbenef.percparticipacao
	FROM _cadbasicos.dbprojetobeneficiario	AS dbprjbenef
	JOIN _cadbasicos.vwprojeto AS vwprj ON ( dbprjbenef.idprojeto = vwprj.id )
	JOIN _cadbasicos.vwbeneficiario AS vwbenef ON ( dbprjbenef.idbeneficiario = vwbenef.idbeneficiario )
	ORDER BY vwbenef.sigla ASC, vwbenef.nome ASC
;
-- MNobre: não entra ==>> 	WHERE vwprj.exc_data IS NULL	


ALTER TABLE _cadbasicos.vwprojetobeneficiario OWNER TO postgres;
GRANT ALL ON TABLE _cadbasicos.vwprojetobeneficiario TO n2espindesenv;
GRANT ALL ON TABLE _cadbasicos.vwprojetobeneficiario TO postgres;


-- -----------------------------------------------------------------------------------------
-- View: _CADBASICOS.VWPROJETOPARCBENEF
-- -----------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW _cadbasicos.vwprojetoparcbenef
AS SELECT vwppb.id,
    vwppb.idprojeto,
    vwppb.tipopb,
    t1.valordominio AS desctipopb,
    vwppb.nome,
    vwppb.nomesigla,
    vwppb.sigla
    --    vwppb.ativo
   FROM ( SELECT dbprjbenef.id,
            dbprjbenef.idprojeto,
            vwbenef.tipopb,
            vwbenef.nome,
            vwbenef.nomesigla,
            vwbenef.sigla,
            vwbenef.ativo
           FROM _cadbasicos.dbprojetobeneficiario dbprjbenef
            JOIN _cadbasicos.vwbeneficiario vwbenef ON dbprjbenef.idbeneficiario = vwbenef.idbeneficiario
        UNION
         SELECT dbprjparc.id,
            dbprjparc.idprojeto,
            vwparc.tipopb,
            vwparc.nome,
            vwparc.nomesigla,
            vwparc.sigla,
            vwparc.ativo
           FROM _cadbasicos.dbprojetoparceiro dbprjparc
            JOIN _cadbasicos.vwparceiro vwparc ON dbprjparc.idparceiro = vwparc.idparceiro
        ) vwppb
   LEFT JOIN _global.dbcampodominio t1 ON t1.grupodominio = 'tpb'::bpchar AND t1.indicedominio = vwppb.tipopb
 ORDER BY vwppb.nome, vwppb.sigla;

ALTER TABLE _cadbasicos.vwprojetoparcbenef OWNER TO postgres;
GRANT ALL ON TABLE _cadbasicos.vwprojetoparcbenef TO n2espindesenv;
GRANT ALL ON TABLE _cadbasicos.vwprojetoparcbenef TO postgres;


-- -----------------------------------------------------------------------------------------
-- Table: _CADBASICOS.DBRODADA
-- -----------------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS _cadbasicos.dbrodada
(
    id 				    SERIAL NOT NULL ,
    nome 			    character varying(80) NOT NULL,
    sigla 			    character varying(20) NOT NULL,
    dataprevistainicio  TIMESTAMP WITHOUT TIME ZONE,
    dataprevistafim     TIMESTAMP WITHOUT TIME ZONE,
    idgestoroperacao    INTEGER,
    dataultimaconfig    TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    flgemoperacao       character(1) DEFAULT 'N'::bpchar,
    indsituacao         SMALLINT DEFAULT 1,
    corgestao		    text,  
    ativo 			    character(1) DEFAULT 'S'::bpchar,        
    inc_data 			TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    inc_idusuario 		integer,
    alt_data 			TIMESTAMP WITHOUT TIME ZONE,
    alt_idusuario 		integer,
    exc_data 			TIMESTAMP WITHOUT TIME ZONE,
    exc_idusuario 		integer,
    CONSTRAINT pk_dbrodada PRIMARY KEY (id),
	
    CONSTRAINT fk_dbrodada_user_inc FOREIGN KEY (inc_idusuario)
        REFERENCES _adm.system_users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
	
    CONSTRAINT fk_dbrodada_user_alt FOREIGN KEY (alt_idusuario)
        REFERENCES _adm.system_users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
	
    CONSTRAINT fk_dbrodada_user_exc FOREIGN KEY (exc_idusuario)
        REFERENCES _adm.system_users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
TABLESPACE pg_default;
COMMENT ON TABLE  _cadbasicos.dbrodada                      IS 'Registro do OBJETO DE PRIORIZAÇÃO - RODADA';
COMMENT ON COLUMN _cadbasicos.dbrodada.id		     	    IS 'PK da tabela';
COMMENT ON COLUMN _cadbasicos.dbrodada.sigla 			    IS 'Sigla da identificação da Rodada';
COMMENT ON COLUMN _cadbasicos.dbrodada.nome 			    IS 'Nome ou Título da Rodada';
COMMENT ON COLUMN _cadbasicos.dbrodada.dataprevistainicio 	IS 'Data Prevista de Inicio da Rodada';
COMMENT ON COLUMN _cadbasicos.dbrodada.dataprevistafim		IS 'Data Prevista de Termino da Rodada';
COMMENT ON COLUMN _cadbasicos.dbrodada.idgestoroperacao 	IS 'Usuario / Operador responsável pela Rodada';
COMMENT ON COLUMN _cadbasicos.dbrodada.dataultimaconfig		IS 'Data da Ultima atualização na Configuração da Rodada';
COMMENT ON COLUMN _cadbasicos.dbrodada.flgemoperacao		IS 'Flag que indica que esta Rodada é a corrente em Operação pelo Usuario / Operador';
COMMENT ON COLUMN _cadbasicos.dbrodada.indsituacao 		    IS 'Fake FK para tabela _GLOBAL.DBGRUPODOMINIO no grupo STRD e indice INDSITUACAO';

ALTER TABLE IF EXISTS _cadbasicos.dbrodada OWNER to postgres;
GRANT ALL ON TABLE _cadbasicos.dbrodada TO n2espindesenv;
GRANT ALL ON TABLE _cadbasicos.dbrodada TO postgres;
GRANT ALL ON SEQUENCE _cadbasicos.dbrodada_id_seq TO n2espindesenv; 

-- -----------------------------------------------------------------------------------------
-- View: _CADBASICOS.VWRODADA
-- -----------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW _cadbasicos.vwrodada
 AS
 SELECT dbrdd.id,
        dbrdd.nome,
        dbrdd.sigla,
        (TRIM(BOTH FROM dbrdd.nome) || ' - '::text) || TRIM(BOTH FROM dbrdd.sigla) AS nomesiglarodada,
        dbrdd.dataprevistainicio,
        dbrdd.dataprevistafim,
        to_char(dbrdd.dataprevistainicio,'DD/MM/YYYY') AS formatdataprevistainicio,
        to_char(dbrdd.dataprevistafim,'DD/MM/YYYY') AS formatdataprevistafim,
        dbrdd.idgestoroperacao,
        dbrdd.dataultimaconfig,
        dbrdd.flgemoperacao,
        dbrdd.indsituacao           AS indicesituacao,
        dbdomstrdd.grupodominio     AS grpsituacao,
        dbdomstrdd.descdominio      AS descsituacao,
        dbdomstrdd.valordominio     AS valorsituacao,
        dbdomstrdd.aux              AS simbolosituacao,    
        dbrdd.corgestao,		    
        dbrdd.ativo,
        dbrdd.inc_data,
        dbrdd.inc_idusuario,
        dbrdd.alt_data,
        dbrdd.alt_idusuario,
        dbrdd.exc_data,
        dbrdd.exc_idusuario
   FROM _cadbasicos.dbrodada dbrdd
   LEFT JOIN _global.dbcampodominio dbdomstrdd ON dbdomstrdd.grupodominio = 'strd'::bpchar AND dbdomstrdd.indicedominio = dbrdd.indsituacao
   WHERE dbrdd.exc_data is NULL;  -- Paulo

-- MNobre: não entra ==>> 	WHERE dbrdd.ativo = 'S'
-- MNobre: não entra ==>> 	  AND dbrdd.exc_data IS NULL


ALTER TABLE _cadbasicos.vwrodada  OWNER TO postgres;
GRANT ALL ON TABLE _cadbasicos.vwrodada TO n2espindesenv;
GRANT ALL ON TABLE _cadbasicos.vwrodada TO postgres;


INSERT INTO _cadbasicos.dbrodada( nome, sigla, dataprevistainicio, dataprevistafim, inc_idusuario) VALUES 
( 'Priorização de Projetos do Vale do Sorocaba', 'SOROCABA-2024', '2024-10-30 15:03:59.753', '2025-03-30 15:03:59.753', 1 ),
( 'Projetos de Melhoramento Genético da Mandioca', 'MANDIOCA-2024', '2024-12-10 15:03:59.753', '2025-02-15 15:03:59.753', 1 );


-- -----------------------------------------------------------------------------------------
-- View: _CADBASICOS.VWJUIZ
-- -----------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW _cadbasicos.vwjuiz
 AS
 SELECT 
    vwpc.id                                     ,
    vwpc.nomefantasia                           ,
    vwpc.nome                                   ,
    vwpc.emailpessoal                           ,
    vwpc.cargo                                  AS especialista,
    vwpc.genero                                 ,
    vwpc.dscgenero                              ,
    vwpc.numcelular                             ,
    vwpc.numcelularformat                       ,
    vwpc.ativo                                  ,
    vwpc.dsctipocolaborador                     ,
    vwpc.id                                     AS idcolaborador,
    vwpc.id                                     AS idjuiz,
    vwpc.idpessoa                               ,
    vwpc.idusuario
FROM _adm.vwpessoacolaborador AS vwpc
WHERE vwpc.tipocolaborador = 4
AND   vwpc.ativo = 'S'
;

ALTER TABLE _cadbasicos.vwjuiz  OWNER TO postgres;
GRANT ALL ON TABLE _cadbasicos.vwjuiz TO n2espindesenv;
GRANT ALL ON TABLE _cadbasicos.vwjuiz TO postgres;

