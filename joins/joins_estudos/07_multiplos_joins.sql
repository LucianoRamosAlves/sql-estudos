-- =============================================================================
-- MÚLTIPLOS JOINS - JUNTANDO 3 OU MAIS TABELAS
-- =============================================================================
-- Na vida real, você raramente junta só 2 tabelas.
-- Normalmente precisa de 3, 4, 5 ou mais tabelas para obter os dados completos.
--
-- Exemplo: Pedido → Cliente → Itens do Pedido → Produtos → Categoria
--
-- ⚠️ ORDEM DE EXECUÇÃO DOS JOINS (importante entender!):
--   1. FROM + primerio JOIN
--   2. Resultado desse JOIN + segundo JOIN
--   3. Resultado desse JOIN + terceiro JOIN
--   ... e assim por diante
-- =============================================================================

-- CONFIGURAÇÃO DO BANCO
-- =============================================================================
CREATE DATABASE IF NOT EXISTS estudos_joins;
USE estudos_joins;

DROP TABLE IF EXISTS itens_pedido;
DROP TABLE IF EXISTS pedidos;
DROP TABLE IF EXISTS clientes;
DROP TABLE IF EXISTS produtos;
DROP TABLE IF EXISTS categorias;

-- =============================================================================
-- CENÁRIO COMPLETO: Sistema de E-commerce
-- =============================================================================
-- Vamos criar 5 tabelas relacionadas para praticar múltiplos JOINs
-- =============================================================================

-- 1. Tabela de categorias (nível mais alto)
CREATE TABLE categorias (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    descricao VARCHAR(255)
);

-- 2. Tabela de produtos (pertence a uma categoria)
CREATE TABLE produtos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    preco DECIMAL(10, 2),
    categoria_id INT,
    estoque INT DEFAULT 0,
    FOREIGN KEY (categoria_id) REFERENCES categorias(id)
);

-- 3. Tabela de clientes
CREATE TABLE clientes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    cidade VARCHAR(50),
    estado VARCHAR(2)
);

-- 4. Tabela de pedidos (feitos por um cliente)
CREATE TABLE pedidos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    cliente_id INT NOT NULL,
    data_pedido DATETIME DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'Pendente',
    FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

-- 5. Tabela de itens do pedido (produtos em cada pedido)
CREATE TABLE itens_pedido (
    id INT PRIMARY KEY AUTO_INCREMENT,
    pedido_id INT NOT NULL,
    produto_id INT NOT NULL,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10, 2),  -- Preço no momento da compra
    FOREIGN KEY (pedido_id) REFERENCES pedidos(id),
    FOREIGN KEY (produto_id) REFERENCES produtos(id)
);

-- =============================================================================
-- INSERINDO DADOS DE EXEMPLO
-- =============================================================================

-- Categorias
INSERT INTO categorias (nome, descricao) VALUES
('Eletrônicos',   'Dispositivos e aparelhos eletrônicos'),
('Móveis',        'Móveis para casa e escritório'),
('Roupas',        'Vestuário em geral'),
('Alimentos',     'Comidas e bebidas'),
('Livros',        'Livros e materiais educativos');

-- Produtos
INSERT INTO produtos (nome, preco, categoria_id, estoque) VALUES
('Notebook',      3500.00, 1, 10),
('Mouse',          80.00,  1, 50),
('Teclado',       150.00,  1, 30),
('Monitor',      1200.00,  1, 15),
('Cadeira Gamer', 850.00,  2, 8),
('Mesa Escrivaninha', 450.00, 2, 12),
('Camiseta Polo', 89.90,  3, 100),
('Tênis Running', 299.00,  3, 40),
('Cafeteira',     180.00,  4, 20),
('Livro SQL',      79.90,  5, 60);

-- Clientes
INSERT INTO clientes (nome, email, cidade, estado) VALUES
('Ana Oliveira',  'ana@email.com',    'São Paulo',   'SP'),
('Bruno Santos',  'bruno@email.com',  'Rio de Janeiro','RJ'),
('Carla Lima',    'carla@email.com',  'Belo Horizonte','MG'),
('Daniel Costa',  'daniel@email.com', 'Curitiba',    'PR'),
('Eduarda Souza', 'eduarda@email.com','Porto Alegre', 'RS');

-- Pedidos
INSERT INTO pedidos (cliente_id, data_pedido, status) VALUES
(1, '2024-01-15 10:30:00', 'Entregue'),       -- Pedido 1 - Ana
(2, '2024-01-18 14:00:00', 'Entregue'),       -- Pedido 2 - Bruno
(1, '2024-02-20 09:15:00', 'Enviado'),        -- Pedido 3 - Ana
(3, '2024-03-10 11:00:00', 'Processando'),    -- Pedido 4 - Carla
(4, '2024-03-15 08:30:00', 'Pendente');       -- Pedido 5 - Daniel

