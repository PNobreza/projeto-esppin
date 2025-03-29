-- -----------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------
-- SCHEMA: _RODADACONFIG
-- -----------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------


SET search_path TO _rodadaconfig, public;

DROP VIEW   IF EXISTS _rodadaconfig.vwrodadacriterios_socamb;
DROP VIEW   IF EXISTS _rodadaconfig.vwrodadacriterios_sa_selecao;



-- -----------------------------------------------------------------------------------------
-- View: _rodadaconfig.VWRODADACRITERIOS_SOCAMB
-- -----------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW _rodadaconfig.vwrodadacriterios_socamb
AS SELECT   dbrcsa.id               ,
            dbrcsa.idrodada         ,
            vr.nome                 as nomerodada,
            vr.nomesiglarodada      ,
            vcrsa.ch                , 
            vcrsa.hierarquia        , 
            vcrsa.valorimportancia  , 
            vcrsa.sigla             , 
            vcrsa.iddimaspecto      , 
            vcrsa.idcriterio        , 
            vcrsa.idindicador       , 
            vcrsa.nivel
   FROM _rodadaconfig.dbrodadacriterios_socamb dbrcsa
   JOIN _cadbasicos.vwrodada vr on vr.id = dbrcsa.idrodada
   JOIN _referencia.vw_h_criteriosindicadores_socamb vcrsa on vcrsa.idcriterio = dbrcsa.idcriterio  
   ORDER BY vcrsa.ch
;
COMMENT ON VIEW  _rodadaconfig.vwrodadacriterios_socamb  IS 'View que descreve a tabela de relacionamento da Rodada x Criterio-de-Ref Configurado';
ALTER TABLE IF EXISTS _rodadaconfig.vwrodadacriterios_socamb OWNER to postgres;
GRANT ALL ON TABLE _rodadaconfig.vwrodadacriterios_socamb TO n2espindesenv;
GRANT ALL ON TABLE _rodadaconfig.vwrodadacriterios_socamb TO postgres;



-- -----------------------------------------------------------------------------------------
-- View: _rodadaconfig.VWRODADACRITERIOS_SA_SELECAO
-- -----------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW _rodadaconfig.vwrodadacriterios_sa_selecao
AS SELECT   ch                  ,
            hierarquia          , 
            valorimportancia    , 
            sigla               , 
            iddimaspecto        , 
            idcriterio          , 
            idindicador         , 
            nivel
   FROM _referencia.vw_h_criteriosindicadores_socamb vwrcsa
   WHERE nivel <= 2
   ORDER BY ch
;
COMMENT ON VIEW  _rodadaconfig.vwrodadacriterios_sa_selecao IS 'View que descreve a tabela de referencia de CRITERIO-SOCAMB até o nivel de Criterio.';
ALTER TABLE IF EXISTS _rodadaconfig.vwrodadacriterios_sa_selecao OWNER to postgres;
GRANT ALL ON TABLE _rodadaconfig.vwrodadacriterios_sa_selecao TO n2espindesenv;
GRANT ALL ON TABLE _rodadaconfig.vwrodadacriterios_sa_selecao TO postgres;





