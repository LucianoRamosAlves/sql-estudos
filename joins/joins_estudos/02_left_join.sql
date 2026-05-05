-- =============================================================================
-- LEFT JOIN - TODOS OS REGISTROS DA TABELA DA ESQUERDA
-- =============================================================================
-- O LEFT JOIN retorna TODOS os registros da tabela da ESQUERDA (a primeira)
-- e apenas os registros CORRESPONDENTES da tabela da DIREITA.
--
-- Quando não há correspondência na tabela da direita, preenche com NULL.
--
--      Tabela A    LEFT JOIN   Tabela B
--      ┌────────┐               ┌────────┐
--      │  AAAA  │    JUNÇÃO     │  BBBB  │
--      │  AAAA  │──────────────►│  BBBB  │
--      │  AAAA  │               │        │ ← NULL
--      └────────┘               └────────┘
--               ╔══════════════════╗
--               ║   RESULTADO:     ║
--               ║  TUDO DE A +    ║
--               ║  CORRESP. DE B  ║
--               ╚══════════════════╝
-- =============================================================================

-- PRIMEIRO, RECRIAMOS O BANCO DE TESTE
-- =============================================================================
CREATE DATABASE IF NOT EXISTS estudos_joins;
USE estudos_joins;

-- Recriando as tabelas para garantir que estão limpas
DROP TABLE IF EXISTS pedidos;
DROP TABLE IF EXISTS clientes;

CREATE TABLE clientes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    cidade VARCHAR(50),
    data_cadastro DATE DEFAULT (CURRENT_DATE)
);

CREATE TABLE pedidos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    cliente_id INT NOT NULL,
    data_pedido DATE,
    valor DECIMAL(10, 2),
    FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

-- Inserindo dados de exemplo
INSERT INTO clientes (nome, email, cidade) VALUES
('Ana Oliveira',  'ana@email.com',    'São Paulo'),
('Bruno Santos',  'bruno@email.com',  'Rio de Janeiro'),
('Carla Lima',    'carla@email.com',  'Belo Horizonte'),
('Daniel Costa',  'daniel@email.com', 'Curitiba'),
('Eduarda Souza', 'eduarda@email.com','Porto Alegre'),
('Fernando Alves','fernando@email.com','Salvador');

INSERT INTO pedidos (cliente_id, data_pedido, valor) VALUES
(1, '2024-01-15', 150.00),   -- Ana
(1, '2024-02-20', 89.90),    -- Ana
(2, '2024-01-18', 250.00),   -- Bruno
(2, '2024-03-05', 32.50),    -- Bruno
(3, '2024-02-10', 500.00);   -- Carla
-- Daniel (4), Eduarda (5) e Fernando (6) NÃO têm pedidos


-- =============================================================================
-- EXEMPLO 1: LEFT JOIN BÁSICO
-- =============================================================================
-- Queremos TODOS os clientes, mesmo os que não fizeram pedidos
-- =============================================================================

SELECT 
    c.id,
    c.nome,
    p.id AS pedido_id,
    p.data_pedido,
    p.valor
FROM clientes c              -- LEFT: esta é a tabela "principal"
LEFT JOIN pedidos p          -- RIGHT: esta é a tabela "secundária"
ON c.id = p.cliente_id;

-- RESULTADO ESPERADO:
-- +----+----------------+-----------+-------------+--------+
-- | id | nome           | pedido_id | data_pedido | valor  |
-- +----+----------------+-----------+-------------+--------+
-- |  1 | Ana Oliveira   |         1 | 2024-01-15  | 150.00 |
-- |  1 | Ana Oliveira   |         2 | 2024-02-20  | 89.90  |
-- |  2 | Bruno Santos   |         3 | 2024-01-18  | 250.00 |
-- |  2 | Bruno Santos   |         4 | 2024-03-05  | 32.50  |
-- |  3 | Carla Lima     |         5 | 2024-02-10  | 500.00 |
-- |  4 | Daniel Costa   |      NULL | NULL        |   NULL | ← Daniel apareceu!
-- |  5 | Eduarda Souza  |      NULL | NULL        |   NULL | ← Eduarda apareceu!
-- |  6 | Fernando Alves |      NULL | NULL        |   NULL | ← Fernando apareceu!
-- +----+----------------+-----------+-------------+--------+
-- DIFERENÇA CRÍTICA: Daniel, Eduarda e Fernando aparecem mesmo sem pedidos!
-- Quando não há pedido, as colunas de pedidos vêm como NULL


-- =============================================================================
-- EXEMPLO 2: ENCONTRANDO CLIENTES SEM PEDIDOS
-- =============================================================================
-- Uma das aplicações mais úteis do LEFT JOIN:
-- Encontrar registros que NÃO têm correspondência na outra tabela
-- =============================================================================

