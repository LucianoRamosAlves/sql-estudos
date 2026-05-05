-- ============================================================
-- ARQUIVO 03: JOINS - JUNTANDO TABELAS
-- ============================================================
-- OBJETIVO: Aprender a combinar dados de várias tabelas
-- usando os diferentes tipos de JOIN
-- ============================================================

USE loja;

-- ============================================================
-- INTRODUÇÃO AOS JOINS
-- ============================================================
-- JOINs permitem juntar dados de DUAS ou MAIS tabelas
-- baseados em uma RELAÇÃO entre elas (chave estrangeira).
--
-- TIPOS DE JOIN:
--
-- INNER JOIN → Só traz registros que existem nas DUAS tabelas
-- LEFT JOIN  → Traz TODOS da tabela da esquerda + os que
--              correspondem na direita (NULL se não existir)
-- RIGHT JOIN → Traz TODOS da tabela da direita + os que
--              correspondem na esquerda (NULL se não existir)
--
-- Nosso diagrama de tabelas:
--
-- clientes ──< pedidos ──< itens_pedido >── produtos >── categorias
--    |           |              |              |              |
--    |           |              |              |              |
--    +--- 1:N ---+    N:N       +----- N:1 ----+----- N:1 ---+
--
-- RELACIONAMENTOS:
-- 1 cliente  → N pedidos          (1:N)
-- 1 pedido   → N itens_pedido     (1:N)
-- 1 produto  → N itens_pedido     (1:N)
-- 1 produto  → 1 categoria        (N:1)
-- N pedidos  → N produtos (via itens_pedido)  (N:N)

-- ============================================================
-- EXEMPLO 1: INNER JOIN
-- ============================================================
-- INNER JOIN = SÓ O QUE TEM EM AMBAS AS TABELAS
-- Mostra apenas registros onde há correspondência
-- nos dois lados

-- 1A - Clientes com seus pedidos
-- Queremos: nome do cliente + data do pedido
SELECT 
    c.nome AS cliente,
    p.data_pedido
FROM clientes c                    -- Tabela esquerda (apelido = c)
INNER JOIN pedidos p               -- Tabela direita (apelido = p)
    ON c.clientes_id = p.clientes_id;  -- Condição do JOIN

-- 1B - Pedidos com detalhes dos itens
SELECT 
    p.pedidos_id,
    p.data_pedido,
    ip.produtos_id,
    ip.quantidade
FROM pedidos p
INNER JOIN itens_pedido ip
    ON p.pedidos_id = ip.pedidos_id;

-- 1C - Três tabelas: clientes → pedidos → itens_pedido
SELECT 
    c.nome AS cliente,
    p.pedidos_id,
    p.data_pedido,
    ip.quantidade
FROM clientes c
INNER JOIN pedidos p ON c.clientes_id = p.clientes_id
INNER JOIN itens_pedido ip ON p.pedidos_id = ip.pedidos_id;

-- 1D - TODAS as tabelas (clientes → pedidos → itens → produtos → categorias)
SELECT 
    c.nome AS cliente,
    p.data_pedido,
    pr.nome_produto AS produto,
    ip.quantidade,
    pr.preco,
    (pr.preco * ip.quantidade) AS total_item,  -- Calcula o total
    cat.nome_categoria AS categoria
FROM clientes c
INNER JOIN pedidos p ON c.clientes_id = p.clientes_id
INNER JOIN itens_pedido ip ON p.pedidos_id = ip.pedidos_id
INNER JOIN produtos pr ON ip.produtos_id = pr.produtos_id
INNER JOIN categorias cat ON pr.categorias_id = cat.categorias_id;

-- ============================================================
-- EXEMPLO 2: LEFT JOIN
-- ============================================================
-- LEFT JOIN = TUDO DA ESQUERDA + O QUE CORRESPONDE NA DIREITA
-- A tabela da ESQUERDA (antes do JOIN) tem TODAS as linhas
-- Se não houver correspondência na direita, mostra NULL

-- 2A - Todos os clientes, mesmo sem pedidos
-- (Se um cliente não fez pedido, mostra NULL)
SELECT 
    c.nome AS cliente,
    p.pedidos_id,
    p.data_pedido
FROM clientes c               -- ESQUERDA: TODOS os clientes
LEFT JOIN pedidos p           -- DIREITA: só pedidos que existem
    ON c.clientes_id = p.clientes_id;

-- 2B - Todos os produtos, mesmo sem itens_pedido
-- (Se um produto nunca foi vendido, mostra NULL)
SELECT 
    pr.nome_produto,
    ip.pedidos_id,
    ip.quantidade
FROM produtos pr
LEFT JOIN itens_pedido ip
    ON pr.produtos_id = ip.produtos_id;

-- 2C - Clientes que NUNCA fizeram pedido
SELECT 
    c.nome AS cliente,
    p.pedidos_id
FROM clientes c
LEFT JOIN pedidos p ON c.clientes_id = p.clientes_id
WHERE p.pedidos_id IS NULL;       -- Só quem não tem pedido

-- 2D - Produtos que NUNCA foram vendidos
SELECT 
    pr.nome_produto,
    ip.pedidos_id
