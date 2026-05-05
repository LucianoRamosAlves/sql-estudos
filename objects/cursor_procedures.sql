-- ============================================================
--  CURSOR DENTRO DE PROCEDURES - Guia Completo
-- ============================================================
--
-- O que é um CURSOR?
-- Cursor é como se fosse um "ponteiro" que percorre os resultados
-- de um SELECT linha por linha.
--
-- Imagine que você fez: SELECT * FROM alunos
-- Isso retorna VÁRIAS linhas de uma vez.
-- Com um CURSOR, você consegue pegar UMA linha de cada vez e
-- processar cada uma individualmente.
--
-- PASSO A PASSO PARA USAR UM CURSOR:
--
-- 1. DECLARAR o cursor (dizer qual SELECT ele vai usar)
-- 2. DECLARAR variáveis para guardar os dados de cada linha
-- 3. DECLARAR um HANDLER para saber quando acabaram os registros
-- 4. ABRIR o cursor
-- 5. FETCH (buscar) cada linha dentro de um LOOP
-- 6. FECHAR o cursor
-- ============================================================

CREATE DATABASE IF NOT EXISTS estudos_cursor;
USE estudos_cursor;

-- ============================================================
-- TABELAS DE EXEMPLO
-- ============================================================
CREATE TABLE IF NOT EXISTS alunos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    nota DECIMAL(4,2) DEFAULT 0,
    situacao VARCHAR(30) DEFAULT 'Cursando'
);

CREATE TABLE IF NOT EXISTS relatorio_notas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    aluno_id INT,
    nome VARCHAR(100),
    nota DECIMAL(4,2),
    conceito VARCHAR(20),
    mensagem TEXT,
    data_processamento DATETIME DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO alunos (nome, nota) VALUES
('João',   8.5),
('Maria',  6.0),
('Pedro',  4.5),
('Ana',    9.0),
('Lucas',  5.0),
('Carla',  7.5),
(' Bruno', 3.0);

-- ============================================================
-- EXEMPLO 1: CURSOR PASSO A PASSO (comentário em cada parte)
-- ============================================================
-- Vamos criar um cursor que percorre todos os alunos,
-- define um conceito para cada um e salva em outra tabela.

DELIMITER $$

