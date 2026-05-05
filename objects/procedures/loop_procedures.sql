-- ============================================================
--  LOOPS DENTRO DE PROCEDURES - Guia Básico
-- ============================================================
-- Loops servem para repetir algo várias vezes.
-- Existem 3 tipos de loop no MySQL:
--
-- 1. LOOP         → repete até você mandar parar (LEAVE)
-- 2. WHILE        → repete ENQUANTO a condição for verdade
-- 3. REPEAT       → repete ATÉ a condição ser verdade
-- ============================================================

CREATE DATABASE IF NOT EXISTS estudos_loop;
USE estudos_loop;

-- ============================================================
-- TABELA DE EXEMPLO
-- ============================================================
CREATE TABLE IF NOT EXISTS numeros (
    id INT AUTO_INCREMENT PRIMARY KEY,
    valor INT NOT NULL,
    descricao VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS logs_loop (
    id INT AUTO_INCREMENT PRIMARY KEY,
    mensagem TEXT,
    data_log DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- EXEMPLO 1: LOOP SIMPLES (com LEAVE)
-- ============================================================
-- LOOP precisa de LEAVE para parar, senão roda pra sempre!

DELIMITER $$

CREATE PROCEDURE sp_loop_simples()
BEGIN
    DECLARE v_contador INT DEFAULT 1;

    -- LOOP básico
    meuloop: LOOP
        -- Inserir na tabela
        INSERT INTO numeros (valor, descricao)
        VALUES (v_contador, CONCAT('Número ', v_contador));

        SET v_contador = v_contador + 1;

        -- Condição para parar (LEAVE)
        IF v_contador > 5 THEN
            LEAVE meuloop;
        END IF;
    END LOOP meuloop;

    SELECT 'Loop finalizado! 5 números inseridos.' AS resultado;
END $$

DELIMITER ;

-- Teste: CALL sp_loop_simples();
-- Teste: SELECT * FROM numeros;


-- ============================================================
-- EXEMPLO 2: WHILE (enquanto... faça)
-- ============================================================
-- WHILE é o mais comum. Repete ENQUANTO a condição for verdadeira.

DELIMITER $$

CREATE PROCEDURE sp_while_basico()
BEGIN
    DECLARE v_contador INT DEFAULT 1;

    -- WHILE: repete enquanto contador <= 5
    WHILE v_contador <= 5 DO
        INSERT INTO logs_loop (mensagem)
        VALUES (CONCAT('WHILE - Iteração número ', v_contador));

        SET v_contador = v_contador + 1;
    END WHILE;

    SELECT 'WHILE finalizado! 5 iterações.' AS resultado;
END $$

DELIMITER ;

-- Teste: CALL sp_while_basico();
-- Teste: SELECT * FROM logs_loop;


-- ============================================================
-- EXEMPLO 3: REPEAT (repita... até)
-- ============================================================
-- REPEAT é o contrário do WHILE.
-- Ele repete ATÉ a condição ser verdadeira (executa pelo menos 1 vez).

DELIMITER $$

CREATE PROCEDURE sp_repeat_basico()
BEGIN
    DECLARE v_contador INT DEFAULT 1;

    -- REPEAT: repete até contador > 5
    REPEAT
        INSERT INTO logs_loop (mensagem)
        VALUES (CONCAT('REPEAT - Iteração número ', v_contador));

        SET v_contador = v_contador + 1;
    UNTIL v_contador > 5 END REPEAT;

    SELECT 'REPEAT finalizado! 5 iterações.' AS resultado;
END $$

DELIMITER ;

-- Teste: CALL sp_repeat_basico();


-- ============================================================
-- EXEMPLO 4: WHILE COM TABELA (mais útil na prática)
-- ============================================================
-- Usando loop para popular dados em uma tabela

DELIMITER $$

CREATE PROCEDURE sp_gerar_tabuada(IN p_numero INT)
BEGIN
    DECLARE v_contador INT DEFAULT 1;
    DECLARE v_resultado INT;

    -- Primeiro limpa dados anteriores
    DELETE FROM numeros;

    -- Gera a tabuada do número
    WHILE v_contador <= 10 DO
        SET v_resultado = p_numero * v_contador;

        INSERT INTO numeros (valor, descricao)
        VALUES (v_resultado, CONCAT(p_numero, ' x ', v_contador, ' = ', v_resultado));

        SET v_contador = v_contador + 1;
    END WHILE;

    -- Mostra a tabuada gerada
    SELECT descricao AS tabuada FROM numeros;
END $$

DELIMITER ;

-- Teste: CALL sp_gerar_tabuada(7);  -- Tabuada do 7


-- ============================================================
-- EXEMPLO 5: LOOP COM IF DENTRO (pular números)
-- ============================================================
-- Usando IF dentro do loop para tomar decisões

DELIMITER $$

CREATE PROCEDURE sp_pares_ate(IN p_limite INT)
BEGIN
    DECLARE v_contador INT DEFAULT 1;

    DELETE FROM numeros;

    WHILE v_contador <= p_limite DO
        -- IF dentro do WHILE: só insere números pares
        IF v_contador % 2 = 0 THEN
            INSERT INTO numeros (valor, descricao)
            VALUES (v_contador, CONCAT(v_contador, ' é PAR'));
        END IF;

        SET v_contador = v_contador + 1;
    END WHILE;

    SELECT * FROM numeros;
END $$

DELIMITER ;

-- Teste: CALL sp_pares_ate(10);  -- Mostra só os pares de 1 a 10


-- ============================================================
-- EXEMPLO 6: ITERATE (pular uma volta do loop)
-- ============================================================
-- ITERATE é como um "continue" - pula para a próxima iteração

DELIMITER $$

CREATE PROCEDURE sp_pular_multiplos(IN p_limite INT)
BEGIN
    DECLARE v_contador INT DEFAULT 0;

    DELETE FROM numeros;

    meuloop: WHILE v_contador < p_limite DO
        SET v_contador = v_contador + 1;

        -- Pula os múltiplos de 3
        IF v_contador % 3 = 0 THEN
            ITERATE meuloop;  -- Volta pro começo do WHILE
        END IF;

        INSERT INTO numeros (valor, descricao)
        VALUES (v_contador, CONCAT(v_contador, ' - não é múltiplo de 3'));
    END WHILE;

    SELECT * FROM numeros;
END $$

DELIMITER ;

-- Teste: CALL sp_pular_multiplos(10);  -- Pula 3, 6, 9


-- ============================================================
-- EXEMPLO 7: LOOP COM CURSOR (lendo dados de uma tabela)
-- ============================================================
-- Percorre registros de uma tabela um por um

DELIMITER $$

CREATE PROCEDURE sp_processar_numeros()
BEGIN
    DECLARE v_id INT;
    DECLARE v_valor INT;
    DECLARE v_finalizado INT DEFAULT 0;

    -- Cursor que percorre a tabela numeros
    DECLARE cursor_numeros CURSOR FOR
        SELECT id, valor FROM numeros;

    -- Handler para quando acabar os registros
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_finalizado = 1;

    OPEN cursor_numeros;

    processar: LOOP
        FETCH cursor_numeros INTO v_id, v_valor;

        IF v_finalizado THEN
            LEAVE processar;
        END IF;

        -- Para cada número, registra no log
        INSERT INTO logs_loop (mensagem)
        VALUES (CONCAT('Processado ID ', v_id, ' - Valor: ', v_valor));
    END LOOP;

    CLOSE cursor_numeros;

    SELECT 'Todos os números foram processados!' AS resultado;
END $$

DELIMITER ;

-- Teste: CALL sp_processar_numeros();
-- Teste: SELECT * FROM logs_loop;


-- ============================================================
--  RESUMÃO DOS LOOPS
-- ============================================================
--
-- 1. LOOP (precisa de LEAVE para parar)
--    nome: LOOP
--        IF condicao THEN LEAVE nome; END IF;
--    END LOOP;
--
-- 2. WHILE (executa enquanto a condição for verdade)
--    WHILE condicao DO
--        comandos;
--    END WHILE;
--
-- 3. REPEAT (executa até a condição ser verdade)
--    REPEAT
--        comandos;
--    UNTIL condicao END REPEAT;
--
-- Comandos importantes:
--    LEAVE    → sai do loop (como break)
--    ITERATE  → pula para próxima iteração (como continue)
--
-- Quando usar cada um:
--    WHILE  → quando você NÃO sabe quantas vezes vai repetir
--    LOOP   → quando precisa de controle total (vários LEAVEs)
--    REPEAT → quando precisa garantir pelo menos 1 execução
-- ============================================================
