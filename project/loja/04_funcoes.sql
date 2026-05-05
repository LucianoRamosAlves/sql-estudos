-- ============================================================
-- ARQUIVO 04: FUNÇÕES NO CONTEXTO DA LOJA
-- ============================================================
-- OBJETIVO: Criar funções úteis para o dia-a-dia da loja
-- usando os dados das nossas tabelas
-- ============================================================

USE loja;

-- ============================================================
-- O QUE É UMA FUNÇÃO?
-- ============================================================
-- Função = bloco de código que:
-- 1. Recebe PARÂMETROS (entrada)
-- 2. Executa uma LÓGICA
-- 3. SEMPRE retorna UM ÚNICO valor (RETURN obrigatório)
-- 4. Pode ser usada em SELECT, WHERE, etc.
--
-- ESTRUTURA:
-- DELIMITER //
-- CREATE FUNCTION nome(parametros)
-- RETURNS tipo
-- CARACTERISTICAS
-- BEGIN
--     DECLARE variavel;
--     -- lógica
--     RETURN variavel;
-- END //
-- DELIMITER ;

-- ============================================================
-- EXEMPLO 1: Função para calcular desconto
-- ============================================================
-- Objetivo: Receber preço e % de desconto, retornar preço final
-- Aplicabilidade: E-commerce, sistemas de venda

DELIMITER //

DROP FUNCTION IF EXISTS f_aplicar_desconto //

CREATE FUNCTION f_aplicar_desconto(
    preco_original DECIMAL(10,2),    -- Preço do produto
    percentual DECIMAL(5,2)          -- % de desconto (ex: 10 = 10%)
)
RETURNS DECIMAL(10,2)                -- Preço com desconto
DETERMINISTIC
BEGIN
    DECLARE preco_final DECIMAL(10,2);
    
    -- Cálculo: preço - (preço * percentual/100)
    SET preco_final = preco_original - (preco_original * percentual / 100);
    
    -- Garante que não fique negativo
    IF preco_final < 0 THEN
        SET preco_final = 0;
    END IF;
    
    RETURN preco_final;
END //

DELIMITER ;

-- TESTE: Aplicar 10% de desconto nos produtos
SELECT 
    nome_produto,
    preco,
    f_aplicar_desconto(preco, 10) AS preco_com_10_desconto,
    f_aplicar_desconto(preco, 50) AS preco_com_50_desconto
FROM produtos;

-- ============================================================
-- EXEMPLO 2: Função para classificar preço
-- ============================================================
-- Objetivo: Classificar um produto como Barato, Médio ou Caro
-- Aplicabilidade: Filtros de busca, recomendações

DELIMITER //

DROP FUNCTION IF EXISTS f_classificar_preco //

CREATE FUNCTION f_classificar_preco(
    preco DECIMAL(10,2)
)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE classificacao VARCHAR(20);
    
    IF preco < 5 THEN
        SET classificacao = 'Barato';
    ELSEIF preco <= 10 THEN
        SET classificacao = 'Médio';
    ELSE
        SET classificacao = 'Caro';
    END IF;
    
    RETURN classificacao;
END //

DELIMITER ;

-- TESTE: Classificar todos os produtos
SELECT 
    nome_produto,
    preco,
    f_classificar_preco(preco) AS categoria_preco
FROM produtos;

-- Usando a função em WHERE (filtrar por classificação)
SELECT nome_produto, preco
FROM produtos
WHERE f_classificar_preco(preco) = 'Barato';

-- ============================================================
-- EXEMPLO 3: Função para formatar nome do cliente
-- ============================================================
-- Objetivo: Padronizar nomes (primeira letra maiúscula, resto minúsculo)
-- Aplicabilidade: Cadastro de clientes, relatórios

DELIMITER //

DROP FUNCTION IF EXISTS f_formatar_nome //

CREATE FUNCTION f_formatar_nome(
    nome VARCHAR(100)
)
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    DECLARE nome_formatado VARCHAR(100);
    
    -- Concatena:
    -- LEFT(nome, 1) = primeira letra → UCASE = maiúscula
    -- SUBSTRING(nome, 2) = resto → LCASE = minúsculo
    -- TRIM = remove espaços extras
    SET nome_formatado = CONCAT(
        UCASE(LEFT(TRIM(nome), 1)),
        LCASE(SUBSTRING(TRIM(nome), 2))
    );
    
    RETURN nome_formatado;
END //

DELIMITER ;

