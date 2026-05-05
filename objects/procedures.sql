-- ============================================================
--  PROCEDURES (PROCEDIMENTOS ARMAZENADOS) - Guia Básico
-- ============================================================
-- Procedures guardam códigos SQL no banco para reutilizar.
-- Você cria uma vez e chama quantas vezes quiser com CALL.
-- ============================================================

-- ============================================================
-- 1. CRIANDO UMA DATABASE SIMPLES
-- ============================================================
CREATE DATABASE IF NOT EXISTS estudos_procedure;
USE estudos_procedure;

-- ============================================================
-- 2. TABELAS SIMPLES
-- ============================================================
CREATE TABLE IF NOT EXISTS alunos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    nota DECIMAL(4,2) DEFAULT 0,
    situacao VARCHAR(20) DEFAULT 'Cursando'
);

CREATE TABLE IF NOT EXISTS logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    mensagem TEXT,
    data_log DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Inserindo dados de exemplo
INSERT INTO alunos (nome, nota) VALUES
('João', 8.5),
('Maria', 6.0),
('Pedro', 4.5),
('Ana', 9.0),
('Lucas', 5.0);

-- ============================================================
-- 3. PROCEDURE SEM PARÂMETRO (mais simples possível)
-- ============================================================
-- Mostra todos os alunos

DELIMITER $$

CREATE PROCEDURE sp_listar_alunos()
BEGIN
    SELECT id, nome, nota, situacao FROM alunos;
END $$

DELIMITER ;

 -- Executar: CALL sp_listar_alunos();


-- ============================================================
-- 4. PROCEDURE COM PARÂMETRO DE ENTRADA (IN)
-- ============================================================
-- Busca aluno pelo nome

DELIMITER $$

CREATE PROCEDURE sp_buscar_aluno(IN p_nome VARCHAR(100))
BEGIN
    SELECT * FROM alunos WHERE nome LIKE CONCAT('%', p_nome, '%');
END $$

DELIMITER ;

-- Executar: CALL sp_buscar_aluno('João');


-- ============================================================
-- 5. PROCEDURE COM PARÂMETRO DE SAÍDA (OUT)
-- ============================================================
-- Retorna a quantidade de alunos aprovados (nota >= 6)

DELIMITER $$

CREATE PROCEDURE sp_total_aprovados(OUT p_total INT)
BEGIN
    SELECT COUNT(*) INTO p_total FROM alunos WHERE nota >= 6;
END $$

DELIMITER ;

-- Executar:
-- CALL sp_total_aprovados(@total);
-- SELECT @total AS aprovados;


-- ============================================================
-- 6. PROCEDURE COM IF/ELSE
-- ============================================================
-- Define a situação do aluno baseado na nota

DELIMITER $$

CREATE PROCEDURE sp_definir_situacao(IN p_id INT)
BEGIN
    DECLARE v_nota DECIMAL(4,2);

    -- Pega a nota do aluno
    SELECT nota INTO v_nota FROM alunos WHERE id = p_id;

    -- Define a situação
    IF v_nota >= 7 THEN
        UPDATE alunos SET situacao = 'Aprovado' WHERE id = p_id;
    ELSEIF v_nota >= 5 THEN
        UPDATE alunos SET situacao = 'Recuperação' WHERE id = p_id;
    ELSE
        UPDATE alunos SET situacao = 'Reprovado' WHERE id = p_id;
    END IF;

    -- Mostra o resultado
    SELECT id, nome, nota, situacao FROM alunos WHERE id = p_id;
END $$

DELIMITER ;

-- Executar: CALL sp_definir_situacao(3);


-- ============================================================
-- 7. PROCEDURE QUE INSERE REGISTRO
-- ============================================================

DELIMITER $$

CREATE PROCEDURE sp_novo_aluno(
    IN p_nome VARCHAR(100),
    IN p_nota DECIMAL(4,2)
)
BEGIN
    INSERT INTO alunos (nome, nota) VALUES (p_nome, p_nota);
    SELECT CONCAT('Aluno ', p_nome, ' cadastrado com sucesso!') AS mensagem;
END $$

DELIMITER ;

-- Executar: CALL sp_novo_aluno('Carla', 7.5);


-- ============================================================
-- 8. PROCEDURE QUEUSA TRANSAÇÃO (se der erro, desfaz tudo)
-- ============================================================

DELIMITER $$

CREATE PROCEDURE sp_excluir_aluno(IN p_id INT)
BEGIN
    DECLARE v_nome VARCHAR(100);

    START TRANSACTION;

    SELECT nome INTO v_nome FROM alunos WHERE id = p_id;

    DELETE FROM alunos WHERE id = p_id;

    INSERT INTO logs (mensagem) VALUES (CONCAT('Aluno removido: ', v_nome));

    COMMIT;

    SELECT CONCAT('Aluno ', v_nome, ' excluído com sucesso!') AS resultado;
END $$

DELIMITER ;

-- Executar: CALL sp_excluir_aluno(5);


-- ============================================================
-- 9. VER PROCEDURES CRIADAS
-- ============================================================
-- SHOW PROCEDURE STATUS WHERE Db = 'estudos_procedure';
-- ou
-- SELECT ROUTINE_NAME FROM INFORMATION_SCHEMA.ROUTINES
-- WHERE ROUTINE_SCHEMA = 'estudos_procedure' AND ROUTINE_TYPE = 'PROCEDURE';

-- ============================================================
-- 10. REMOVER UMA PROCEDURE
-- ============================================================
-- DROP PROCEDURE IF EXISTS sp_listar_alunos;


-- ============================================================
--  RESUMÃO
-- ============================================================
-- Criar:      CREATE PROCEDURE nome(parâmetros) BEGIN ... END
-- Executar:   CALL nome(parametros);
-- Deletar:    DROP PROCEDURE nome;
-- Parâmetros: IN (entrada), OUT (saída)
-- Variável:   DECLARE var TIPO; SET var = valor;
-- IF:         IF cond THEN ... ELSEIF cond THEN ... ELSE ... END IF;
-- ============================================================
