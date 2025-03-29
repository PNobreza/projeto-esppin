DROP VIEW IF EXISTS cidades;

CREATE VIEW cidades AS
-- CTEs para cada nível, com colunas de ordenação adicionais
WITH regiao_cte AS (
    SELECT 
        id AS id_regiao,
        'Regiao: ' || nome AS hierarquia,
        id * 10000 AS ch -- Coluna de ordenação
    FROM
        regiao
),
estado_cte AS (
    SELECT 
        e.id AS id_estado,
        e.idregiao,
        '   Estado: ' || e.nome AS hierarquia,
        (r.id * 10000) + (e.id * 1000) AS ch -- Coluna de ordenação para estado
    FROM 
        estado e
    JOIN 
        regiao r ON r.id = e.idregiao
    ORDER BY e.idregiao
),
cidade_cte AS (
    SELECT 
        c.id AS id_cidade,
        c.idestado,
        '      Cidade: ' || c.nome AS hierarquia,
        (r.id * 10000) + (e.id * 1000) + (c.id * 100) AS ch -- Coluna de ordenação para cidade
    FROM
        cidade c
    JOIN
        estado e ON e.id = c.idestado
    JOIN
        regiao r ON r.id = e.idregiao
    ORDER BY e.idregiao, c.idestado
)

-- Construindo a árvore com joins em cada nível
SELECT ch, hierarquia
FROM (
    -- Nível de Região
    SELECT r.hierarquia, r.ch
    FROM regiao_cte r
    
    UNION ALL

    -- Nível de Estado
    SELECT e.hierarquia, e.ch
    FROM estado_cte e

    UNION ALL

    -- Nível de Cidade
    SELECT c.hierarquia, c.ch
    FROM cidade_cte c
) AS arvore
ORDER BY ch
;
