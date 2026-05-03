
-- Criando a base de dados
CREATE DATABASE exemplos_distinct;

SELECT DATABASE(); -- mostra qual a base de dados esta selecionada
 
-- Selecionando a base de dados
USE exemplos_distinct;

-- Criando a tabela de exemplo
CREATE TABLE exemplos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(50),
    idade INT
);

-- Inserindo dados na tabela
INSERT INTO exemplos (nome, idade) VALUES
    ('João', 25),
    ('Maria', 30),
    ('João', 35),
    ('Ana', 25),
    ('Pedro', 40);

-- Consulta sem a cláusula DISTINCT
SELECT * FROM exemplos;

-- Consulta com a cláusula DISTINCT
-- remove as linhas duplicadas
SELECT DISTINCT nome FROM exemplos;

-- Consulta com a cláusula DISTINCT e ordenação
SELECT DISTINCT nome FROM exemplos ORDER BY nome;

-- Consulta com a cláusula DISTINCT e agrupamento
SELECT DISTINCT nome, MAX(idade) AS maior_idade FROM exemplos GROUP BY nome;

-- posso usar o count para contar valores unicos, sem duplicados
SELECT COUNT(DISTINCT nome) AS quantidade
FROM exemplos;
