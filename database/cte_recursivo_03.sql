DROP VIEW IF EXISTS cidades;

CREATE VIEW cidades AS
-- CTEs para cada nível, com colunas de ordenação adicionais
WITH regiao_cte AS (
    SELECT 
        id AS id_regiao,
        'Regiao: ' || nome AS hierarquia,
        id AS ordem_regiao -- Coluna de ordenação
    FROM
        regiao
),
estado_cte AS (
    SELECT 
        e.id AS id_estado,
        e.idregiao,
        '   Estado: ' || e.nome AS hierarquia,
        r.id AS ordem_regiao, -- Coluna de ordenação para região
        e.id AS ordem_estado -- Coluna de ordenação para estado
    FROM 
        estado e
    JOIN 
        regiao r ON r.id = e.idregiao
),
cidade_cte AS (
    SELECT 
        c.id AS id_cidade,
        c.idestado,
        '      Cidade: ' || c.nome AS hierarquia,
        r.id AS ordem_regiao, -- Coluna de ordenação para região
        e.id AS ordem_estado, -- Coluna de ordenação para estado
        c.id AS ordem_cidade -- Coluna de ordenação para cidade
    FROM 
        cidade c
    JOIN 
        estado e ON e.id = c.idestado
    JOIN 
        regiao r ON r.id = e.idregiao
)

-- Construindo a árvore com joins em cada nível
SELECT hierarquia
FROM (
    -- Nível de Região
    SELECT r.hierarquia, r.ordem_regiao, NULL::integer AS ordem_estado, NULL::integer AS ordem_cidade
    FROM regiao_cte r
    
    UNION ALL

    -- Nível de Estado
    SELECT e.hierarquia, e.ordem_regiao, e.ordem_estado, NULL::integer AS ordem_cidade
    FROM estado_cte e

    UNION ALL

    -- Nível de Cidade
    SELECT c.hierarquia, c.ordem_regiao, c.ordem_estado, c.ordem_cidade
    FROM cidade_cte c
) AS arvore
ORDER BY ordem_regiao, ordem_estado, ordem_cidade
;
