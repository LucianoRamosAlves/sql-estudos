-- ============================================================
-- PROJETO LOJA - ESTRUTURA COMPLETA DO BANCO DE DADOS
-- ============================================================
-- Este arquivo cria TODO o banco de dados do zero.
-- Execute ele primeiro!
-- ============================================================

-- ============================================================
-- PASSO 1: CRIAR O BANCO DE DADOS
-- ============================================================
-- CREATE DATABASE cria um novo banco
-- Se já existir, DROP DATABASE IF EXISTS remove e recria

DROP DATABASE IF EXISTS loja;
CREATE DATABASE loja;

-- USE seleciona o banco que vamos trabalhar
USE loja;

-- ============================================================
-- PASSO 2: CRIAR AS TABELAS (NA ORDEM CORRETA!)
-- ============================================================
-- IMPORTANTE: Tabelas com chaves estrangeiras (FK) devem ser
-- criadas DEPOIS das tabelas que elas referenciam.
-- 
-- ORDEM CORRETA:
-- 1. clientes (não depende de ninguém)
-- 2. categorias (não depende de ninguém)
-- 3. produtos (depende de categorias)
-- 4. pedidos (depende de clientes)
-- 5. itens_pedido (depende de pedidos e produtos)
-- ============================================================

-- ----------------------------
-- TABELA 1: clientes
-- ----------------------------
-- Guarda os dados dos clientes da loja
CREATE TABLE clientes (
    clientes_id INT PRIMARY KEY AUTO_INCREMENT,  -- ID único, auto incrementado
    nome VARCHAR(50) NOT NULL                    -- Nome do cliente (obrigatório)
);

-- ----------------------------
-- TABELA 2: categorias
-- ----------------------------
-- Guarda as categorias dos produtos
CREATE TABLE categorias (
    categorias_id INT PRIMARY KEY AUTO_INCREMENT,
    nome_categoria VARCHAR(50) NOT NULL
);

-- ----------------------------
-- TABELA 3: produtos
-- ----------------------------
-- Guarda os produtos da loja
-- FK para categorias (um produto pertence a uma categoria)
CREATE TABLE produtos (
    produtos_id INT PRIMARY KEY AUTO_INCREMENT,
    nome_produto VARCHAR(50) NOT NULL,
    preco DECIMAL(10, 2) NOT NULL,              -- Preço com 2 casas decimais
    categorias_id INT,
    FOREIGN KEY (categorias_id) REFERENCES categorias(categorias_id)
);

-- ----------------------------
-- TABELA 4: pedidos
-- ----------------------------
-- Guarda os pedidos feitos pelos clientes
-- FK para clientes (um pedido pertence a um cliente)
CREATE TABLE pedidos (
    pedidos_id INT PRIMARY KEY AUTO_INCREMENT,
    clientes_id INT,
    data_pedido DATE NOT NULL,
    FOREIGN KEY (clientes_id) REFERENCES clientes(clientes_id)
);

-- ----------------------------
-- TABELA 5: itens_pedido (TABELA ASSOCIATIVA)
-- ----------------------------
-- Resolve o relacionamento MUITOS-PARA-MUITOS entre
-- pedidos e produtos.
-- 
-- Um pedido pode ter vários produtos
-- Um produto pode estar em vários pedidos
-- 
-- Chave primária COMPOSTA: (pedidos_id, produtos_id)
CREATE TABLE itens_pedido (
    pedidos_id INT,
    produtos_id INT,
    quantidade INT DEFAULT 1,                    -- Quantidade do produto no pedido
    PRIMARY KEY (pedidos_id, produtos_id),
    FOREIGN KEY (pedidos_id) REFERENCES pedidos(pedidos_id),
    FOREIGN KEY (produtos_id) REFERENCES produtos(produtos_id)
);

-- ============================================================
-- PASSO 3: INSERIR DADOS (SEEDS)
-- ============================================================

-- Inserindo clientes
INSERT INTO clientes (nome) VALUES 
    ('João'),
    ('Maria'),
    ('Pedro'),
    ('Ana'),
    ('Julia'),
    ('Rhafa'),
    ('Miguel'),
    ('Ana');  -- Nome repetido proposital! IDs diferentes.

-- Inserindo categorias
INSERT INTO categorias (nome_categoria) VALUES 
    ('Alimentos'),
    ('Bebidas'),
    ('Limpeza'),
    ('Higiene');

-- Inserindo produtos
INSERT INTO produtos (nome_produto, preco, categorias_id) VALUES 
    ('Pizza', 10.99, 1),           -- Alimentos
    ('Suco', 2.99, 2),             -- Bebidas
    ('Papel Higiênico', 5.99, 3),  -- Limpeza
    ('Shampoo', 9.99, 4);          -- Higiene

-- Inserindo pedidos
INSERT INTO pedidos (clientes_id, data_pedido) VALUES 
    (1, '2023-01-01'),  -- João
    (2, '2023-01-02'),  -- Maria
    (3, '2023-01-03'),  -- Pedro
    (4, '2023-01-04'),  -- Ana
    (5, '2023-01-05'),  -- Julia
    (6, '2023-01-06'),  -- Rhafa
    (7, '2023-01-07'),  -- Miguel
    (8, '2023-01-08');  -- Ana (outro ID)

-- Inserindo itens dos pedidos (tabela associativa)
INSERT INTO itens_pedido (pedidos_id, produtos_id, quantidade) VALUES 
    (1, 1, 2),  -- Pedido 1: 2 Pizzas
    (2, 2, 3),  -- Pedido 2: 3 Sucos
    (3, 3, 1),  -- Pedido 3: 1 Papel Higiênico
    (4, 4, 2),  -- Pedido 4: 2 Shampoos
    (5, 1, 1),  -- Pedido 5: 1 Pizza
    (6, 2, 5),  -- Pedido 6: 5 Sucos
    (7, 3, 2),  -- Pedido 7: 2 Papéis Higiênicos
    (8, 4, 3);  -- Pedido 8: 3 Shampoos

-- ============================================================
-- PRONTO! O BANCO ESTÁ CRIADO E POPULADO!
-- Agora execute os outros arquivos na ordem:
-- 01_basico.sql → 02_filtros.sql → 03_funcoes.sql → 04_joins.sql
-- ============================================================