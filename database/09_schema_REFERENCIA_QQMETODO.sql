-- -----------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------
-- SCHEMA: _referencia - QUAQUER METODOLOGIA
-- -----------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------


SET search_path TO _referencia, public;

/* DIMENSÃO / ASPECTOS => INSTITUCIONAL */
INSERT INTO _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES
/* 183 */(null,2,'DA183C000I000', 'CAPACIDADE RELACIONAL',null, '2',1,1),
/* 184 */(null,2,'DA184C000I000', 'CAPACIDADE CIENTÍFICA-TECNOLÓGICA',null, '2',1, 1),
/* 185 */(null,2,'DA185C000I000', 'CAPACIDADE ORGANIZACIONAL',null, '2',1, 1),
/* 186 */(null,2,'DA186C000I000', 'PRODUTOS DE PESQUISA E DESENVOLVIMENTO',null, '2',1, 1)
;


/* CRITERIOS => INSTITUCIONAL */
-- -------------------------------------------------------------------------------------
/* Capacidade Relacional */
-- -------------------------------------------------------------------------------------
INSERT INTO _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES
(183, 2, null, 'RELAÇÕES DE EQUIPE / REDE DE PESQUISA', '0.5', '2',2,1),
(183, 2, null, 'RELAÇÕES COM INTERLOCURTORES (BENEFICIARIOS, PARCEIROS, FORNECEDORES E FINANCIADORES)', '0.5', '2',2,1)
;
-- -------------------------------------------------------------------------------------
/* Capacidade Cientifica-Tecnologica */
-- -------------------------------------------------------------------------------------
INSERT INTO _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES
(184,2,null, 'INSTALAÇÕES (MÉTODOS E MEIOS)', '0.5', '2',2,1),         
(184,2,null, 'RECURSOS DO PROJETO (CAPTAÇÃO E EXECUÇÃO)', '0.5', '2',2,1)
;                              
-- -------------------------------------------------------------------------------------
/* Capacidade Organizacional */
-- -------------------------------------------------------------------------------------
INSERT INTO _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES
(185,2,null, 'EQUIPE / REDE DE PESQUISA', '0.5', '2',2,1),         
(185,2,null, 'TRANSFERÊNCIA EXTENSÃO', '0.5', '2',2,1)                                                               
;                              
-- -------------------------------------------------------------------------------------
/* Produtos de P&D */
-- -------------------------------------------------------------------------------------
INSERT INTO _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES
(186,2,null, 'PRODUTOS DE P & D', '0.5', '2',2,1),         
(186,2,null, 'PRODUTOS TECNOLÓGICOS', '0.5', '2',2,1)                                                               
;

UPDATE _referencia.dbreferencia AS dbr
SET sigla = ( SELECT 'DA'|| substring((1000+id_autoref)::varchar,2,3)||
					 'C'||substring((1000+id)::varchar,2,3)||
					 'I000'
			  FROM _referencia.dbreferencia WHERE id = dbr.id )
WHERE sigla IS NULL AND id > 182
;


/* INDICADORES => INSTITUCIONAL */
/*
-- IMPORTAR
INSERT INTO _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) 
SELECT 186+idcriterio as id_autoref, 2 as idmetodologia, null as sigla, nome, valorimportancia, _referencia.fn_carimbaversao('INSTIT') as versao, 3 as nivel, 1 as inc_idusuario  
FROM _referencia.dbindicadorref_instit
ORDER BY id ASC ;
-- EXPORTAR
SELECT '('||id_autoref||', '||idmetodologia||', null'||', '''||nome||''', '||valorimportancia||', '||'''20241001'', 3, 1),'
FROM _referencia.dbreferencia where id > 182 AND SIGLA IS NULL
ORDER BY idmetodologia ASC , sigla ASC, id_autoref ASC
*/

INSERT INTO _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES
(187, 2, null, 'DIVERSIDADE DE ESPECIALIDADES', 0.250, '2', 3, 1),
(187, 2, null, 'INTERDISCIPLINIDADE (CO-AUTORIAS)', 0.250, '2', 3, 1),
(187, 2, null, 'KNOW-HOW (REFERENCIAL CONCEITUAL / METODOLOGICO)', 0.250, '2', 3, 1),
(187, 2, null, 'GRUPOS DE ESTUDO / PESQUISA FORMALIZADOS', 0.250, '2', 3, 1),
(187, 2, null, 'EVENTOS TECNICO-CIENTIFICOS FORMAIS REALIZADOS', 0.250, '2', 3, 1),
(187, 2, null, 'ADOÇÃO / APROPRIAÇÃO METODOLÓGICA POR MEMBROS DA REDE', 0.250, '2', 3, 1)
;
UPDATE _referencia.dbreferencia AS dbr
SET sigla = ( SELECT 'DA183'|| 
					 'C'||(id_autoref)::varchar||
					 'I'||substring((id+1000)::varchar,2,3) 
			  FROM _referencia.dbreferencia WHERE id = dbr.id )
