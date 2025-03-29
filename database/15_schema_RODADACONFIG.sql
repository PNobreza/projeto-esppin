-- -----------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------
-- SCHEMA: _rodadaconfig - 
-- -----------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------
SET search_path TO _rodadaconfig, public;

DROP VIEW _rodadaconfig.vwrodadaprojetos_1linha;

CREATE VIEW _rodadaconfig.vwrodadaprojetos_1linha 
AS WITH base_cte AS 
(
    SELECT  vwrdd.id,
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
            to_char( vwrdd.dataultimaconfig, 'DD/MM/YYYY HH24:MI:SS'::text ) AS dataultimaconfig,
            vwrdd.flgemoperacao,
            vwrdd.ativo,
            vwrdd.corgestao
    FROM _cadbasicos.vwrodada vwrdd
    LEFT JOIN _adm.vwpessoacolaborador vwpc ON vwpc.idusuario = vwrdd.idgestoroperacao
    WHERE vwrdd.ativo = 'S'::bpchar
), projetosrodada AS (
	SELECT	dbrp.idrodada,
			string_agg('. ' || vp.nomesiglaprojeto, ' | ') AS projetos_texto,
	 		'<ul>' || string_agg('<li>' || vp.nomesiglaprojeto || '</li>', '') || '</ul>' AS projetos_html,
	 		'<table>' || string_agg('<tr><td>' || vp.nomesiglaprojeto || '</td></tr>', '') || '</table>' AS projetos_htmltable
	FROM _rodadaconfig.dbrodadaprojetos dbrp
	JOIN base_cte bc ON bc.id = dbrp.idrodada
	JOIN _cadbasicos.vwprojeto vp ON vp.id = dbrp.idprojeto
	GROUP BY dbrp.idrodada
	ORDER BY dbrp.idrodada
), posicaoprojetos AS (
    SELECT vrp.idrodada, count(vrp.idprojeto) AS posicao_projetos
    FROM _rodadaconfig.vwrodadaprojetos vrp
    JOIN base_cte ON base_cte.id = vrp.idrodada
	GROUP BY vrp.idrodada
	ORDER BY vrp.idrodada
), qtdjuizes AS (
    SELECT vrj.idrodada, count(vrj.idjuiz) AS qtd_juizes
    FROM _rodadaconfig.vwrodadajuizes vrj
    JOIN base_cte ON vrj.idrodada = base_cte.id
	GROUP BY vrj.idrodada
	ORDER BY vrj.idrodada
), qtdjuizesconfirmados AS (
    SELECT vrj.idrodada, COUNT(vrj.idjuiz) FILTER( WHERE vrj.flgconfirmado = 'S'::bpchar ) AS qtd_juizes_confirmados
    FROM _rodadaconfig.vwrodadajuizes vrj
    JOIN base_cte ON vrj.idrodada = base_cte.id
	GROUP BY vrj.idrodada
	ORDER BY vrj.idrodada
), dividendojuizes AS (
    SELECT qjc.idrodada, qjc.qtd_juizes_confirmados AS dividendo_juizes
    FROM qtdjuizesconfirmados qjc
    JOIN base_cte ON qjc.idrodada = base_cte.id
), divisorjuizes AS (
    SELECT 	qj.idrodada,
			CASE WHEN qtd_juizes = 0 
                THEN 1 
                ELSE qtd_juizes 
            END AS divisor_juizes
    FROM qtdjuizes qj
    JOIN base_cte ON qj.idrodada = base_cte.id
), posicaojuizes AS (
    SELECT dd.idrodada, 
	    ( SELECT dd.dividendo_juizes )::text || '/'::text 
	    ||
	    ( SELECT dv.divisor_juizes  )::text AS posicao_juizes
	FROM base_cte bc
	JOIN dividendojuizes dd ON bc.id = dd.idrodada
	JOIN divisorjuizes dv ON bc.id = dv.idrodada
), percjuizesconfirm AS (
    SELECT dd.idrodada, round((dd.dividendo_juizes::numeric / dv.divisor_juizes::numeric) * 100::numeric, 2) AS perc_confirm_juizes 
    FROM dividendojuizes dd
	JOIN divisorjuizes dv ON dd.idrodada = dv.idrodada
), rodadacriterios AS (
	SELECT rc.idrodada, rc.idmetodologia, count(rc.idreferencia) AS qtdcriterios
	FROM _rodadaconfig.dbrodadacriterios rc
	JOIN _rodadaconfig.dbrodadametodologias rm ON rc.idrodada = rm.idrodada AND rc.idmetodologia = rm.idmetodologia
	JOIN _referencia.dbreferencia rf ON rc.idreferencia = rf.id
    JOIN base_cte ON rc.idrodada = base_cte.id
	WHERE rf.nivel = 3
	GROUP BY rc.idrodada, rc.idmetodologia
	ORDER BY rc.idrodada, rc.idmetodologia
), metodos AS (
	SELECT id, siglanomemetodologia 
	FROM _referencia.vwmetodologia vmt
	JOIN rodadacriterios rc ON vmt.id = rc.idmetodologia
), resumo AS (
	SELECT DISTINCT rc.idrodada, rc.idmetodologia, mt.siglanomemetodologia, rc.qtdcriterios
	FROM rodadacriterios rc
	JOIN metodos mt ON rc.idmetodologia = mt.id
    JOIN base_cte ON rc.idrodada = base_cte.id
	ORDER BY rc.idrodada, rc.idmetodologia
), criteriosrodada AS (
	SELECT	rs.idrodada,
			string_agg('. ' || rs.siglanomemetodologia || ' - ' || rs.qtdcriterios::text, ' | ') AS criterios,
			'<ul>' || string_agg('<li>' || rs.siglanomemetodologia || ' - ' || rs.qtdcriterios::text || '</li>', '') || '</ul>' AS criterios_html_ulli
	FROM resumo rs
    JOIN base_cte ON rs.idrodada = base_cte.id
	GROUP BY rs.idrodada
	ORDER BY rs.idrodada
)
    SELECT  bc.id,
            bc.nome,
            bc.sigla,
            bc.nomesiglarodada,
            bc.siglanomerodada,
            bc.dataprevistainicio,
            bc.dataprevistafim,
            bc.formatdataprevistainicio,
            bc.formatdataprevistafim,
            bc.periodovalidade,
			prd.projetos_texto,
			prd.projetos_html,
			prd.projetos_htmltable,
            bc.indicesituacao,
            bc.grpsituacao,
            bc.valorsituacao,
            bc.idgestoroperacao,
            bc.nomegestor,
            bc.dataultimaconfig,
            bc.flgemoperacao,
            bc.ativo,
            bc.corgestao,
            pprj.posicao_projetos,
            pjz.posicao_juizes,
            pjc.perc_confirm_juizes,
			cr.criterios,
			cr.criterios_html_ulli
    FROM base_cte bc
	JOIN posicaoprojetos pprj ON bc.id = pprj.idrodada
	JOIN posicaojuizes pjz ON bc.id = pjz.idrodada
	JOIN percjuizesconfirm pjc ON bc.id = pjc.idrodada
	JOIN projetosrodada prd ON bc.id = prd.idrodada
	JOIN criteriosrodada cr ON bc.id = cr.idrodada
;
ALTER TABLE _rodadaconfig.vwrodadaprojetos_1linha OWNER TO postgres;
GRANT ALL ON TABLE _rodadaconfig.vwrodadaprojetos_1linha TO n2espindesenv;
GRANT ALL ON TABLE _rodadaconfig.vwrodadaprojetos_1linha TO postgres;