CREATE PROCEDURE sp_gerar_conceitos()
BEGIN
    ---------------------------------------------------------------
    -- PASSO 1: DECLARAR AS VARIÁVEIS
    -- Aqui criamos as "caixinhas" que vão guardar os dados
    -- de cada linha que o cursor vai buscar.
    ---------------------------------------------------------------
    DECLARE v_id INT;                 -- Guarda o id do aluno
    DECLARE v_nome VARCHAR(100);      -- Guarda o nome do aluno
    DECLARE v_nota DECIMAL(4,2);      -- Guarda a nota do aluno
    DECLARE v_conceito VARCHAR(20);   -- Guarda o conceito calculado
    DECLARE v_finalizado INT DEFAULT 0;  -- Flag para saber se acabou

    ---------------------------------------------------------------
    -- PASSO 2: DECLARAR O CURSOR
    -- Aqui dizemos qual SELECT o cursor vai usar.
    -- O cursor vai "apontar" para cada linha desse SELECT.
    -- Importante: o SELECT deve ter as colunas na ordem que
    -- você vai usar no FETCH.
    ---------------------------------------------------------------
    DECLARE cursor_alunos CURSOR FOR
        SELECT id, nome, nota FROM alunos;

    ---------------------------------------------------------------
    -- PASSO 3: DECLARAR O HANDLER (tratador de fim)
    -- O HANDLER é tipo um "vigia" que fica monitorando.
    -- Quando o cursor chegar ao fim dos registros (NOT FOUND),
    -- ele vai executar o comando: SET v_finalizado = 1
    -- Isso serve para sabermos quando parar o loop.
    --
    -- CONTINUE HANDLER = quando acontecer, continua executando
    -- NOT FOUND = quando não encontrar mais registros
    ---------------------------------------------------------------
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_finalizado = 1;

    ---------------------------------------------------------------
    -- PASSO 4: ABRIR O CURSOR
    -- Aqui o cursor é "iniciado". Ele prepara o SELECT
    -- e fica pronto para buscar os dados.
    ---------------------------------------------------------------
    OPEN cursor_alunos;

    ---------------------------------------------------------------
    -- PASSO 5: LOOP PARA PERCORRER AS LINHAS
    -- Usamos um LOOP para ir buscando linha por linha.
    ---------------------------------------------------------------
    percorrer: LOOP
        ---------------------------------------------------------------
        -- PASSO 5a: FETCH (buscar a próxima linha)
        -- FETCH pega a linha atual do cursor e guarda nas variáveis.
        -- A ordem das variáveis tem que ser igual à do SELECT no cursor.
        -- Cada vez que chama FETCH, o cursor avança para próxima linha.
        --
        -- Exemplo visual:
        -- Antes do 1º FETCH: cursor -> [linha 1] linha 2 linha 3
        -- Depois do 1º FETCH: cursor -> linha 1 [linha 2] linha 3
        -- Depois do 2º FETCH: cursor -> linha 1 linha 2 [linha 3]
        ---------------------------------------------------------------
        FETCH cursor_alunos INTO v_id, v_nome, v_nota;

        ---------------------------------------------------------------
        -- PASSO 5b: VERIFICAR SE ACABOU
        -- Se v_finalizado = 1, significa que o HANDLER foi ativado
        -- porque não havia mais o que buscar. Então saímos do loop.
        -- Isso evita loop infinito!
        ---------------------------------------------------------------
        IF v_finalizado THEN
            LEAVE percorrer;
        END IF;

        ---------------------------------------------------------------
        -- PASSO 5c: PROCESSAR OS DADOS
        -- Aqui fazemos o que quisermos com os dados da linha atual.
        -- Cada volta do loop processa UM aluno diferente.
        ---------------------------------------------------------------
        -- Calcula o conceito baseado na nota
        IF v_nota >= 7 THEN
            SET v_conceito = 'Aprovado';
        ELSEIF v_nota >= 5 THEN
            SET v_conceito = 'Recuperação';
        ELSE
            SET v_conceito = 'Reprovado';
        END IF;

        -- Insere na tabela de relatório
        INSERT INTO relatorio_notas (aluno_id, nome, nota, conceito, mensagem)
        VALUES (v_id, v_nome, v_nota, v_conceito,
                CONCAT(v_nome, ' - Nota: ', v_nota, ' - ', v_conceito));

    END LOOP percorrer;

    ---------------------------------------------------------------
    -- PASSO 6: FECHAR O CURSOR
    -- Sempre fechar o cursor para liberar memória.
    ---------------------------------------------------------------
    CLOSE cursor_alunos;

    -- Mostra o resultado final
    SELECT 'Conceitos gerados com sucesso!' AS mensagem;
    SELECT * FROM relatorio_notas;
END $$

DELIMITER ;

-- Teste: CALL sp_gerar_conceitos();


-- ============================================================
-- EXEMPLO 2: CURSOR COM WHILE (outra forma de loop)
-- ============================================================
-- Mesma coisa do exemplo 1, mas usando WHILE em vez de LOOP.

DELIMITER $$

CREATE PROCEDURE sp_cursor_com_while()
BEGIN
    DECLARE v_id INT;
    DECLARE v_nome VARCHAR(100);
    DECLARE v_nota DECIMAL(4,2);
    DECLARE v_media DECIMAL(4,2);
    DECLARE v_finalizado INT DEFAULT 0;

    DECLARE cursor_notas CURSOR FOR
        SELECT id, nome, nota FROM alunos;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_finalizado = 1;

    -- Calcula a média geral (para comparar depois)
    SELECT AVG(nota) INTO v_media FROM alunos;

    OPEN cursor_notas;

    -- WHILE: executa enquanto NÃO finalizado
    WHILE v_finalizado = 0 DO
        FETCH cursor_notas INTO v_id, v_nome, v_nota;

        -- Se acabou, sai do WHILE
        IF v_finalizado THEN
            LEAVE;
        END IF;

        -- Compara a nota do aluno com a média
        IF v_nota >= v_media THEN
            INSERT INTO relatorio_notas (aluno_id, nome, nota, conceito, mensagem)
            VALUES (v_id, v_nome, v_nota, 'Acima da média',
                    CONCAT(v_nome, ' está ACIMA da média (', v_media, ')'));
        ELSE
            INSERT INTO relatorio_notas (aluno_id, nome, nota, conceito, mensagem)
            VALUES (v_id, v_nome, v_nota, 'Abaixo da média',
                    CONCAT(v_nome, ' está ABAIXO da média (', v_media, ')'));
        END IF;
    END WHILE;

    CLOSE cursor_notas;

    SELECT CONCAT('Média geral: ', v_media) AS media, 'Conceitos gerados!' AS status;