FROM produtos pr
LEFT JOIN itens_pedido ip ON pr.produtos_id = ip.produtos_id
WHERE ip.pedidos_id IS NULL;

-- ============================================================
-- EXEMPLO 3: RIGHT JOIN
-- ============================================================
-- RIGHT JOIN = TUDO DA DIREITA + O QUE CORRESPONDE NA ESQUERDA
-- É o contrário do LEFT JOIN
-- Menos usado, porque podemos inverter a ordem e usar LEFT

-- 3A - Mesmo que 2A, mas com RIGHT JOIN (invertendo a ordem)
SELECT 
    c.nome AS cliente,
    p.pedidos_id,
    p.data_pedido
FROM pedidos p                 -- Agora pedidos está na ESQUERDA
RIGHT JOIN clientes c          -- e clientes na DIREITA
    ON c.clientes_id = p.clientes_id;
-- Resultado idêntico ao LEFT JOIN de 2A!

-- ============================================================
-- EXEMPLO 4: CORRIGINDO O JOIN COM BUG
-- ============================================================
-- O arquivo original tinha:
-- SELECT nome AS nome, produtos_id AS produto
-- FROM clientes c
-- LEFT JOIN itens_pedido p
-- ON c.clientes_id = p.produtos_id  -- BUG! Chave errada!
--
-- PROBLEMA:
-- 1. Estava ligando clientes_id com produtos_id (não faz sentido)
-- 2. Faltava terminar a query
-- 3. A relação correta é: clientes → pedidos → itens_pedido

-- VERSÃO CORRIGIDA:
-- Queremos ver o nome do cliente e os IDs dos produtos que ele comprou
SELECT 
    c.nome AS nome_cliente,
    ip.produtos_id AS id_produto,
    pr.nome_produto AS nome_produto
FROM clientes c
LEFT JOIN pedidos p ON c.clientes_id = p.clientes_id
LEFT JOIN itens_pedido ip ON p.pedidos_id = ip.pedidos_id
LEFT JOIN produtos pr ON ip.produtos_id = pr.produtos_id
ORDER BY c.nome;

-- ============================================================
-- EXEMPLO 5: CONSULTAS ÚTEIS COM JOINS
-- ============================================================

-- 5A - Total gasto por cada cliente
SELECT 
    c.clientes_id,
    c.nome AS cliente,
    SUM(pr.preco * ip.quantidade) AS total_gasto
FROM clientes c
INNER JOIN pedidos p ON c.clientes_id = p.clientes_id
INNER JOIN itens_pedido ip ON p.pedidos_id = ip.pedidos_id
INNER JOIN produtos pr ON ip.produtos_id = pr.produtos_id
GROUP BY c.clientes_id, c.nome
ORDER BY total_gasto DESC;

-- 5B - Quantidade de pedidos por cliente
SELECT 
    c.nome AS cliente,
    COUNT(p.pedidos_id) AS total_pedidos
FROM clientes c
LEFT JOIN pedidos p ON c.clientes_id = p.clientes_id
GROUP BY c.clientes_id, c.nome
ORDER BY total_pedidos DESC;

-- 5C - Produto mais vendido (por quantidade)
SELECT 
    pr.nome_produto,
    SUM(ip.quantidade) AS total_vendido
FROM produtos pr
INNER JOIN itens_pedido ip ON pr.produtos_id = ip.produtos_id
GROUP BY pr.produtos_id, pr.nome_produto
ORDER BY total_vendido DESC;

-- 5D - Pedidos com valor total (incluindo cliente e data)
SELECT 
    p.pedidos_id,
    c.nome AS cliente,
    p.data_pedido,
    SUM(pr.preco * ip.quantidade) AS valor_total
FROM pedidos p
INNER JOIN clientes c ON p.clientes_id = c.clientes_id
INNER JOIN itens_pedido ip ON p.pedidos_id = ip.pedidos_id
INNER JOIN produtos pr ON ip.produtos_id = pr.produtos_id
GROUP BY p.pedidos_id, c.nome, p.data_pedido
ORDER BY p.pedidos_id;

-- ============================================================
-- RESUMO VISUAL DOS JOINS
-- ============================================================
--
-- INNER JOIN (só interseção):
--   [ Tabela A ] ∩ [ Tabela B ]
--   Só registros que existem em A E B
--
-- LEFT JOIN (tudo de A):
--   [ Tabela A ] ∪ [ Correspondentes em B ]
--   Todos de A, mesmo se não existir em B
--
-- RIGHT JOIN (tudo de B):
--   [ Correspondentes em A ] ∪ [ Tabela B ]
--   Todos de B, mesmo se não existir em A
--
-- REGRA DE OURO:
-- LEFT JOIN é o mais usado! Pense: "quero TODOS os
-- registros da tabela X, mesmo que não tenham Y"
-- ============================================================

-- ============================================================
-- DESAFIOS PARA PRATICAR:
-- ============================================================
-- 1. Liste todos os produtos com o nome da categoria
-- 2. Mostre todos os clientes e quantos pedidos cada um fez
-- 3. Qual o valor total de cada pedido?
-- 4. Quais clientes NUNCA compraram nada?
-- 5. Qual produto foi o mais comprado (em quantidade)?
-- ============================================================