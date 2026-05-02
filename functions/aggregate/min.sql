SELECT MIN(populacao) FROM continentes;

SELECT continente_nome AS continente,
    populacao AS menor_populacao
FROM continentes
WHERE populacao =(
    SELECT MIN(populacao)
    FROM continentes
);