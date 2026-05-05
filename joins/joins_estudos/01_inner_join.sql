-- =============================================================================
-- INNER JOIN - O BÁSICO DOS JOINS
-- =============================================================================
-- O INNER JOIN retorna APENAS os registros que têm correspondência
-- em AMBAS as tabelas envolvidas na junção.
--
--      Tabela A    INNER JOIN    Tabela B
--      ┌────────┐               ┌────────┐
--      │  AAAA  │    JUNÇÃO     │  BBBB  │
--      │  AAAA  │ ◄──────────► │  BBBB  │
--      │  AAAA  │               │  BBBB  │
--      └────────┘               └────────┘
--               ╔══════════════════╗
--               ║   RESULTADO:     ║
--               ║   SÓ O QUE TEM   ║
--               ║   NAS DUAS (A∩B) ║
--               ╚══════════════════╝
-- =============================================================================

-- ANTES DE COMEÇAR, VAMOS CRIAR UM BANCO PARA TESTES
-- =============================================================================

CREATE DATABASE IF NOT EXISTS estudos_joins;
USE estudos_joins;

-- =============================================================================
-- TABELA: clientes
-- Guarda informações básicas dos clientes
-- =============================================================================
CREATE TABLE clientes (
    id INT PRIMARY KEY AUTO_INCREMENT,   -- ID único do cliente
    nome VARCHAR(100) NOT NULL,           -- Nome do cliente
    email VARCHAR(100),                    -- E-mail do cliente
    cidade VARCHAR(50)                     -- Cidade onde mora
);

