
-- -------------------------------------------------------------------------------------
/* Impactos Ecológicos - Eficiência Tecnológica */
-- -------------------------------------------------------------------------------------
insert into _referencia.dbcriterioref_socamb (iddimaspecto,nome,valorimportancia ) VALUES 
(1, 'MUDANCA NO USO DIRETO DA TERRA', '0.05'),
(1, 'MUDANCA NO USO INDIRETO DA TERRA', '0.05'),
(1, 'CONSUMO DE AGUA', '0.05'),
(1, 'USO DE INSUMOS AGRICOLAS', '0.05'),
(1, 'USO DE INSUMOS VETERINARIOS E MATERIAS-PRIMAS', '0.05'),
(1, 'CONSUMO DE ENERGIA', '0.05'),
(1, 'GERACAO PROPRIA, APROVEITAMENTO, REUSO E AUTONOMIA', '0.025');

-- -------------------------------------------------------------------------------------
/* Impactos Ecológicos - Qualidade Ambiental */
-- -------------------------------------------------------------------------------------
insert into _referencia.dbcriterioref_socamb (iddimaspecto,nome,valorimportancia ) VALUES 
(2, 'EMISSOES A ATMOSFERA', '0.02'),         
(2, 'QUALIDADE DO SOLO', '0.05'),                                                               
(2, 'QUALIDADE DA AGUA', '0.05'),                                                                  
(2, 'CONSERVACAO DA BIODIVERSIDADE E RECUPERACAO AMBIENTAL', '0.05');                              

-- -------------------------------------------------------------------------------------
/* Impactos Socio-Ambientais - Respeito ao Consumidor */
-- -------------------------------------------------------------------------------------
insert into _referencia.dbcriterioref_socamb (iddimaspecto,nome,valorimportancia ) VALUES 
(3, 'QUALIDADE DO PRODUTO', '0.05'),
(3, 'CAPITAL SOCIAL', '0.02'),                                                               
(3, 'BEM-ESTAR E SAUDE ANIMAL', '0.02');                                                           

-- -------------------------------------------------------------------------------------
/* Impactos Socio-Ambientais - Trabalho / Emprego */
-- -------------------------------------------------------------------------------------
insert into _referencia.dbcriterioref_socamb (iddimaspecto,nome,valorimportancia ) VALUES 
(4, 'CAPACITACAO', '0.02'),                                                                        
(4, 'QUALIFICACAO E OFERTA DE TRABALHO', '0.02'),                                                  
(4, 'QUALIDADE DO EMPREGO / OCUPACAO', '0.05'),
(4, 'OPORTUNIDADE, EMANCIPACAO E RECOMPENSA EQUITATIVA ENTRE GENEROS, GERACOES E ETNIAS', '0.02'); 

-- -------------------------------------------------------------------------------------
/* Impactos Socio-Ambientais - Renda */
-- -------------------------------------------------------------------------------------
insert into _referencia.dbcriterioref_socamb (iddimaspecto,nome,valorimportancia ) VALUES 
(5, 'GERACAO DE RENDA', '0.05'),
(5, 'VALOR DA PROPRIEDADE', '0.02');                                                               

-- -------------------------------------------------------------------------------------
/* Impactos Socio-Ambientais - Saúde */
-- -------------------------------------------------------------------------------------
insert into _referencia.dbcriterioref_socamb (iddimaspecto,nome,valorimportancia ) VALUES 
(6, 'SEGURANCA E SAUDE OCUPACIONAL', '0.025'),
(6, 'SEGURANCA ALIMENTAR', '0.05');                                                                

-- -------------------------------------------------------------------------------------
/* Impactos Socio-Ambientais - Gestão e Administração */
-- -------------------------------------------------------------------------------------
insert into _referencia.dbcriterioref_socamb (iddimaspecto,nome,valorimportancia ) VALUES 
(7, 'DEDICACAO E PERFIL DO RESPONSAVEL', '0.05'),
(7, 'CONDICAO DE COMERCIALIZACAO', '0.05'),                                                  
(7, 'DISPOSICAO DE RESIDUOS', '0.02'),                                                        
(7, 'GESTAO DE INSUMOS QUIMICOS', '0.02'),                                                         
(7, 'RELACIONAMENTO INSTITUCIONAL', '0.02');                                                       

