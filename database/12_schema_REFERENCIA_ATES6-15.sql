-- -----------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------
-- SCHEMA: _referencia - AmbitecAgro-ATES-6.15
-- -----------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------


SET search_path TO _referencia, public;


/*

UPDATE _referencia.dbmetodologia 
    SET sigla = 'SOCAMBv815' , 
        nome  = 'SócioAmbiental - Ambitec-Agro v8.15'
    WHERE id = 1;

WITH jaexiste AS (
	SELECT count(*) AS qtd
	FROM _referencia.dbmetodologia
	WHERE sigla = 'SOCAMBv615'
)
INSERT INTO _referencia.dbmetodologia (sigla,nome) 
SELECT 'SOCAMBv615' AS sigla, 'SócioAmbiental - Ambitec-Agro v6.15' AS nome
FROM jaexiste AS xx
WHERE xx.qtd = 0
;


UPDATE _referencia.dbcontroleversao 
    SET metodo = 'SOCAMBv815'
    WHERE id = 1;

WITH jaexiste AS (
	SELECT count(*) AS qtd
	FROM _referencia.dbcontroleversao
	WHERE metodo = 'SOCAMBv615'
)
INSERT INTO _referencia.dbcontroleversao (metodo,versao) 
SELECT 'SOCAMBv615' AS metodo, '20250201' AS versao
FROM jaexiste AS xx
WHERE xx.qtd = 0
;


UPDATE _referencia.dbreferencia SET versao = idmetodologia::text;

ALTER TABLE _referencia.dbreferencia ALTER COLUMN versao TYPE integer USING versao::integer;

*/

ALTER TABLE IF EXISTS _referencia.dbreferencia RENAME versao TO idversao;

ALTER TABLE _referencia.dbreferencia ALTER COLUMN idversao SET NOT NULL; 

ALTER TABLE _referencia.dbreferencia
      ADD CONSTRAINT fk_dbreferencia_dbcontroleversao FOREIGN KEY (idversao) 
          REFERENCES _referencia.dbcontroleversao (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION;

COMMENT ON COLUMN _referencia.dbreferencia.idversao 					    IS 'Fk para DBCONTROLEVERSAO - Versão do Registro na tabela';


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



/*
CREATE TABLE IF NOT EXISTS _referencia.tmp_tbreferencia
(
    id 				        SERIAL NOT NULL ,
    id_autoref              BIGINT,
    idmetodologia           INTEGER NOT NULL,
    sigla 			        character varying(20),
    nome 			        character varying(200),
    valorimportancia        NUMERIC(4,3) DEFAULT 0.100 ,
    versao                  INTEGER,
    nivel                   SMALLINT
    CONSTRAINT pk_tmp_tbreferencia PRIMARY KEY (id),

    CONSTRAINT fk_tmp_tbreferencia_autoreferencia FOREIGN KEY (id_autoref)
        REFERENCES _referencia.tmp_tbreferencia (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
TABLESPACE pg_default; --  DEFAULT _referencia.fn_carimbaversao('SOCAMB')

ALTER TABLE IF EXISTS _referencia.tmp_tbreferencia OWNER to postgres;
GRANT ALL ON TABLE _referencia.tmp_tbreferencia TO n2espindesenv;
GRANT ALL ON TABLE _referencia.tmp_tbreferencia TO postgres;
GRANT ALL ON SEQUENCE _referencia.tmp_tbreferencia_id_seq TO n2espindesenv; 
*/


-- -------------------------------------------------------------------------------------
/* DIMENSAO : SOCIOAMBIENTAL v6.15 */
-- -------------------------------------------------------------------------------------
/* ASPECTOS */
-- -------------------------------------------------------------------------------------
INSERT INTO _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,nivel,idversao,inc_idusuario) VALUES
/* 240 */ (null,5,'DA240C000I000', 'Dimensão: SócioAmbiental | Aspecto: Impactos Ecológicos',null,1,5,1),
/* 241 */ (null,5,'DA241C000I000', 'Dimensão: SócioAmbiental | Aspecto: Impactos SocioAmbientais',null,1,5,1)
;