END $$

DELIMITER ;

-- Teste: CALL sp_cursor_com_while();


-- ============================================================
-- EXEMPLO 3: CURSOR COM DUAS TABELAS (JOIN)
-- ============================================================
-- O cursor pode usar JOIN, GROUP BY, qualquer SELECT válido.

CREATE TABLE IF NOT EXISTS cursos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL
);

INSERT INTO cursos VALUES
(1, 'SQL Básico'),
(2, 'Java'),
(3, 'Python');

CREATE TABLE IF NOT EXISTS matriculas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    aluno_id INT,
    curso_id INT,
    FOREIGN KEY (aluno_id) REFERENCES alunos(id),
    FOREIGN KEY (curso_id) REFERENCES cursos(id)
);

INSERT INTO matriculas VALUES
(1, 1, 1),  -- João no SQL
(2, 1, 2),  -- João no Java
(3, 2, 1),  -- Maria no SQL
(4, 3, 3),  -- Pedro no Python
(5, 4, 1),  -- Ana no SQL
(6, 4, 2);  -- Ana no Java

DELIMITER $$

CREATE PROCEDURE sp_relatorio_matriculas()
BEGIN
    DECLARE v_aluno_nome VARCHAR(100);
    DECLARE v_curso_nome VARCHAR(100);
    DECLARE v_total INT;
    DECLARE v_finalizado INT DEFAULT 0;

    -- Cursor com JOIN entre 3 tabelas
    DECLARE cursor_matriculas CURSOR FOR
        SELECT a.nome AS aluno, c.nome AS curso
        FROM matriculas m
        INNER JOIN alunos a ON m.aluno_id = a.id
        INNER JOIN cursos c ON m.curso_id = c.id
        ORDER BY a.nome, c.nome;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_finalizado = 1;

    SELECT COUNT(*) INTO v_total FROM matriculas;

    OPEN cursor_matriculas;

    percorrer: LOOP
        FETCH cursor_matriculas INTO v_aluno_nome, v_curso_nome;

        IF v_finalizado THEN
            LEAVE percorrer;
        END IF;

        INSERT INTO relatorio_notas (aluno_id, nome, mensagem)
        VALUES (NULL, v_aluno_nome,
                CONCAT('Aluno: ', v_aluno_nome, ' -> Curso: ', v_curso_nome));
    END LOOP;

    CLOSE cursor_matriculas;

    SELECT CONCAT('Total de matrículas processadas: ', v_total) AS resultado;
    SELECT * FROM relatorio_notas WHERE aluno_id IS NULL;
END $$

DELIMITER ;

-- Teste: CALL sp_relatorio_matriculas();


-- ============================================================
-- EXEMPLO 4: CURSOR COM ATUALIZAÇÃO (UPDATE)
-- ============================================================
-- Usando cursor para atualizar dados na própria tabela

DELIMITER $$

CREATE PROCEDURE sp_atualizar_situacoes()
BEGIN
    DECLARE v_id INT;
    DECLARE v_nota DECIMAL(4,2);
    DECLARE v_finalizado INT DEFAULT 0;

    DECLARE cursor_atualizar CURSOR FOR
        SELECT id, nota FROM alunos;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_finalizado = 1;

    OPEN cursor_atualizar;

    atualizar: LOOP
        FETCH cursor_atualizar INTO v_id, v_nota;

        IF v_finalizado THEN
            LEAVE atualizar;
        END IF;

        -- Atualiza a situação do aluno baseado na nota
        IF v_nota >= 7 THEN
            UPDATE alunos SET situacao = 'Aprovado' WHERE id = v_id;
        ELSEIF v_nota >= 5 THEN
            UPDATE alunos SET situacao = 'Recuperação' WHERE id = v_id;
        ELSE
            UPDATE alunos SET situacao = 'Reprovado' WHERE id = v_id;
        END IF;
    END LOOP;

    CLOSE cursor_atualizar;

    SELECT 'Situações atualizadas!' AS resultado;
    SELECT * FROM alunos;
END $$

DELIMITER ;

-- Teste: CALL sp_atualizar_situacoes();


-- ============================================================
-- EXEMPLO 5: DOIS CURSORES NA MESMA PROCEDURE
-- ============================================================
-- É possível ter mais de um cursor na mesma procedure.

