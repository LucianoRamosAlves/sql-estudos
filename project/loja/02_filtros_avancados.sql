-- ============================================================
-- ARQUIVO 02: FILTROS AVANÇADOS E FUNÇÕES AGREGADAS
-- ============================================================
-- OBJETIVO: Aprofundar nos filtros e aprender funções
-- de agregação (COUNT, SUM, AVG, MAX, MIN)
-- ============================================================

USE loja;

-- ============================================================
-- PARTE 1: FILTROS MAIS AVANÇADOS
-- ============================================================

-- ----------------------------
-- LIKE - Busca por padrão no texto
-- ----------------------------
-- % → qualquer sequência de caracteres (coringa)
-- _ → um caractere qualquer

-- 1A - Clientes que começam com 'M'
SELECT * FROM clientes WHERE nome LIKE 'M%';

-- 1B - Clientes que terminam com 'a'
SELECT * FROM clientes WHERE nome LIKE '%a';

-- 1C - Clientes que têm 'a' em qualquer posição
SELECT * FROM clientes WHERE nome LIKE '%a%';

-- 1D - Clientes com nome de exatamente 4 letras
SELECT * FROM clientes WHERE nome LIKE '____';  -- 4 underscores

-- 1E - Produtos que contêm 'papel' no nome
SELECT * FROM produtos WHERE nome_produto LIKE '%papel%';

-- ----------------------------
-- NOT - Negação
-- ----------------------------

-- 2A - Clientes que NÃO se chamam Ana
SELECT * FROM clientes WHERE nome <> 'Ana';
-- ou
SELECT * FROM clientes WHERE nome != 'Ana';
-- ou
SELECT * FROM clientes WHERE NOT nome = 'Ana';

-- 2B - Produtos que NÃO são da categoria 1
SELECT * FROM produtos WHERE categorias_id <> 1;

-- 2C - Produtos com preço NÃO entre 5 e 10
SELECT * FROM produtos WHERE preco NOT BETWEEN 5 AND 10;

-- ----------------------------
-- IS NULL / IS NOT NULL - Valores nulos
-- ----------------------------
-- NULL = ausência de valor (não é zero nem vazio!)
-- Não se compara NULL com =, usa-se IS NULL

-- 3A - Produtos sem categoria definida (se houver)
SELECT * FROM produtos WHERE categorias_id IS NULL;

-- 3B - Produtos COM categoria definida
SELECT * FROM produtos WHERE categorias_id IS NOT NULL;

-- ----------------------------
-- DATAS - Filtrando por data
-- ----------------------------

-- 4A - Pedidos depois de 5 de janeiro de 2023
SELECT * FROM pedidos 
WHERE data_pedido > '2023-01-05';

-- 4B - Pedidos entre duas datas
SELECT * FROM pedidos 
WHERE data_pedido BETWEEN '2023-01-01' AND '2023-01-05';

-- 4C - Pedidos feitos em janeiro (qualquer ano)
SELECT * FROM pedidos 
WHERE MONTH(data_pedido) = 1;  -- MONTH() extrai o mês

-- 4D - Pedidos feitos em 2023
SELECT * FROM pedidos 
WHERE YEAR(data_pedido) = 2023;  -- YEAR() extrai o ano

-- ============================================================
-- PARTE 2: FUNÇÕES DE AGREGAÇÃO
-- ============================================================
-- Essas funções operam em VÁRIAS linhas e retornam UM resultado
--
-- COUNT()  → Conta quantas linhas
-- SUM()    → Soma os valores
-- AVG()    → Média dos valores
-- MAX()    → Maior valor
-- MIN()    → Menor valor

-- ----------------------------
-- COUNT - Contagem
-- ----------------------------

-- 5A - Quantos clientes temos?
SELECT COUNT(*) AS total_clientes FROM clientes;

-- 5B - Quantos produtos temos?
SELECT COUNT(*) AS total_produtos FROM produtos;

-- 5C - Quantos pedidos foram feitos?
SELECT COUNT(*) AS total_pedidos FROM pedidos;

-- 5D - Quantos clientes com nome diferente?
SELECT COUNT(DISTINCT nome) AS nomes_unicos FROM clientes;

-- 5E - Quantos produtos com preço > 5?
SELECT COUNT(*) AS produtos_acima_5 
FROM produtos 
WHERE preco > 5;

-- ----------------------------
-- SUM - Soma
-- ----------------------------

