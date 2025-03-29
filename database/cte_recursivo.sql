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

    -- Passo intermediário: selecionar os estados
    SELECT
        r.id_regiao,
        r.nome_regiao,
        e.id AS id_estado,
        e.nome AS nome_estado,
        NULL::integer AS id_cidade,
        NULL::varchar AS nome_cidade,
        2 AS nivel
    FROM
        arvore r
        JOIN estado e ON e.idregiao = r.id_regiao
    WHERE
        r.nivel = 1

    UNION ALL

    -- Passo final: selecionar as cidades
    SELECT
        r.id_regiao,
        r.nome_regiao,
        r.id_estado,
        r.nome_estado,
        c.id AS id_cidade,
        c.nome AS nome_cidade,
        3 AS nivel
    FROM
        arvore ar
        JOIN cidade c ON c.idestado = ar.id_estado
    WHERE
        ar.nivel = 2
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