WHERE sigla IS NULL AND id > 182;

INSERT INTO _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES
(188, 2, null, 'DIVERSIDADE DE INTERLOCUTORES', -0.250, '2', 3, 1),
(188, 2, null, 'INTERATIVIDADE ENTRE INTERLOCUTORES (AÇÕES E ATIVIDADES)', -0.250, '2', 3, 1),
(188, 2, null, 'KNOW-HOW (REFERENCIAL OPERACIONAL)', -0.250, '2', 3, 1),
(188, 2, null, 'FONTES DE RECURSOS / CONTRATAÇÃO INSTITUCIONAL', -0.250, '2', 3, 1),
(188, 2, null, 'REDES DE INTERAÇÕES COMUNITÁRIAS (NÃO CIENTÍFICAS)', -0.250, '2', 3, 1),
(188, 2, null, 'INSERÇÃO NO MERCADO (COMERCIO OU CESSAO DE PRODUTOS / TECNOLOGIAS)', -0.250, '2', 3, 1)
;
UPDATE _referencia.dbreferencia AS dbr
SET sigla = ( SELECT 'DA183'|| 
					 'C'||(id_autoref)::varchar||
					 'I'||substring((id+1000)::varchar,2,3) 
			  FROM _referencia.dbreferencia WHERE id = dbr.id )
WHERE sigla IS NULL AND id > 182;


INSERT INTO _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES
(189, 2, null, 'INFRAESTRUTURA INSTITUCIONAL (NÚMERO DE UNIDADES)', -0.200, '2', 3, 1),
(189, 2, null, 'INFRAESTRUTURA OPERACIONAL (ÁREA FÍSICA)', -0.200, '2', 3, 1),
(189, 2, null, 'INSTRUMENTAL OPERACIONAL (SITUAÇÃO E MANUTENÇÃO)', -0.200, '2', 3, 1),
(189, 2, null, 'INSTRUMENTAL BIBLIOGRÁFICO', -0.200, '2', 3, 1),
(189, 2, null, 'INFORMATIZAÇÃO / AUTOMAÇÃO / TECNOLOGIA DA INFORMAÇÃO', -0.200, '2', 3, 1),
(189, 2, null, 'COMPARTILHAMENTO DA INFRAESTRUTURA', -0.200, '2', 3, 1)
;
UPDATE _referencia.dbreferencia AS dbr
SET sigla = ( SELECT 'DA184'|| 
					 'C'||(id_autoref)::varchar||
					 'I'||substring((id+1000)::varchar,2,3) 
			  FROM _referencia.dbreferencia WHERE id = dbr.id )
WHERE sigla IS NULL AND id > 182;

INSERT INTO _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES
(190, 2, null, 'INFRAESTRUTURA (AMPLIAÇÃO DA ÁREA FÍSICA)', -0.200, '2', 3, 1),
(190, 2, null, 'INSTRUMENTAL OPERACIONAL (INCLUSIVE INFORMATIZAÇÃO / AUTOMAÇÃO / TECNOLOGIA DA INFORMAÇÃO)', -0.200, '2', 3, 1),
(190, 2, null, 'INSTRUMENTAL BIBLIOGRÁFICO (AQUISIÇÃO)', -0.200, '2', 3, 1),
(190, 2, null, 'CONTRATAÇÃO DE CONSULTORES, BOLSISTAS, PESQUISADORES VISITANTES', -0.200, '2', 3, 1),
(190, 2, null, 'CUSTEIO DE DIÁRIAS, TRASLADOS E ESTADIAS', -0.200, '2', 3, 1)
;
UPDATE _referencia.dbreferencia AS dbr
SET sigla = ( SELECT 'DA184'|| 
					 'C'||(id_autoref)::varchar||
					 'I'||substring((id+1000)::varchar,2,3) 
			  FROM _referencia.dbreferencia WHERE id = dbr.id )
WHERE sigla IS NULL AND id > 182;

