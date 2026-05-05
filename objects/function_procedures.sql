-- aqui eu mostro as function e producers
SELECT ROUTINE_TYPE,
    ROUTINE_NAME
FROM INFORMATION_SCHEMA.ROUTINES





-- ============================================================
--  FUNCTIONS (FUNÇÕES) DENTRO DE PROCEDURES - Guia Completo
-- ============================================================
--
-- DIFERENÇA ENTRE PROCEDURE E FUNCTION:
--
-- PROCEDURE:
--   • Faz ações (INSERT, UPDATE, DELETE)
--   • Pode retornar 0 ou N resultados (SELECT)
--   • Usa OUT para retornar valores
--   • CALL nome()
--
-- FUNCTION:
--   • Calcula e RETORNA UM ÚNICO VALOR
--   • Pode ser usada dentro de SELECT, WHERE, etc
--   • Obrigatoriamente retorna um valor com RETURN
--   • Não pode fazer INSERT/UPDATE/DELETE (em muitos SGBDs)
--   • SELECT nome()
--
-- PENSANDO EM ANALOGIA:
--   Procedure = uma receita de bolo (faz todo o processo)
--   Function  = uma calculadora (entra número, sai resultado)
--
-- ESTRUTURA DE UMA FUNCTION:
--
-- CREATE FUNCTION nome(parametros)
-- RETURNS tipo      ← Obrigatório! Diz o tipo do retorno
-- DETERMINISTIC     ← Opcional. Diz se sempre retorna o mesmo valor
-- BEGIN
--     DECLARE variaveis;
--     -- lógica aqui
--     RETURN valor;  ← Obrigatório! Devolve o resultado
-- END;
-- ============================================================

CREATE DATABASE IF NOT EXISTS estudos_function;
USE estudos_function;

-- ============================================================
-- TABELAS DE EXEMPLO
-- ============================================================
CREATE TABLE IF NOT EXISTS produtos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    preco DECIMAL(10,2) NOT NULL,
    estoque INT DEFAULT 0,
    categoria VARCHAR(50) DEFAULT 'Geral'
);

CREATE TABLE IF NOT EXISTS vendas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    produto_id INT NOT NULL,
    quantidade INT NOT NULL,
    valor_total DECIMAL(10,2) NOT NULL,
    data_venda DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (produto_id) REFERENCES produtos(id)
);

INSERT INTO produtos (nome, preco, estoque, categoria) VALUES
('Notebook',    3500.00, 10, 'Eletrônicos'),
('Mouse',       50.00,   100, 'Eletrônicos'),
('Camiseta',    79.90,   30, 'Vestuário'),
('Livro SQL',   89.90,   2,  'Livros'),
('Monitor',     1200.00, 0,  'Eletrônicos'),
('Teclado',     150.00,  50, 'Eletrônicos');

INSERT INTO vendas (produto_id, quantidade, valor_total) VALUES
(1, 2, 7000.00),
(2, 10, 500.00),
(3, 5, 399.50),
(1, 1, 3500.00),
(4, 3, 269.70);

-- ============================================================
-- EXEMPLO 1: FUNCTION MAIS SIMPLES POSSÍVEL
-- ============================================================
-- Function que retorna uma saudação. Só pra entender a estrutura.

DELIMITER $$

CREATE FUNCTION fn_ola()
RETURNS VARCHAR(50)  -- Diz que vai retornar um texto de até 50 caracteres
DETERMINISTIC        -- Diz que sempre retorna o mesmo valor (não muda)
BEGIN
    RETURN 'Olá! Esta é uma function!';  -- O valor que ela devolve
END $$

DELIMITER ;

-- Como usar:
-- SELECT fn_ola();  -- Vai mostrar: "Olá! Esta é uma function!"


-- ============================================================
-- EXEMPLO 2: FUNCTION QUE CALCULA (entrada e saída)
-- ============================================================
-- Function que recebe dois números e retorna a soma.

DELIMITER $$

CREATE FUNCTION fn_somar(a DECIMAL(10,2), b DECIMAL(10,2))
RETURNS DECIMAL(10,2)   -- Retorna um número decimal
DETERMINISTIC            -- Mesmo cálculo sempre dá o mesmo resultado
BEGIN
    DECLARE v_resultado DECIMAL(10,2);

    SET v_resultado = a + b;

    RETURN v_resultado;  -- Devolve o resultado
