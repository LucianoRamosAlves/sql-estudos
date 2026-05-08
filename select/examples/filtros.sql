USE sports;
-- tenho o where e o having

-- o where uso antes das agregação ou seja quando quero filtrar minha tabela seca

-- o having uso depois das agregações

SELECT
    pais,
    SUM(score) AS total_score
FROM player -- 1 passo
WHERE score > 50 -- 2 passo
GROUP BY pais -- 3 passo
HAVING total_score > 100; -- 4 passo

