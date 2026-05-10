/* ========================================================================
   04 - DIFERENÇAS: DATEDIFF e TIMESTAMPDIFF
   ========================================================================
   
   Para calcular a diferença entre duas datas usamos:
   
   DATEDIFF(data1, data2)
   → Diferença em DIAS (data1 - data2)
   → Retorna sempre em DIAS, não importa a diferença
   
   TIMESTAMPDIFF(unidade, data_inicio, data_fim)
   → Diferença na unidade que você ESCOLHER
   → Unidades: YEAR, MONTH, DAY, HOUR, MINUTE, SECOND
   ======================================================================== */

-- ========================================================================
-- 1. DATEDIFF - Diferença em DIAS
-- ========================================================================

/*
   DATEDIFF(data_maior, data_menor) → quantidade de DIAS entre elas
   
   A ordem importa:
   DATEDIFF(data_futura, data_passada) = positivo (dias para frente)
   DATEDIFF(data_passada, data_futura) = negativo (dias para trás)
   
   Fórmula: DATEDIFF = data1 - data2
*/

SELECT
    -- Diferença entre hoje e uma data passada
    DATEDIFF(NOW(), '2000-10-05') AS dias_desde_2000,        -- positivo

    -- Diferença entre uma data passada e hoje (ordem inversa)
    DATEDIFF('2000-10-05', NOW()) AS dias_ordem_inversa,     -- negativo

    -- Diferença entre duas datas específicas
    DATEDIFF('2024-12-25', '2024-10-05') AS dias_ate_natal;  -- 81 dias

/*
   Resultado (considerando hoje = 2024-10-05):
   
   coluna              | resultado
   --------------------+----------
   dias_desde_2000     | 8766      ← positivo (hoje > 2000)
   dias_ordem_inversa  | -8766     ← negativo (2000 < hoje)
   dias_ate_natal      | 81        ← 25/dez - 05/out = 81 dias
*/

-- Aplicando na tabela pessoas: quantos dias desde o nascimento?
SELECT
    nome,
    nascimento,
    DATEDIFF(NOW(), nascimento) AS dias_de_vida
FROM pessoas;

/*
   Resultado (exemplo):
   
   nome           | nascimento | dias_de_vida
   ---------------+------------+-------------
   Ana Silva      | 1995-06-15 | 10704
   Carlos Souza   | 2000-10-05 | 8766
   Maria Lima     | 1988-12-25 | 13073
   João Santos    | 2000-10-20 | 8751
*/

-- ========================================================================
-- 2. TIMESTAMPDIFF - Diferença em QUALQUER unidade
-- ========================================================================

/*
   TIMESTAMPDIFF(unidade, data_inicio, data_fim)
   
   Diferente do DATEDIFF, aqui você ESCOLHE a unidade do resultado.
   
   Unidades: YEAR, MONTH, DAY, HOUR, MINUTE, SECOND
   
   IMPORTANTE: a ordem é data_inicio, data_fim
   TIMESTAMPDIFF(YEAR, '2000-10-05', NOW()) = 24 anos
   (do início ao fim, quantos anos se passaram?)
*/

SELECT
    -- Diferença em ANOS
    TIMESTAMPDIFF(YEAR, '2000-10-05', NOW()) AS anos_desde_2000,

    -- Diferença em MESES
    TIMESTAMPDIFF(MONTH, '2000-10-05', NOW()) AS meses_desde_2000,

    -- Diferença em DIAS
    TIMESTAMPDIFF(DAY, '2000-10-05', NOW()) AS dias_desde_2000,

    -- Diferença em HORAS
    TIMESTAMPDIFF(HOUR, '2000-10-05', NOW()) AS horas_desde_2000,

    -- Diferença em MINUTOS
    TIMESTAMPDIFF(MINUTE, '2000-10-05', NOW()) AS minutos_desde_2000,

    -- Diferença em SEGUNDOS
    TIMESTAMPDIFF(SECOND, '2000-10-05', NOW()) AS segundos_desde_2000;

/*
   Resultado (considerando hoje = 2024-10-05 14:30:00):
   
   coluna              | resultado
   --------------------+-----------
   anos_desde_2000     | 24         ← 24 anos
   meses_desde_2000    | 288        ← 24 anos * 12 meses
   dias_desde_2000     | 8766       ← já vimos no DATEDIFF
   horas_desde_2000    | 210390     ← 8766 dias * 24h + 14h
   minutos_desde_2000  | 12623430   ← muitas horas * 60
   segundos_desde_2000 | 757405800  ← muitos minutos * 60
   
   PERCEBA: Com TIMESTAMPDIFF você controla a unidade!
*/

-- ========================================================================
-- 2. TIMESTAMPDIFF - Diferença em QUALQUER unidade
-- ========================================================================

/*
   TIMESTAMPDIFF(unidade, data_inicio, data_fim)
   
   Diferente do DATEDIFF, aqui você ESCOLHE a unidade do resultado.
   
   Unidades: YEAR, MONTH, DAY, HOUR, MINUTE, SECOND
   
   IMPORTANTE: a ordem é data_inicio, data_fim
   TIMESTAMPDIFF(YEAR, '2000-10-05', NOW()) = 24 anos
   (do início ao fim, quantos anos se passaram?)
*/

SELECT
    -- Diferença em ANOS
    TIMESTAMPDIFF(YEAR, '2000-10-05', NOW()) AS anos_desde_2000,

    -- Diferença em MESES
    TIMESTAMPDIFF(MONTH, '2000-10-05', NOW()) AS meses_desde_2000,

    -- Diferença em DIAS
    TIMESTAMPDIFF(DAY, '2000-10-05', NOW()) AS dias_desde_2000,

    -- Diferença em HORAS
    TIMESTAMPDIFF(HOUR, '2000-10-05', NOW()) AS horas_desde_2000,

    -- Diferença em MINUTOS
    TIMESTAMPDIFF(MINUTE, '2000-10-05', NOW()) AS minutos_desde_2000,

    -- Diferença em SEGUNDOS
    TIMESTAMPDIFF(SECOND, '2000-10-05', NOW()) AS segundos_desde_2000;

/*
   Resultado (considerando hoje = 2024-10-05 14:30:00):
   
   coluna              | resultado
   --------------------+-----------
   anos_desde_2000     | 24         ← 24 anos
   meses_desde_2000    | 288        ← 24 anos * 12 meses
   dias_desde_2000     | 8766       ← já vimos no DATEDIFF
   horas_desde_2000    | 210390     ← 8766 dias * 24h + 14h
   minutos_desde_2000  | 12623430   ← muitas horas * 60
   segundos_desde_2000 | 757405800  ← muitos minutos * 60
   
   PERCEBA: Com TIMESTAMPDIFF você controla a unidade!
*/