SELECT 
    c.id,
    c.nome,
    c.email,
    c.cidade
FROM clientes c
LEFT JOIN pedidos p ON c.id = p.cliente_id
WHERE p.id IS NULL;  -- IMPORTANTE: Filtra quem NÃO tem pedido
-- Usamos a PRIMARY KEY da tabela da direita (p.id) para verificar NULL

-- RESULTADO ESPERADO:
-- +----+----------------+-------------------+--------------+
-- | id | nome           | email             | cidade       |
-- +----+----------------+-------------------+--------------+
-- |  4 | Daniel Costa   | daniel@email.com  | Curitiba     |
-- |  5 | Eduarda Souza  | eduarda@email.com | Porto Alegre |
-- |  6 | Fernando Alves | fernando@email.com| Salvador     |
-- +----+----------------+-------------------+--------------+
-- EXCELENTE para encontrar registros "órfãos"!


-- =============================================================================
-- EXEMPLO 3: LEFT JOIN COM CONTAGEM
-- =============================================================================
-- Queremos saber quantos pedidos CADA cliente fez
-- Incluindo os que não fizeram nenhum (mostrará 0)
-- =============================================================================

SELECT 
    c.id,
    c.nome,
    COUNT(p.id) AS total_pedidos,       -- Conta pedidos (0 para quem não tem)
    COALESCE(SUM(p.valor), 0) AS total_gasto  -- Soma valores (0 para NULL)
FROM clientes c
LEFT JOIN pedidos p ON c.id = p.cliente_id
GROUP BY c.id, c.nome
ORDER BY total_pedidos DESC, c.nome;

-- RESULTADO ESPERADO:
-- +----+----------------+---------------+-------------+
-- | id | nome           | total_pedidos | total_gasto |
-- +----+----------------+---------------+-------------+
-- |  1 | Ana Oliveira   |             2 |      239.90 |
-- |  2 | Bruno Santos   |             2 |      282.50 |
-- |  3 | Carla Lima     |             1 |      500.00 |
-- |  4 | Daniel Costa   |             0 |        0.00 | ← 0 pedidos!
-- |  6 | Fernando Alves |             0 |        0.00 | ← 0 pedidos!
-- |  5 | Eduarda Souza  |             0 |        0.00 | ← 0 pedidos!
-- +----+----------------+---------------+-------------+
-- IMPORTANTE: COUNT(p.id) conta só os IDs não-NULL de pedidos
-- Se usasse COUNT(*), contaria 1 para cada cliente mesmo sem pedido!


-- =============================================================================
-- EXEMPLO 4: LEFT JOIN COM MÚLTIPLAS CONDIÇÕES
-- =============================================================================
-- Podemos adicionar filtros na cláusula ON
-- Diferença entre filtrar no ON vs WHERE:
--   ON filtra ANTES do JOIN (afeta quais linhas da direita entram)
--   WHERE filtra DEPOIS do JOIN
-- =============================================================================

-- FILTRO NO ON: Ainda mostra todos os clientes, mas só pedidos > 100
SELECT 
    c.nome,
    p.valor,
    p.data_pedido
FROM clientes c
LEFT JOIN pedidos p 
    ON c.id = p.cliente_id 
    AND p.valor > 100;     -- Filtro no ON: só junta pedidos > 100

-- RESULTADO:
-- +----------------+--------+-------------+
-- | nome           | valor  | data_pedido |
-- +----------------+--------+-------------+
-- | Ana Oliveira   | 150.00 | 2024-01-15  |
-- | Ana Oliveira   |   NULL | NULL        | ← pedido de 89.90 virou NULL!
-- | Bruno Santos   | 250.00 | 2024-01-18  |
-- | Bruno Santos   |   NULL | NULL        | ← pedido de 32.50 virou NULL!
-- | Carla Lima     | 500.00 | 2024-02-10  |
-- | Daniel Costa   |   NULL | NULL        |
-- | Eduarda Souza  |   NULL | NULL        |
-- | Fernando Alves |   NULL | NULL        |
-- +----------------+--------+-------------+
-- Todos os clientes continuam aparecendo, mas pedidos filtrados


-- =============================================================================
-- EXEMPLO 5: FILTRO NO WHERE (comportamento DIFERENTE)
-- =============================================================================
-- Quando filtramos no WHERE, pode eliminar linhas da esquerda também!
-- Isso porque WHERE ocorre DEPOIS da junção completa
-- =============================================================================

-- FILTRO NO WHERE: vira um INNER JOIN disfarçado!
SELECT 
    c.nome,
    p.valor,
    p.data_pedido
FROM clientes c
LEFT JOIN pedidos p ON c.id = p.cliente_id
WHERE p.valor > 100;      -- Filtro no WHERE (depois do JOIN)

