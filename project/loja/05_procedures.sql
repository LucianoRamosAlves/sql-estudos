-- ============================================================
-- ARQUIVO 05: PROCEDURES NO CONTEXTO DA LOJA
-- ============================================================
-- OBJETIVO: Aprender a criar procedures (procedimentos
-- armazenados) para automatizar tarefas da loja
-- ============================================================

USE loja;

-- ============================================================
-- O QUE É UMA PROCEDURE?
-- ============================================================
-- Procedure = bloco de código que:
-- 1. Pode receber parâmetros (IN, OUT, INOUT)
-- 2. Executa uma ou várias ações
-- 3. Pode retornar ZERO ou MÚLTIPLOS valores (via OUT)
-- 4. Pode usar transações (COMMIT, ROLLBACK)
-- 5. Pode modificar dados (INSERT, UPDATE, DELETE)
-- 6. NÃO pode ser usada em SELECT (diferente de função)
--
-- CHAMADA: CALL nome_procedure(parametros);
--
-- DIFERENÇA FUNÇÃO vs PROCEDURE:
-- | Característica   | FUNÇÃO          | PROCEDURE       |
-- |------------------|-----------------|-----------------|
-- | Retorno          | SEMPRE 1 valor  | 0 ou + valores  |
-- | Usar em SELECT   | ✅ Sim          | ❌ Não          |
-- | Parâmetros OUT   | ❌ Não          | ✅ Sim          |
-- | Transações       | ❌ Não          | ✅ Sim          |
-- | Modificar dados  | ❌ Evitar       | ✅ Sim          |
-- | RETURN           | Obrigatório     | Opcional        |
-- ============================================================

-- ============================================================
-- EXEMPLO 1: Procedure para inserir novo cliente
-- ============================================================
-- Objetivo: Cadastrar um cliente de forma segura
-- Aplicabilidade: Sistemas de cadastro

DELIMITER //

DROP PROCEDURE IF EXISTS sp_inserir_cliente //

CREATE PROCEDURE sp_inserir_cliente(
    IN p_nome VARCHAR(50)       -- Nome do cliente (entrada)
)
BEGIN
    -- Insere o cliente na tabela
    INSERT INTO clientes (nome) VALUES (p_nome);
    
    -- Mostra mensagem de confirmação
    SELECT CONCAT('Cliente "', p_nome, '" cadastrado com sucesso!') AS mensagem;
END //

DELIMITER ;

-- TESTE:
CALL sp_inserir_cliente('Carlos');
SELECT * FROM clientes;  -- Verifica se Carlos foi adicionado

-- ============================================================
-- EXEMPLO 2: Procedure para inserir pedido completo
-- ============================================================
-- Objetivo: Criar pedido com itens em uma única chamada
-- Aplicabilidade: Sistemas de vendas (PDV, e-commerce)
-- Demonstra: transação, validação, múltiplos parâmetros

DELIMITER //

DROP PROCEDURE IF EXISTS sp_criar_pedido //

CREATE PROCEDURE sp_criar_pedido(
    IN p_cliente_id INT,        -- ID do cliente
    IN p_produto_id INT,        -- ID do produto
    IN p_quantidade INT,        -- Quantidade
    IN p_data DATE              -- Data do pedido
)
BEGIN
    DECLARE v_cliente_existe INT;
    DECLARE v_produto_existe INT;
    DECLARE v_pedido_id INT;
    
    -- Inicia a transação (se algo der errado, tudo volta)
    START TRANSACTION;
    
    -- Verifica se o cliente existe
    SELECT COUNT(*) INTO v_cliente_existe
    FROM clientes WHERE clientes_id = p_cliente_id;
    
    -- Verifica se o produto existe
    SELECT COUNT(*) INTO v_produto_existe
    FROM produtos WHERE produtos_id = p_produto_id;
    
    -- Validações
    IF v_cliente_existe = 0 THEN
        SELECT 'ERRO: Cliente não encontrado!' AS mensagem;
        ROLLBACK;  -- Desfaz tudo
    ELSEIF v_produto_existe = 0 THEN
        SELECT 'ERRO: Produto não encontrado!' AS mensagem;
        ROLLBACK;
    ELSEIF p_quantidade <= 0 THEN
        SELECT 'ERRO: Quantidade inválida!' AS mensagem;
        ROLLBACK;
    ELSE
        -- Cria o pedido
        INSERT INTO pedidos (clientes_id, data_pedido)
        VALUES (p_cliente_id, p_data);
        
        -- Pega o ID do pedido que acabou de ser criado
        SET v_pedido_id = LAST_INSERT_ID();
        
        -- Insere o item no pedido
        INSERT INTO itens_pedido (pedidos_id, produtos_id, quantidade)
        VALUES (v_pedido_id, p_produto_id, p_quantidade);
        
        -- Confirma a transação
        COMMIT;
        
        SELECT 
            CONCAT('Pedido #', v_pedido_id, ' criado com sucesso!') AS mensagem,
            v_pedido_id AS pedido_id;
    END IF;
END //

DELIMITER ;

