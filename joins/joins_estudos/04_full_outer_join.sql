-- =============================================================================
-- FULL OUTER JOIN (FULL JOIN) - UNIÃO COMPLETA DE DUAS TABELAS
-- =============================================================================
-- Retorna TODAS as linhas de AMBAS as tabelas.
-- Quando há correspondência, junta os dados.
-- Quando NÃO há, preenche com NULL do lado que não tem.
--
--      Tabela A    FULL JOIN    Tabela B
--      ┌────────┐               ┌────────┐
--      │  AAAA  │    JUNÇÃO     │  BBBB  │
--      │  AAAA  │◄════════════►│  BBBB  │
--      │  AAAA  │               │        │ ← NULLs
--      └────────┘               └────────┘
--               ╔══════════════════╗
--               ║   RESULTADO:     ║
--               ║  TUDO DE A +    ║
--               ║  TUDO DE B      ║
--               ╚══════════════════╝
--
-- ⚠️ IMPORTANTE: MySQL NÃO tem FULL OUTER JOIN nativo!
--    Para simular, usamos LEFT JOIN UNION RIGHT JOIN
-- =============================================================================

-- CONFIGURAÇÃO DO BANCO
-- =============================================================================
CREATE DATABASE IF NOT EXISTS estudos_joins;
USE estudos_joins;

DROP TABLE IF EXISTS itens_pedido;
DROP TABLE IF EXISTS pedidos;
DROP TABLE IF EXISTS produtos;
DROP TABLE IF EXISTS clientes;

-- =============================================================================
-- CENÁRIO: Duas listas de funcionários
-- Vamos simular dois departamentos que podem ter funcionários em comum
-- =============================================================================

CREATE TABLE funcionarios_vendas (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    cargo VARCHAR(50)
);

CREATE TABLE funcionarios_marketing (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    cargo VARCHAR(50)
);

INSERT INTO funcionarios_vendas (nome, cargo) VALUES
('Ana Oliveira', 'Vendedor Sênior'),
('Bruno Santos', 'Vendedor Jr'),
('Carla Lima', 'Gerente de Vendas'),
('Daniel Costa', 'Assistente de Vendas'),
('Eduarda Souza', 'Vendedor Sênior');

INSERT INTO funcionarios_marketing (nome, cargo) VALUES
('Carla Lima', 'Gerente de Marketing'),      -- Mesma pessoa que em Vendas!
('Fernando Alves', 'Analista de Marketing'),
('Gabriela Torres', 'Coordenadora de Marketing'),
('Eduarda Souza', 'Analista de Marketing'),   -- Mesma pessoa que em Vendas!
('Hugo Martins', 'Estagiário de Marketing');

-- Note: Carla e Eduarda estão em AMBOS os departamentos
-- Ana, Bruno, Daniel estão SÓ em Vendas
-- Fernando, Gabriela, Hugo estão SÓ em Marketing


-- =============================================================================
-- EXEMPLO 1: FULL OUTER JOIN via UNION
-- =============================================================================
-- Mostra TODOS os funcionários de AMBOS os departamentos
-- =============================================================================

-- Primeira parte: LEFT JOIN (todos de vendas + correspondências de marketing)
SELECT 
    v.nome AS funcionario,
    v.cargo AS cargo_vendas,
    m.cargo AS cargo_marketing
FROM funcionarios_vendas v
LEFT JOIN funcionarios_marketing m ON v.nome = m.nome

UNION  -- UNION elimina duplicatas automaticamente

-- Segunda parte: RIGHT JOIN (todos de marketing que não estavam no LEFT)
SELECT 
    m.nome,
    v.cargo,
    m.cargo
FROM funcionarios_vendas v
RIGHT JOIN funcionarios_marketing m ON v.nome = m.nome;

-- RESULTADO ESPERADO:
-- +-----------------+---------------------+-------------------------+
-- | funcionario     | cargo_vendas        | cargo_marketing         |
-- +-----------------+---------------------+-------------------------+
-- | Ana Oliveira    | Vendedor Sênior     | NULL                    |
-- | Bruno Santos    | Vendedor Jr         | NULL                    |
-- | Carla Lima      | Gerente de Vendas   | Gerente de Marketing    |
-- | Daniel Costa    | Assistente de Vendas| NULL                    |
-- | Eduarda Souza   | Vendedor Sênior     | Analista de Marketing   |
-- | Fernando Alves  | NULL                | Analista de Marketing   |
-- | Gabriela Torres | NULL                | Coordenadora de Market. |
-- | Hugo Martins    | NULL                | Estagiário de Marketing |
-- +-----------------+---------------------+-------------------------+
-- Aqui vemos: funcionários exclusivos de cada dept + quem está em ambos


-- =============================================================================
-- EXEMPLO 2: FULL JOIN com UNION ALL (mais rápido, mas com duplicatas)
-- =============================================================================
-- UNION ALL não elimina duplicatas, então é mais performático
-- Use quando você SABE que não há sobreposição ou quer todas as linhas
-- =============================================================================

