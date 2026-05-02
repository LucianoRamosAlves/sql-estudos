SELECT MAX(populacao) FROM continentes;

SELECT continente_nome AS continente,
    populacao AS maior_populacao
FROM continentes
WHERE populacao =(
    SELECT MAX(populacao)
    FROM continentes
);