-- TESTE: Aplicar nos clientes
SELECT 
    nome AS nome_original,
    f_formatar_nome(nome) AS nome_formatado
FROM clientes;

-- ============================================================
-- EXEMPLO 4: Função com consulta em tabela (SELECT...INTO)
-- ============================================================
-- Objetivo: Calcular total gasto por um cliente específico
-- Aplicabilidade: Dashboard do cliente, relatórios de vendas

DELIMITER //

DROP FUNCTION IF EXISTS f_total_gasto_cliente //

CREATE FUNCTION f_total_gasto_cliente(
    id_cliente INT            -- ID do cliente que vamos pesquisar
)
RETURNS DECIMAL(15,2)         -- Total gasto
DETERMINISTIC
READS SQL DATA                -- Informa que só lê dados
BEGIN
    DECLARE total DECIMAL(15,2) DEFAULT 0;
    
    -- Soma preço * quantidade de todos os pedidos do cliente
    SELECT COALESCE(SUM(pr.preco * ip.quantidade), 0)
    INTO total
    FROM clientes c
    INNER JOIN pedidos p ON c.clientes_id = p.clientes_id
    INNER JOIN itens_pedido ip ON p.pedidos_id = ip.pedidos_id
    INNER JOIN produtos pr ON ip.produtos_id = pr.produtos_id
    WHERE c.clientes_id = id_cliente;
    
    RETURN total;
END //

DELIMITER ;

-- TESTE: Quanto cada cliente gastou?
SELECT 
    clientes_id,
    nome,
    f_total_gasto_cliente(clientes_id) AS total_gasto
FROM clientes;

-- ============================================================
-- EXEMPLO 5: Função para contar pedidos de um cliente
-- ============================================================
-- Objetivo: Saber quantos pedidos um cliente já fez
-- Aplicabilidade: Programas de fidelidade, análise de clientes

DELIMITER //

DROP FUNCTION IF EXISTS f_contar_pedidos_cliente //

CREATE FUNCTION f_contar_pedidos_cliente(
    id_cliente INT
)
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE total_pedidos INT DEFAULT 0;
    
    SELECT COUNT(*)
    INTO total_pedidos
    FROM pedidos
    WHERE clientes_id = id_cliente;
    
    RETURN total_pedidos;
END //

DELIMITER ;

-- TESTE: Quantos pedidos cada cliente fez?
SELECT 
    nome,
    f_contar_pedidos_cliente(clientes_id) AS total_pedidos
FROM clientes;

-- ============================================================
-- EXEMPLO 6: Função com validação e CASE
-- ============================================================
-- Objetivo: Classificar cliente baseado no total gasto
-- Aplicabilidade: Programas de fidelidade, segmentação

DELIMITER //

DROP FUNCTION IF EXISTS f_classificar_cliente //

CREATE FUNCTION f_classificar_cliente(
    id_cliente INT
)
RETURNS VARCHAR(20)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE total DECIMAL(15,2);
    DECLARE classificacao VARCHAR(20);
    
    -- Usa a função que já criamos
    SET total = f_total_gasto_cliente(id_cliente);
    
    -- Classifica baseado no total
    IF total = 0 THEN
        SET classificacao = 'Sem compras';
    ELSEIF total < 10 THEN
        SET classificacao = 'Bronze';
    ELSEIF total < 30 THEN
        SET classificacao = 'Prata';
    ELSE
        SET classificacao = 'Ouro';
    END IF;
    
    RETURN classificacao;
END //

DELIMITER ;

-- TESTE: Classificar todos os clientes
SELECT 
    nome,
    f_total_gasto_cliente(clientes_id) AS total_gasto,
    f_classificar_cliente(clientes_id) AS classificacao
FROM clientes;

-- ============================================================
-- EXEMPLO 7: Função com cálculo de frete
-- ============================================================
-- Objetivo: Calcular frete baseado no valor do pedido
-- Aplicabilidade: E-commerce, carrinho de compras
--
-- REGRA DE FRETE:
-- Abaixo de R$ 20 → frete de R$ 10
-- Entre R$ 20 e R$ 50 → frete de R$ 5
-- Acima de R$ 50 → frete GRÁTIS

DELIMITER //

DROP FUNCTION IF EXISTS f_calcular_frete //

CREATE FUNCTION f_calcular_frete(
    valor_pedido DECIMAL(10,2)
)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE frete DECIMAL(10,2);
    
    IF valor_pedido >= 50 THEN
        SET frete = 0;            -- Frete grátis
    ELSEIF valor_pedido >= 20 THEN
        SET frete = 5;            -- Frete reduzido
    ELSE
        SET frete = 10;           -- Frete normal
    END IF;
    
    RETURN frete;
