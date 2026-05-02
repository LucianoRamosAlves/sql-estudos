CREATE DATABASE mercado;
USE mercado;

CREATE TABLE ordem (
    id INT PRIMARY KEY AUTO_INCREMENT,
    cliente VARCHAR(50),
    produto VARCHAR(50),
    categorias VARCHAR(50),
    preco DECIMAL(10, 2),
     quantidade INT,
    data_pedido DATE
);

INSERT INTO ordem (cliente, produto, categorias, preco, quantidade, data_pedido) VALUES
    ('Ana', 'Pizza', 'Alimentos', 10.99, 1, '2023-01-01'),
    ('Pedro', 'Suco', 'Bebidas', 2.99, 2, '2023-01-02'),
    ('Rafael', 'Papel Higiênico', 'Limpeza', 5.99, 1, '2023-01-03'),
    ('Pedro', 'Shampoo', 'Higiene', 9.99, 1, '2023-01-04'),
    ('Vitor', 'Pizza', 'Alimentos', 10.99, 1, '2023-01-05'),
    ('Vitor', 'Suco', 'Bebidas', 2.99, 2, '2023-01-06'),
    ('Ana', 'Papel Higiênico', 'Limpeza', 5.99, 1, '2023-01-07'),
    ('Ana', 'Shampoo', 'Higiene', 9.99, 1, '2023-01-08');

-- importante posso usar group by com qualquer funcao aggregate COMMENT

SELECT cliente , COUNT(*) AS quantidade_pedidos 
FROM ordem 
GROUP BY cliente;

-- siga esse padrão sempre -- acima --
-- SELECT coluna1, funcao_agregada(coluna2) FROM tabela GROUP BY coluna1

SELECT * FROM ordem;
-- total de pedidos por cliente
SELECT cliente, 
    SUM(preco * quantidade) AS total_gasto
FROM ordem
GROUP BY cliente;

-- total de pedidos por categoria
SELECT SUM(preco * quantidade) AS total_gasto
FROM ordem;


-- total de pedidos por categoria
SELECT categorias, 
    SUM(preco * quantidade) AS total_gasto
FROM ordem
GROUP BY categorias;

-- media dos precos COMMENT
SELECT AVG(preco) AS media_precos
FROM ordem

-- produto mais vendido
SELECT produto, 
    SUM(quantidade) AS total_vendido
FROM ordem
GROUP BY produto
ORDER BY total_vendido DESC
LIMIT 1;

-- produto mais vendido por categoria
SELECT categorias, 
    produto, 
    SUM(quantidade) AS total_vendido
FROM ordem
GROUP BY categorias, produto
ORDER BY total_vendido DESC
LIMIT 2;

-- produto mais caro
SELECT produto,
    preco
FROM ordem
WHERE preco = (SELECT MAX(preco) FROM ordem )
LIMIT 1;

-- pedidos depois de 2023-01-05
SELECT *
FROM ordem
WHERE data_pedido > '2023-01-05';

-- clientes que gastaram mais de 20 reais
SELECT cliente, 
    SUM(preco * quantidade) AS total_gasto
FROM ordem
GROUP BY cliente
HAVING total_gasto < 20;

-- clientes que gastaram acima da media
SELECT cliente, 
    SUM(preco * quantidade) AS total_gasto
FROM ordem
GROUP BY cliente
HAVING total_gasto > (SELECT AVG(preco * quantidade) FROM ordem);