CREATE VIEW cidades AS
WITH RECURSIVE arvore AS (
    -- Passo inicial: selecionar as regiões
    SELECT 
        id AS id_regiao,
        nome AS nome_regiao,
        NULL::integer AS id_estado,
        NULL::varchar AS nome_estado,
        NULL::integer AS id_cidade,
        NULL::varchar AS nome_cidade,
        1 AS nivel
    FROM 
        regiao

    UNION ALL

    -- Passo intermediário: selecionar os estados a partir das regiões
    SELECT
        a.id_regiao,
        a.nome_regiao,
        e.id AS id_estado,
        e.nome AS nome_estado,
        NULL::integer AS id_cidade,
        NULL::varchar AS nome_cidade,
        2 AS nivel
    FROM 
        arvore a
        JOIN estado e ON e.idregiao = a.id_regiao
    WHERE 
        a.nivel = 1

    UNION ALL

    -- Passo final: selecionar as cidades a partir dos estados
    SELECT
        a.id_regiao,
        a.nome_regiao,
        a.id_estado,
        a.nome_estado,
        c.id AS id_cidade,
        c.nome AS nome_cidade,
        3 AS nivel
    FROM 
        arvore a
        JOIN cidade c ON c.idestado = a.id_estado
    WHERE 
        a.nivel = 2
)
-- Ordena pela hierarquia e exibe a estrutura
SELECT
    COALESCE(nome_regiao, '') AS regiao,
    COALESCE(nome_estado, '') AS estado,
    COALESCE(nome_cidade, '') AS cidade,
    nivel
FROM 
    arvore
ORDER BY 
    id_regiao, id_estado, id_cidade
;