END //

DELIMITER ;

-- TESTE: Mostrar valor do pedido + frete
SELECT 
    p.pedidos_id,
    c.nome AS cliente,
    SUM(pr.preco * ip.quantidade) AS valor_pedido,
    f_calcular_frete(SUM(pr.preco * ip.quantidade)) AS frete,
    SUM(pr.preco * ip.quantidade) + 
        f_calcular_frete(SUM(pr.preco * ip.quantidade)) AS total_com_frete
FROM pedidos p
INNER JOIN clientes c ON p.clientes_id = c.clientes_id
INNER JOIN itens_pedido ip ON p.pedidos_id = ip.pedidos_id
INNER JOIN produtos pr ON ip.produtos_id = pr.produtos_id
GROUP BY p.pedidos_id, c.nome;

-- ============================================================
-- EXEMPLO 8: Função para calcular idade (usando datas)
-- ============================================================
-- Objetivo: Calcular idade baseado na data de nascimento
-- Aplicabilidade: Sistemas com cadastro de pessoas

-- Primeiro, vamos adicionar data de nascimento na tabela clientes
ALTER TABLE clientes ADD COLUMN data_nascimento DATE;

-- Atualizar alguns clientes com datas de exemplo
UPDATE clientes SET data_nascimento = '1990-05-15' WHERE clientes_id = 1;
UPDATE clientes SET data_nascimento = '1995-01-20' WHERE clientes_id = 2;
UPDATE clientes SET data_nascimento = '1988-12-01' WHERE clientes_id = 3;
UPDATE clientes SET data_nascimento = '2000-07-10' WHERE clientes_id = 4;
UPDATE clientes SET data_nascimento = '1992-03-25' WHERE clientes_id = 5;
UPDATE clientes SET data_nascimento = '1998-09-30' WHERE clientes_id = 6;
UPDATE clientes SET data_nascimento = '2002-11-15' WHERE clientes_id = 7;
UPDATE clientes SET data_nascimento = '1985-06-08' WHERE clientes_id = 8;

-- Agora a função de idade
DELIMITER //

DROP FUNCTION IF EXISTS f_calcular_idade //

CREATE FUNCTION f_calcular_idade(
    data_nascimento DATE
)
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE idade INT;
    
    -- TIMESTAMPDIFF calcula diferença entre duas datas no formato especificado
    -- YEAR = diferença em anos
    SET idade = TIMESTAMPDIFF(YEAR, data_nascimento, CURDATE());
    
    RETURN idade;
END //

DELIMITER ;

-- TESTE: Clientes com idade
SELECT 
    nome,
    data_nascimento,
    f_calcular_idade(data_nascimento) AS idade
FROM clientes;

-- Clientes maiores de idade
SELECT nome, data_nascimento
FROM clientes
WHERE f_calcular_idade(data_nascimento) >= 18;

-- ============================================================
-- RESUMO DAS CARACTERÍSTICAS DE FUNÇÕES:
-- ============================================================
-- ✅ Recebem parâmetros de entrada
-- ✅ Sempre retornam UM valor
-- ✅ Podem ser usadas em SELECT, WHERE, etc.
-- ✅ São reutilizáveis
-- ✅ DETERMINISTIC = mesmo input → mesmo output
-- ✅ READS SQL DATA = só lê dados (SELECT)
-- ✅ DELIMITER necessário para criar
-- ✅ DROP IF EXISTS para recriar sem erro
--
-- LIMITAÇÕES:
-- ❌ Não podem retornar conjuntos de resultados
-- ❌ Não podem usar transações (COMMIT/ROLLBACK)
-- ❌ Só parâmetros de entrada (IN)
-- ============================================================

-- ============================================================
-- DESAFIOS PARA PRATICAR:
-- ============================================================
-- 1. Crie uma função que retorne quanto um cliente economizou
--    com frete grátis (se o valor do pedido for >= 50)
-- 2. Crie uma função que diga se um cliente é "VIP" (mais de
--    R$ 30 em compras) ou "Normal"
-- 3. Crie uma função que calcule o valor de cada item do pedido
--    (preço * quantidade) com 2 casas decimais
-- 4. Crie uma função que formate o nome da categoria
--    (ex: 'alimentos' → 'Alimentos')
-- ============================================================