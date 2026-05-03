USE exemplos_distinct;

SELECT
    nome,
    idade,
    IF(idade <= 30, 'Adulto', 'Idoso') AS status
FROM
    exemplos;


-- varios IFs
SELECT nome,
    idade,
    CASE
        WHEN idade >= 40 THEN 'cobertura A'
        WHEN idade >= 30 THEN 'cobertura B'
        ELSE 'cobertura C'
    END AS cobertura
FROM exemplos;

SELECT VERSION();