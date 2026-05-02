SELECT AVG(populacao) 
FROM continentes;


-- a função AVG() retorna a media de uma coluna

-- aqui retorno os abaixo da media de populacao
SELECT continente_nome AS continente,
    populacao AS media_populacao
FROM continentes
WHERE populacao < (
    SELECT AVG(populacao)
    FROM continentes
);

-- aqui retorno os acima da media de populacao
SELECT continente_nome AS continente,
    populacao AS media_populacao
FROM continentes
WHERE populacao > (
    SELECT AVG(populacao)
    FROM continentes
);


-- aqui retorno os abaixo da media de populacao de Europa, Oceania e América do Sul
SELECT continente_nome AS continente,
    populacao AS media_populacao
FROM continentes
WHERE populacao < (
    SELECT AVG(populacao)
    FROM continentes
    WHERE continente_nome IN ('Europa', 'Oceania', 'América do Sul')
);