-- Itens dos Pedidos
INSERT INTO itens_pedido (pedido_id, produto_id, quantidade, preco_unitario) VALUES
(1, 1, 1, 3500.00),   -- Pedido 1: 1 Notebook
(1, 2, 2, 80.00),     -- Pedido 1: 2 Mouses
(2, 3, 1, 150.00),    -- Pedido 2: 1 Teclado
(2, 5, 1, 850.00),    -- Pedido 2: 1 Cadeira Gamer
(3, 2, 1, 75.00),     -- Pedido 3: 1 Mouse (com desconto)
(3, 7, 2, 89.90),     -- Pedido 3: 2 Camisetas
(4, 9, 1, 180.00),    -- Pedido 4: 1 Cafeteira
(4, 10, 1, 79.90),    -- Pedido 4: 1 Livro SQL
(5, 4, 1, 1200.00);   -- Pedido 5: 1 Monitor


-- =============================================================================
-- EXEMPLO 1: 3 TABELAS - Pedido + Cliente + Itens
-- =============================================================================
-- Informações completas de cada pedido, incluindo cliente e itens
-- =============================================================================

SELECT 
    p.id AS pedido_id,
    p.data_pedido,
    p.status,
    c.nome AS cliente,
    c.cidade,
    i.quantidade,
    i.preco_unitario,
    (i.quantidade * i.preco_unitario) AS subtotal
FROM pedidos p
INNER JOIN clientes c ON p.cliente_id = c.id
INNER JOIN itens_pedido i ON p.id = i.pedido_id
ORDER BY p.id, i.produto_id;

-- RESULTADO (cada linha = 1 item de pedido):
-- +-----------+---------------------+------------+--------------+--------------+------------+---------------+----------+
-- | pedido_id | data_pedido         | status     | cliente      | cidade       | quantidade | preco_unitario| subtotal |
-- +-----------+---------------------+------------+--------------+--------------+------------+---------------+----------+
-- |         1 | 2024-01-15 10:30:00 | Entregue   | Ana Oliveira | São Paulo    |          1 |       3500.00 |  3500.00 |
-- |         1 | 2024-01-15 10:30:00 | Entregue   | Ana Oliveira | São Paulo    |          2 |         80.00 |   160.00 |
-- |         2 | 2024-01-18 14:00:00 | Entregue   | Bruno Santos | Rio de Janeiro|         1 |        150.00 |   150.00 |
-- |         2 | 2024-01-18 14:00:00 | Entregue   | Bruno Santos | Rio de Janeiro|         1 |        850.00 |   850.00 |
-- |       ... | ...                 | ...        | ...          | ...          |       ... |           ... |      ... |
-- +-----------+---------------------+------------+--------------+--------------+------------+---------------+----------+


-- =============================================================================
-- EXEMPLO 2: 4 TABELAS - Adicionando Produtos
-- =============================================================================
-- Agora incluímos o nome do produto em cada item
-- =============================================================================

SELECT 
    p.id AS pedido_id,
    c.nome AS cliente,
    pr.nome AS produto,
    i.quantidade,
    i.preco_unitario,
    (i.quantidade * i.preco_unitario) AS subtotal
FROM pedidos p
INNER JOIN clientes c ON p.cliente_id = c.id
INNER JOIN itens_pedido i ON p.id = i.pedido_id
INNER JOIN produtos pr ON i.produto_id = pr.id
ORDER BY p.id, pr.nome;

-- Agora vemos o nome do produto em vez de apenas IDs


-- =============================================================================
-- EXEMPLO 3: 5 TABELAS - Completo com Categoria
-- =============================================================================
-- A consulta MAIS completa: pedido → cliente → itens → produto → categoria
-- =============================================================================

SELECT 
    p.id AS pedido,
    p.data_pedido,
    c.nome AS cliente,
    c.cidade,
    c.estado,
    pr.nome AS produto,
    cat.nome AS categoria,
    i.quantidade,
    i.preco_unitario,
    (i.quantidade * i.preco_unitario) AS subtotal,
    p.status
FROM pedidos p
INNER JOIN clientes c ON p.cliente_id = c.id
INNER JOIN itens_pedido i ON p.id = i.pedido_id
INNER JOIN produtos pr ON i.produto_id = pr.id
INNER JOIN categorias cat ON pr.categoria_id = cat.id
ORDER BY p.id;