END $$

DELIMITER ;

-- Como usar:
-- SELECT fn_somar(10, 20);        -- Resultado: 30
-- SELECT fn_somar(15.5, 3.2);     -- Resultado: 18.70


-- ============================================================
-- EXEMPLO 3: FUNCTION COM IF (calcula desconto)
-- ============================================================
-- Function que calcula desconto baseado no valor.

DELIMITER $$

CREATE FUNCTION fn_calcular_desconto(valor DECIMAL(10,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE v_desconto DECIMAL(10,2);

    -- IF dentro da function para decidir o desconto
    IF valor >= 1000 THEN
        SET v_desconto = valor * 0.10;  -- 10% de desconto
    ELSEIF valor >= 500 THEN
        SET v_desconto = valor * 0.05;  -- 5% de desconto
    ELSE
        SET v_desconto = 0;             -- Sem desconto
    END IF;

    RETURN v_desconto;
END $$

DELIMITER ;

-- Como usar:
-- SELECT fn_calcular_desconto(2000);  -- Resultado: 200 (10% de 2000)
-- SELECT fn_calcular_desconto(600);   -- Resultado: 30 (5% de 600)
-- SELECT fn_calcular_desconto(100);   -- Resultado: 0 (sem desconto)


-- ============================================================
-- EXEMPLO 4: FUNCTION USANDO SELECT (busca no banco)
-- ============================================================
-- Function que consulta o banco e retorna um valor calculado.
-- ATENÇÃO: A function pode consultar tabelas, mas NÃO pode
-- modificar (INSERT/UPDATE/DELETE).

DELIMITER $$

CREATE FUNCTION fn_total_estoque(categoria_busca VARCHAR(50))
RETURNS INT
READS SQL DATA  -- Diz que a função SOMENTE LÊ dados (não modifica)
BEGIN
    DECLARE v_total INT;

    -- Consulta o banco de dados
    SELECT SUM(estoque) INTO v_total
    FROM produtos
    WHERE categoria = categoria_busca;

    -- Se for NULL (categoria não existe), retorna 0
    IF v_total IS NULL THEN
        SET v_total = 0;
    END IF;

    RETURN v_total;
END $$

DELIMITER ;

-- Como usar:
-- SELECT fn_total_estoque('Eletrônicos');  -- Resultado: 160 (10+100+0+50)
-- SELECT fn_total_estoque('Livros');       -- Resultado: 2


-- ============================================================
-- EXEMPLO 5: FUNCTION COM CASE (classificação)
-- ============================================================

DELIMITER $$

CREATE FUNCTION fn_classificar_preco(preco DECIMAL(10,2))
RETURNS VARCHAR(30)
DETERMINISTIC
BEGIN
    DECLARE v_classificacao VARCHAR(30);

    -- CASE para classificar o preço
    SET v_classificacao = CASE
        WHEN preco = 0 THEN 'Grátis'
        WHEN preco < 50 THEN 'Muito Barato'
        WHEN preco BETWEEN 50 AND 200 THEN 'Barato'
        WHEN preco BETWEEN 201 AND 1000 THEN 'Médio'
        WHEN preco BETWEEN 1001 AND 5000 THEN 'Caro'
        ELSE 'Muito Caro'
    END;

    RETURN v_classificacao;
END $$

DELIMITER ;

-- Como usar:
-- SELECT fn_classificar_preco(50);     -- Resultado: "Barato"
-- SELECT fn_classificar_preco(3500);   -- Resultado: "Caro"


-- ============================================================
-- EXEMPLO 6: FUNCTION DENTRO DE SELECT (uso mais comum!)
-- ============================================================
-- Este exemplo mostra como USAR as functions dentro de um SELECT.
-- Primeiro criamos uma function...

DELIMITER $$

CREATE FUNCTION fn_status_estoque(quantidade INT)
RETURNS VARCHAR(30)
DETERMINISTIC
BEGIN
    DECLARE v_status VARCHAR(30);

    IF quantidade = 0 THEN
        SET v_status = 'ESGOTADO';
    ELSEIF quantidade < 5 THEN
        SET v_status = 'CRÍTICO';
    ELSEIF quantidade < 20 THEN
        SET v_status = 'BAIXO';
    ELSEIF quantidade < 50 THEN
        SET v_status = 'NORMAL';
    ELSE
        SET v_status = 'ALTO';
    END IF;

    RETURN v_status;
END $$

DELIMITER ;

-- ...agora USAMOS ela dentro de um SELECT:

-- SELECT
--     nome,
--     estoque,
--     fn_status_estoque(estoque) AS status   -- Chamando a function aqui!
-- FROM produtos;

-- Resultado:
-- Notebook  | 10  | BAIXO
-- Mouse     | 100 | ALTO
-- Camiseta  | 30  | NORMAL
-- Livro SQL | 2   | CRÍTICO
-- Monitor   | 0   | ESGOTADO
-- Teclado   | 50  | NORMAL


-- ============================================================
-- EXEMPLO 7: FUNCTION COM CONCATENAÇÃO DE TEXTOS
-- ============================================================
-- Function que formata um texto bonito para exibição.

DELIMITER $$

CREATE FUNCTION fn_formatar_produto(nome_produto VARCHAR(100), preco DECIMAL(10,2))
RETURNS VARCHAR(200)
DETERMINISTIC
BEGIN
    DECLARE v_formatado VARCHAR(200);

    -- Monta um texto bonito
    SET v_formatado = CONCAT(
        '🛒 ', UPPER(nome_produto),
        ' - R$ ', FORMAT(preco, 2, 'pt_BR')
    );

    RETURN v_formatado;
END $$

DELIMITER ;

-- Como usar:
-- SELECT fn_formatar_produto('Notebook', 3500.00);
-- Resultado: "🛒 NOTEBOOK - R$ 3.500,00"


-- ============================================================
-- EXEMPLO 8: FUNCTION COM DOIS PARÂMETROS E VALIDAÇÃO
-- ============================================================
-- Function que calcula valor total de venda com validação.

DELIMITER $$

CREATE FUNCTION fn_valor_venda(
    p_preco DECIMAL(10,2),
    p_quantidade INT
)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE v_total DECIMAL(10,2);

    -- Validações
    IF p_preco IS NULL OR p_preco <= 0 THEN
        RETURN 0;  -- Preço inválido
    END IF;

    IF p_quantidade IS NULL OR p_quantidade <= 0 THEN
        RETURN 0;  -- Quantidade inválida
    END IF;

    -- Calcula o total
    SET v_total = p_preco * p_quantidade;

    -- Aplica desconto se for compra grande
    IF p_quantidade >= 10 THEN
        SET v_total = v_total * 0.90;  -- 10% de desconto
    END IF;

    RETURN v_total;
END $$

DELIMITER ;

-- Como usar:
-- SELECT fn_valor_venda(3500, 2);    -- 7000 (sem desconto)
-- SELECT fn_valor_venda(50, 10);     -- 450 (com 10% desconto)
-- SELECT fn_valor_venda(0, 5);       -- 0 (preço inválido)


-- ============================================================
-- EXEMPLO 9: FUNCTION DENTRO DE WHERE (filtrando com function)
-- ============================================================
-- Function que diz se um produto tem desconto especial.

DELIMITER $$

CREATE FUNCTION fn_tem_desconto_especial(preco DECIMAL(10,2))
RETURNS BOOLEAN  -- Retorna TRUE ou FALSE
DETERMINISTIC
BEGIN
    -- Produtos acima de 1000 têm desconto especial
    IF preco > 1000 THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END $$

DELIMITER ;

-- Usando a function no WHERE:
-- SELECT nome, preco
-- FROM produtos
-- WHERE fn_tem_desconto_especial(preco) = TRUE;
-- Resultado: Notebook (3500) e Monitor (1200)


-- ============================================================
-- EXEMPLO 10: FUNCTION CHAMANDO OUTRA FUNCTION
-- ============================================================
-- Uma function pode chamar outra function!

DELIMITER $$

CREATE FUNCTION fn_preco_com_desconto(preco DECIMAL(10,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE v_desconto DECIMAL(10,2);

    -- Chamando a function fn_calcular_desconto que criamos antes
    SET v_desconto = fn_calcular_desconto(preco);

    -- Retorna o preço com desconto
    RETURN preco - v_desconto;
END $$

DELIMITER ;

-- Como usar:
-- SELECT
--     nome,
--     preco,
--     fn_calcular_desconto(preco) AS desconto,      -- function 1
--     fn_preco_com_desconto(preco) AS preco_final    -- function 2 (chama a 1)
-- FROM produtos;


-- ============================================================
-- EXEMPLO 11: PROCEDURE QUE USA FUNCTION
-- ============================================================
-- Uma procedure pode chamar functions dentro dela!

DELIMITER $$

CREATE PROCEDURE sp_relatorio_com_functions()
BEGIN
    SELECT
        nome,
        preco,
        estoque,
        fn_classificar_preco(preco) AS classificacao,    -- chamando function
        fn_status_estoque(estoque) AS status_estoque,   -- chamando function
        fn_calcular_desconto(preco) AS valor_desconto   -- chamando function
    FROM produtos
    ORDER BY preco DESC;
END $$

DELIMITER ;

-- Como usar:
-- CALL sp_relatorio_com_functions();


-- ============================================================
--  EXPLICAÇÃO DE CADA TERMO USADO NA FUNCTION
-- ============================================================
--
-- 1. CREATE FUNCTION nome(parametros)
--    → Cria a função.
--    → parametros são os valores de entrada.
--    → Ex: CREATE FUNCTION fn_somar(a INT, b INT)
--
-- 2. RETURNS tipo
--    → OBRIGATÓRIO! Diz qual tipo de dado vai retornar.
--    → Pode ser: INT, VARCHAR, DECIMAL, DATE, BOOLEAN, etc.
--    → Ex: RETURNS DECIMAL(10,2)
--
-- 3. DETERMINISTIC / NOT DETERMINISTIC
--    → DETERMINISTIC = sempre retorna o mesmo valor para mesma entrada
--    → NOT DETERMINISTIC = pode retornar valores diferentes
--    → Ex: fn_somar(2,2) SEMPRE retorna 4 → DETERMINISTIC
--    → Ex: fn_ano_atual() retorna ano diferente → NOT DETERMINISTIC
--
-- 4. READS SQL DATA / MODIFIES SQL DATA
--    → READS SQL DATA = só consulta (SELECT), não modifica
--    → MODIFIES SQL DATA = pode modificar (INSERT, UPDATE, DELETE)
--    → A maioria das functions só lê dados
--
-- 5. BEGIN ... END
--    → Bloco onde fica o código da função
--
-- 6. DECLARE
--    → Cria variáveis dentro da função
--    → Ex: DECLARE v_resultado INT;
--
-- 7. SET
--    → Atribui valor a uma variável
--    → Ex: SET v_resultado = a + b;
--
-- 8. RETURN valor
--    → OBRIGATÓRIO! Devolve o resultado da função
--    → Ex: RETURN v_resultado;
--
-- DIFERENÇA PRÁTICA ENTRE PROCEDURE E FUNCTION:
--
-- PROCEDURE                          | FUNCTION
-- -----------------------------------|-----------------------------------
-- CALL sp_nome()                     | SELECT fn_nome()
-- Pode retornar vários resultados    | Retorna UM ÚNICO valor
-- Pode fazer INSERT/UPDATE/DELETE    | Só consulta (na maioria dos casos)
-- Usa OUT para retornar valores      | Usa RETURN para retornar
-- Não pode ser usada em SELECT       | Pode ser usada DENTRO de SELECT
-- -----------------------------------|-----------------------------------
--
-- ONDE USAR FUNCTION:
--   ✓ DENTRO DE SELECT: SELECT fn_calcular(...) FROM tabela
--   ✓ DENTRO DE WHERE:  SELECT * FROM tabela WHERE fn_valido(...)
--   ✓ DENTRO DE SET:    SET v = fn_somar(1,2)
--   ✓ DENTRO DE IF:     IF fn_tem_desconto(preco) THEN ...
--   ✓ DENTRO DE PROCEDURE: dentro de uma procedure
--   ✓ DENTRO DE OUTRA FUNCTION: uma function chamando outra
--
-- O QUE NÃO PODE NA FUNCTION:
--   ✗ INSERT / UPDATE / DELETE (na maioria dos SGBDs)
--   ✗ CREATE / ALTER / DROP
--   ✗ Usar tabelas temporárias
--   ✗ Usar COMMIT / ROLLBACK
-- ============================================================
