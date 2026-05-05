-- ============================================================
--  CASE DENTRO DE PROCEDURES - Guia Completo e Simples
-- ============================================================
-- O CASE é tipo um "IF mais organizado" para várias condições.
-- Use CASE quando tiver MUITAS condições (mais legível que IF).
--
-- Existem 2 tipos de CASE:
--
-- 1. CASE SIMPLES:
--    CASE expressao
--        WHEN valor1 THEN resultado1
--        WHEN valor2 THEN resultado2
--        ELSE resultado3
--    END CASE;
--
-- 2. CASE CONDICIONAL (parece IF):
--    CASE
--        WHEN condicao1 THEN resultado1
--        WHEN condicao2 THEN resultado2
--        ELSE resultado3
--    END CASE;
-- ============================================================

CREATE DATABASE IF NOT EXISTS estudos_case;
USE estudos_case;

-- ============================================================
-- TABELA DE EXEMPLO
-- ============================================================
CREATE TABLE IF NOT EXISTS funcionarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cargo VARCHAR(50) NOT NULL,
    salario DECIMAL(10,2) NOT NULL,
    avaliacao INT DEFAULT 0,  -- 1 a 5
    horas_extras INT DEFAULT 0,
    departamento VARCHAR(50) DEFAULT 'Geral'
);

INSERT INTO funcionarios (nome, cargo, salario, avaliacao, horas_extras, departamento) VALUES
('João Silva',    'Analista',     4500.00, 5, 20, 'TI'),
('Maria Santos',  'Gerente',      8000.00, 4, 5,  'TI'),
('Pedro Costa',   'Assistente',   2500.00, 3, 15, 'RH'),
('Ana Lima',      'Analista',     5000.00, 5, 30, 'RH'),
('Lucas Souza',   'Coordenador',  6500.00, 2, 0,  'TI'),
('Carla Dias',    'Assistente',   2200.00, 4, 10, 'Financeiro'),
('Rafaela Alves', 'Analista',     4800.00, 1, 2,  'Financeiro');

-- ============================================================
-- EXEMPLO 1: CASE SIMPLES (comparando UM valor)
-- ============================================================
-- O CASE SIMPLES compara uma expressão com valores fixos

DELIMITER $$

CREATE PROCEDURE sp_nivel_avaliacao(IN p_funcionario_id INT)
BEGIN
    DECLARE v_nome VARCHAR(100);
    DECLARE v_avaliacao INT;
    DECLARE v_nivel VARCHAR(30);

    SELECT nome, avaliacao INTO v_nome, v_avaliacao
    FROM funcionarios WHERE id = p_funcionario_id;

    -- CASE SIMPLES: compara v_avaliacao com valores fixos
    SET v_nivel = CASE v_avaliacao
        WHEN 1 THEN 'Péssimo'
        WHEN 2 THEN 'Ruim'
        WHEN 3 THEN 'Regular'
        WHEN 4 THEN 'Bom'
        WHEN 5 THEN 'Excelente'
        ELSE 'Não avaliado'
    END;

    SELECT
        v_nome AS funcionario,
        CONCAT(v_avaliacao, ' estrelas') AS avaliacao,
        v_nivel AS nivel;
END $$

DELIMITER ;

-- Teste: CALL sp_nivel_avaliacao(1);  -- João - 5 estrelas -> Excelente
-- Teste: CALL sp_nivel_avaliacao(5);  -- Lucas - 2 estrelas -> Ruim


-- ============================================================
-- EXEMPLO 2: CASE CONDICIONAL (com condições diferentes)
-- ============================================================
-- O CASE CONDICIONAL permite usar operadores como >, <, AND, etc

DELIMITER $$

