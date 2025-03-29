
-- -----------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------
-- SCHEMA: _rodadaconfig - QUAQUER METODOLOGIA
-- -----------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------

SET search_path TO _rodadaconfig, public;

DROP VIEW IF EXISTS _referencia.vwmetodologia;
DROP TRIGGER IF EXISTS after_insert_rodadametodologia_trigger ON _rodadaconfig.dbrodadametodologias RESTRICT;
DROP FUNCTION IF EXISTS _rodadaconfig.fn_insereRodadaCriterios();
DROP VIEW IF EXISTS _rodadaconfig.vwrodadametodologias;
DROP VIEW IF EXISTS _rodadaconfig.vwrodadacriterios;
DROP FUNCTION IF EXISTS _rodadaconfig.fn_setRodadaCriterios(idRodada INTEGER, idMetodologia INTEGER);
DROP TABLE IF EXISTS _rodadaconfig.dbrodadacriterios; 
DROP TABLE IF EXISTS _rodadaconfig.dbrodadametodologias;


-- -----------------------------------------------------------------------------------------
-- Table: _rodadaconfig.DBRODADAMETODOLOGIAS
-- -----------------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS _rodadaconfig.dbrodadametodologias
(
    id 				    SERIAL NOT NULL ,
    idrodada            INTEGER NOT NULL,
    idmetodologia       INTEGER NOT NULL,
    CONSTRAINT pk_dbrodadametodologias PRIMARY KEY (id),

    CONSTRAINT unq_metodologiadarodada UNIQUE (idrodada, idmetodologia) INCLUDE(idrodada, idmetodologia),

    CONSTRAINT fk_dbrodadametodologias_dbrodada FOREIGN KEY (idrodada)
        REFERENCES _cadbasicos.dbrodada (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,

    CONSTRAINT fk_dbrodadametodologias_dbmetodologia FOREIGN KEY (idmetodologia)
        REFERENCES _referencia.dbmetodologia (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
TABLESPACE pg_default;
ALTER TABLE IF EXISTS _rodadaconfig.dbrodadametodologias OWNER to postgres;
GRANT ALL ON TABLE _rodadaconfig.dbrodadametodologias TO n2espindesenv;
GRANT ALL ON TABLE _rodadaconfig.dbrodadametodologias TO postgres;
GRANT ALL ON SEQUENCE _rodadaconfig.dbrodadametodologias_id_seq TO n2espindesenv; 

--------------------------------------------------------------------------------------------
-- View: _referencia.VWMETODOLOGIA
--------------------------------------------------------------------------------------------

CREATE OR REPLACE VIEW _referencia.vwmetodologia
AS SELECT id,
    nome,
    sigla,
    (sigla::text || ' - '::text) || nome::text AS siglanomemetodologia,
    ativo
   FROM _referencia.dbmetodologia dm
  WHERE ativo = 'S'::bpchar;

COMMENT ON VIEW  _referencia.vwmetodologia  IS 'View que descreve a tabela de Metodologias';
ALTER TABLE IF EXISTS _referencia.vwmetodologia OWNER to postgres;
GRANT ALL ON TABLE _referencia.vwmetodologia TO n2espindesenv;
GRANT ALL ON TABLE _referencia.vwmetodologia TO postgres;

--------------------------------------------------------------------------------------------
-- View: _referencia.VWMETODOLOGIASELECAO
--------------------------------------------------------------------------------------------

CREATE OR REPLACE VIEW "_referencia".vwmetodologiaselecao
AS SELECT id,
    nome,
    sigla,
    siglanomemetodologia,
    ativo
   FROM ( SELECT dm.id,
            dm.nome,
            dm.sigla,
            (dm.sigla::text || ' - '::text) || dm.nome::text AS siglanomemetodologia,
            dm.ativo
           FROM _referencia.dbmetodologia dm
        UNION
         SELECT '-1'::integer AS id,
            rpad('Ver todas as Metodologias'::text, 100, ''::text) AS nome,
            ''::character varying AS sigla,
            ''::text AS siglanomemetodologia,
            'S'::bpchar AS ativo) unnamed_subquery
  WHERE ativo = 'S'::bpchar;

COMMENT ON VIEW  _referencia.vwmetodologia  IS 'View que descreve a tabela de Metodologias para uso em combos de seleção';
ALTER TABLE IF EXISTS _referencia.vwmetodologiaselecao OWNER to postgres;
GRANT ALL ON TABLE _referencia.vwmetodologiaselecao TO n2espindesenv;
GRANT ALL ON TABLE _referencia.vwmetodologiaselecao TO postgres;

-- -----------------------------------------------------------------------------------------
-- View: _rodadaconfig.VWRODADAMETODOLOGIAS
-- -----------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW _rodadaconfig.vwrodadametodologias
AS SELECT   dbrm.id                 ,
            /* Rodada */
            dbrm.idrodada           ,
            vr.nome                 as nomerodada,
            vr.sigla                as siglarodada,
            vr.nomesiglarodada      ,
            /* Metodologia */
            dbrm.idmetodologia      ,
            dbm.nome                , 
            dbm.sigla               ,
            dbm.ativo
   FROM _rodadaconfig.dbrodadametodologias dbrm
   JOIN _cadbasicos.vwrodada vr on dbrm.idrodada = vr.id
   JOIN _referencia.vwmetodologia dbm on dbrm.idmetodologia = dbm.id
   ORDER BY dbm.nome
;
COMMENT ON VIEW  _rodadaconfig.vwrodadametodologias  IS 'View que descreve a tabela de relacionamento da Rodada x Metodologias do Escores';
ALTER TABLE IF EXISTS _rodadaconfig.vwrodadametodologias OWNER to postgres;
GRANT ALL ON TABLE _rodadaconfig.vwrodadametodologias TO n2espindesenv;
GRANT ALL ON TABLE _rodadaconfig.vwrodadametodologias TO postgres;


-- -----------------------------------------------------------------------------------------
-- Table: _rodadaconfig.DBRODADACRITERIOS
-- -----------------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS _rodadaconfig.dbrodadacriterios 
(
    id 				        SERIAL NOT NULL ,
    idrodada                INTEGER NOT NULL,
    idmetodologia           INTEGER NOT NULL,
    idreferencia            INTEGER NOT NULL,
    CONSTRAINT pk_dbrodadacriterios PRIMARY KEY (id),

    CONSTRAINT unq_criteriosdarodada UNIQUE (idrodada, idmetodologia, idreferencia) INCLUDE(idrodada, idmetodologia, idreferencia),

    CONSTRAINT fk_dbrodadacriterios_dbrodadametodologia FOREIGN KEY (idrodada, idmetodologia)
        REFERENCES _rodadaconfig.dbrodadametodologias (idrodada, idmetodologia) MATCH FULL
        ON UPDATE NO ACTION
        ON DELETE CASCADE,

    CONSTRAINT fk_dbrodadacriterios_dbrodada FOREIGN KEY (idrodada)
        REFERENCES _cadbasicos.dbrodada (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE,

    CONSTRAINT fk_dbrodadacriterios_dbmetodologia FOREIGN KEY (idmetodologia)
        REFERENCES _referencia.dbmetodologia (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE,

    CONSTRAINT fk_dbrodadacriterios_dbreferencia FOREIGN KEY (idreferencia)
        REFERENCES _referencia.dbreferencia (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
)
TABLESPACE pg_default;
ALTER TABLE IF EXISTS _rodadaconfig.dbrodadacriterios OWNER to postgres;
GRANT ALL ON TABLE _rodadaconfig.dbrodadacriterios TO n2espindesenv;
GRANT ALL ON TABLE _rodadaconfig.dbrodadacriterios TO postgres;
GRANT ALL ON SEQUENCE _rodadaconfig.dbrodadacriterios_id_seq TO n2espindesenv; 


-- -----------------------------------------------------------------------------------------
-- Function-Trigger : _rodadaconfig.FN_INSERERODADACRITERIOS
-- -----------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION _rodadaconfig.fn_insereRodadaCriterios()
   RETURNS TRIGGER
   LANGUAGE PLPGSQL
AS
$$
DECLARE vidRodada INTEGER;
DECLARE vidMetodologia INTEGER;
BEGIN
    vidRodada = NEW.idrodada;
    vidMetodologia = NEW.idmetodologia;
    -- trigger logic
    INSERT INTO _rodadaconfig.dbrodadacriterios (idrodada, idmetodologia, idreferencia)
        SELECT  vidRodada       AS idrodada,
                vidMetodologia  AS idmetodologia, 
                dbref.id        AS idreferencia 
        FROM _referencia.dbreferencia dbref 
        WHERE dbref.idmetodologia = vidMetodologia 
        ORDER BY dbref.sigla;    
    -- Retorna a Nova Linha da tabela do Trigger
    RETURN NEW;
END;
$$;


-- -----------------------------------------------------------------------------------------
-- Trigger: _rodadaconfig.AFTER_INSERT_RODADAMETODOLOGIA_TRIGGER
-- -----------------------------------------------------------------------------------------
CREATE TRIGGER after_insert_rodadametodologia_trigger
AFTER INSERT ON _rodadaconfig.dbrodadametodologias
FOR EACH ROW
EXECUTE FUNCTION _rodadaconfig.fn_insereRodadaCriterios();


-- -----------------------------------------------------------------------------------------
-- Function: _rodadaconfig.FN_SETRODADACRITERIOS
-- -----------------------------------------------------------------------------------------
CREATE FUNCTION _rodadaconfig.fn_setRodadaCriterios(idRodada INTEGER, idMetodologia INTEGER) RETURNS VOID AS 
$$
DECLARE vMetodoNaRodada INTEGER;
BEGIN
    SELECT dbrm.id 
        INTO    vMetodoNaRodada
        FROM    _rodadaconfig.dbrodadametodologias dbrm
        WHERE   dbrm.idrodada = $1
        AND     dbrm.idmetodologia = $2;

    IF NOT FOUND
    THEN
        RAISE NOTICE 'NÃO ACHOU RODADAMETODOLOGIA';
    ELSE
        DELETE FROM _rodadaconfig.dbrodadacriterios dbrc WHERE (dbrc.idrodada = $1) AND (dbrc.idmetodologia = $2);

        INSERT INTO _rodadaconfig.dbrodadacriterios (idrodada, idmetodologia, idreferencia)
            SELECT  $1       AS idrodada,
                    $2       AS idmetodologia, 
                    dbref.id AS idreferencia 
            FROM _referencia.dbreferencia dbref 
            WHERE dbref.idmetodologia = $2 
            ORDER BY dbref.sigla;    
    END IF;
END;
$$ LANGUAGE PLPGSQL
   SET search_path = _rodadaconfig, pg_temp;

ALTER FUNCTION _rodadaconfig.fn_setRodadaCriterios OWNER to postgres;
GRANT ALL ON FUNCTION _rodadaconfig.fn_setRodadaCriterios TO n2espindesenv;
GRANT ALL ON FUNCTION _rodadaconfig.fn_setRodadaCriterios TO postgres;

/* Exemplo de Uso
SELECT _rodadaconfig.fn_setRodadaCriterios(1,2);
*/



-- -----------------------------------------------------------------------------------------
-- View: _rodadaconfig.VWRODADACRITERIOS
-- -----------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW _rodadaconfig.vwrodadacriterios
AS SELECT   dbrc.id                 ,
            /* Rodada */
            dbrc.idrodada           ,
            vrod.nome               as nomerodada,
            vrod.nomesiglarodada    ,
            /* Metodologia */
            dbrc.idmetodologia      ,
            dbrm.nome               as nomemetodologia,
            dbrm.sigla              as siglametodologia,
            /* Referencia */
            vcref.id                as idreferencia,
            vcref.ch                , 
            vcref.hierarquia        , 
            vcref.valorimportancia  , 
            vcref.iddimaspecto      , 
            vcref.idcriterio        , 
            vcref.idindicador       , 
            vcref.nivel
   FROM _rodadaconfig.dbrodadacriterios dbrc
   JOIN _referencia.dbmetodologia dbrm          ON dbrc.idmetodologia = dbrm.id
   JOIN _cadbasicos.vwrodada vrod               on dbrc.idrodada = vrod.id  
   JOIN _referencia.vw_hierarq_referencia vcref on dbrc.idreferencia = vcref.id 
   ORDER BY vcref.ch
;
COMMENT ON VIEW  _rodadaconfig.vwrodadacriterios  IS 'View que descreve a tabela de relacionamento da Rodada x Criterio-de-Ref Configurado';
ALTER TABLE IF EXISTS _rodadaconfig.vwrodadacriterios OWNER to postgres;
GRANT ALL ON TABLE _rodadaconfig.vwrodadacriterios TO n2espindesenv;
GRANT ALL ON TABLE _rodadaconfig.vwrodadacriterios TO postgres;