-- EXPERT: 5 tabelas em um único SELECT!
-- +--------+---------------------+--------------+--------------+--------+----------+--------------+------------+---------------+----------+------------+
-- | pedido | data_pedido         | cliente      | cidade       | estado | produto  | categoria    | quantidade | preco_unitario| subtotal | status     |
-- +--------+---------------------+--------------+--------------+--------+----------+--------------+------------+---------------+----------+------------+
-- |      1 | 2024-01-15 10:30:00 | Ana Oliveira | São Paulo   | SP     | Notebook | Eletrônicos  |          1 |       3500.00 |  3500.00 | Entregue   |
-- |      1 | 2024-01-15 10:30:00 | Ana Oliveira | São Paulo   | SP     | Mouse    | Eletrônicos  |          2 |         80.00 |   160.00 | Entregue   |
-- |      2 | 2024-01-18 14:00:00 | Bruno Santos | Rio de Janeiro| RJ  | Teclado  | Eletrônicos  |          1 |        150.00 |   150.00 | Entregue   |
-- |    ... | ...                 | ...          | ...         | ...    | ...      | ...          |        ... |           ... |      ... | ...        |
-- +--------+---------------------+--------------+--------------+--------+----------+--------------+------------+---------------+----------+------------+


-- =============================================================================
-- EXEMPLO 4: LEFT JOINs ENCADEADOS
-- =============================================================================
-- Se alguma informação pode estar faltando, use LEFT JOIN
-- Exemplo: Pedidos que podem não ter itens (raro, mas possível)
-- =============================================================================

-- Inserindo um pedido SEM itens (para demonstração)
INSERT INTO pedidos (cliente_id, data_pedido, status) VALUES
(5, '2024-04-01', 'Cancelado');  -- Pedido 6 - Eduarda, cancelado, sem itens

SELECT 
    p.id AS pedido,
    c.nome AS cliente,
    COALESCE(pr.nome, 'NENHUM ITEM') AS produto,
    i.quantidade,
    i.preco_unitario,
    (i.quantidade * i.preco_unitario) AS subtotal
FROM pedidos p
INNER JOIN clientes c ON p.cliente_id = c.id
LEFT JOIN itens_pedido i ON p.id = i.pedido_id
LEFT JOIN produtos pr ON i.produto_id = pr.id
ORDER BY p.id;

-- RESULTADO: Pedido 6 aparece com "NENHUM ITEM"
-- LEFT JOIN garante que pedidos sem itens ainda aparecem


-- =============================================================================
-- EXEMPLO 5: JOINs COM AGREGAÇÃO (Relatório Completo)
-- =============================================================================
-- Vamos criar um relatório resumido de vendas por cliente
-- =============================================================================

SELECT 
    c.id AS cliente_id,
    c.nome AS cliente,
    c.cidade,
    c.estado,
    COUNT(DISTINCT p.id) AS total_pedidos,    -- Quantos pedidos
    COUNT(i.id) AS total_itens,               -- Quantos itens comprou
    SUM(i.quantidade * i.preco_unitario) AS total_gasto,  -- Valor total
    ROUND(AVG(i.quantidade * i.preco_unitario), 2) AS ticket_medio,  -- Gasto médio por item
    MIN(p.data_pedido) AS primeira_compra,
    MAX(p.data_pedido) AS ultima_compra
FROM clientes c
LEFT JOIN pedidos p ON c.id = p.cliente_id
LEFT JOIN itens_pedido i ON p.id = i.pedido_id
GROUP BY c.id, c.nome, c.cidade, c.estado
ORDER BY total_gasto DESC;

-- RESULTADO:
-- +------------+--------------+--------------+--------+---------------+------------+-------------+-------------+---------------------+---------------------+
-- | cliente_id | cliente      | cidade       | estado | total_pedidos | total_itens| total_gasto | ticket_medio | primeira_compra     | ultima_compra       |
-- +------------+--------------+--------------+--------+---------------+------------+-------------+-------------+---------------------+---------------------+
-- |          1 | Ana Oliveira | São Paulo    | SP     |             2 |          4 |     3810.00 |      952.50 | 2024-01-15 10:30:00 | 2024-02-20 09:15:00 |
-- |          2 | Bruno Santos | Rio de Janeiro| RJ    |             1 |          2 |     1000.00 |      500.00 | 2024-01-18 14:00:00 | 2024-01-18 14:00:00 |
-- |          3 | Carla Lima   | Belo Horizonte| MG    |             1 |          2 |      259.90 |      129.95 | 2024-03-10 11:00:00 | 2024-03-10 11:00:00 |
-- |          4 | Daniel Costa | Curitiba     | PR    |             1 |          1 |     1200.00 |     1200.00 | 2024-03-15 08:30:00 | 2024-03-15 08:30:00 |
-- |          5 | Eduarda Souza| Porto Alegre | RS    |             1 |          0 |        0.00 |        0.00 | 2024-04-01 00:00:00 | 2024-04-01 00:00:00 |
-- +------------+--------------+--------------+--------+---------------+------------+-------------+-------------+---------------------+---------------------+
-- ⚠️ Eduarda aparece com 0 itens (pedido cancelado sem itens)


