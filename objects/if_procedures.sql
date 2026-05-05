-- ============================================================
--  IF DENTRO DE PROCEDURES - Guia Completo e Simples
-- ============================================================
-- O IF é usado dentro de procedures para tomar decisões.
-- Estrutura:
--
-- IF condição THEN
--     faz algo
-- ELSEIF outra_condição THEN
--     faz outra coisa
-- ELSE
--     faz algo diferente
-- END IF;
-- ============================================================

CREATE DATABASE IF NOT EXISTS estudos_if;
USE estudos_if;

-- ============================================================
-- TABELA DE EXEMPLO
-- ============================================================
CREATE TABLE IF NOT EXISTS produtos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    preco DECIMAL(10,2) NOT NULL,
    estoque INT DEFAULT 0,
    categoria VARCHAR(50) DEFAULT 'Geral',
    status VARCHAR(20) DEFAULT 'Ativo'
);

INSERT INTO produtos (nome, preco, estoque, categoria) VALUES
('Notebook', 3500.00, 10, 'Eletrônicos'),
('Mouse', 50.00, 100, 'Eletrônicos'),
('Camiseta', 79.90, 30, 'Vestuário'),
('Livro SQL', 89.90, 2, 'Livros'),
('Monitor', 1200.00, 0, 'Eletrônicos'),
('Teclado', 0.00, 50, 'Eletrônicos');  -- preço 0 para teste

-- ============================================================
-- EXEMPLO 1: IF SIMPLES (mais básico possível)
-- ============================================================
-- Verifica se um produto tem estoque baixo

DELIMITER $$

CREATE PROCEDURE sp_verificar_estoque(IN p_produto_id INT)
BEGIN
    DECLARE v_estoque INT;
    DECLARE v_nome VARCHAR(100);

    -- Pega os dados do produto
    SELECT nome, estoque INTO v_nome, v_estoque
    FROM produtos WHERE id = p_produto_id;

    -- IF simples
    IF v_estoque < 5 THEN
        SELECT CONCAT('ALERTA: ', v_nome, ' tem apenas ', v_estoque, ' unidades!') AS mensagem;
    END IF;

    -- Mostra o produto
    SELECT id, nome, estoque FROM produtos WHERE id = p_produto_id;
END $$

DELIMITER ;

-- Teste: CALL sp_verificar_estoque(4);  -- Livro com estoque 2 (vai mostrar alerta)
-- Teste: CALL sp_verificar_estoque(1);  -- Notebook com 10 (não mostra alerta)


-- ============================================================
-- EXEMPLO 2: IF / ELSE (básico)
-- ============================================================
-- Diz se o produto está disponível ou não

DELIMITER $$

CREATE PROCEDURE sp_disponibilidade(IN p_produto_id INT)
BEGIN
    DECLARE v_estoque INT;
    DECLARE v_nome VARCHAR(100);

    SELECT nome, estoque INTO v_nome, v_estoque
    FROM produtos WHERE id = p_produto_id;

    -- IF / ELSE
    IF v_estoque > 0 THEN
        SELECT CONCAT(v_nome, ' - DISPONÍVEL (', v_estoque, ' unidades)') AS status;
    ELSE
        SELECT CONCAT(v_nome, ' - INDISPONÍVEL (estoque zerado)') AS status;
    END IF;
END $$

DELIMITER ;

-- Teste: CALL sp_disponibilidade(1);  -- Notebook - DISPONÍVEL
-- Teste: CALL sp_disponibilidade(5);  -- Monitor - INDISPONÍVEL


-- ============================================================
-- EXEMPLO 3: IF / ELSEIF / ELSE (várias condições)
-- ============================================================
-- Classifica o preço do produto em categorias

DELIMITER $$

CREATE PROCEDURE sp_classificar_preco(IN p_produto_id INT)
BEGIN
    DECLARE v_preco DECIMAL(10,2);
    DECLARE v_nome VARCHAR(100);
    DECLARE v_classificacao VARCHAR(30);

    SELECT nome, preco INTO v_nome, v_preco
    FROM produtos WHERE id = p_produto_id;

    -- IF com várias condições
    IF v_preco = 0 THEN
        SET v_classificacao = 'Preço não definido';
    ELSEIF v_preco < 100 THEN
        SET v_classificacao = 'Barato';
    ELSEIF v_preco >= 100 AND v_preco < 1000 THEN
        SET v_classificacao = 'Médio';
    ELSEIF v_preco >= 1000 AND v_preco < 5000 THEN
        SET v_classificacao = 'Caro';
    ELSE
        SET v_classificacao = 'Muito Caro';
    END IF;

    -- Mostra o resultado
    SELECT
        v_nome AS produto,
        CONCAT('R$ ', v_preco) AS preco,
        v_classificacao AS classificacao;
