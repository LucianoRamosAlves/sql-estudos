-- =============================================================================
-- DICAS PRÁTICAS, BOAS PRÁTICAS E ERROS COMUNS EM JOINS
-- =============================================================================
-- Um guia de sobrevivência para trabalhar com JOINs no dia a dia
-- =============================================================================

-- CONFIGURAÇÃO
-- =============================================================================
CREATE DATABASE IF NOT EXISTS estudos_joins;
USE estudos_joins;

-- =============================================================================
-- 1. 🌟 ALIAS (APELIDOS) - SEMPRE USE!
-- =============================================================================
-- Sempre dê apelidos para suas tabelas. Código fica mais limpo.
-- =============================================================================

-- ❌ RUIM (repetitivo):
SELECT clientes.nome, pedidos.valor 
FROM clientes 
INNER JOIN pedidos ON clientes.id = pedidos.cliente_id;

-- ✅ BOM (uso de alias):
SELECT c.nome, p.valor
FROM clientes c
INNER JOIN pedidos p ON c.id = p.cliente_id;

-- ✅ ÓTIMO (alias descritivos):
SELECT cli.nome, ped.valor
FROM clientes cli
INNER JOIN pedidos ped ON cli.id = ped.cliente_id;

-- ⚠️ Padrão comum: primeira letra da tabela (c = clientes, p = pedidos)
-- Se tiver duas tabelas com a mesma letra, use duas letras:
-- cli = clientes, cat = categorias, car = carrinho


-- =============================================================================
-- 2. 🔍 ERRO COMUM: LEFT JOIN que vira INNER JOIN
-- =============================================================================
-- Esse é o erro MAIS COMUM! Você usa LEFT JOIN mas depois filtra
-- uma coluna da tabela da direita no WHERE. Isso elimina os NULLs!
-- =============================================================================

-- ❌ ERRADO (LEFT JOIN vira INNER JOIN):
SELECT c.nome, p.valor
FROM clientes c
LEFT JOIN pedidos p ON c.id = p.cliente_id
WHERE p.valor > 100;  -- Isso elimina clientes SEM pedidos!

-- ✅ CORRETO (mantém os NULLs):
SELECT c.nome, p.valor
FROM clientes c
LEFT JOIN pedidos p ON c.id = p.cliente_id
WHERE (p.valor > 100 OR p.valor IS NULL);  -- Preserva os NULLs

-- Ou filtre no ON:
SELECT c.nome, p.valor
FROM clientes c
LEFT JOIN pedidos p ON c.id = p.cliente_id AND p.valor > 100;


-- =============================================================================
-- 3. 📊 CUIDADO COM COUNT(*) vs COUNT(coluna)
-- =============================================================================
-- COUNT(*) conta TODAS as linhas, incluindo as que têm tudo NULL
-- COUNT(coluna) conta só linhas com valor NÃO-NULO naquela coluna
-- =============================================================================

-- ❌ ERRADO (conta clientes sem pedido como 1 pedido):
SELECT 
    c.nome,
    COUNT(*) AS total_pedidos  -- Conta a linha inteira (1 mesmo sem pedido!)
FROM clientes c
LEFT JOIN pedidos p ON c.id = p.cliente_id
GROUP BY c.nome;

-- ✅ CORRETO (conta só pedidos reais):
SELECT 
    c.nome,
    COUNT(p.id) AS total_pedidos  -- Só conta quando p.id NÃO é NULL
FROM clientes c
LEFT JOIN pedidos p ON c.id = p.cliente_id
GROUP BY c.nome;

-- ⚠️ Diferença:
-- COUNT(*) = conta linhas no resultado
-- COUNT(p.id) = conta valores não-NULL de p.id


-- =============================================================================
-- 4. 🎯 DICA DE OURO: ON vs WHERE
-- =============================================================================
/*
ON  = Filtro ANTES do JOIN (eficiente, afeta quais linhas são unidas)
WHERE = Filtro DEPOIS do JOIN (pode ser menos eficiente)

Para INNER JOIN: ON e WHERE são equivalentes em resultado
Para LEFT/RIGHT JOIN: ON e WHERE têm COMPORTAMENTOS DIFERENTES!
*/
-- =============================================================================