-- =============================================================================
-- EXEMPLO 6: JOINs COM SUBCONSULTAS
-- =============================================================================
-- Às vezes é melhor fazer uma subconsulta e JOIN com o resultado
-- =============================================================================

-- Quais produtos foram vendidos mais de uma vez?
SELECT 
    pr.nome,
    cat.nome AS categoria,
    total.vendas,
    total.quantidade_total
FROM produtos pr
INNER JOIN categorias cat ON pr.categoria_id = cat.id
INNER JOIN (
    -- Subconsulta: total de vendas por produto
    SELECT 
        produto_id,
        COUNT(*) AS vendas,
        SUM(quantidade) AS quantidade_total
    FROM itens_pedido
    GROUP BY produto_id
    HAVING COUNT(*) >= 1
) total ON pr.id = total.produto_id
ORDER BY total.quantidade_total DESC;

-- Mostra só produtos que já foram vendidos, com total de vendas


-- =============================================================================
-- EXEMPLO 7: JOINs COM DIFERENTES TIPOS MISTURADOS
-- =============================================================================
-- Na mesma query, podemos misturar INNER, LEFT, RIGHT normalmente
-- =============================================================================

SELECT 
    c.nome AS cliente,
    p.id AS pedido,
    p.status,
    pr.nome AS produto,
    i.quantidade
FROM clientes c
INNER JOIN pedidos p ON c.id = p.cliente_id       -- Só clientes com pedido
LEFT JOIN itens_pedido i ON p.id = i.pedido_id     -- Todos os pedidos (mesmo sem itens)
LEFT JOIN produtos pr ON i.produto_id = pr.id      -- Todos os itens (mesmo sem produto)
WHERE p.status != 'Cancelado'                      -- Filtro após todos os joins
ORDER BY c.nome, p.id;


-- =============================================================================
-- DICAS IMPORTANTES PARA MÚLTIPLOS JOINS
-- =============================================================================
/*
╔═══════════════════════════════════════════════════════════════════╗
║                   MÚLTIPLOS JOINS - DICAS                         ║
╠═══════════════════════════════════════════════════════════════════╣
║                                                                  ║
║  1. ORDEM IMPORTA!                                               ║
║     - O MySQL processa os JOINs na ordem que você escreve        ║
║     - Comece com a tabela "principal" (FROM)                    ║
║     - Depois adicione as tabelas relacionadas                    ║
║                                                                  ║
║  2. ESCOLHA O TIPO CERTO:                                       ║
║     - INNER JOIN: só dados que existem em AMBAS                  ║
║     - LEFT JOIN: mantenha todos da esquerda                     ║
║     - Mude o tipo conforme necessário em cada JOIN              ║
║                                                                  ║
║  3. NOMEIE COLUNAS UNICAMENTE:                                   ║
║     - Se duas tabelas têm "nome", use alias:                     ║
║       c.nome AS cliente_nome, pr.nome AS produto_nome           ║
║                                                                  ║
║  4. USE ALIAS SIGNIFICATIVOS:                                   ║
║     - c = clientes, p = pedidos, pr = produtos                 ║
║     - cat = categorias, i = itens_pedido                        ║
║                                                                  ║
║  5. TESTE COM LIMITE:                                            ║
║     - Adicione LIMIT 10 enquanto desenvolve                      ║
║     - Remova só quando tiver certeza da query                   ║
║                                                                  ║
║  6. CUIDADO COM AGREGAÇÕES:                                      ║
║     - LEFT JOIN pode gerar NULLs que afetam SUM/COUNT           ║
║     - Use COALESCE(valor, 0) para evitar NULLs                  ║
║                                                                  ║
║  7. PERFORMACE:                                                  ║
║     - Quanto mais JOINs, mais lento                              ║
║     - Certifique-se de que as colunas do ON têm ÍNDICES          ║
║     - Evite JOINs desnecessários                                 ║
╚═══════════════════════════════════════════════════════════════════╝
*/

-- LIMPEZA (opcional)
-- DROP DATABASE IF EXISTS estudos_joins;
