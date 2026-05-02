SELECT DATABASE();

-- a função COUNT() retorna o total de linhas de uma tabela

SELECT * FROM continentes;

SELECT COUNT(*) FROM continentes;


SELECT COUNT(*)
FROM continentes 
WHERE populacao > 500000000;