-- 6A - Soma total dos preços dos produtos
SELECT SUM(preco) AS soma_precos FROM produtos;

-- 6B - Soma dos preços só da categoria 1
SELECT SUM(preco) AS soma_categoria1 
FROM produtos 
WHERE categorias_id = 1;

-- ----------------------------
-- AVG - Média
-- ----------------------------

-- 7A - Preço médio dos produtos
SELECT AVG(preco) AS preco_medio FROM produtos;

-- 7B - Preço médio dos produtos com preço > 5
SELECT AVG(preco) AS preco_medio_caros 
FROM produtos 
WHERE preco > 5;

-- ----------------------------
-- MAX e MIN - Máximo e Mínimo
-- ----------------------------

-- 8A - Produto mais caro e mais barato
SELECT 
    MAX(preco) AS preco_maximo,
    MIN(preco) AS preco_minimo
FROM produtos;

-- 8B - Nome do produto mais caro (precisa de ORDER BY)
SELECT nome_produto, preco 
FROM produtos 
ORDER BY preco DESC 
LIMIT 1;

-- 8C - Nome do produto mais barato
SELECT nome_produto, preco 
FROM produtos 
ORDER BY preco ASC 
LIMIT 1;

-- ============================================================
-- PARTE 3: GROUP BY - AGRUPANDO RESULTADOS
-- ============================================================
-- GROUP BY → Agrupa linhas que têm valores iguais
-- Geralmente usado com funções de agregação
--
-- IMPORTANTE: Toda coluna no SELECT que NÃO é função
-- de agregação deve estar no GROUP BY!

-- 9A - Quantos produtos em cada categoria?
SELECT 
    categorias_id,
    COUNT(*) AS quantidade_produtos
FROM produtos
GROUP BY categorias_id;

-- 9B - Preço médio por categoria
SELECT 
    categorias_id,
    AVG(preco) AS preco_medio
FROM produtos
GROUP BY categorias_id;

-- 9C - Agora com os nomes das categorias (JOIN)
-- (Vamos aprender JOIN no próximo arquivo)
SELECT 
    c.nome_categoria AS categoria,
    COUNT(p.produtos_id) AS total_produtos,
    AVG(p.preco) AS preco_medio
FROM categorias c
LEFT JOIN produtos p ON c.categorias_id = p.categorias_id
GROUP BY c.categorias_id, c.nome_categoria;

-- ============================================================
-- PARTE 4: HAVING - FILTRANDO GRUPOS
-- ============================================================
-- HAVING é como WHERE, mas para grupos (depois do GROUP BY)
-- WHERE filtra LINHAS
-- HAVING filtra GRUPOS

-- 10A - Categorias com mais de 1 produto
SELECT 
    categorias_id,
    COUNT(*) AS total_produtos
FROM produtos
GROUP BY categorias_id
HAVING COUNT(*) > 1;

-- 10B - Categorias com preço médio > 5
SELECT 
    categorias_id,
    AVG(preco) AS preco_medio
FROM produtos
GROUP BY categorias_id
HAVING AVG(preco) > 5;

-- ============================================================
-- RESUMO DA ORDEM DOS COMANDOS:
-- ============================================================
-- SELECT → colunas que queremos ver
-- FROM → tabela de onde vêm os dados
-- WHERE → filtrar linhas (ANTES de agrupar)
-- GROUP BY → agrupar resultados
-- HAVING → filtrar grupos (DEPOIS de agrupar)
-- ORDER BY → ordenar resultado final
-- LIMIT → limitar linhas
--
-- EXEMPLO COMPLETO:
SELECT 
    categorias_id,
    COUNT(*) AS qtd,
    AVG(preco) AS media
FROM produtos
WHERE preco > 5           -- Filtra produtos com preco > 5
GROUP BY categorias_id     -- Agrupa por categoria
HAVING COUNT(*) >= 1       -- Só grupos com 1+ produtos
ORDER BY media DESC;       -- Ordena do maior para menor
-- ============================================================

-- ============================================================
-- DESAFIOS PARA PRATICAR:
-- ============================================================
-- 1. Quantos pedidos foram feitos antes de 2023-01-05?
-- 2. Qual o valor total somado de todos os produtos?
-- 3. Quantos clientes têm nome começando com 'M'?
-- 4. Qual o preço médio dos produtos da categoria 'Alimentos'?
-- 5. Quantos produtos cada categoria tem? (use GROUP BY)
-- ============================================================