DELIMITER $$

CREATE PROCEDURE sp_dois_cursos()
BEGIN
    DECLARE v_id1 INT;
    DECLARE v_nome1 VARCHAR(100);
    DECLARE v_id2 INT;
    DECLARE v_nome2 VARCHAR(100);
    DECLARE v_finalizado1 INT DEFAULT 0;
    DECLARE v_finalizado2 INT DEFAULT 0;

    -- Primeiro cursor
    DECLARE cursor1 CURSOR FOR
        SELECT id, nome FROM alunos WHERE nota >= 7;

    -- Segundo cursor
    DECLARE cursor2 CURSOR FOR
        SELECT id, nome FROM alunos WHERE nota < 5;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_finalizado1 = 1;

    -- Processa o primeiro cursor (aprovados)
    OPEN cursor1;

    loop1: LOOP
        FETCH cursor1 INTO v_id1, v_nome1;
        IF v_finalizado1 THEN LEAVE loop1; END IF;

        INSERT INTO relatorio_notas (aluno_id, nome, conceito, mensagem)
        VALUES (v_id1, v_nome1, 'APROVADO',
                CONCAT(v_nome1, ' - APROVADO (nota >= 7)'));
    END LOOP;

    CLOSE cursor1;

    -- Processa o segundo cursor (reprovados)
    -- Reseta a flag para reutilizar
    SET v_finalizado2 = 0;

    -- Muda o handler para a flag do cursor2
    -- (Na prática, você precisaria de handlers separados ou lógica diferente)

    OPEN cursor2;

    loop2: LOOP
        FETCH cursor2 INTO v_id2, v_nome2;
        IF v_finalizado1 THEN
            -- Como o handler já foi ativado, precisamos de outra lógica
            -- Na prática, use handlers separados com nomes diferentes
            SET v_finalizado2 = 1;
        END IF;
        IF v_finalizado2 THEN LEAVE loop2; END IF;

        INSERT INTO relatorio_notas (aluno_id, nome, conceito, mensagem)
        VALUES (v_id2, v_nome2, 'REPROVADO',
                CONCAT(v_nome2, ' - REPROVADO (nota < 5)'));
    END LOOP;

    CLOSE cursor2;

    SELECT 'Processamento com dois cursores concluído!' AS resultado;
END $$

DELIMITER ;

-- Teste: CALL sp_dois_cursos();


-- ============================================================
--  EXPLICAÇÃO DE CADA TERMO USADO NO CURSOR
-- ============================================================
--
-- 1. DECLARE nome CURSOR FOR SELECT ...
--    → Cria o cursor e diz qual SELECT ele vai percorrer.
--    Ex: DECLARE cursor_alunos CURSOR FOR SELECT id, nome FROM alunos;
--
-- 2. DECLARE CONTINUE HANDLER FOR NOT FOUND
--    → "Tratador" que detecta quando o cursor chegou ao fim.
--    → CONTINUE = depois de tratar, continua executando.
--    → NOT FOUND = quando não há mais registros para buscar.
--    → Geralmente usamos: SET variavel = 1 para sinalizar o fim.
--
-- 3. OPEN nome_cursor
--    → Inicia o cursor. Executa o SELECT e prepara para buscar.
--    → É como "abrir" o arquivo para leitura.
--
-- 4. FETCH nome_cursor INTO var1, var2, ...
--    → Busca a PRÓXIMA linha do cursor.
--    → Guarda os valores nas variáveis (na mesma ordem do SELECT).
--    → Cada FETCH avança uma linha.
--
-- 5. CLOSE nome_cursor
--    → Fecha o cursor e libera os recursos.
--    → Sempre feche após usar!
--
-- 6. LOOP / WHILE / REPEAT
--    → Estrutura para repetir o FETCH até acabar os registros.
--    → Dentro do loop usamos IF para verificar se acabou.
--
-- FLUXO COMPLETO:
--
--    1. DECLARE cursor CURSOR FOR SELECT ...  (prepara)
--    2. DECLARE CONTINUE HANDLER FOR NOT FOUND (vigia o fim)
--    3. OPEN cursor;                          (inicia)
--    4. LOOP:
--         FETCH cursor INTO vars;             (busca linha)
--         IF finalizado THEN LEAVE;           (acabou? sai)
--         -- processa a linha aqui --         (faz algo com os dados)
--       END LOOP;
--    5. CLOSE cursor;                         (finaliza)
-- ============================================================
