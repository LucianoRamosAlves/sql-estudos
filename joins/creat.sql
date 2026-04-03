-- Tabela: clientes
CREATE TABLE clientes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    cidade VARCHAR(50)
);

-- Tabela: pedidos
CREATE TABLE pedidos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    cliente_id INT NOT NULL,
    data_pedido DATE,
    total DECIMAL(10, 2),
    FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

-- Tabela: produtos
CREATE TABLE produtos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    preco DECIMAL(10, 2),
    categoria VARCHAR(50)
);

-- Tabela: itens_pedido
CREATE TABLE itens_pedido (
    id INT PRIMARY KEY AUTO_INCREMENT,
    pedido_id INT NOT NULL,
    produto_id INT NOT NULL,
    quantidade INT,
    preco_unitario DECIMAL(10, 2),
    FOREIGN KEY (pedido_id) REFERENCES pedidos(id),
    FOREIGN KEY (produto_id) REFERENCES produtos(id)
);

-- Inserindo dados de exemplo
INSERT INTO clientes VALUES (1, 'João Silva', 'joao@email.com', 'São Paulo');
INSERT INTO clientes VALUES (2, 'Maria Santos', 'maria@email.com', 'Rio de Janeiro');
INSERT INTO clientes VALUES (3, 'Pedro Costa', 'pedro@email.com', 'Belo Horizonte');

INSERT INTO produtos VALUES (1, 'Notebook', 2500.00, 'Eletrônicos');
INSERT INTO produtos VALUES (2, 'Mouse', 50.00, 'Eletrônicos');
INSERT INTO produtos VALUES (3, 'Teclado', 150.00, 'Eletrônicos');

INSERT INTO pedidos VALUES (1, 1, '2024-01-15', 2550.00);
INSERT INTO pedidos VALUES (2, 2, '2024-01-20', 200.00);
INSERT INTO pedidos VALUES (3, 1, '2024-02-05', 150.00);

INSERT INTO itens_pedido VALUES (1, 1, 1, 1, 2500.00);
INSERT INTO itens_pedido VALUES (2, 1, 2, 1, 50.00);
INSERT INTO itens_pedido VALUES (3, 2, 2, 4, 50.00);
INSERT INTO itens_pedido VALUES (4, 3, 3, 1, 150.00);