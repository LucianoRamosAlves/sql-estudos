SELECT DATABASE();

USE word;

SELECT continente_nome,
    FORMAT(populacao, 0) AS populacao
FROM continentes
ORDER BY populacao DESC;