SELECT v.nome, v.cargo AS cargo, 'Vendas' AS departamento
FROM funcionarios_vendas v

UNION ALL  -- UNION ALL mantém duplicatas

SELECT m.nome, m.cargo AS cargo, 'Marketing' AS departamento
FROM funcionarios_marketing m;

-- RESULTADO:
-- +-----------------+------------------------+--------------+
-- | nome            | cargo                  | departamento |
-- +-----------------+------------------------+--------------+
-- | Ana Oliveira    | Vendedor Sênior        | Vendas       |
-- | Bruno Santos    | Vendedor Jr            | Vendas       |
-- | Carla Lima      | Gerente de Vendas      | Vendas       |
-- | Daniel Costa    | Assistente de Vendas   | Vendas       |
-- | Eduarda Souza   | Vendedor Sênior        | Vendas       |
-- | Carla Lima      | Gerente de Marketing   | Marketing    | ← Duplicata!
-- | Fernando Alves  | Analista de Marketing  | Marketing    |
-- | Gabriela Torres | Coordenadora de Market.| Marketing    |
-- | Eduarda Souza   | Analista de Marketing  | Marketing    | ← Duplicata!
-- | Hugo Martins    | Estagiário de Marketing| Marketing    |
-- +-----------------+------------------------+--------------+
-- Carla e Eduarda aparecem 2 vezes cada (uma para cada departamento)


-- =============================================================================
-- EXEMPLO 3: ENCONTRANDO FUNCIONÁRIOS EXCLUSIVOS DE CADA DEPARTAMENTO
-- =============================================================================
-- Quem trabalha APENAS em Vendas? (LEFT JOIN com NULL na direita)
-- Quem trabalha APENAS em Marketing? (RIGHT JOIN com NULL na esquerda)
-- FULL OUTER JOIN nos dá os dois ao mesmo tempo!
-- =============================================================================

SELECT 
    COALESCE(v.nome, m.nome) AS funcionario,
    CASE 
        WHEN v.nome IS NOT NULL AND m.nome IS NULL THEN 'Só Vendas'
        WHEN v.nome IS NULL AND m.nome IS NOT NULL THEN 'Só Marketing'
        ELSE 'Ambos'
    END AS situacao,
    v.cargo AS cargo_vendas,
    m.cargo AS cargo_marketing
FROM funcionarios_vendas v
LEFT JOIN funcionarios_marketing m ON v.nome = m.nome

UNION

SELECT 
    COALESCE(v.nome, m.nome),
    CASE 
        WHEN v.nome IS NOT NULL AND m.nome IS NULL THEN 'Só Vendas'
        WHEN v.nome IS NULL AND m.nome IS NOT NULL THEN 'Só Marketing'
        ELSE 'Ambos'
    END,
    v.cargo,
    m.cargo
FROM funcionarios_vendas v
RIGHT JOIN funcionarios_marketing m ON v.nome = m.nome;

-- RESULTADO:
-- +-----------------+---------------+---------------------+-------------------------+
-- | funcionario     | situacao      | cargo_vendas        | cargo_marketing         |
-- +-----------------+---------------+---------------------+-------------------------+
-- | Ana Oliveira    | Só Vendas     | Vendedor Sênior     | NULL                    |
-- | Bruno Santos    | Só Vendas     | Vendedor Jr         | NULL                    |
-- | Carla Lima      | Ambos         | Gerente de Vendas   | Gerente de Marketing    |
-- | Daniel Costa    | Só Vendas     | Assistente de Vendas| NULL                    |
-- | Eduarda Souza   | Ambos         | Vendedor Sênior     | Analista de Marketing   |
-- | Fernando Alves  | Só Marketing  | NULL                | Analista de Marketing   |
-- | Gabriela Torres | Só Marketing  | NULL                | Coordenadora de Market. |
-- | Hugo Martins    | Só Marketing  | NULL                | Estagiário de Marketing |
-- +-----------------+---------------+---------------------+-------------------------+


-- =============================================================================
-- EXEMPLO 4: FULL OUTER JOIN EM CENÁRIO REAL (Clientes × Pedidos)
-- =============================================================================
-- Queremos ver TODOS os clientes e TODOS os pedidos
-- =============================================================================

CREATE TABLE clientes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100)
);

CREATE TABLE pedidos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    cliente_id INT,
    produto VARCHAR(100),
    valor DECIMAL(10, 2)
);

INSERT INTO clientes VALUES
(1, 'Ana'), (2, 'Bruno'), (3, 'Carla'), (4, 'Daniel');

INSERT INTO pedidos VALUES
(1, 1, 'Notebook', 2500.00),
(2, 2, 'Mouse', 50.00),
(3, NULL, 'Teclado', 150.00),  -- Pedido SEM cliente (órfão)
(4, 5, 'Monitor', 1200.00);    -- Cliente 5 não existe!