-- TESTE: Criar um pedido para cliente 1 com produto 2
CALL sp_criar_pedido(1, 2, 4, '2026-05-05');
SELECT * FROM pedidos;
SELECT * FROM itens_pedido;

-- TESTE: Tentar criar pedido com cliente inexistente
CALL sp_criar_pedido(999, 1, 1, '2026-05-05');

-- ============================================================
-- EXEMPLO 3: Procedure com parâmetros OUT (retorno)
-- ============================================================
-- Objetivo: Buscar dados de um cliente e retornar em variáveis
-- Aplicabilidade: Sistemas que precisam de dados processados

DELIMITER //

DROP PROCEDURE IF EXISTS sp_buscar_cliente //

CREATE PROCEDURE sp_buscar_cliente(
    IN p_cliente_id INT,            -- Entrada: ID do cliente
    OUT p_nome VARCHAR(50),         -- Saída: nome do cliente
    OUT p_total_pedidos INT,        -- Saída: total de pedidos
    OUT p_total_gasto DECIMAL(15,2) -- Saída: total gasto
)
BEGIN
    -- Busca o nome do cliente
    SELECT nome INTO p_nome
    FROM clientes
    WHERE clientes_id = p_cliente_id;
    
    -- Conta os pedidos
    SELECT COUNT(*) INTO p_total_pedidos
    FROM pedidos
    WHERE clientes_id = p_cliente_id;
    
    -- Calcula o total gasto
    SELECT COALESCE(SUM(pr.preco * ip.quantidade), 0) INTO p_total_gasto
    FROM clientes c
    LEFT JOIN pedidos p ON c.clientes_id = p.clientes_id
    LEFT JOIN itens_pedido ip ON p.pedidos_id = ip.pedidos_id
    LEFT JOIN produtos pr ON ip.produtos_id = pr.produtos_id
    WHERE c.clientes_id = p_cliente_id;
END //

DELIMITER ;

-- TESTE: Chamar a procedure e ver os valores retornados
SET @nome = '';
SET @pedidos = 0;
SET @gasto = 0;

CALL sp_buscar_cliente(1, @nome, @pedidos, @gasto);

SELECT 
    @nome AS nome_cliente,
    @pedidos AS total_pedidos,
    @gasto AS total_gasto;

-- ============================================================
-- EXEMPLO 4: Procedure com cursor (loop por resultados)
-- ============================================================
-- Objetivo: Gerar relatório de clientes com seus totais
-- Aplicabilidade: Relatórios, exportação de dados

DELIMITER //

DROP PROCEDURE IF EXISTS sp_relatorio_vendas //

CREATE PROCEDURE sp_relatorio_vendas()
BEGIN
    -- Mostra um relatório completo de vendas
    SELECT 
        c.clientes_id,
        c.nome AS cliente,
        COUNT(DISTINCT p.pedidos_id) AS total_pedidos,
        COALESCE(SUM(pr.preco * ip.quantidade), 0) AS total_gasto,
        CASE 
            WHEN COALESCE(SUM(pr.preco * ip.quantidade), 0) >= 50 THEN 'VIP'
            WHEN COALESCE(SUM(pr.preco * ip.quantidade), 0) > 0 THEN 'Regular'
            ELSE 'Sem compras'
        END AS status
    FROM clientes c
    LEFT JOIN pedidos p ON c.clientes_id = p.clientes_id
    LEFT JOIN itens_pedido ip ON p.pedidos_id = ip.pedidos_id
    LEFT JOIN produtos pr ON ip.produtos_id = pr.produtos_id
    GROUP BY c.clientes_id, c.nome
    ORDER BY total_gasto DESC;
END //

DELIMITER ;

-- TESTE:
CALL sp_relatorio_vendas();

-- ============================================================
-- EXEMPLO 5: Procedure para atualizar preços
-- ============================================================
-- Objetivo: Aplicar reajuste em massa nos produtos
-- Aplicabilidade: Gestão de estoque/preços

DELIMITER //

DROP PROCEDURE IF EXISTS sp_reajustar_precos //

CREATE PROCEDURE sp_reajustar_precos(
    IN p_categoria_id INT,       -- NULL = todas as categorias
    IN p_percentual DECIMAL(5,2) -- % de aumento (positivo) ou desconto (negativo)
)
BEGIN
    DECLARE v_linhas_afetadas INT;
    
    -- Se categoria for NULL, atualiza todos
    IF p_categoria_id IS NULL THEN
        UPDATE produtos 
        SET preco = preco * (1 + p_percentual / 100);
        
        SET v_linhas_afetadas = ROW_COUNT();
        
        SELECT CONCAT('Preços de TODOS os produtos reajustados em ', 
                      p_percentual, '%. Total: ', v_linhas_afetadas, ' produtos') AS mensagem;
    ELSE
        -- Verifica se a categoria existe
        IF EXISTS (SELECT 1 FROM categorias WHERE categorias_id = p_categoria_id) THEN
            UPDATE produtos 
            SET preco = preco * (1 + p_percentual / 100)
            WHERE categorias_id = p_categoria_id;
            
            SET v_linhas_afetadas = ROW_COUNT();
            
            SELECT CONCAT('Preços da categoria ', p_categoria_id, 
                          ' reajustados em ', p_percentual, 
                          '%. Total: ', v_linhas_afetadas, ' produtos') AS mensagem;
        ELSE
            SELECT 'ERRO: Categoria não encontrada!' AS mensagem;
        END IF;
    END IF;