CREATE PROCEDURE sp_classificar_salario(IN p_funcionario_id INT)
BEGIN
    DECLARE v_nome VARCHAR(100);
    DECLARE v_salario DECIMAL(10,2);
    DECLARE v_faixa VARCHAR(40);

    SELECT nome, salario INTO v_nome, v_salario
    FROM funcionarios WHERE id = p_funcionario_id;

    -- CASE CONDICIONAL: cada WHEN tem uma condição diferente
    SET v_faixa = CASE
        WHEN v_salario < 2500 THEN 'Abaixo do piso'
        WHEN v_salario >= 2500 AND v_salario < 4000 THEN 'Júnior'
        WHEN v_salario >= 4000 AND v_salario < 6000 THEN 'Pleno'
        WHEN v_salario >= 6000 AND v_salario < 9000 THEN 'Sênior'
        WHEN v_salario >= 9000 THEN 'Diretoria'
        ELSE 'Indefinido'
    END;

    SELECT
        v_nome AS funcionario,
        CONCAT('R$ ', v_salario) AS salario,
        v_faixa AS faixa_salarial;
END $$

DELIMITER ;

-- Teste: CALL sp_classificar_salario(3);  -- Pedro - 2500 -> Júnior
-- Teste: CALL sp_classificar_salario(4);  -- Ana - 5000 -> Pleno
-- Teste: CALL sp_classificar_salario(2);  -- Maria - 8000 -> Sênior


-- ============================================================
-- EXEMPLO 3: CASE DENTRO DE SELECT (muito comum!)
-- ============================================================
-- Você pode usar CASE direto no SELECT sem precisar de variável

DELIMITER $$

CREATE PROCEDURE sp_listar_com_conceito()
BEGIN
    SELECT
        nome,
        salario,
        CASE
            WHEN salario < 3000 THEN '💰 Baixo'
            WHEN salario BETWEEN 3000 AND 6000 THEN '💰💰 Médio'
            WHEN salario > 6000 THEN '💰💰💰 Alto'
        END AS faixa_salarial,
        CASE
            WHEN horas_extras = 0 THEN 'Sem extras'
            WHEN horas_extras <= 10 THEN 'Poucas extras'
            WHEN horas_extras <= 20 THEN 'Médias extras'
            ELSE 'Muitas extras'
        END AS carga_extras
    FROM funcionarios
    ORDER BY salario DESC;
END $$

DELIMITER ;

-- Teste: CALL sp_listar_com_conceito();


-- ============================================================
-- EXEMPLO 4: CASE COM UPDATE (atualizar valores diferentes)
-- ============================================================
-- Define aumento baseado na avaliação

DELIMITER $$

CREATE PROCEDURE sp_aumento_por_avaliacao(IN p_funcionario_id INT)
BEGIN
    DECLARE v_nome VARCHAR(100);
    DECLARE v_avaliacao INT;
    DECLARE v_salario_atual DECIMAL(10,2);
    DECLARE v_aumento DECIMAL(10,2);
    DECLARE v_percentual VARCHAR(10);

    SELECT nome, avaliacao, salario INTO v_nome, v_avaliacao, v_salario_atual
    FROM funcionarios WHERE id = p_funcionario_id;

    -- CASE para definir o percentual de aumento
    SET v_aumento = CASE v_avaliacao
        WHEN 1 THEN 0           -- 0%
        WHEN 2 THEN v_salario_atual * 0.03  -- 3%
        WHEN 3 THEN v_salario_atual * 0.05  -- 5%
        WHEN 4 THEN v_salario_atual * 0.08  -- 8%
        WHEN 5 THEN v_salario_atual * 0.12  -- 12%
        ELSE 0
    END;

    -- Aplica o aumento
    UPDATE funcionarios
    SET salario = salario + v_aumento
    WHERE id = p_funcionario_id;

    -- Mostra o resultado
    SELECT
        v_nome AS funcionario,
        CONCAT('R$ ', v_salario_atual) AS salario_antigo,
        CASE v_avaliacao
            WHEN 1 THEN '0%'
            WHEN 2 THEN '3%'
            WHEN 3 THEN '5%'
            WHEN 4 THEN '8%'
            WHEN 5 THEN '12%'
        END AS percentual_aumento,
        CONCAT('R$ ', v_aumento) AS valor_aumento,
        CONCAT('R$ ', v_salario_atual + v_aumento) AS novo_salario,
        CASE v_avaliacao
            WHEN 1 THEN 'Sem aumento (avaliação ruim)'
            WHEN 5 THEN 'Maior aumento (parabéns!)'
            ELSE 'Aumento regular'
        END AS observacao;