-- -------------------------------------------------------------------------------------
/* CRITERIOS */
-- -------------------------------------------------------------------------------------
INSERT INTO _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,nivel,idversao,inc_idusuario) VALUES
/* 242 */ (240,5,'**', 'Eficiência Tecnológica',null, 2, 5, 1),
/* 243 */ (240,5,'**', 'Qualidade Ambiental',null, 2, 5, 1),
/* 244 */ (241,5,'**', 'Respeito ao Consumidor',null, 2, 5, 1),
/* 245 */ (241,5,'**', 'Trabalho & Emprego',null, 2, 5, 1),
/* 246 */ (241,5,'**', 'Renda',null, 2, 5, 1),
/* 247 */ (241,5,'**', 'Saúde',null, 2, 5, 1),
/* 248 */ (241,5,'**', 'Gestão e Administração',null, 2, 5, 1)
;
UPDATE _referencia.dbreferencia AS dbr
SET sigla = ( SELECT 'DA'|| substring((1000+id_autoref)::varchar,2,3)||
					 'C'||substring((1000+id)::varchar,2,3)||
					 'I000'
			  FROM _referencia.dbreferencia WHERE id = dbr.id )
WHERE sigla = '**' AND id > 239
;

-- -------------------------------------------------------------------------------------
/* INDICADORES de : Impactos Ecológicos - Eficiência Tecnológica 242 */
-- -------------------------------------------------------------------------------------
INSERT INTO _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,nivel,idversao,inc_idusuario) VALUES
(242,5,null,'USO DE INSUMOS AGRICOLAS', '0.05', 3, 5, 1),
(242,5,null,'USO DE INSUMOS VETERINARIOS E MATÉRIAS-PRIMAS', '0.05', 3, 5, 1),
(242,5,null,'CONSUMO DE ENERGIA', '0.05', 3, 5, 1),
(242,5,null,'GERACAO PROPRIA, APROVEITAMENTO, REUSO E AUTONOMIA', '0.025', 3, 5, 1)
;
UPDATE _referencia.dbreferencia AS dbr
SET sigla = ( SELECT substring(sigla,1,9) FROM _referencia.dbreferencia WHERE id = dbr.id_autoref )||
            'I'||substring( (id+1000)::varchar,2,3) 
WHERE sigla IS NULL
AND   nivel = 3;

-- -------------------------------------------------------------------------------------
/* INDICADORES de : Impactos Ecológicos - Qualidade Ambiental */
-- -------------------------------------------------------------------------------------
INSERT INTO _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,nivel,idversao,inc_idusuario) VALUES
(243,5,null,'EMISSOES A ATMOSFERA', '0.02', 3, 5, 1),         
(243,5,null,'QUALIDADE DO SOLO', '0.05', 3, 5, 1),                                                               
(243,5,null,'QUALIDADE DA AGUA', '0.05', 3, 5, 1),                                                                  
(243,5,null,'CONSERVACAO DA BIODIVERSIDADE', '0.05', 3, 5, 1),
(243,5,null,'RECUPERACAO AMBIENTAL', '0.05', 3, 5, 1)
;                              
UPDATE _referencia.dbreferencia AS dbr
SET sigla = ( SELECT substring(sigla,1,9) FROM _referencia.dbreferencia WHERE id = dbr.id_autoref )||
            'I'||substring( (id+1000)::varchar,2,3) 
WHERE sigla IS NULL
AND   nivel = 3;

-- -------------------------------------------------------------------------------------
/* INDICADORES de : Impactos Socio-Ambientais - Respeito ao Consumidor */
-- -------------------------------------------------------------------------------------
INSERT INTO _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,nivel,idversao,inc_idusuario) VALUES
(244,5,null, 'QUALIDADE DO PRODUTO', '0.05', 3, 5, 1),
(244,5,null, 'CAPITAL SOCIAL', '0.02', 3, 5, 1),                                                               
(244,5,null, 'BEM-ESTAR E SAUDE ANIMAL', '0.02', 3, 5, 1)
;                                                           
UPDATE _referencia.dbreferencia AS dbr
SET sigla = ( SELECT substring(sigla,1,9) FROM _referencia.dbreferencia WHERE id = dbr.id_autoref )||
            'I'||substring( (id+1000)::varchar,2,3) 
