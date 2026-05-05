-- =============================================================================
-- RIGHT JOIN - TODOS OS REGISTROS DA TABELA DA DIREITA
-- =============================================================================
-- O RIGHT JOIN é o INVERSO do LEFT JOIN.
-- Retorna TODOS os registros da tabela da DIREITA (a segunda)
-- e apenas os registros CORRESPONDENTES da tabela da ESQUERDA.
--
--      Tabela A    RIGHT JOIN  Tabela B
--      ┌────────┐               ┌────────┐
--      │        │    JUNÇÃO     │  BBBB  │
--      │  AAAA  │◄──────────────│  BBBB  │
--      │        │               │  BBBB  │ ← NULL
--      └────────┘               └────────┘
--               ╔══════════════════╗
--               ║   RESULTADO:     ║
--               ║  TUDO DE B +    ║
--               ║  CORRESP. DE A  ║
--               ╚══════════════════╝
--
-- ⚠️ NOTA IMPORTANTE: RIGHT JOIN é menos usado porque muitos
--    preferem simplesmente inverter a ordem das tabelas e usar LEFT JOIN.
--    LEFT JOIN A ON ... = RIGHT JOIN B ON ...
-- =============================================================================

-- CONFIGURAÇÃO DO BANCO
-- =============================================================================
CREATE DATABASE IF NOT EXISTS estudos_joins;
USE estudos_joins;

DROP TABLE IF EXISTS itens_pedido;
DROP TABLE IF EXISTS pedidos;
DROP TABLE IF EXISTS clientes;
DROP TABLE IF EXISTS produtos;

-- =============================================================================
-- EXEMPLO PRÁTICO: CATÁLOGO DE PRODUTOS
-- =============================================================================
-- Imagine um sistema de e-commerce onde queremos ver:
-- - Todos os produtos (mesmo os que nunca foram vendidos)
-- - Todos os pedidos associados a esses produtos
-- =============================================================================

CREATE TABLE produtos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    preco DECIMAL(10, 2),
    categoria VARCHAR(50),
    estoque INT DEFAULT 0
);

CREATE TABLE clientes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL
);

CREATE TABLE pedidos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    cliente_id INT NOT NULL,
    data_pedido DATE,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

CREATE TABLE itens_pedido (
    id INT PRIMARY KEY AUTO_INCREMENT,
    pedido_id INT NOT NULL,
    produto_id INT NOT NULL,
    quantidade INT,
    FOREIGN KEY (pedido_id) REFERENCES pedidos(id),
    FOREIGN KEY (produto_id) REFERENCES produtos(id)
);

-- Inserindo dados
INSERT INTO produtos (nome, preco, categoria, estoque) VALUES
('Notebook', 2500.00, 'Eletrônicos', 10),
('Mouse', 50.00, 'Eletrônicos', 50),
('Teclado', 150.00, 'Eletrônicos', 30),
('Monitor', 1200.00, 'Eletrônicos', 15),
('Cadeira Gamer', 800.00, 'Móveis', 5),
('Headset', 200.00, 'Áudio', 20),         -- Este nunca será vendido nos exemplos
('Webcam', 180.00, 'Eletrônicos', 12);     -- Este também não

INSERT INTO clientes (nome) VALUES
('Ana Oliveira'),
('Bruno Santos'),
('Carla Lima');

INSERT INTO pedidos (cliente_id, data_pedido) VALUES
(1, '2024-01-15'),  -- Pedido 1 - Ana
(2, '2024-01-18'),  -- Pedido 2 - Bruno
(1, '2024-02-20'),  -- Pedido 3 - Ana
(3, '2024-03-10');  -- Pedido 4 - Carla

INSERT INTO itens_pedido (pedido_id, produto_id, quantidade) VALUES
(1, 1, 1),   -- Ana comprou 1 Notebook
(1, 2, 2),   -- Ana comprou 2 Mouses
(2, 3, 1),   -- Bruno comprou 1 Teclado
(3, 2, 1),   -- Ana comprou 1 Mouse
(4, 4, 2);   -- Carla comprou 2 Monitores


