-- ============================================================
-- ARQUIVO 01: CONSULTAS BÁSICAS (SELECT, FROM, AS, WHERE)
-- ============================================================
-- OBJETIVO: Aprender os comandos SQL mais básicos
-- ============================================================

USE loja;

-- ============================================================
-- SELECT - O comando mais importante do SQL
-- ============================================================
-- SELECT → "Selecione / mostre"
-- FROM   → "De / da tabela"
-- *      → "Todas as colunas"
-- WHERE  → "Onde / quando"
-- AS     → "Como / apelido" (ALIAS)
-- ORDER BY → "Ordenar por"
-- LIMIT  → "Limite de linhas"

-- ============================================================
-- EXEMPLO 1: SELECT com * (TUDO)
-- ============================================================
-- Mostra TODAS as colunas da tabela
-- * = coringa, significa "todas as colunas"

-- 1A - Todos os clientes (todas colunas)
SELECT * FROM clientes;

-- 1B - Todos os produtos
SELECT * FROM produtos;

-- 1C - Todos os pedidos
SELECT * FROM pedidos;

-- 1D - Todas as categorias
SELECT * FROM categorias;

-- 1E - Todos os itens de pedido
SELECT * FROM itens_pedido;

-- ============================================================
-- EXEMPLO 2: Selecionando colunas específicas
-- ============================================================
-- Em vez de *, listamos só as colunas que queremos

-- 2A - Só o nome dos clientes
SELECT nome FROM clientes;

-- 2B - Só nome e preço dos produtos
SELECT nome_produto, preco FROM produtos;

-- 2C - Só a data dos pedidos
SELECT data_pedido FROM pedidos;

-- ============================================================
-- EXEMPLO 3: ALIAS (APELIDOS) com AS
-- ============================================================
-- AS dá um "apelido" para a coluna no resultado
-- Deixa o resultado mais legível

-- 3A - Renomeando colunas no resultado
SELECT 
    nome_produto AS produto,   -- 'nome_produto' aparece como 'produto'
    preco AS valor             -- 'preco' aparece como 'valor'
FROM produtos;

-- 3B - Calculando e dando nome ao resultado
SELECT 
    nome_produto,
    preco,
    preco * 1.1 AS preco_com_10_porcento  -- Calcula +10% e apelida
FROM produtos;

-- ============================================================
-- EXEMPLO 4: WHERE - FILTRANDO RESULTADOS
-- ============================================================
-- WHERE = "Onde" → Filtra linhas baseado em condições
-- Operadores de comparação:
-- =   → igual a
-- >   → maior que
-- <   → menor que
-- >=  → maior ou igual
-- <=  → menor ou igual
-- <>  → diferente de (também !=)
-- AND → "e" (as duas condições devem ser verdade)
-- OR  → "ou" (pelo menos uma condição verdade)
-- IN  → "dentro de uma lista"
-- BETWEEN → "entre dois valores"

-- 4A - Produtos com preço maior que 5
SELECT * FROM produtos WHERE preco > 5;

-- 4B - Produtos com preço menor que 5
SELECT * FROM produtos WHERE preco < 5;

-- 4C - Produto específico pelo nome
SELECT * FROM produtos WHERE nome_produto = 'Pizza';

-- 4D - Produtos entre 5 e 10 reais
SELECT * FROM produtos WHERE preco BETWEEN 5 AND 10;

-- 4E - Clientes com nome específico
SELECT * FROM clientes WHERE nome = 'Ana';
-- ATENÇÃO: Retorna 2 resultados porque temos 2 clientes chamados Ana!

-- 4F - Filtrando com AND (duas condições)
SELECT * FROM produtos 
WHERE preco > 5 AND categorias_id = 1;

-- 4G - Filtrando com OR (uma ou outra condição)
SELECT * FROM produtos 
WHERE nome_produto = 'Pizza' OR nome_produto = 'Suco';

-- 4H - Usando IN (lista de valores)
SELECT * FROM produtos 
WHERE nome_produto IN ('Pizza', 'Suco', 'Shampoo');

-- ============================================================
-- EXEMPLO 5: ORDENAÇÃO COM ORDER BY
-- ============================================================
-- ORDER BY → ordena os resultados
-- ASC → crescente (padrão)
-- DESC → decrescente

-- 5A - Produtos do mais barato ao mais caro
SELECT * FROM produtos ORDER BY preco ASC;

-- 5B - Produtos do mais caro ao mais barato
SELECT * FROM produtos ORDER BY preco DESC;

-- 5C - Clientes em ordem alfabética
SELECT * FROM clientes ORDER BY nome ASC;

-- 5D - Clientes em ordem alfabética inversa
SELECT * FROM clientes ORDER BY nome DESC;

-- 5E - Combinando: filtrar + ordenar
SELECT * FROM produtos 
WHERE preco > 5 
ORDER BY preco DESC;

-- ============================================================
-- EXEMPLO 6: LIMIT - LIMITANDO RESULTADOS
-- ============================================================
-- LIMIT → limita quantas linhas retornar

-- 6A - Só os 3 primeiros produtos
SELECT * FROM produtos LIMIT 3;

-- 6B - Produto mais caro (ordenar decrescente + limitar 1)
SELECT * FROM produtos ORDER BY preco DESC LIMIT 1;

-- 6C - Produto mais barato
SELECT * FROM produtos ORDER BY preco ASC LIMIT 1;

-- 6D - Top 3 mais caros
SELECT * FROM produtos ORDER BY preco DESC LIMIT 3;

-- 6E - Pular 2 e mostrar os próximos 2 (paginação)
SELECT * FROM produtos LIMIT 2 OFFSET 2;
-- EQUIVALENTE: SELECT * FROM produtos LIMIT 2, 2;

-- ============================================================
-- EXEMPLO 7: OPERAÇÕES MATEMÁTICAS NO SELECT
-- ============================================================
-- Podemos fazer contas dentro do SELECT!

-- 7A - Aplicar 10% de desconto
SELECT 
    nome_produto,
    preco,
    preco * 0.9 AS preco_com_desconto
FROM produtos;

-- 7B - Calcular o dobro do preço
SELECT 
    nome_produto,
    preco,
    preco * 2 AS dobro
FROM produtos;

-- ============================================================
-- EXEMPLO 8: DISTINCT - VALORES ÚNICOS
-- ============================================================
-- DISTINCT remove valores duplicados do resultado

-- 8A - Quais são os nomes ÚNICOS de clientes?
SELECT DISTINCT nome FROM clientes;
-- Só mostra "Ana" uma vez, mesmo tendo duas

-- 8B - Quais categorias têm produtos cadastrados?
SELECT DISTINCT categorias_id FROM produtos;

-- ============================================================
-- DESAFIOS PARA PRATICAR:
-- ============================================================
-- Tente escrever as queries para:
-- 1. Mostrar o nome de todos os produtos e seus preços
-- 2. Mostrar o produto mais caro da loja
-- 3. Mostrar os 2 produtos mais baratos
-- 4. Mostrar clientes com nome diferente de "Ana"
-- 5. Mostrar produtos com preço entre 3 e 10 reais
-- ============================================================