-- =============================================================================
-- TABELA: pedidos
-- Guarda os pedidos feitos pelos clientes
-- =============================================================================
CREATE TABLE pedidos (
    id INT PRIMARY KEY AUTO_INCREMENT,   -- ID único do pedido
    cliente_id INT NOT NULL,              -- ID do cliente que fez o pedido
    data_pedido DATE,                     -- Data em que o pedido foi feito
    valor DECIMAL(10, 2),                 -- Valor total do pedido
    
    -- Chave estrangeira: liga o pedido ao cliente
    FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

-- =============================================================================
-- INSERINDO DADOS DE EXEMPLO
-- =============================================================================

-- Inserindo clientes
INSERT INTO clientes (nome, email, cidade) VALUES
('Ana Oliveira',  'ana@email.com',    'São Paulo'),
('Bruno Santos',  'bruno@email.com',  'Rio de Janeiro'),
('Carla Lima',    'carla@email.com',  'Belo Horizonte'),
('Daniel Costa',  'daniel@email.com', 'Curitiba'),
('Eduarda Souza', 'eduarda@email.com','Porto Alegre');

-- Inserindo pedidos (note: Daniel (id=4) NÃO tem pedido, Eduarda (id=5) NÃO tem pedido)
INSERT INTO pedidos (cliente_id, data_pedido, valor) VALUES
(1, '2024-01-15', 150.00),   -- Pedido da Ana
(1, '2024-02-20', 89.90),    -- Outro pedido da Ana
(2, '2024-01-18', 250.00),   -- Pedido do Bruno
(2, '2024-03-05', 32.50),    -- Outro pedido do Bruno
(3, '2024-02-10', 500.00);   -- Pedido da Carla

-- =============================================================================
-- EXEMPLO 1: INNER JOIN SIMPLES
-- =============================================================================
-- Mostra APENAS clientes que têm pedidos
-- Daniel (id=4) e Eduarda (id=5) NÃO aparecerão porque não têm pedidos
-- =============================================================================

SELECT 
    c.id,              -- ID do cliente
    c.nome,            -- Nome do cliente
    p.id AS pedido_id, -- ID do pedido
    p.data_pedido,     -- Data do pedido
    p.valor            -- Valor do pedido
FROM clientes AS c          -- Tabela da esquerda
INNER JOIN pedidos AS p     -- Tabela da direita
ON c.id = p.cliente_id;     -- Condição de junção (campo em comum)

-- RESULTADO ESPERADO:
-- +----+--------------+-----------+-------------+-------+
-- | id | nome         | pedido_id | data_pedido | valor |
-- +----+--------------+-----------+-------------+-------+
-- |  1 | Ana Oliveira |         1 | 2024-01-15  | 150.00|
-- |  1 | Ana Oliveira |         2 | 2024-02-20  | 89.90 |
-- |  2 | Bruno Santos |         3 | 2024-01-18  | 250.00|
-- |  2 | Bruno Santos |         4 | 2024-03-05  | 32.50 |
-- |  3 | Carla Lima   |         5 | 2024-02-10  | 500.00|
-- +----+--------------+-----------+-------------+-------+
-- Daniel e Eduarda NÃO aparecem (não têm pedidos)


-- =============================================================================
-- EXEMPLO 2: INNER JOIN COM ALIAS (APELIDOS) NAS TABELAS
-- =============================================================================
-- Usar alias (apelidos) é uma boa prática para escrever menos código
-- "AS c" = apelido para clientes
-- "AS p" = apelido para pedidos
-- =============================================================================

SELECT 
    c.nome,              -- c = clientes
    p.valor,             -- p = pedidos
    p.data_pedido
FROM clientes c          -- "AS" é opcional, pode omitir
JOIN pedidos p           -- "INNER" é opcional, JOIN já é INNER por padrão
ON c.id = p.cliente_id;

-- Perceba: usamos "c" e "p" em vez de escrever "clientes" e "pedidos" toda vez


-- =============================================================================
-- EXEMPLO 3: INNER JOIN COM FILTRO (WHERE)
-- =============================================================================
-- Você pode adicionar condições extras com WHERE
-- Primeiro o JOIN junta as tabelas, depois o WHERE filtra
-- =============================================================================

SELECT 
    c.nome,
    p.valor,
    p.data_pedido
FROM clientes c
INNER JOIN pedidos p ON c.id = p.cliente_id
WHERE p.valor > 100;  -- Só mostra pedidos com valor acima de 100

-- RESULTADO ESPERADO:
-- +--------------+-------+-------------+
-- | nome         | valor | data_pedido |
-- +--------------+-------+-------------+
-- | Ana Oliveira | 150.00| 2024-01-15  |
-- | Bruno Santos | 250.00| 2024-01-18  |
-- | Carla Lima   | 500.00| 2024-02-10  |
-- +--------------+-------+-------------+
-- O pedido de 89,90 e 32,50 foram filtrados


-- =============================================================================
-- EXEMPLO 4: INNER JOIN COM ORDENAÇÃO (ORDER BY)
-- =============================================================================

SELECT 
    c.nome,
    p.valor,
    p.data_pedido
FROM clientes c
INNER JOIN pedidos p ON c.id = p.cliente_id
ORDER BY p.valor DESC;  -- Do maior valor para o menor

-- RESULTADO:
-- +--------------+-------+-------------+
-- | nome         | valor | data_pedido |
-- +--------------+-------+-------------+
-- | Carla Lima   | 500.00| 2024-02-10  |
-- | Bruno Santos | 250.00| 2024-01-18  |
-- | Ana Oliveira | 150.00| 2024-01-15  |
-- | Ana Oliveira | 89.90 | 2024-02-20  |
-- | Bruno Santos | 32.50 | 2024-03-05  |
-- +--------------+-------+-------------+


-- =============================================================================
-- EXEMPLO 5: INNER JOIN COM FUNÇÕES DE AGREGAÇÃO
-- =============================================================================
-- Quanto cada cliente gastou no total?
-- GROUP BY agrupa por cliente, SUM soma os valores
-- =============================================================================

SELECT 
    c.nome,
    COUNT(p.id) AS quantidade_pedidos,  -- Quantos pedidos cada cliente fez
    SUM(p.valor) AS total_gasto         -- Quanto gastou no total
FROM clientes c
INNER JOIN pedidos p ON c.id = p.cliente_id
GROUP BY c.id, c.nome                   -- Agrupa por cliente
ORDER BY total_gasto DESC;              -- Ordena do que mais gastou

-- RESULTADO:
-- +--------------+---------------------+-------------+
-- | nome         | quantidade_pedidos  | total_gasto |
-- +--------------+---------------------+-------------+
-- | Carla Lima   |                   1 |      500.00 |
-- | Bruno Santos |                   2 |      282.50 |
-- | Ana Oliveira |                   2 |      239.90 |
-- +--------------+---------------------+-------------+


-- =============================================================================
-- EXEMPLO 6: INNER JOIN COM HAVING (Filtrar após agregação)
-- =============================================================================
-- WHERE filtra ANTES de agrupar, HAVING filtra DEPOIS de agrupar
-- =============================================================================

SELECT 
    c.nome,
    COUNT(p.id) AS quantidade_pedidos,
    SUM(p.valor) AS total_gasto
FROM clientes c
INNER JOIN pedidos p ON c.id = p.cliente_id
GROUP BY c.id, c.nome
HAVING COUNT(p.id) >= 2  -- Só clientes com 2 ou mais pedidos
ORDER BY total_gasto DESC;

-- RESULTADO:
-- +--------------+---------------------+-------------+
-- | nome         | quantidade_pedidos  | total_gasto |
-- +--------------+---------------------+-------------+
-- | Bruno Santos |                   2 |      282.50 |
-- | Ana Oliveira |                   2 |      239.90 |
-- +--------------+---------------------+-------------+
-- Carla sumiu porque tem só 1 pedido


-- =============================================================================
-- RESUMO DO INNER JOIN
-- =============================================================================
/*
╔══════════════════════════════════════════════════════════════╗
║                    INNER JOIN                               ║
╠══════════════════════════════════════════════════════════════╣
║  SINTAXE:                                                   ║
║  SELECT colunas                                             ║
║  FROM tabela_A                                             ║
║  INNER JOIN tabela_B ON condição                           ║
║                                                             ║
║  CARACTERÍSTICAS:                                           ║
║  ✓ Retorna SÓ o que existe nas DUAS tabelas                 ║
║  ✓ Linhas sem correspondência são EXCLUÍDAS                 ║
║  ✓ JOIN = INNER JOIN (é o padrão)                           ║
║  ✓ Geralmente o tipo de JOIN mais usado                     ║
║                                                             ║
║  QUANDO USAR:                                               ║
║  - Quando você SÓ quer dados que existem em ambas           ║
║  - Clientes que FIZERAM pedidos                             ║
║  - Produtos que FORAM vendidos                              ║
║  - Alunos que estão MATRICULADOS em cursos                  ║
╚══════════════════════════════════════════════════════════════╝
*/

-- LIMPEZA (opcional - descomente para limpar o banco de teste)
-- DROP DATABASE IF EXISTS estudos_joins;
