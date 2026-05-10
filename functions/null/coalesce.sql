-- =============================================================
-- FUNÇÃO COALESCE - Estudo Completo
-- =============================================================
-- Retorna o primeiro valor NÃO NULO de uma lista de expressões.
-- Se todos os valores forem NULL, retorna NULL.
-- Sintaxe: COALESCE(valor1, valor2, valor3, ..., valorN)

-- =============================================================
-- EXEMPLO 1: Uso básico com valores literais
-- =============================================================
-- A função avalia da esquerda para a direita e retorna
-- o primeiro valor que NÃO é NULL.

SELECT
    COALESCE(NULL, NULL, 'terceiro', 'quarto') AS resultado;
-- Resultado: 'terceiro'
-- Passo a passo:
--   1º: NULL → ignora
--   2º: NULL → ignora
--   3º: 'terceiro' → NÃO é NULL → retorna 'terceiro'
--   4º: 'quarto' → nem chega a avaliar

-- =============================================================
-- EXEMPLO 2: Primeiro valor já é não nulo
-- =============================================================
SELECT
    COALESCE('primeiro', NULL, 'terceiro') AS resultado;
-- Resultado: 'primeiro'
-- Passo a passo:
--   1º: 'primeiro' → NÃO é NULL → retorna imediatamente

-- =============================================================
-- EXEMPLO 3: Todos os valores são NULL
-- =============================================================
SELECT
    COALESCE(NULL, NULL, NULL) AS resultado;
-- Resultado: NULL
-- Passo a passo:
--   1º: NULL → ignora
--   2º: NULL → ignora
--   3º: NULL → ignora
--   Fim: todos NULL → retorna NULL

-- =============================================================
-- EXEMPLO 4: Uso prático com tabela de clientes
-- =============================================================
-- Cenário: tabela onde cliente pode ter telefone celular,
-- telefone fixo OU email. Queremos o primeiro contato disponível.

-- Criação da tabela de exemplo
CREATE TABLE IF NOT EXISTS clientes (
    id INT PRIMARY KEY,
    nome VARCHAR(100),
    celular VARCHAR(20),
    fixo VARCHAR(20),
    email VARCHAR(100)
);

-- Inserindo alguns dados
INSERT INTO clientes VALUES
    (1, 'João',   '9999-0001',  NULL,        'joao@email.com'),
    (2, 'Maria',   NULL,       '3333-1111',  'maria@email.com'),
    (3, 'Pedro',   NULL,        NULL,        'pedro@email.com'),
    (4, 'Ana',     NULL,        NULL,         NULL);

-- Consulta usando COALESCE para priorizar: celular > fixo > email
SELECT
    nome,
    COALESCE(celular, fixo, email, 'Sem contato') AS contato_principal
FROM clientes;

-- Resultado esperado:
-- Joao   | 9999-0001       (celular)
-- Maria  | 3333-1111       (fixo - celular era NULL)
-- Pedro  | pedro@email.com (email - celular e fixo eram NULL)
-- Ana    | Sem contato     (todos NULL, caiu no fallback)

-- =============================================================
-- EXEMPLO 5: COALESCE vs IFNULL
-- =============================================================
-- IFNULL(expr1, expr2) é equivalente a COALESCE(expr1, expr2)
-- Mas COALESCE aceita MAIS de 2 argumentos

SELECT
    IFNULL(NULL, 'fallback') AS com_ifnull,
    COALESCE(NULL, 'fallback') AS com_coalesce;
-- Ambos retornam 'fallback'

-- IFNULL só aceita 2 argumentos:
-- IFNULL(NULL, 'a', 'b') → ERRO!
-- COALESCE(NULL, 'a', 'b') → retorna 'a'

-- =============================================================
-- EXEMPLO 6: COALESCE com cálculos
-- =============================================================
-- Útil para evitar NULL em operações matemáticas

SELECT
    COALESCE(10, 0) + COALESCE(NULL, 0) AS soma_segura;
-- Passo a passo:
--   COALESCE(10, 0)    → 10   (10 não é NULL)
--   COALESCE(NULL, 0)  → 0    (NULL, usa fallback 0)
--   Resultado: 10 + 0 = 10
-- Sem COALESCE: 10 + NULL = NULL (problema!)

-- =============================================================
-- EXEMPLO 7: COALESCE com CASE (mesma lógica)
-- =============================================================
-- COALESCE é um "açúcar sintático" para CASE:

SELECT
    COALESCE(NULL, 'b', 'c') AS usando_coalesce,
    CASE
        WHEN NULL IS NOT NULL THEN NULL
        WHEN 'b'  IS NOT NULL THEN 'b'
        WHEN 'c'  IS NOT NULL THEN 'c'
    END AS usando_case;
-- Ambos retornam 'b'

-- =============================================================
-- EXEMPLO 8: COALESCE em ORDER BY
-- =============================================================
-- Útil para ordenar dados que podem ter NULL

SELECT *
FROM clientes
ORDER BY COALESCE(celular, fixo, email);
-- Ordena usando o primeiro contato disponível de cada cliente

-- =============================================================
-- RESUMO RÁPIDO
-- =============================================================
-- 1. COALESCE retorna o 1º valor NÃO NULO da lista
-- 2. Aceita 2 ou mais argumentos
-- 3. Se todos forem NULL, retorna NULL
-- 4. COALESCE(x, y) = IFNULL(x, y)
-- 5. Ótimo para: fallbacks, evitar NULL em cálculos,
--    priorizar valores, e substituir dados faltantes