CREATE DATABASE sport;

USE sport;

CREATE TABLE if not exists player (
    id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(255) NOT NULL,
    pais VARCHAR(255) NOT NULL,
    score INT NOT NULL
);

INSERT INTO player (nome, pais, score) VALUES
    ('Rother', 'Brasil', 100),
    ('Maria', 'Argentina', 90),
    ('Naiara', 'Brasil', 80),
    ('Gustavo', 'Francia', 70),
    ('Zidane', 'Francia', 60),
    ('Rother', 'Brasil', 50),
    ('Maria', 'Argentina', 40),
    ('Naiara', 'Brasil', 30),
    ('Gustavo', 'Francia', 20),
    ('Zidane', 'Francia', 10),
    ('Raul', 'Espanha', 0);

SELECT nome,
    pais,
    score
FROM player
WHERE pais = 'Brasil';

SELECT nome,
    pais,
    score
FROM player
ORDER BY score ASC;

-- ordenando por mais de uma coluna
SELECT nome,
    pais,
    score
FROM player
ORDER BY pais ASC,
    score DESC;


-- aqui eu uso grup by tipo ele pega todos valores repitidos e comprime em uma, lembra tem  que esta no select tambem
SELECT
    pais,
    SUM(score) AS total_score
FROM player
GROUP BY pais
ORDER BY total_score DESC;

SELECT
    nome,
    SUM(score) AS total_score
FROM player
GROUP BY nome
ORDER BY total_score DESC;



