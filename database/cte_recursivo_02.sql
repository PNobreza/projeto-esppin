DROP VIEW IF EXISTS cidades;

CREATE VIEW cidades AS
-- CTEs para cada nível, com uma coluna única que representa a hierarquia
WITH regiao_cte AS (
    SELECT 
        id AS id_regiao,
        'Regiao: ' || nome AS hierarquia
    FROM
        regiao
    ORDER BY id
),
estado_cte AS (
    SELECT 
        e.id AS id_estado,
        e.idregiao,
        '   Estado: ' || e.nome AS hierarquia
    FROM 
        estado e
    ORDER BY e.idregiao, e.id
),
cidade_cte AS (
    SELECT 
        c.id AS id_cidade,
        c.idestado,
        '      Cidade: ' || c.nome AS hierarquia
    FROM 
        cidade c
    ORDER BY c.idestado, c.id
)

-- Construindo a árvore com joins em cada nível
SELECT hierarquia
FROM (
    -- Nível de Região
    SELECT r.hierarquia, r.id_regiao, NULL::integer AS id_estado, NULL::integer AS id_cidade
    FROM regiao_cte r
    
    UNION ALL

    -- Nível de Estado
    SELECT e.hierarquia, e.idregiao AS id_regiao, e.id_estado, NULL::integer AS id_cidade
    FROM estado_cte e

    UNION ALL

    -- Nível de Cidade
    SELECT c.hierarquia, e.idregiao AS id_regiao, e.id_estado, c.id_cidade
    FROM cidade_cte c
    JOIN estado_cte e ON e.id_estado = c.idestado
) AS arvore
ORDER BY id_regiao, id_estado, id_cidade
;