INSERT INTO _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES
(191, 2, null, 'CURSOS E TREINAMENTOS', -0.100, '2', 3, 1),
(191, 2, null, 'REALIZAÇÃO DE EXPERIMENTOS, AVALIAÇÕES, EXPEDIÇÕES, ENSAIOS', -0.100, '2', 3, 1),
(191, 2, null, 'IMPLEMENTAÇÃO DE BANCOS DE DADOS, PLATAFORMAS DE INFORMAÇÃO CODIFICADA', -0.100, '2', 3, 1),
(191, 2, null, 'PARTICIPAÇÃO EM EVENTOS TÉCNICO-CIENTÍFICOS', -0.200, '2', 3, 1),
(191, 2, null, 'ORGANIZAÇÃO DE EVENTOS TÉCNICO-CIENTÍFICOS', -0.200, '2', 3, 1),
(191, 2, null, 'ADOÇÃO DE SISTEMAS DE GESTÃO E DE QUALIDADE', -0.300, '2', 3, 1)
;
UPDATE _referencia.dbreferencia AS dbr
SET sigla = ( SELECT 'DA185'|| 
					 'C'||(id_autoref)::varchar||
					 'I'||substring((id+1000)::varchar,2,3) 
			  FROM _referencia.dbreferencia WHERE id = dbr.id )
WHERE sigla IS NULL AND id > 182;

INSERT INTO _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES
(192, 2, null, 'CURSOS E TREINAMENTOS PARA PÚBLICO EXTERNO', -0.100, '2', 3, 1),
(192, 2, null, 'NÚMERO DE PARTICIPANTES', -0.100, '2', 3, 1),
(192, 2, null, 'CRIAÇÃO DE UNIDADES DEMONSTRATIVAS', -0.300, '2', 3, 1),
(192, 2, null, 'NÚMERO DE EXPOSIÇÕES NA MÍDIA / ARTIGOS DE DIVULGAÇÃO', -0.500, '2', 3, 1),
(192, 2, null, 'PROJETOS DE EXTENSÃO / DESENVOLVIMENTO LOCAL', -0.500, '2', 3, 1),
(192, 2, null, 'DISCIPLINAS EM CURSOS DE GRADUAÇÃO E PÓS-GRADUAÇÃO', -0.500, '2', 3, 1)
;
UPDATE _referencia.dbreferencia AS dbr
SET sigla = ( SELECT 'DA185'|| 
					 'C'||(id_autoref)::varchar||
					 'I'||substring((id+1000)::varchar,2,3) 
			  FROM _referencia.dbreferencia WHERE id = dbr.id )
WHERE sigla IS NULL AND id > 182;

INSERT INTO _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES
(193, 2, null, 'APRESENTAÇÕES EM CONGRESSOS', 0.300, '2', 3, 1),
(193, 2, null, 'ARTIGOS INDEXADOS', 0.150, '2', 3, 1),
(193, 2, null, 'ÍNDICE DE IMPACTO TOTAL (WEB-OF-SCIENCE)', 0.150, '2', 3, 1),
(193, 2, null, 'TESES, DISSERTAÇÕES, TCCS', 0.150, '2', 3, 1),
(193, 2, null, 'LIVROS/CAPÍTULOS, BOLETINS, GUIAS, MANUAIS, CD-ROMS, WEBSITES, OUTRAS MÍDIAS, MAPAS, ETC.', 0.250, '2', 3, 1)
;
UPDATE _referencia.dbreferencia AS dbr
SET sigla = ( SELECT 'DA186'|| 
					 'C'||(id_autoref)::varchar||
					 'I'||substring((id+1000)::varchar,2,3) 
			  FROM _referencia.dbreferencia WHERE id = dbr.id )
WHERE sigla IS NULL AND id > 182;

INSERT INTO _referencia.dbreferencia (id_autoref,idmetodologia,sigla,nome,valorimportancia,versao,nivel,inc_idusuario) VALUES
(194, 2, null, 'PATENTES / REGISTROS', -0.100, '2', 3, 1),
(194, 2, null, 'VARIEDADES / LINHAGENS', -0.100, '2', 3, 1),
(194, 2, null, 'NOVAS PRÁTICAS METODOLÓGICAS', -0.400, '2', 3, 1),
(194, 2, null, 'PRODUTOS TECNOLÓGICOS', -0.400, '2', 3, 1),
(194, 2, null, 'MARCOS REGULATÓRIOS (LEIS, NORMAS)', -0.250, '2', 3, 1)
;
UPDATE _referencia.dbreferencia AS dbr
SET sigla = ( SELECT 'DA186'|| 
					 'C'||(id_autoref)::varchar||
					 'I'||substring((id+1000)::varchar,2,3) 
			  FROM _referencia.dbreferencia WHERE id = dbr.id )
WHERE sigla IS NULL AND id > 182;