END $$

DELIMITER ;

-- Teste: CALL sp_classificar_preco(6);  -- Teclado - Preço não definido
-- Teste: CALL sp_classificar_preco(2);  -- Mouse - Barato
-- Teste: CALL sp_classificar_preco(5);  -- Monitor - Caro


-- ============================================================
-- EXEMPLO 4: IF DENTRO DE OUTRO IF (IF aninhado)
-- ============================================================
-- Um IF dentro do outro para decisões mais específicas

DELIMITER $$

CREATE PROCEDURE sp_analisar_produto(IN p_produto_id INT)
BEGIN
    DECLARE v_preco DECIMAL(10,2);
    DECLARE v_estoque INT;
    DECLARE v_nome VARCHAR(100);

    SELECT nome, preco, estoque INTO v_nome, v_preco, v_estoque
    FROM produtos WHERE id = p_produto_id;

    -- IF aninhado (um IF dentro de outro)
    IF v_estoque > 0 THEN
        -- Tem estoque, agora verifica o preço
        IF v_preco = 0 THEN
            SELECT CONCAT(v_nome, ' - Em estoque, mas sem preço definido') AS analise;
        ELSEIF v_preco < 50 THEN
            SELECT CONCAT(v_nome, ' - Produto popular (barato e em estoque)') AS analise;
        ELSE
            SELECT CONCAT(v_nome, ' - Produto disponível, preço: R$ ', v_preco) AS analise;
        END IF;
    ELSE
        -- Não tem estoque
        IF v_preco = 0 THEN
            SELECT CONCAT(v_nome, ' - Produto sem estoque e sem preço') AS analise;
        ELSE
            SELECT CONCAT(v_nome, ' - Produto sem estoque. Preço: R$ ', v_preco) AS analise;
        END IF;
    END IF;
END $$

DELIMITER ;

-- Teste: CALL sp_analisar_produto(6);  -- Teclado - em estoque, sem preço
-- Teste: CALL sp_analisar_produto(5);  -- Monitor - sem estoque


-- ============================================================
-- EXEMPLO 5: IF USANDO OUTRA TABELA (UPDATE condicional)
-- ============================================================
-- Atualiza o status do produto baseado em regras

DELIMITER $$

CREATE PROCEDURE sp_atualizar_status(IN p_produto_id INT)
BEGIN
    DECLARE v_preco DECIMAL(10,2);
    DECLARE v_estoque INT;
    DECLARE v_nome VARCHAR(100);

    SELECT nome, preco, estoque INTO v_nome, v_preco, v_estoque
    FROM produtos WHERE id = p_produto_id;

    -- Atualiza o status baseado nas condições
    IF v_estoque = 0 THEN
        UPDATE produtos SET status = 'Indisponível' WHERE id = p_produto_id;
        SELECT CONCAT(v_nome, ' - Status alterado para Indisponível (estoque zerado)') AS resultado;
    ELSEIF v_preco = 0 THEN
        UPDATE produtos SET status = 'Preço Pendente' WHERE id = p_produto_id;
        SELECT CONCAT(v_nome, ' - Status alterado para Preço Pendente') AS resultado;
    ELSEIF v_estoque < 5 THEN
        UPDATE produtos SET status = 'Estoque Crítico' WHERE id = p_produto_id;
        SELECT CONCAT(v_nome, ' - Status alterado para Estoque Crítico (menos de 5 unidades)') AS resultado;
    ELSE
        UPDATE produtos SET status = 'Ativo' WHERE id = p_produto_id;
        SELECT CONCAT(v_nome, ' - Status mantido como Ativo') AS resultado;
    END IF;
END $$

DELIMITER ;

-- Teste: CALL sp_atualizar_status(4);  -- Livro com estoque 2 -> Estoque Crítico
-- Teste: CALL sp_atualizar_status(5);  -- Monitor com estoque 0 -> Indisponível