END $$

DELIMITER ;

-- Teste: CALL sp_aumento_por_avaliacao(7);  -- Rafaela - avaliacao 1 (sem aumento)
-- Teste: CALL sp_aumento_por_avaliacao(1);  -- João - avaliacao 5 (12% de aumento)


-- ============================================================
-- EXEMPLO 5: CASE SIMPLES COM VALORES TEXTUAIS
-- ============================================================
-- Classifica funcionários pelo departamento

DELIMITER $$

CREATE PROCEDURE sp_classificar_departamento(IN p_funcionario_id INT)
BEGIN
    DECLARE v_nome VARCHAR(100);
    DECLARE v_departamento VARCHAR(50);
    DECLARE v_setor VARCHAR(40);

    SELECT nome, departamento INTO v_nome, v_departamento
    FROM funcionarios WHERE id = p_funcionario_id;

    -- CASE SIMPLES com texto
    SET v_setor = CASE v_departamento
        WHEN 'TI' THEN 'Tecnologia'
        WHEN 'RH' THEN 'Pessoas'
        WHEN 'Financeiro' THEN 'Financeiro'
        ELSE 'Outros'
    END;

    SELECT
        v_nome AS funcionario,
        v_departamento AS departamento,
        v_setor AS setor_responsavel;
END $$

DELIMITER ;

-- Teste: CALL sp_classificar_departamento(2);  -- Maria - TI -> Tecnologia
-- Teste: CALL sp_classificar_departamento(6);  -- Carla - Financeiro


-- ============================================================
-- EXEMPLO 6: CASE ANINHADO (CASE dentro de CASE)
-- ============================================================
-- Raro, mas possível: um CASE dentro de outro

DELIMITER $$

CREATE PROCEDURE sp_relatorio_funcionario(IN p_funcionario_id INT)
BEGIN
    DECLARE v_nome VARCHAR(100);
    DECLARE v_cargo VARCHAR(50);
    DECLARE v_departamento VARCHAR(50);
    DECLARE v_salario DECIMAL(10,2);
    DECLARE v_classificacao VARCHAR(60);

    SELECT nome, cargo, departamento, salario
    INTO v_nome, v_cargo, v_departamento, v_salario
    FROM funcionarios WHERE id = p_funcionario_id;

    -- CASE aninhado
    SET v_classificacao = CASE
        WHEN v_departamento = 'TI' THEN
            -- CASE interno para cargos de TI
            CASE v_cargo
                WHEN 'Analista' THEN 'TI - Técnico'
                WHEN 'Gerente' THEN 'TI - Gestão'
                WHEN 'Coordenador' THEN 'TI - Supervisão'
                ELSE 'TI - Geral'
            END
        WHEN v_departamento = 'RH' THEN
            CASE v_cargo
                WHEN 'Analista' THEN 'RH - Recrutamento'
                WHEN 'Assistente' THEN 'RH - Administrativo'
                ELSE 'RH - Geral'
            END
        WHEN v_departamento = 'Financeiro' THEN
            CASE v_cargo
                WHEN 'Analista' THEN 'FIN - Contábil'
                WHEN 'Assistente' THEN 'FIN - Fiscal'
                ELSE 'FIN - Geral'
            END
        ELSE 'Departamento não classificado'
    END;

    SELECT
        v_nome AS funcionario,
        v_cargo AS cargo,
        v_departamento AS departamento,
        v_classificacao AS classificacao_completa;
END $$

DELIMITER ;

-- Teste: CALL sp_relatorio_funcionario(1);  -- João - TI / Analista -> TI - Técnico
-- Teste: CALL sp_relatorio_funcionario(4);  -- Ana - RH / Analista -> RH - Recrutamento