-- RESULTADO:
-- +--------------+--------+-------------+
-- | nome         | valor  | data_pedido |
-- +--------------+--------+-------------+
-- | Ana Oliveira | 150.00 | 2024-01-15  |
-- | Bruno Santos | 250.00 | 2024-01-18  |
-- | Carla Lima   | 500.00 | 2024-02-10  |
-- +--------------+--------+-------------+
-- ⚠️ Daniel, Eduarda e Fernando SUMIRAM!
-- Porque WHERE filtra TUDO depois do JOIN, incluindo NULLs

-- Para manter clientes sem pedidos, faça assim:
SELECT 
    c.nome,
    p.valor,
    p.data_pedido
FROM clientes c
LEFT JOIN pedidos p ON c.id = p.cliente_id
WHERE (p.valor > 100 OR p.valor IS NULL);  -- Não esqueça dos NULLs!


-- =============================================================================
-- EXEMPLO 6: LEFT JOIN COM ORDER BY E LIMIT
-- =============================================================================

SELECT 
    c.nome,
    COUNT(p.id) AS total_pedidos
FROM clientes c
LEFT JOIN pedidos p ON c.id = p.cliente_id
GROUP BY c.id, c.nome
ORDER BY total_pedidos DESC
LIMIT 3;  -- Top 3 clientes (mesmo os que têm 0 pedidos)

-- RESULTADO:
-- +--------------+---------------+
-- | nome         | total_pedidos |
-- +--------------+---------------+
-- | Ana Oliveira |             2 |
-- | Bruno Santos |             2 |
-- | Carla Lima   |             1 |
-- +--------------+---------------+


-- =============================================================================
-- EXEMPLO 7: LEFT JOIN ENCADEADO (MÚLTIPLAS TABELAS)
-- =============================================================================
-- Vamos adicionar uma tabela de itens para mostrar 3 LEFT JOINs juntos

CREATE TABLE IF NOT EXISTS itens_pedido (
    id INT PRIMARY KEY AUTO_INCREMENT,
    pedido_id INT NOT NULL,
    produto VARCHAR(100),
    quantidade INT,
    preco_unitario DECIMAL(10, 2),
    FOREIGN KEY (pedido_id) REFERENCES pedidos(id)
);

INSERT INTO itens_pedido VALUES
(1, 1, 'Notebook', 1, 150.00),
(2, 2, 'Mouse', 2, 44.95),
(3, 3, 'Teclado Mecânico', 1, 250.00),
(4, 4, 'Caneta', 5, 6.50);
-- Pedido 5 (Carla) não tem itens cadastrados

SELECT 
    c.nome AS cliente,
    p.id AS pedido,
    COALESCE(i.produto, 'NENHUM ITEM') AS produto,
    i.quantidade,
    i.preco_unitario
FROM clientes c
LEFT JOIN pedidos p ON c.id = p.cliente_id
LEFT JOIN itens_pedido i ON p.id = i.pedido_id
ORDER BY c.nome, p.id;

-- Mostra TODOS os clientes, todos os pedidos, e todos os itens
-- Mesmo quando algum nível não existe


-- =============================================================================
-- RESUMO DO LEFT JOIN
-- =============================================================================
/*
╔═══════════════════════════════════════════════════════════════════╗
║                        LEFT JOIN                                 ║
╠═══════════════════════════════════════════════════════════════════╣
║  SINTAXE:                                                        ║
║  SELECT colunas                                                  ║
║  FROM tabela_esquerda                                            ║
║  LEFT JOIN tabela_direita ON condição                            ║
║                                                                  ║
║  CARACTERÍSTICAS:                                                ║
║  ✓ Retorna TODAS as linhas da tabela da ESQUERDA                 ║
║  ✓ Retorna apenas as correspondentes da DIREITA                  ║
║  ✓ Preenche com NULL onde não há correspondência                 ║
║  ✓ A ordem das tabelas IMPORTA!                                  ║
║                                                                  ║
║  QUANDO USAR:                                                    ║
║  - Listar todos os itens de uma lista principal (ex: clientes)   ║
║  - Encontrar registros "órfãos" (WHERE direita IS NULL)          ║
║  - Relatórios onde a tabela principal é mais importante          ║
║  - LEFT JOIN é o mais usado depois do INNER JOIN                 ║
║                                                                  ║
║  CUIDADOS:                                                       ║
║  ⚠️  WHERE na coluna da direita pode eliminar linhas!            ║
║  ⚠️  COUNT(p.id) conta só registros válidos                      ║
║  ⚠️  LEFT JOIN com GROUP BY pode dar resultados inesperados      ║
╚═══════════════════════════════════════════════════════════════════╝
*/

-- LIMPEZA (opcional)
-- DROP DATABASE IF EXISTS estudos_joins;
