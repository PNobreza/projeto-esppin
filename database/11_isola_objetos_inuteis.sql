
-- -------------------------------------------------------------------
-- -------------------------------------------------------------------
SET search_path TO _rodadaconfig, public;

ALTER TABLE IF EXISTS _rodadaconfig.dbrodadacriterios_instit 
    RENAME TO zzz_dbrodadacriterios_instit;

ALTER TABLE IF EXISTS _rodadaconfig.dbrodadacriterios_socamb 
    RENAME TO zzz_dbrodadacriterios_socamb;

ALTER VIEW IF EXISTS _rodadaconfig.vwrodadacriterios_inst_selecao
    RENAME TO zzz_vwrodadacriterios_inst_selecao;

ALTER VIEW IF EXISTS _rodadaconfig.vwrodadacriterios_instit
    RENAME TO zzz_vwrodadacriterios_instit;

ALTER VIEW IF EXISTS _rodadaconfig.vwrodadacriterios_sa_selecao
    RENAME TO zzz_vwrodadacriterios_sa_selecao;

ALTER VIEW IF EXISTS _rodadaconfig.vwrodadacriterios_socamb
    RENAME TO zzz_vwrodadacriterios_socamb;


-- -------------------------------------------------------------------
-- -------------------------------------------------------------------
SET search_path TO _referencia, public;

ALTER TABLE IF EXISTS _referencia.dbcriterioref_instit 
    RENAME TO zzz_dbcriterioref_instit;

ALTER TABLE IF EXISTS _referencia.dbcriterioref_socamb 
    RENAME TO zzz_dbcriterioref_socamb;

ALTER TABLE IF EXISTS _referencia.dbdimensaoaspecto_instit 
    RENAME TO zzz_dbdimensaoaspecto_instit;

ALTER TABLE IF EXISTS _referencia.dbdimensaoaspecto_socamb 
    RENAME TO zzz_dbdimensaoaspecto_socamb;

ALTER TABLE IF EXISTS _referencia.dbindicadorref_instit 
    RENAME TO zzz_dbindicadorref_instit;

ALTER TABLE IF EXISTS _referencia.dbindicadorref_socamb 
    RENAME TO zzz_dbindicadorref_socamb;


ALTER VIEW IF EXISTS _referencia.vw_h_criteriosindicadores_instit
    RENAME TO zzz_vw_h_criteriosindicadores_instit;

ALTER VIEW IF EXISTS _referencia.vw_h_criteriosindicadores_socamb
    RENAME TO zzz_vw_h_criteriosindicadores_socamb;

ALTER VIEW IF EXISTS _referencia.vw_treview_criteriosindicadores_instit
    RENAME TO zzz_vw_treview_criteriosindicadores_instit;

ALTER VIEW IF EXISTS _referencia.vw_treview_criteriosindicadores_socamb
    RENAME TO zzz_vw_treview_criteriosindicadores_socamb;

ALTER VIEW IF EXISTS _referencia.vwcriterioref_instit
    RENAME TO zzz_vwcriterioref_instit;

ALTER VIEW IF EXISTS _referencia.vwcriterioref_socamb
    RENAME TO zzz_vwcriterioref_socamb;

ALTER VIEW IF EXISTS _referencia.vwdimensaoaspecto_instit
    RENAME TO zzz_vwdimensaoaspecto_instit;

ALTER VIEW IF EXISTS _referencia.vwdimensaoaspecto_socamb
    RENAME TO zzz_vwdimensaoaspecto_socamb;

ALTER VIEW IF EXISTS _referencia.vwindicadorref_instit
    RENAME TO zzz_vwindicadorref_instit;

ALTER VIEW IF EXISTS _referencia.vwindicadorref_socamb
    RENAME TO zzz_vwindicadorref_socamb;


UPDATE _referencia.dbmetodologia SET ativo = 'N' WHERE id > 2 ;