-- =============================================================================
-- EXEMPLO 1: RIGHT JOIN - Todos os produtos com vendas
-- =============================================================================
-- Queremos: TODOS os produtos, e se foram vendidos, mostrar a venda
-- =============================================================================

SELECT 
    p.nome AS produto,
    p.preco,
    ip.quantidade,
    pe.id AS pedido_id
FROM itens_pedido ip
RIGHT JOIN produtos p ON ip.produto_id = p.id;

-- RESULTADO ESPERADO:
-- +----------------+--------+------------+-----------+
-- | produto        | preco  | quantidade | pedido_id |
-- +----------------+--------+------------+-----------+
-- | Notebook       | 2500.00|          1 |         1 |
-- | Mouse          | 50.00  |          2 |         1 |
-- | Mouse          | 50.00  |          1 |         3 |
-- | Teclado        | 150.00 |          1 |         2 |
-- | Monitor        | 1200.00|          2 |         4 |
-- | Cadeira Gamer  | 800.00 |       NULL |      NULL | ← Produto NÃO vendido!
-- | Headset        | 200.00 |       NULL |      NULL | ← Produto NÃO vendido!
-- | Webcam         | 180.00 |       NULL |      NULL | ← Produto NÃO vendido!
-- +----------------+--------+------------+-----------+
-- Headset e Webcam aparecem mesmo sem terem sido vendidos!


-- =============================================================================
-- EXEMPLO 2: MESMO RESULTADO COM LEFT JOIN
-- =============================================================================
-- RIGHT JOIN produtos p ON ... é EQUIVALENTE a:
-- LEFT JOIN itens_pedido ip ON ...
-- Basta inverter a ordem das tabelas
-- =============================================================================

-- LEFT JOIN equivalente (mais comum/legível):
SELECT 
    p.nome AS produto,
    p.preco,
    ip.quantidade,
    pe.id AS pedido_id
FROM produtos p
LEFT JOIN itens_pedido ip ON ip.produto_id = p.id;

-- Exatamente o MESMO resultado!
-- Por isso RIGHT JOIN é menos usado - sempre dá pra trocar por LEFT JOIN


-- =============================================================================
-- EXEMPLO 3: ENCONTRANDO PRODUTOS NUNCA VENDIDOS
-- =============================================================================
-- Usando RIGHT JOIN para achar "órfãos" na tabela da direita
-- =============================================================================

SELECT 
    p.*
FROM itens_pedido ip
RIGHT JOIN produtos p ON ip.produto_id = p.id
WHERE ip.id IS NULL;

-- RESULTADO:
-- +----+---------------+--------+-------------+---------+
-- | id | nome          | preco  | categoria   | estoque |
-- +----+---------------+--------+-------------+---------+
-- |  5 | Cadeira Gamer | 800.00 | Móveis      |       5 |
-- |  6 | Headset       | 200.00 | Áudio       |      20 |
-- |  7 | Webcam        | 180.00 | Eletrônicos |      12 |
-- +----+---------------+--------+-------------+---------+
-- Produtos que estão no catálogo mas nunca foram vendidos


-- =============================================================================
-- EXEMPLO 4: RIGHT JOIN COM WHERE
-- =============================================================================
-- CUIDADO: WHERE na coluna da esquerda pode eliminar linhas!
-- =============================================================================

-- ERRO COMUM: filtrar produtos caros no WHERE
-- Isto VAI eliminar produtos sem venda porque quantidade será NULL
SELECT 
    p.nome,
    p.preco,
    ip.quantidade
FROM itens_pedido ip
RIGHT JOIN produtos p ON ip.produto_id = p.id
WHERE ip.quantidade >= 2;  -- Isso elimina NULLs e produtos não vendidos!

-- RESULTADO (perdeu Headset, Webcam, Cadeira Gamer):
-- +---------+--------+------------+
-- | nome    | preco  | quantidade |
-- +---------+--------+------------+
-- | Mouse   | 50.00  |          2 |
-- | Monitor | 1200.00|          2 |
-- +---------+--------+------------+

-- CORREÇÃO: precisa incluir NULL no WHERE
SELECT 
    p.nome,
    p.preco,
    ip.quantidade
FROM itens_pedido ip
RIGHT JOIN produtos p ON ip.produto_id = p.id
WHERE (ip.quantidade >= 2 OR ip.quantidade IS NULL);

