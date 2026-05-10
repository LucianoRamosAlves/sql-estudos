/* ========================================================================
   04 - DIFERENÇAS: DATEDIFF e TIMESTAMPDIFF
   ========================================================================
   
   Para calcular a diferença entre duas datas usamos:
   
   DATEDIFF(data1, data2)           → diferença em DIAS
   TIMESTAMPDIFF(unidade, inicio, fim) → diferença na unidade que escolher
   
   Unidades do TIMESTAMPDIFF: YEAR, MONTH, DAY, HOUR, MINUTE, SECOND
   ======================================================================== */

-- ========================================================================
-- 1. DATEDIFF - Diferença em DIAS
-- ========================================================================

/*
   DATEDIFF(data_maior, data_menor) → quantidade de DIAS entre elas
   
   A ordem importa:
   - DATEDIFF(hoje, passado) = positivo
   - DATEDIFF(passado, hoje) = negativo
*/

SELECT
    DATEDIFF(NOW(), '2000-10-05') AS dias_desde_2000,         -- positivo
    DATEDIFF('2000-10-05', NOW()) AS dias_ordem_inversa,      -- negativo
    DATEDIFF('2024-12-25', '2024-10-05') AS dias_ate_natal;   -- 81 dias

/*
   Resultado:
   
   dias_desde_2000 | dias_ordem_inversa | dias_ate_natal
   ----------------+--------------------+---------------
   8766            | -8766              | 81
*/

-- Aplicando na tabela pessoas
SELECT
    nome,
    nascimento,
    DATEDIFF(NOW(), nascimento) AS dias_de_vida
FROM pessoas;

/*
   Resultado:
   
   nome           | nascimento | dias_de_vida
   ---------------+------------+-------------
   Ana Silva      | 1995-06-15 | 10704
   Carlos Souza   | 2000-10-05 | 8766
   Maria Lima     | 1988-12-25 | 13073
   João Santos    | 2000-10-20 | 8751
*/

-- ========================================================================
-- 2. TIMESTAMPDIFF - Diferença na unidade que você escolher
-- ========================================================================

/*
   TIMESTAMPDIFF(unidade, data_inicio, data_fim)
   
   ORDEM: data_inicio, data_fim
   Ex: TIMESTAMPDIFF(YEAR, '2000-10-05', NOW()) = 24 anos
*/

SELECT
    TIMESTAMPDIFF(YEAR,   '2000-10-05', NOW()) AS anos,
    TIMESTAMPDIFF(MONTH,  '2000-10-05', NOW()) AS meses,
    TIMESTAMPDIFF(DAY,    '2000-10-05', NOW()) AS dias,
    TIMESTAMPDIFF(HOUR,   '2000-10-05', NOW()) AS horas,
    TIMESTAMPDIFF(MINUTE, '2000-10-05', NOW()) AS minutos,
    TIMESTAMPDIFF(SECOND, '2000-10-05', NOW()) AS segundos;

/*
   Resultado (considerando hoje = 2024-10-05 14:30):
   
   anos | meses | dias | horas  | minutos  | segundos
   -----+-------+------+--------+----------+----------
   24   | 288   | 8766 | 210390 | 12623430 | 757405800
*/

-- ========================================================================
-- 3. DATEDIFF vs TIMESTAMPDIFF - Quando usar
-- ========================================================================

/*
   DATEDIFF                 | TIMESTAMPDIFF
   -------------------------+-------------------------------
   Sempre retorna DIAS      | Retorna na unidade que você quer
   Sintaxe mais simples     | Sintaxe mais flexível
   
   Use DATEDIFF:            | Use TIMESTAMPDIFF:
   Só precisa de dias       | Precisa de anos, meses, horas
*/

-- Calculando idade de cada pessoa
SELECT
    nome,
    nascimento,
    TIMESTAMPDIFF(YEAR, nascimento, NOW()) AS idade_anos,
    TIMESTAMPDIFF(MONTH, nascimento, NOW()) AS idade_meses,
    DATEDIFF(NOW(), nascimento) AS idade_dias
FROM pessoas;

/*
   Resultado:
   
   nome           | nascimento | idade_anos | idade_meses | idade_dias
   ---------------+------------+------------+-------------+-----------
   Ana Silva      | 1995-06-15 | 29         | 351         | 10704
   Carlos Souza   | 2000-10-05 | 24         | 288         | 8766
   Maria Lima     | 1988-12-25 | 35         | 429         | 13073
   João Santos    | 2000-10-20 | 23         | 287         | 8751
   
   DICA: Para calcular IDADE, use TIMESTAMPDIFF(YEAR, ...).
         Para saber dias entre datas, use DATEDIFF.
*/

-- ========================================================================
-- FIM
-- ========================================================================