-- ON filtra antes da junção:
SELECT c.nome, p.valor
FROM clientes c
LEFT JOIN pedidos p 
    ON c.id = p.cliente_id AND p.valor > 100;
-- Resultado: TODOS os clientes, mas só pedidos > 100 (outros viram NULL)

-- WHERE filtra depois da junção:
SELECT c.nome, p.valor
FROM clientes c
LEFT JOIN pedidos p ON c.id = p.cliente_id
WHERE p.valor > 100;
-- Resultado: SÓ clientes com pedidos > 100 (perde clientes sem pedidos)


-- =============================================================================
-- 5. 💡 COALESCE - Tratando NULLs com elegância
-- =============================================================================
-- COALESCE retorna o primeiro valor não-NULL da lista
-- =============================================================================

SELECT 
    c.nome,
    COALESCE(p.valor, 0) AS valor_pedido,           -- NULL vira 0
    COALESCE(p.data_pedido, 'SEM PEDIDO') AS data   -- NULL vira texto
FROM clientes c
LEFT JOIN pedidos p ON c.id = p.cliente_id;

-- Outras funções para NULL:
-- IFNULL(valor, substituto) - Mais simples, só 2 parâmetros
-- COALESCE(val1, val2, val3, default) - Vários parâmetros

SELECT 
    IFNULL(p.valor, 0) AS com_ifnull,
    COALESCE(p.valor, 0) AS com_coalesce  -- Mesmo resultado
FROM clientes c
LEFT JOIN pedidos p ON c.id = p.cliente_id;


-- =============================================================================
-- 6. ⚡ PERFORMACE - Índices são CRUCIAIS
-- =============================================================================
-- JOINs sem índices são MUITO lentos em tabelas grandes
-- Sempre crie índices nas colunas usadas no ON
-- =============================================================================

-- Crie índices para melhorar performance de JOINs:
CREATE INDEX idx_pedidos_cliente_id ON pedidos(cliente_id);
CREATE INDEX idx_clientes_id ON clientes(id);

-- O MySQL já cria índice automático para PRIMARY KEY e FOREIGN KEY
-- Mas se você JOIN por outras colunas, crie índices manualmente

-- Verifique se uma query está usando índices:
EXPLAIN SELECT c.nome, p.valor
FROM clientes c
INNER JOIN pedidos p ON c.id = p.cliente_id;
-- EXPLAIN mostra como o MySQL executa a query


-- =============================================================================
-- 7. 🔄 ORDEM DOS JOINS IMPORTA (para performance)
-- =============================================================================
-- O MySQL tenta otimizar, mas a ordem pode afetar performance
-- Regra geral: comece com a tabela MAIOR e vá para as MENORES
-- =============================================================================

-- Se clientes tem 1000 linhas e pedidos tem 100.000:
-- Comece com clientes (menor) e adicione pedidos (maior)
SELECT c.nome, p.valor
FROM clientes c  -- Tabela menor primeiro
INNER JOIN pedidos p ON c.id = p.cliente_id;  -- Tabela maior depois


-- =============================================================================
-- 8. 🧪 TESTE COM LIMIT E EXPLAIN
-- =============================================================================
-- Sempre teste queries complexas com LIMIT antes
-- =============================================================================

-- Teste rápido:
SELECT c.nome, COUNT(p.id) AS pedidos
FROM clientes c
LEFT JOIN pedidos p ON c.id = p.cliente_id
GROUP BY c.nome
LIMIT 5;  -- Só 5 linhas para testar

-- Veja o plano de execução:
EXPLAIN SELECT c.nome, p.valor
FROM clientes c
LEFT JOIN pedidos p ON c.id = p.cliente_id;


-- =============================================================================
-- 9. 🎨 FORMATANDO JOINS LEGÍVEIS
-- =============================================================================
-- Um JOIN bem formatado é mais fácil de entender e dar manutenção
-- =============================================================================