-- Ou melhor: filtre no ON em vez de WHERE
SELECT 
    p.nome,
    p.preco,
    ip.quantidade
FROM itens_pedido ip
RIGHT JOIN produtos p ON ip.produto_id = p.id AND ip.quantidade >= 2;


-- =============================================================================
-- EXEMPLO 5: RIGHT JOIN COM AGRUPAMENTO
-- =============================================================================
-- Quantidade de vezes que cada produto foi vendido
-- =============================================================================

SELECT 
    p.nome AS produto,
    p.categoria,
    COALESCE(SUM(ip.quantidade), 0) AS unidades_vendidas,
    COALESCE(COUNT(ip.id), 0) AS vezes_vendido
FROM itens_pedido ip
RIGHT JOIN produtos p ON ip.produto_id = p.id
GROUP BY p.id, p.nome, p.categoria
ORDER BY unidades_vendidas DESC;

-- RESULTADO:
-- +----------------+-------------+-------------------+---------------+
-- | produto        | categoria   | unidades_vendidas | vezes_vendido |
-- +----------------+-------------+-------------------+---------------+
-- | Monitor        | Eletrônicos |                 2 |             1 |
-- | Mouse          | Eletrônicos |                 3 |             2 |
-- | Notebook       | Eletrônicos |                 1 |             1 |
-- | Teclado        | Eletrônicos |                 1 |             1 |
-- | Cadeira Gamer  | Móveis      |                 0 |             0 |
-- | Headset        | Áudio       |                 0 |             0 |
-- | Webcam         | Eletrônicos |                 0 |             0 |
-- +----------------+-------------+-------------------+---------------+


-- =============================================================================
-- EXEMPLO 6: QUANDO RIGHT JOIN É MAIS INTUITIVO
-- =============================================================================
-- Às vezes, a lógica do problema favorece o RIGHT JOIN
-- Exemplo: "Liste todos os clientes e seus pedidos,
--           mas garanta que TODOS OS PEDIDOS apareçam"
-- =============================================================================

SELECT 
    c.nome AS cliente,
    pe.id AS pedido,
    pe.data_pedido
FROM clientes c
RIGHT JOIN pedidos pe ON c.id = pe.cliente_id;

-- Nesse caso, RIGHT JOIN garante que todos os pedidos aparecem
-- Mesmo que um dia tenhamos pedidos sem cliente (o que não deveria acontecer)


-- =============================================================================
-- RESUMO DO RIGHT JOIN
-- =============================================================================
/*
╔═══════════════════════════════════════════════════════════════════╗
║                       RIGHT JOIN                                 ║
╠═══════════════════════════════════════════════════════════════════╣
║  SINTAXE:                                                        ║
║  SELECT colunas                                                  ║
║  FROM tabela_esquerda                                            ║
║  RIGHT JOIN tabela_direita ON condição                           ║
║                                                                  ║
║  CARACTERÍSTICAS:                                                ║
║  ✓ Retorna TODAS as linhas da tabela da DIREITA                  ║
║  ✓ Retorna apenas as correspondentes da ESQUERDA                 ║
║  ✓ Preenche com NULL onde não há correspondência                 ║
║  ✓ É o INVERSO do LEFT JOIN                                      ║
║                                                                  ║
║  REGRA DE OURO:                                                  ║
║  LEFT JOIN A = RIGHT JOIN B (invertendo as tabelas)              ║
║  Geralmente é mais legível usar LEFT JOIN                        ║
║                                                                  ║
║  QUANDO USAR RIGHT JOIN:                                         ║
║  - Quando a lógica do problema pede "todos da direita"           ║
║  - Em queries complexas com muitos joins                         ║
║  - Quando não dá pra rearranjar a ordem das tabelas              ║
║                                                                  ║
║  DICA: A maioria dos profissionais prefere SEMPRE LEFT JOIN,     ║
║  simplesmente rearranjando a ordem das tabelas.                  ║
╚═══════════════════════════════════════════════════════════════════╝
*/

-- LIMPEZA (opcional)
-- DROP DATABASE IF EXISTS estudos_joins;
