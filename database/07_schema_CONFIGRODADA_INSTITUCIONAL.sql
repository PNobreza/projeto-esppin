-- -----------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------
-- SCHEMA: _RODADACONFIG
-- -----------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------


SET search_path TO _rodadaconfig, public;

DROP VIEW   IF EXISTS _rodadaconfig.vwrodadacriterios_instit;
DROP VIEW   IF EXISTS _rodadaconfig.vwrodadacriterios_inst_selecao;
DROP TABLE  IF EXISTS _rodadaconfig.dbrodadacriterios_instit;




-- -----------------------------------------------------------------------------------------
-- Table: _rodadaconfig.DBRODADACRITERIOS_instit
-- -----------------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS _rodadaconfig.dbrodadacriterios_instit
(
    id 				    SERIAL NOT NULL ,
    idrodada            BIGINT NOT NULL,
    idcriterio          BIGINT NOT NULL,
    CONSTRAINT pk_dbrodadacriterios_instit PRIMARY KEY (id),
    CONSTRAINT unq_criterionarodada_instit UNIQUE (idrodada, idcriterio) INCLUDE(idrodada, idcriterio),
    CONSTRAINT fk_dbrodadacriterios_instit_dbcriterioref FOREIGN KEY (idcriterio)
        REFERENCES _referencia.dbcriterioref_instit (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
TABLESPACE pg_default;
ALTER TABLE IF EXISTS _rodadaconfig.dbrodadacriterios_instit OWNER to postgres;
GRANT ALL ON TABLE _rodadaconfig.dbrodadacriterios_instit TO n2espindesenv;
GRANT ALL ON TABLE _rodadaconfig.dbrodadacriterios_instit TO postgres;
GRANT ALL ON SEQUENCE _rodadaconfig.dbrodadacriterios_instit_id_seq TO n2espindesenv; 



-- -----------------------------------------------------------------------------------------
-- View: _rodadaconfig.VWRODADACRITERIOS_instit
-- -----------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW _rodadaconfig.vwrodadacriterios_instit
AS SELECT   dbrcin.id               ,
            dbrcin.idrodada         ,
            vr.nome                 as nomerodada,
            vr.nomesiglarodada      ,
            vcrin.ch                , 
            vcrin.hierarquia        , 
            vcrin.valorimportancia  , 
            vcrin.sigla             , 
            vcrin.iddimaspecto      , 
            vcrin.idcriterio        , 
            vcrin.idindicador       , 
            vcrin.nivel
   FROM _rodadaconfig.dbrodadacriterios_instit dbrcin
   JOIN _cadbasicos.vwrodada vr on vr.id = dbrcin.idrodada
   JOIN _referencia.vw_h_criteriosindicadores_instit vcrin on vcrin.idcriterio = dbrcin.idcriterio  
   ORDER BY vcrin.ch
;
COMMENT ON VIEW  _rodadaconfig.vwrodadacriterios_instit  IS 'View que descreve a tabela de relacionamento da Rodada x Criterio-de-Ref Configurado';
ALTER TABLE IF EXISTS _rodadaconfig.vwrodadacriterios_instit OWNER to postgres;
GRANT ALL ON TABLE _rodadaconfig.vwrodadacriterios_instit TO n2espindesenv;
GRANT ALL ON TABLE _rodadaconfig.vwrodadacriterios_instit TO postgres;



-- -----------------------------------------------------------------------------------------
-- View: _rodadaconfig.VWRODADACRITERIOS_SA_SELECAO
-- -----------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW _rodadaconfig.vwrodadacriterios_inst_selecao
AS SELECT   ch                  ,
            hierarquia          , 
            valorimportancia    , 
            sigla               , 
            iddimaspecto        , 
            idcriterio          , 
            idindicador         , 
            nivel
   FROM _referencia.vw_h_criteriosindicadores_instit
   WHERE nivel <= 2
   ORDER BY ch
;
COMMENT ON VIEW  _rodadaconfig.vwrodadacriterios_inst_selecao IS 'View que descreve a tabela de referencia de CRITERIO-INSTIT até o nivel de Criterio.';
ALTER TABLE IF EXISTS _rodadaconfig.vwrodadacriterios_inst_selecao OWNER to postgres;
GRANT ALL ON TABLE _rodadaconfig.vwrodadacriterios_inst_selecao TO n2espindesenv;
GRANT ALL ON TABLE _rodadaconfig.vwrodadacriterios_inst_selecao TO postgres;