END //

DELIMITER ;

-- TESTE: Aumentar 15% nos preços da categoria 1 (Alimentos)
CALL sp_reajustar_precos(1, 15);
SELECT * FROM produtos WHERE categorias_id = 1;

-- Voltar ao normal para os próximos testes
UPDATE produtos SET preco = 10.99 WHERE produtos_id = 1;

-- ============================================================
-- EXEMPLO 6: Procedure para excluir cliente com segurança
-- ============================================================
-- Objetivo: Remover cliente e todos seus dados relacionados
-- Aplicabilidade: LGPD, exclusão de contas

DELIMITER //

DROP PROCEDURE IF EXISTS sp_excluir_cliente //

CREATE PROCEDURE sp_excluir_cliente(
    IN p_cliente_id INT
)
BEGIN
    DECLARE v_cliente_existe INT;
    
    -- Verifica se cliente existe
    SELECT COUNT(*) INTO v_cliente_existe
    FROM clientes WHERE clientes_id = p_cliente_id;
    
    IF v_cliente_existe = 0 THEN
        SELECT 'ERRO: Cliente não encontrado!' AS mensagem;
    ELSE
        START TRANSACTION;
        
        -- Remove itens dos pedidos do cliente
        DELETE ip FROM itens_pedido ip
        INNER JOIN pedidos p ON ip.pedidos_id = p.pedidos_id
        WHERE p.clientes_id = p_cliente_id;
        
        -- Remove os pedidos do cliente
        DELETE FROM pedidos WHERE clientes_id = p_cliente_id;
        
        -- Remove o cliente
        DELETE FROM clientes WHERE clientes_id = p_cliente_id;
        
        COMMIT;
        
        SELECT CONCAT('Cliente ID ', p_cliente_id, 
                      ' e todos seus dados foram excluídos.') AS mensagem;
    END IF;
END //

DELIMITER ;

-- TESTE: Excluir o cliente Carlos que criamos
CALL sp_excluir_cliente(9);  -- ID do Carlos que inserimos
SELECT * FROM clientes;

-- ============================================================
-- EXEMPLO 7: Procedure com LOOP (WHILE)
-- ============================================================
-- Objetivo: Gerar dados de teste automaticamente
-- Aplicabilidade: Testes, população de banco

DELIMITER //

DROP PROCEDURE IF EXISTS sp_gerar_clientes_teste //

CREATE PROCEDURE sp_gerar_clientes_teste(
    IN p_quantidade INT       -- Quantos clientes gerar
)
BEGIN
    DECLARE v_contador INT DEFAULT 1;
    
    -- Loop para criar clientes
    WHILE v_contador <= p_quantidade DO
        INSERT INTO clientes (nome)
        VALUES (CONCAT('Cliente Teste #', v_contador));
        
        SET v_contador = v_contador + 1;
    END WHILE;
    
    SELECT CONCAT(p_quantidade, ' clientes de teste criados!') AS mensagem;
END //

DELIMITER ;

-- TESTE: Criar 3 clientes de teste
CALL sp_gerar_clientes_teste(3);
SELECT * FROM clientes;

-- Limpar dados de teste
DELETE FROM clientes WHERE nome LIKE 'Cliente Teste%';

-- ============================================================
-- RESUMO DAS CARACTERÍSTICAS DE PROCEDURES:
-- ============================================================
-- ✅ Parâmetros IN, OUT, INOUT
-- ✅ Podem modificar dados (INSERT, UPDATE, DELETE)
-- ✅ Suportam transações (START TRANSACTION, COMMIT, ROLLBACK)
-- ✅ Podem ter validações e tratamento de erros
-- ✅ Podem ter loops (WHILE, REPEAT, LOOP)
-- ✅ Podem retornar múltiplos valores (OUT)
--
-- ❌ NÃO podem ser usadas em SELECT, WHERE, etc.
-- ❌ NÃO têm RETURN (mas podem ter SELECT como saída)
--
-- QUANDO USAR FUNÇÃO vs PROCEDURE:
-- - FUNÇÃO: quando precisa de UM valor de volta (cálculo, formatação)
-- - PROCEDURE: quando precisa executar AÇÕES (inserir, atualizar, relatórios)
-- ============================================================

-- ============================================================
-- DESAFIOS PARA PRATICAR:
-- ============================================================
-- 1. Crie uma procedure que liste todos os pedidos de um cliente
-- 2. Crie uma procedure que calcule e mostre o ticket médio
--    (valor total / total de pedidos)
-- 3. Crie uma procedure que faça uma "venda" completa:
--    receba cliente, lista de produtos e quantidades
-- 4. Crie uma procedure que aplique desconto em produtos
--    com estoque baixo (simule um campo estoque)
-- ============================================================