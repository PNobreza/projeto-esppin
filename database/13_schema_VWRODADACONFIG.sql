
-- -----------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------

SET search_path TO _rodadaconfig, public;


DROP VIEW IF EXISTS _rodadaconfig.vwrodadaconfig;


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
        END::numeric * 100::numeric, 2) AS percconfigjuizes
   FROM _cadbasicos.vwrodada vwrdd
     LEFT JOIN _adm.vwpessoacolaborador vwpc ON vwpc.idusuario = vwrdd.idgestoroperacao
  WHERE vwrdd.ativo = 'S'::bpchar;

-- MNobre : não tem    WHERE vwrdd.exc_data IS NULL
ALTER TABLE _rodadaconfig.vwrodadaconfig  OWNER TO postgres;
GRANT ALL ON TABLE _rodadaconfig.vwrodadaconfig TO n2espindesenv;
GRANT ALL ON TABLE _rodadaconfig.vwrodadaconfig TO postgres;