WHERE sigla IS NULL
AND   nivel = 3;

-- -------------------------------------------------------------------------------------
/* INDICADORES de : Impactos Socio-Ambientais - Trabalho / Emprego */
-- -------------------------------------------------------------------------------------
INSERT INTO _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,nivel,idversao,inc_idusuario) VALUES
(245,5,null, 'CAPACITACAO', '0.02', 3, 5, 1),                                                                        
(245,5,null, 'QUALIFICACAO E OFERTA DE TRABALHO', '0.02', 3, 5, 1),                                                  
(245,5,null, 'QUALIDADE DO EMPREGO / OCUPACAO', '0.05', 3, 5, 1)
;
UPDATE _referencia.dbreferencia AS dbr
SET sigla = ( SELECT substring(sigla,1,9) FROM _referencia.dbreferencia WHERE id = dbr.id_autoref )||
            'I'||substring( (id+1000)::varchar,2,3) 
WHERE sigla IS NULL
AND   nivel = 3;

-- -------------------------------------------------------------------------------------
/* INDICADORES de : Impactos Socio-Ambientais - Renda */
-- -------------------------------------------------------------------------------------
INSERT INTO _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,nivel,idversao,inc_idusuario) VALUES
(246,5,null, 'GERACAO DE RENDA DO ESTABELECIMENTO', '0.05', 3, 5, 1),
(246,5,null, 'DIVERSIDADE DE FONTES DE RENDA', '0.02', 3, 5, 1),
(246,5,null, 'VALOR DA PROPRIEDADE', '0.02', 3, 5, 1)
;
UPDATE _referencia.dbreferencia AS dbr
SET sigla = ( SELECT substring(sigla,1,9) FROM _referencia.dbreferencia WHERE id = dbr.id_autoref )||
            'I'||substring( (id+1000)::varchar,2,3) 
WHERE sigla IS NULL
AND   nivel = 3;

-- -------------------------------------------------------------------------------------
/* INDICADORES de : Impactos Socio-Ambientais - Saúde */
-- -------------------------------------------------------------------------------------
INSERT INTO _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,nivel,idversao,inc_idusuario) VALUES
(247,5,null, 'SAÚDE AMBIENTAL E PESSOAL', '0.025', 3, 5, 1),
(247,5,null, 'SEGURANCA E SAUDE OCUPACIONAL', '0.025', 3, 5, 1),
(247,5,null, 'SEGURANCA ALIMENTAR', '0.05', 3, 5, 1)
;
UPDATE _referencia.dbreferencia AS dbr
SET sigla = ( SELECT substring(sigla,1,9) FROM _referencia.dbreferencia WHERE id = dbr.id_autoref )||
            'I'||substring( (id+1000)::varchar,2,3) 
WHERE sigla IS NULL
AND   nivel = 3;

-- -------------------------------------------------------------------------------------
/* INDICADORES de : Impactos Socio-Ambientais - Gestão e Administração */
-- -------------------------------------------------------------------------------------
INSERT INTO _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,nivel,idversao,inc_idusuario) VALUES
(248,5,null, 'DEDICACAO E PERFIL DO RESPONSAVEL', '0.05', 3, 5, 1),
(248,5,null, 'CONDICAO DE COMERCIALIZACAO', '0.05', 3, 5, 1),                                                  
(248,5,null, 'DISPOSICAO DE RESIDUOS', '0.02', 3, 5, 1),                                                        
(248,5,null, 'GESTAO DE INSUMOS QUIMICOS', '0.02', 3, 5, 1),                                                         
(248,5,null, 'RELACIONAMENTO INSTITUCIONAL', '0.02', 3, 5, 1);
UPDATE _referencia.dbreferencia AS dbr
SET sigla = ( SELECT substring(sigla,1,9) FROM _referencia.dbreferencia WHERE id = dbr.id_autoref )||
            'I'||substring( (id+1000)::varchar,2,3) 
WHERE sigla IS NULL
AND   nivel = 3;


UPDATE _referencia.dbreferencia SET nome = UPPER( UNACCENT(NOME) ) WHERE idmetodologia = 5 ;