-- ✅ BEM FORMATADO:
SELECT 
    c.nome            AS cliente,
    p.id              AS pedido_id,
    p.data_pedido,
    pr.nome           AS produto,
    i.quantidade,
    i.preco_unitario,
    (i.quantidade * i.preco_unitario) AS subtotal,
    cat.nome          AS categoria
FROM clientes c
INNER JOIN pedidos p 
    ON c.id = p.cliente_id
INNER JOIN itens_pedido i 
    ON p.id = i.pedido_id
INNER JOIN produtos pr 
    ON i.produto_id = pr.id
INNER JOIN categorias cat 
    ON pr.categoria_id = cat.id
WHERE p.status = 'Entregue'
    AND i.quantidade > 0
ORDER BY p.data_pedido DESC
LIMIT 100;

-- Regras de formatação:
-- 1. Um JOIN por linha
-- 2. ON alinhado e indentado
-- 3. Cada coluna em sua linha (para SELECT com muitas colunas)
-- 4. Alias descritivos
-- 5. Comentários para joins complexos


-- =============================================================================
-- 10. 🚫 ERROS COMUNS PARA EVITAR
-- =============================================================================

-- ERRO 1: Esquecer a condição ON (cria CROSS JOIN acidental)
-- SELECT c.nome, p.valor
-- FROM clientes c, pedidos p;  -- Esqueceu WHERE! Vira CROSS JOIN!

-- ERRO 2: ON com coluna errada
-- SELECT c.nome, p.valor
-- FROM clientes c
-- INNER JOIN pedidos p ON c.nome = p.produto;  -- Lógica errada!

-- ERRO 3: LEFT JOIN com WHERE na tabela da direita (já vimos)
-- SELECT c.nome, p.valor
-- FROM clientes c
-- LEFT JOIN pedidos p ON c.id = p.cliente_id
-- WHERE p.valor > 0;  -- Vira INNER JOIN!

-- ERRO 4: Esquecer GROUP BY com funções de agregação
-- SELECT c.nome, COUNT(p.id)
-- FROM clientes c
-- LEFT JOIN pedidos p ON c.id = p.cliente_id;
-- -- SQL mode only_full_group_by vai dar erro!

-- ERRO 5: JOIN em tabelas sem índices (lentidão extrema)
-- : Crie índices nas colunas do ON

-- ERRO 6: Usar DISTINCT para "consertar" JOIN duplicado
-- SELECT DISTINCT c.nome
-- FROM clientes c
-- INNER JOIN pedidos p ON c.id = p.cliente_id;
-- Melhor investigar POR QUE está duplicando

-- ERRO 7: Não considerar LEFT JOIN para hierarquia
-- SELECT f.nome, g.nome AS gerente
-- FROM funcionarios f
-- INNER JOIN funcionarios g ON f.gerente_id = g.id;
-- O CHEFE NÃO APARECE (não tem gerente)! Use LEFT JOIN


-- =============================================================================
-- 11. 📋 CHECKLIST PARA CRIAR UM JOIN
-- =============================================================================
/*
╔═══════════════════════════════════════════════════════════════════╗
║              CHECKLIST PARA CRIAR JOINS                          ║
╠═══════════════════════════════════════════════════════════════════╣
║                                                                  ║
║  [ ] Qual é a tabela PRINCIPAL? (colocar no FROM)               ║
║  [ ] Quero TODOS os registros dela? → LEFT JOIN                 ║
║  [ ] Quero SÓ quem tem correspondência? → INNER JOIN            ║
║  [ ] Quais colunas ligam as tabelas? (condição ON)              ║
║  [ ] Os nomes das colunas são IGUAIS? → posso usar USING        ║
║  [ ] Preciso de mais de uma condição? → ON com AND              ║
║  [ ] Preciso de mais tabelas? → encadeie mais JOINS             ║
║  [ ]Testei com LIMIT?                                           ║
║  [ ] As colunas do ON têm ÍNDICES?                              ║
║  [ ] Os NULLs estão sendo tratados corretamente?                ║
║                                                                  ║
╚═══════════════════════════════════════════════════════════════════╝
*/

-- LIMPEZA (opcional)
-- DROP DATABASE IF EXISTS estudos_joins;
