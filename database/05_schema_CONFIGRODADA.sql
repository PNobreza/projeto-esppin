-- -----------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------
-- SCHEMA: _RODADACONFIG
-- -----------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------
DROP SCHEMA IF EXISTS _configrodada CASCADE;
DROP SCHEMA IF EXISTS _rodadaconfig CASCADE;
CREATE SCHEMA IF NOT EXISTS _rodadaconfig AUTHORIZATION postgres;
COMMENT ON SCHEMA _rodadaconfig	IS 'Dados de Configuração de Rodada - Objetos relacionados à Rodada: Juizes, Projetos, Critérios.';
GRANT USAGE ON SCHEMA _rodadaconfig TO n2espindesenv;
GRANT ALL ON SCHEMA _rodadaconfig TO postgres;


SET search_path TO _rodadaconfig, public;

DROP VIEW   IF EXISTS _rodadaconfig.vwrodadaprojetos;
DROP VIEW   IF EXISTS _rodadaconfig.vwrodadajuizes;
DROP VIEW   IF EXISTS _rodadaconfig.vwrodadaconfig;
DROP TABLE  IF EXISTS _rodadaconfig.dbrodadajuizes;
DROP TABLE  IF EXISTS _rodadaconfig.dbrodadaprojetos;
DROP TABLE  IF EXISTS _rodadaconfig.dbrodadacriterios_socamb;