-- ============================================================
-- EXEMPLO 7: CASE COM INSERT (criar logs diferentes)
-- ============================================================
-- Gera mensagens diferentes no log baseado no tipo de funcionário

CREATE TABLE IF NOT EXISTS logs_case (
    id INT AUTO_INCREMENT PRIMARY KEY,
    funcionario_id INT,
    mensagem TEXT,
    data_log DATETIME DEFAULT CURRENT_TIMESTAMP
);

DELIMITER $$

CREATE PROCEDURE sp_log_funcionario(IN p_funcionario_id INT)
BEGIN
    DECLARE v_nome VARCHAR(100);
    DECLARE v_cargo VARCHAR(50);
    DECLARE v_salario DECIMAL(10,2);
    DECLARE v_mensagem TEXT;

    SELECT nome, cargo, salario INTO v_nome, v_cargo, v_salario
    FROM funcionarios WHERE id = p_funcionario_id;

    -- CASE para gerar mensagem diferente
    SET v_mensagem = CASE
        WHEN v_salario > 6000 THEN
            CONCAT(v_nome, ' é ', v_cargo, ' - Salário alto: R$ ', v_salario)
        WHEN v_salario > 4000 THEN
            CONCAT(v_nome, ' é ', v_cargo, ' - Salário médio: R$ ', v_salario)
        ELSE
            CONCAT(v_nome, ' é ', v_cargo, ' - Salário inicial: R$ ', v_salario)
    END;

    INSERT INTO logs_case (funcionario_id, mensagem)
    VALUES (p_funcionario_id, v_mensagem);

    SELECT 'Log registrado com sucesso!' AS resultado, v_mensagem AS mensagem;
END $$

DELIMITER ;

-- Teste: CALL sp_log_funcionario(1);
-- Teste: CALL sp_log_funcionario(3);
-- Teste: SELECT * FROM logs_case;


-- ============================================================
-- EXEMPLO 8: CASE EM AGRUPAMENTO (GROUP BY com CASE)
-- ============================================================
-- Mostra quantos funcionários em cada faixa salarial

DELIMITER $$

CREATE PROCEDURE sp_resumo_salarios()
BEGIN
    SELECT
        CASE
            WHEN salario < 3000 THEN '1 - Até R$ 3.000'
            WHEN salario BETWEEN 3000 AND 5000 THEN '2 - R$ 3.001 a R$ 5.000'
            WHEN salario BETWEEN 5001 AND 7000 THEN '3 - R$ 5.001 a R$ 7.000'
            ELSE '4 - Acima de R$ 7.000'
        END AS faixa_salarial,
        COUNT(*) AS total_funcionarios,
        CONCAT('R$ ', FORMAT(AVG(salario), 2)) AS media_salarial
    FROM funcionarios
    GROUP BY faixa_salarial
    ORDER BY faixa_salarial;
END $$

DELIMITER ;

-- Teste: CALL sp_resumo_salarios();


-- ============================================================
--  RESUMÃO DO CASE EM PROCEDURES
-- ============================================================
--
-- CASE SIMPLES (compara UM valor com vários):
--
--     CASE expressao
--         WHEN valor1 THEN resultado1
--         WHEN valor2 THEN resultado2
--         ELSE resultado3
--     END CASE;
--
-- CASE CONDICIONAL (cada WHEN tem sua condição):
--
--     CASE
--         WHEN condicao1 THEN resultado1
--         WHEN condicao2 THEN resultado2
--         ELSE resultado3
--     END CASE;
--
-- Diferença entre CASE e IF:
--     IF = poucas condições (2 ou 3)
--     CASE = várias condições (mais limpo e legível)
--
-- Onde usar CASE:
--     ✓ SET variavel = CASE ...
--     ✓ SELECT ..., CASE ... END AS nome
--     ✓ UPDATE ... SET coluna = CASE ...
--     ✓ GROUP BY com CASE
--     ✓ Dentro de INSERT
-- ============================================================