-- FULL OUTER JOIN
SELECT 
    c.id AS cliente_id,
    c.nome AS cliente,
    p.id AS pedido_id,
    p.produto,
    p.valor
FROM clientes c
LEFT JOIN pedidos p ON c.id = p.cliente_id

UNION

SELECT 
    c.id,
    c.nome,
    p.id,
    p.produto,
    p.valor
FROM clientes c
RIGHT JOIN pedidos p ON c.id = p.cliente_id;

-- RESULTADO:
-- +------------+--------+-----------+----------+--------+
-- | cliente_id | cliente| pedido_id | produto  | valor  |
-- +------------+--------+-----------+----------+--------+
-- |          1 | Ana    |         1 | Notebook | 2500.00|
-- |          2 | Bruno  |         2 | Mouse    | 50.00  |
-- |          3 | Carla  |      NULL | NULL     |   NULL | ← Sem pedido
-- |          4 | Daniel |      NULL | NULL     |   NULL | ← Sem pedido
-- |       NULL | NULL   |         3 | Teclado  | 150.00 | ← Pedido órfão
-- |       NULL | NULL   |         4 | Monitor  | 1200.00| ← Cliente inexistente
-- +------------+--------+-----------+----------+--------+
-- Vemos TODOS os dados, incluindo anomalias!


-- =============================================================================
-- EXEMPLO 5: FULL OUTER JOIN COM AGREGAÇÃO
-- =============================================================================
-- Comparando vendas entre duas lojas
-- =============================================================================

CREATE TABLE loja_a_vendas (
    vendedor VARCHAR(100),
    valor DECIMAL(10, 2)
);

CREATE TABLE loja_b_vendas (
    vendedor VARCHAR(100),
    valor DECIMAL(10, 2)
);

INSERT INTO loja_a_vendas VALUES
('Ana', 1000.00), ('Ana', 500.00),
('Bruno', 1500.00),
('Carla', 2000.00);

INSERT INTO loja_b_vendas VALUES
('Ana', 800.00),
('Bruno', 300.00),
('Daniel', 2500.00);

-- Total por vendedor em ambas as lojas (FULL OUTER JOIN)
SELECT 
    vendedor,
    COALESCE(SUM(a.valor), 0) AS total_loja_a,
    COALESCE(SUM(b.valor), 0) AS total_loja_b
FROM loja_a_vendas a
LEFT JOIN loja_b_vendas b USING(vendedor)  -- USING = ON com mesmo nome

UNION

SELECT 
    vendedor,
    COALESCE(SUM(a.valor), 0),
    COALESCE(SUM(b.valor), 0)
FROM loja_a_vendas a
RIGHT JOIN loja_b_vendas b USING(vendedor);

-- RESULTADO:
-- +----------+-------------+-------------+
-- | vendedor | total_loja_a| total_loja_b|
-- +----------+-------------+-------------+
-- | Ana      |     1500.00 |      800.00 |
-- | Bruno    |     1500.00 |      300.00 |
-- | Carla    |     2000.00 |        0.00 |
-- | Daniel   |        0.00 |     2500.00 |
-- +----------+-------------+-------------+


-- =============================================================================
-- RESUMO DO FULL OUTER JOIN
-- =============================================================================
/*
╔═══════════════════════════════════════════════════════════════════╗
║                   FULL OUTER JOIN                                ║
╠═══════════════════════════════════════════════════════════════════╣
║  SINTAXE (MySQL - simulado):                                     ║
║  SELECT colunas                                                  ║
║  FROM tabela_A                                                   ║
║  LEFT JOIN tabela_B ON condição                                  ║
║                                                                  ║
║  UNION                                                           ║
║                                                                  ║
║  SELECT colunas                                                  ║
║  FROM tabela_A                                                   ║
║  RIGHT JOIN tabela_B ON condição                                 ║
║                                                                  ║
║  CARACTERÍSTICAS:                                                ║
║  ✓ Retorna TODAS as linhas de AMBAS as tabelas                   ║
║  ✓ Preenche com NULL onde não há correspondência                 ║
║  ✓ UNION elimina duplicatas entre LEFT e RIGHT                   ║
║  ✓ MySQL NÃO tem suporte nativo (precisa simular)                ║
║                                                                  ║
║  UNION vs UNION ALL:                                             ║
║  - UNION: elimina duplicatas (mais lento, resultado único)       ║
║  - UNION ALL: mantém duplicatas (mais rápido, pode repetir)      ║
║                                                                  ║
║  QUANDO USAR:                                                    ║
║  - Comparar duas listas completas                                ║
║  - Encontrar divergências entre tabelas                          ║
║  - Relatórios de reconciliação de dados                          ║
║  - Auditoria (achar dados órfãos de ambos os lados)              ║
╚═══════════════════════════════════════════════════════════════════╝
*/

-- LIMPEZA (opcional)
-- DROP DATABASE IF EXISTS estudos_joins;