-- -----------------------------------------------------------------------------------------
-- Table: _rodadaconfig.DBRODADAJUIZES
-- -----------------------------------------------------------------------------------------
CREATE TABLE "_rodadaconfig".dbrodadajuizes (
	id serial4 NOT NULL,
	idrodada int8 NOT NULL,
	idjuiz int8 NOT NULL,
	flgconfirmado bpchar(1) DEFAULT 'N'::bpchar NULL,
	sitprocessamento int4 DEFAULT 1 NOT NULL,
	flgformsenviados bpchar(1) DEFAULT 'N'::bpchar NULL,
	CONSTRAINT pk_dbrodadajuizes PRIMARY KEY (id),	
  CONSTRAINT unq_juiznarodada UNIQUE (idrodada, idjuiz) INCLUDE(idrodada, idjuiz),
  CONSTRAINT fk_dbrodadajuizes_colabjuiz FOREIGN KEY (idjuiz)
        REFERENCES _adm.dbcolaborador(id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;
ALTER TABLE IF EXISTS _rodadaconfig.dbrodadajuizes OWNER to postgres;
GRANT ALL ON TABLE _rodadaconfig.dbrodadajuizes TO n2espindesenv;
GRANT ALL ON TABLE _rodadaconfig.dbrodadajuizes TO postgres;
GRANT ALL ON SEQUENCE _rodadaconfig.dbrodadajuizes_id_seq TO n2espindesenv; 

-- -----------------------------------------------------------------------------------------
-- View: _rodadaconfig.VWRODADAJUIZES
-- -----------------------------------------------------------------------------------------

CREATE OR REPLACE VIEW _rodadaconfig.vwrodadajuizes
AS SELECT dbrj.id,
    dbrj.idrodada,
    vr.nome AS nomerodada,
    vr.nomesiglarodada,
    dbrj.idjuiz,
    vj.nome AS nomejuiz,
    vj.nomefantasia,
    (vj.nome::text || ' - '::text) || vj.nomefantasia::text AS nomeapelidojuiz,
    vj.emailpessoal,
    vj.numcelular,
    vj.numcelularformat,
    dbrj.flgconfirmado,
    dbrj.sitprocessamento,
    dbrj.flgformsenviados
   FROM _rodadaconfig.dbrodadajuizes dbrj
     JOIN _cadbasicos.vwrodada vr ON vr.id = dbrj.idrodada
     JOIN _cadbasicos.vwjuiz vj ON vj.id = dbrj.idjuiz
  ORDER BY vj.nome;

ALTER TABLE _rodadaconfig.vwrodadajuizes  OWNER TO postgres;
GRANT ALL ON TABLE _rodadaconfig.vwrodadajuizes TO n2espindesenv;
GRANT ALL ON TABLE _rodadaconfig.vwrodadajuizes TO postgres;


-- -----------------------------------------------------------------------------------------
-- Table: _rodadaconfig.DBRODADAPROJETOS
-- -----------------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS _rodadaconfig.dbrodadaprojetos
(
    id 				    SERIAL NOT NULL ,
    idrodada            BIGINT NOT NULL,
    idprojeto           BIGINT NOT NULL,
    CONSTRAINT pk_dbrodadaprojetos PRIMARY KEY (id),

    CONSTRAINT unq_projetonarodada UNIQUE (idrodada, idprojeto) INCLUDE(idrodada, idprojeto),

    CONSTRAINT fk_dbrodadaprojetos_dbprojeto FOREIGN KEY (idprojeto)
        REFERENCES _cadbasicos.dbprojeto (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
TABLESPACE pg_default;
ALTER TABLE IF EXISTS _rodadaconfig.dbrodadaprojetos OWNER to postgres;
GRANT ALL ON TABLE _rodadaconfig.dbrodadaprojetos TO n2espindesenv;
GRANT ALL ON TABLE _rodadaconfig.dbrodadaprojetos TO postgres;
GRANT ALL ON SEQUENCE _rodadaconfig.dbrodadaprojetos_id_seq TO n2espindesenv; 

-- -----------------------------------------------------------------------------------------
-- View: _rodadaconfig.VWRODADAPROJETOS
-- -----------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW _rodadaconfig.vwrodadaprojetos
AS SELECT dbrp.id,
    dbrp.idrodada,
    vr.nome as nomerodada,
    vr.nomesiglarodada,
    dbrp.idprojeto,
    vp.nome as nomeprojeto,
    vp.nomesiglaprojeto    
   FROM _rodadaconfig.dbrodadaprojetos dbrp
   join _cadbasicos.vwrodada vr on vr.id = dbrp.idrodada
   join _cadbasicos.vwprojeto vp on vp.id = dbrp.idprojeto  
  ORDER BY nomesiglaprojeto
;

ALTER TABLE _rodadaconfig.vwrodadaprojetos  OWNER TO postgres;
GRANT ALL ON TABLE _rodadaconfig.vwrodadaprojetos TO n2espindesenv;
GRANT ALL ON TABLE _rodadaconfig.vwrodadaprojetos TO postgres;


-- -----------------------------------------------------------------------------------------
-- View: _rodadaconfig.VWRODADACONFIG
-- -----------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW "_rodadaconfig".vwrodadaconfig
AS SELECT vwrdd.id,
    vwrdd.nome,
    vwrdd.sigla,
    vwrdd.nomesiglarodada,
    (vwrdd.sigla::text || ' - '::text) || vwrdd.nome::text AS siglanomerodada,
    vwrdd.dataprevistainicio,
    vwrdd.dataprevistafim,
    vwrdd.formatdataprevistainicio,
    vwrdd.formatdataprevistafim,
    (vwrdd.formatdataprevistainicio || ' -> '::text) || vwrdd.formatdataprevistafim AS periodovalidade,
    vwrdd.indicesituacao,
    vwrdd.grpsituacao,
    vwrdd.valorsituacao,
    vwrdd.idgestoroperacao,
    vwpc.nome AS nomegestor,
    vwpc.nomefantasia,
    to_char(vwrdd.dataultimaconfig, 'DD/MM/YYYY HH24:MI:SS'::text) AS dataultimaconfig,
    vwrdd.flgemoperacao,
    vwrdd.ativo,
    vwrdd.corgestao,
    (( SELECT count(vrp.idprojeto) AS count
           FROM _rodadaconfig.vwrodadaprojetos vrp
          WHERE vrp.idrodada = vwrdd.id))::text AS posicao_projetos,
    (((( SELECT count(vrj.idjuiz) AS count
           FROM _rodadaconfig.vwrodadajuizes vrj
          WHERE vrj.idrodada = vwrdd.id))::text) || '/'::text) || ((( SELECT count(vrj.idjuiz) AS count
           FROM _rodadaconfig.vwrodadajuizes vrj
          WHERE vrj.idrodada = vwrdd.id AND vrj.flgconfirmado = 'S'::bpchar))::text) AS posicao_juizes,
    round((( SELECT count(vrj.idjuiz) AS qtd
           FROM _rodadaconfig.vwrodadajuizes vrj
          WHERE vrj.idrodada = vwrdd.id AND vrj.flgconfirmado = 'S'::bpchar))::numeric /
        CASE
            WHEN (( SELECT count(vrj.idjuiz) AS count
               FROM _rodadaconfig.vwrodadajuizes vrj
              WHERE vrj.idrodada = vwrdd.id)) = 0 THEN 1::bigint
            ELSE ( SELECT count(vrj.idjuiz) AS count
               FROM _rodadaconfig.vwrodadajuizes vrj
              WHERE vrj.idrodada = vwrdd.id)
        END::numeric * 100::numeric, 2) AS percconfigjuizes,
    ( SELECT count(vrsa.idcriterio) AS count
           FROM _rodadaconfig.vwrodadacriterios_socamb vrsa
          WHERE vrsa.idrodada = vwrdd.id) AS posicao_crsa
   FROM _cadbasicos.vwrodada vwrdd
     LEFT JOIN _adm.vwpessoacolaborador vwpc ON vwpc.idusuario = vwrdd.idgestoroperacao
  WHERE vwrdd.ativo = 'S'::bpchar;

-- MNobre : não tem    WHERE vwrdd.exc_data IS NULL
ALTER TABLE _rodadaconfig.vwrodadaconfig  OWNER TO postgres;
GRANT ALL ON TABLE _rodadaconfig.vwrodadaconfig TO n2espindesenv;
GRANT ALL ON TABLE _rodadaconfig.vwrodadaconfig TO postgres;



-- -----------------------------------------------------------------------------------------
-- Table: _rodadaconfig.DBRODADACRITERIOS_SOCAMB
-- -----------------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS _rodadaconfig.dbrodadacriterios_socamb
(
    id 				    SERIAL NOT NULL ,
    idrodada            BIGINT NOT NULL,
    idcriterio          BIGINT NOT NULL,
    CONSTRAINT pk_dbrodadacriterios_socamb PRIMARY KEY (id),
    CONSTRAINT unq_criterionarodada_socamb UNIQUE (idrodada, idcriterio) INCLUDE(idrodada, idcriterio),
    CONSTRAINT fk_dbrodadacriterios_socamb_dbcriterioref FOREIGN KEY (idcriterio)
        REFERENCES _referencia.dbcriterioref_socamb (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
TABLESPACE pg_default;
ALTER TABLE IF EXISTS _rodadaconfig.dbrodadacriterios_socamb OWNER to postgres;
GRANT ALL ON TABLE _rodadaconfig.dbrodadacriterios_socamb TO n2espindesenv;
GRANT ALL ON TABLE _rodadaconfig.dbrodadacriterios_socamb TO postgres;
GRANT ALL ON SEQUENCE _rodadaconfig.dbrodadacriterios_socamb_id_seq TO n2espindesenv; 



-- -----------------------------------------------------------------------------------------
-- Table: _rodadaconfig.VWPROJETOATIVO
-- -----------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW _rodadaconfig.vwprojetosativos
AS SELECT id,
    sigla,
    nome,
    nomesiglaprojeto,
    siglanomeprojeto,
    instituicao,
    descricao,
    impactos_esperados,
    indice_umr,
    grpdominio_umr,
    descdominio_umr,
    valordominio_umr,
    indice_uma,
    grpdominio_uma,
    descdominio_uma,
    valordominio_uma,
    indice_erv,
    grpdominio_erv,
    descdominio_erv,
    valordominio_erv,
    indice_moe,
    grpdominio_moe,
    descdominio_moe,
    valordominio_moe,
    simbolo_moe,
    orc_valor_total,
    formatvalortotal,
    valortotalprojeto,
    percprobabexito,
    ano_inicio_pesqdesenv,
    ano_termino_pesqdesenv,
    ano_inicio_adocao,
    ano_termino_adocao,
    ativo,
    inc_data,
    inc_idusuario,
    alt_data,
    alt_idusuario,
    exc_data,
    exc_idusuario
   FROM _cadbasicos.vwprojeto vp
  WHERE ativo = 'S'::bpchar;

ALTER TABLE _rodadaconfig.vwprojetoativo  OWNER TO postgres;
GRANT ALL ON TABLE _rodadaconfig.vwprojetoativo TO n2espindesenv;
GRANT ALL ON TABLE _rodadaconfig.vwprojetoativo TO postgres;

