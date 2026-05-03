-- remove os nulos
SELECT COALESCE(NULL, 1, 2, 3);

-- retorna o primeiro nulo
SELECT COALESCE(NULL, 1, NULL, 3);

-- se for null substitui por outro valor
-- Esta consulta substitui valores NULL por 'Outro Valor'
SELECT
    COALESCE(coluna1, 'Outro Valor') AS coluna1,
    COALESCE(coluna2, 'Outro Valor') AS coluna2,
    ...
FROM
    tabela;