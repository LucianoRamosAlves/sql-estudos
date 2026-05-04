-- Criando a base de dados
CREATE DATABASE exemplo_views;

-- Selecionando a base de dados
USE exemplo_views;

-- Criando a tabela de clientes
CREATE TABLE clientes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(50) NOT NULL,
    email VARCHAR(50) NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Criando a tabela de pedidos
CREATE TABLE pedidos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_cliente INT,
    produto VARCHAR(50) NOT NULL,
    quantidade INT NOT NULL,
    valor_total DECIMAL(10,2) NOT NULL,
    data_pedido TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id)
);

-- Criando a view de clientes 
-- posso mostrar somente o que eu quero
CREATE VIEW v_clientes AS
SELECT nome AS cliente,
       email AS email,
       telefone AS telefone
FROM clientes


DROP VIEW v_clientes;

-- Inserindo dados na tabela de clientes
INSERT INTO clientes (nome, email, telefone) VALUES
    ('João', 'joao@example.com', '11111111111'),
    ('Maria', 'maria@example.com', '22222222222'),
    ('Pedro', 'pedro@example.com', '33333333333');

-- Inserindo dados na tabela de pedidos
INSERT INTO pedidos (id_cliente, produto, quantidade, valor_total) VALUES
    (1, 'Pizza', 2, 50.00),
    (2, 'Sobremesa', 3, 30.00),
    (3, 'Bolo', 1, 20.00);

-- tipo eu quardo a bisca
-- Consultando a view de clientes com pedidos
SELECT * FROM v_clientes;

-- Atualizando dados na tabela de clientes
UPDATE clientes SET email = 'joao@outro.com' WHERE id = 1;

-- Deletando dados na tabela de clientes
DELETE FROM clientes WHERE id = 3;

-- Desativando a view de clientes
ALTER VIEW v_clientes DISABLED;