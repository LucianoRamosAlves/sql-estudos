-- ============================================
-- TUDO SOBRE NULL NO MySQL
-- ============================================

-- 1. O QUE É NULL?
-- NULL representa a ausência de valor, desconhecido ou não aplicável
-- NULL é diferente de 0, espaço em branco ou string vazia


-- 2. VERIFICANDO NULL
-- Use IS NULL e IS NOT NULL (NOT operadores de comparação)

SELECT * FROM usuarios WHERE email IS NULL;
SELECT * FROM usuarios WHERE email IS NOT NULL;

-- ❌ ERRADO - nunca use = NULL ou != NULL
-- SELECT * FROM usuarios WHERE email = NULL; -- Retorna 0 linhas


-- 3. FUNÇÃO IFNULL (MySQL)
-- Substitui NULL por um valor padrão

SELECT 
    nome,
    IFNULL(telefone, 'Não informado') AS telefone
FROM usuarios;

-- Exemplo: Se telefone é NULL, mostra 'Não informado'
-- SELECT IFNULL(NULL, 'valor_padrao'); -- Retorna 'valor_padrao'


-- 4. FUNÇÃO COALESCE
-- Retorna o primeiro valor NÃO NULL

SELECT 
    nome,
    COALESCE(telefone, email, 'Sem contato') AS contato
FROM usuarios;

-- Testa: telefone → email → 'Sem contato' (na ordem)


-- 5. OPERAÇÕES COM NULL
-- NULL com qualquer operação resulta em NULL

-- Exemplos:
-- NULL + 5 = NULL
-- NULL * 0 = NULL
-- NULL || 'texto' = NULL

SELECT 
    5 + NULL,           -- NULL
    10 * NULL,          -- NULL
    CONCAT('Oi', NULL)  -- NULL


-- 6. NULL EM AGGREGAÇÕES
-- Funções de agregação ignoram NULL por padrão

CREATE TABLE vendas (
    id INT,
    valor DECIMAL(10,2)
);

INSERT INTO vendas VALUES (1, 100), (2, NULL), (3, 50);

SELECT 
    COUNT(*) AS total_linhas,      -- 3 (conta NULL)
    COUNT(valor) AS com_valor,     -- 2 (ignora NULL)
    SUM(valor) AS soma,            -- 150
    AVG(valor) AS media,           -- 75 (150/2)
    MAX(valor) AS maximo,          -- 100
    MIN(valor) AS minimo           -- 50
FROM vendas;


-- 7. NULL EM JOINS
-- NULL não corresponde a NULL em JOINs

CREATE TABLE t1 (id INT, valor VARCHAR(50));
CREATE TABLE t2 (id INT, valor VARCHAR(50));

INSERT INTO t1 VALUES (1, 'A'), (2, NULL);
INSERT INTO t2 VALUES (1, 'A'), (2, NULL);

-- Esta query não retorna a linha com NULL
SELECT * FROM t1 INNER JOIN t2 ON t1.valor = t2.valor; -- Retorna apenas (A, A)


-- 8. NULL EM ORDER BY
-- NULL aparece primeiro (ASC) ou último (DESC) por padrão

SELECT * FROM usuarios 
ORDER BY data_acesso ASC;  -- NULL aparecem primeiro

SELECT * FROM usuarios 
ORDER BY data_acesso DESC; -- NULL aparecem último


-- 9. NULL EM DISTINCT
-- NULL é considerado como um valor distinto único

SELECT DISTINCT telefone FROM usuarios;
-- Retorna NULL como um valor único, mesmo que haja vários NULL


-- 10. DEFININDO NULL EM TABELAS

CREATE TABLE exemplo (
    id INT NOT NULL,                    -- Nunca pode ser NULL
    nome VARCHAR(100) NOT NULL,         
    email VARCHAR(100),                 -- Pode ser NULL
    telefone VARCHAR(20) DEFAULT NULL,  -- Padrão é NULL
    ativo BOOLEAN DEFAULT TRUE          -- Nunca será NULL
);


-- 11. EXEMPLO PRÁTICO COMPLETO

CREATE TABLE pedidos (
    id INT PRIMARY KEY,
    cliente_id INT NOT NULL,
    desconto DECIMAL(5,2),              -- Pode ser NULL
    data_entrega DATE,                  -- Pode ser NULL
    observacoes TEXT
);

INSERT INTO pedidos VALUES 
(1, 100, 10.50, '2024-01-15', 'Entregue'),
(2, 101, NULL, NULL, 'Aguardando'),
(3, 102, 5.00, '2024-01-20', NULL);

-- Consultando com tratamento de NULL
SELECT 
    id,
    cliente_id,
    COALESCE(desconto, 0) AS desconto_real,           -- Substitui NULL por 0
    IFNULL(data_entrega, 'Não entregue') AS status,   -- Substitui NULL por texto
    COALESCE(observacoes, 'Sem anotações') AS notas   
FROM pedidos
WHERE data_entrega IS NULL;  -- Apenas pedidos não entregues