-- ============================================================
-- EXEMPLO 6: IF COM VARIAVEL CALCULADA
-- ============================================================
-- Calcula desconto baseado no valor total

DELIMITER $$

CREATE PROCEDURE sp_calcular_desconto(IN p_produto_id INT, IN p_quantidade INT)
BEGIN
    DECLARE v_preco DECIMAL(10,2);
    DECLARE v_nome VARCHAR(100);
    DECLARE v_total DECIMAL(10,2);
    DECLARE v_desconto DECIMAL(10,2);
    DECLARE v_final DECIMAL(10,2);

    SELECT nome, preco INTO v_nome, v_preco
    FROM produtos WHERE id = p_produto_id;

    SET v_total = v_preco * p_quantidade;

    -- IF para definir o desconto
    IF p_quantidade >= 100 THEN
        SET v_desconto = v_total * 0.20;  -- 20% de desconto
        SELECT CONCAT('Desconto de 20% aplicado (compra acima de 100 unidades)') AS observacao;
    ELSEIF p_quantidade >= 50 THEN
        SET v_desconto = v_total * 0.10;  -- 10% de desconto
        SELECT CONCAT('Desconto de 10% aplicado') AS observacao;
    ELSEIF p_quantidade >= 10 THEN
        SET v_desconto = v_total * 0.05;  -- 5% de desconto
        SELECT CONCAT('Desconto de 5% aplicado') AS observacao;
    ELSE
        SET v_desconto = 0;  -- Sem desconto
        SELECT 'Sem desconto para esta quantidade' AS observacao;
    END IF;

    SET v_final = v_total - v_desconto;

    -- Mostra o resumo
    SELECT
        v_nome AS produto,
        p_quantidade AS quantidade,
        CONCAT('R$ ', v_preco) AS preco_unitario,
        CONCAT('R$ ', v_total) AS total_bruto,
        CONCAT('R$ ', v_desconto) AS desconto,
        CONCAT('R$ ', v_final) AS total_final;
END $$

DELIMITER ;

-- Teste: CALL sp_calcular_desconto(2, 5);    -- Mouse, 5 unidades -> sem desconto
-- Teste: CALL sp_calcular_desconto(2, 10);   -- Mouse, 10 unidades -> 5% desconto
-- Teste: CALL sp_calcular_desconto(2, 100);  -- Mouse, 100 unidades -> 20% desconto


-- ============================================================
-- EXEMPLO 7: IF COM NOT EXISTS (verifica se registro existe)
-- ============================================================
-- Só faz algo se o produto existir

DELIMITER $$

CREATE PROCEDURE sp_buscar_ou_aviso(IN p_produto_id INT)
BEGIN
    -- Verifica se o produto existe
    IF NOT EXISTS (SELECT 1 FROM produtos WHERE id = p_produto_id) THEN
        SELECT CONCAT('Produto com ID ', p_produto_id, ' não encontrado!') AS erro;
    ELSE
        -- Existe, mostra os dados
        SELECT * FROM produtos WHERE id = p_produto_id;
    END IF;
END $$

DELIMITER ;

-- Teste: CALL sp_buscar_ou_aviso(1);   -- Notebook (existe)
-- Teste: CALL sp_buscar_ou_aviso(99);  -- Não existe (vai mostrar erro)


-- ============================================================
--  RESUMÃO DO IF EM PROCEDURES
-- ============================================================
--
-- IF estrutura básica:
--     IF condicao THEN
--         comando;
--     END IF;
--
-- IF com ELSE:
--     IF condicao THEN
--         comando;
--     ELSE
--         comando;
--     END IF;
--
-- IF completo:
--     IF condicao1 THEN
--         comando1;
--     ELSEIF condicao2 THEN
--         comando2;
--     ELSE
--         comando3;
--     END IF;
--
-- Operadores comuns no IF:
--     =          → igual
--     <>  ou != → diferente
--     >  <  >=  <=
--     AND       → e (as duas condições verdadeiras)
--     OR        → ou (uma das condições verdadeiras)
--     NOT       → não (nega a condição)
--     IS NULL   → é nulo
--     IS NOT NULL → não é nulo
--     IN (1,2,3)  → está dentro da lista
-- ============================================================
