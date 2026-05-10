/* ========================================================================
   03 - OPERAÇÕES: Adicionar e Subtrair Datas
   ========================================================================
   
   Com DATE_ADD e DATE_SUB você pode ANDAR NO TEMPO:
   - Adicionar dias, meses, anos a uma data (projetar para frente)
   - Subtrair dias, meses, anos de uma data (voltar no tempo)
   
   SINTÁXE:
   DATE_ADD(data, INTERVAL valor unidade)
   DATE_SUB(data, INTERVAL valor unidade)
   
   UNIDADES DISPONÍVEIS:
   DAY, MONTH, YEAR, HOUR, MINUTE, SECOND, WEEK, QUARTER
   
   Também podemos combinar unidades: '1-2' YEAR_MONTH (1 ano e 2 meses)
   ======================================================================== */

-- ========================================================================
-- 1. DATE_ADD - Adicionando tempo a uma data
-- ========================================================================

/*
   DATE_ADD(data, INTERVAL quantidade unidade)
   
   Pense assim: "Pega a data X e ADICIONA Y unidades pra frente"
   
   Exemplo mental:
   Hoje é 2024-10-05. Se eu adicionar 7 dias, vai pra 2024-10-12.
   DATE_ADD('2024-10-05', INTERVAL 7 DAY) = '2024-10-12'
*/

SELECT
    NOW() AS agora,

    -- ADICIONANDO DIAS
    DATE_ADD(NOW(), INTERVAL 7 DAY)   AS mais_7_dias,     -- +7 dias
    DATE_ADD(NOW(), INTERVAL 30 DAY)  AS mais_30_dias,    -- +30 dias (~1 mês)

    -- ADICIONANDO MESES
    DATE_ADD(NOW(), INTERVAL 1 MONTH) AS mais_1_mes,      -- +1 mês
    DATE_ADD(NOW(), INTERVAL 6 MONTH) AS mais_6_meses,    -- +6 meses

    -- ADICIONANDO ANOS
    DATE_ADD(NOW(), INTERVAL 1 YEAR)  AS mais_1_ano,      -- +1 ano
    DATE_ADD(NOW(), INTERVAL 5 YEAR)  AS mais_5_anos;     -- +5 anos

/*
   Resultado (considerando hoje = 2024-10-05):
   
   coluna          | resultado
   ----------------+---------------------
   agora           | 2024-10-05 14:30:00
   mais_7_dias     | 2024-10-12 14:30:00   ← 7 dias depois
   mais_30_dias    | 2024-11-04 14:30:00   ← 30 dias depois
   mais_1_mes      | 2024-11-05 14:30:00   ← 1 mês depois
   mais_6_meses    | 2025-04-05 14:30:00   ← 6 meses depois
   mais_1_ano      | 2025-10-05 14:30:00   ← 1 ano depois
   mais_5_anos     | 2029-10-05 14:30:00   ← 5 anos depois
   
   PERCEBA: 30 dias NÃO é igual a 1 mês!
   - 30 dias depois de 05/10 = 04/11 (outubro tem 31 dias)
   - 1 mês depois de 05/10 = 05/11
*/

-- ========================================================================
-- 2. DATE_SUB - Subtraindo tempo de uma data
-- ========================================================================

/*
   DATE_SUB(data, INTERVAL quantidade unidade)
   
   Mesma lógica do DATE_ADD, mas SUBTRAI (volta no tempo).
   
   Exemplo mental:
   Hoje é 2024-10-05. Se eu subtrair 7 dias, volta pra 2024-09-28.
   DATE_SUB('2024-10-05', INTERVAL 7 DAY) = '2024-09-28'
*/

SELECT
    NOW() AS agora,

    -- SUBTRAINDO DIAS
    DATE_SUB(NOW(), INTERVAL 7 DAY)    AS menos_7_dias,      -- -7 dias
    DATE_SUB(NOW(), INTERVAL 30 DAY)   AS menos_30_dias,     -- -30 dias

    -- SUBTRAINDO MESES
    DATE_SUB(NOW(), INTERVAL 1 MONTH)  AS menos_1_mes,       -- -1 mês
    DATE_SUB(NOW(), INTERVAL 3 MONTH)  AS menos_3_meses,     -- -3 meses

    -- SUBTRAINDO ANOS
    DATE_SUB(NOW(), INTERVAL 1 YEAR)   AS menos_1_ano,       -- -1 ano
    DATE_SUB(NOW(), INTERVAL 10 YEAR)  AS menos_10_anos;     -- -10 anos

/*
   Resultado (considerando hoje = 2024-10-05):
   
   coluna          | resultado
   ----------------+---------------------
   agora           | 2024-10-05 14:30:00
   menos_7_dias    | 2024-09-28 14:30:00   ← 7 dias atrás
   menos_30_dias   | 2024-09-05 14:30:00   ← 30 dias atrás
   menos_1_mes     | 2024-09-05 14:30:00   ← 1 mês atrás
   menos_3_meses   | 2024-07-05 14:30:00   ← 3 meses atrás
   menos_1_ano     | 2023-10-05 14:30:00   ← 1 ano atrás
   menos_10_anos   | 2014-10-05 14:30:00   ← 10 anos atrás
*/

-- ========================================================================
-- 3. ADDDATE e SUBDATE - Apelidos (alias) mais curtos
-- ========================================================================

/*
   ADDDATE = DATE_ADD (mesma função, nome mais curto)
   SUBDATE = DATE_SUB (mesma função, nome mais curto)
   
   ADDDATE pode ser usado de 2 formas:
   1. ADDDATE(data, INTERVAL valor unidade) → igual DATE_ADD
   2. ADDDATE(data, dias) → atalho SÓ PARA DIAS (mais curto)
*/

SELECT
    -- Forma completa (igual DATE_ADD)
    ADDDATE(NOW(), INTERVAL 2 MONTH) AS add_2_meses,

    -- Forma abreviada (só para DIAS)
    ADDDATE(NOW(), 30)   AS add_30_dias,        -- +30 dias
    SUBDATE(NOW(), 7)    AS sub_7_dias,         -- -7 dias
    SUBDATE(NOW(), INTERVAL 1 YEAR) AS sub_1_ano;  -- -1 ano

/*
   DICA: Use ADDDATE(data, dias) para adicionar dias.
         Use DATE_ADD para outras unidades (meses, anos...).
*/

-- ========================================================================
-- 4. Combinando unidades (YEAR_MONTH, DAY_HOUR, etc)
-- ========================================================================

/*
   Dá para combinar DUAS unidades em uma única operação.
   
   Combinadores:
   YEAR_MONTH  → '1-2' = 1 ano e 2 meses
   DAY_HOUR    → '5 10' = 5 dias e 10 horas
   DAY_MINUTE  → '5 10:30' = 5 dias, 10h30min
   DAY_SECOND  → '5 10:30:15' = 5 dias, 10h30min15seg
   HOUR_MINUTE → '10:30' = 10h30min
   HOUR_SECOND → '10:30:15' = 10h30min15seg
   MINUTE_SECOND → '30:15' = 30min15seg
*/

SELECT
    NOW() AS agora,

    -- +1 ano e 2 meses
    DATE_ADD(NOW(), INTERVAL '1-2' YEAR_MONTH) AS mais_1ano_2meses,

    -- +5 dias e 10 horas
    DATE_ADD(NOW(), INTERVAL '5 10' DAY_HOUR) AS mais_5dias_10horas;

/*
   Resultado:
   
   coluna              | resultado
   --------------------+---------------------
   agora               | 2024-10-05 14:30:00
   mais_1ano_2meses    | 2025-12-05 14:30:00
   mais_5dias_10horas  | 2024-10-11 00:30:00
   
   Formato: YEAR_MONTH usa hífen '1-2'
            DAY_HOUR usa espaço '5 10'
*/

-- ========================================================================
-- 5. LAST_DAY - Último dia do mês
-- ========================================================================

/*
   LAST_DAY(data) → retorna a data do ÚLTIMO DIA daquele mês.
   
   Muito útil para:
   - Fechamento de contas
   - Saber quantos dias tem um mês
   - Calcular o primeiro dia do próximo mês
*/

SELECT
    NOW() AS hoje,

    -- Último dia do mês atual
    LAST_DAY(NOW()) AS ultimo_dia_mes_atual,

    -- Último dia de fevereiro (anos diferentes)
    LAST_DAY('2024-02-10') AS ultimo_dia_fev_2024,          -- 2024 bissexto
    LAST_DAY('2023-02-10') AS ultimo_dia_fev_2023,          -- 2023 normal

    -- Quantidade de dias no mês atual
    DAY(LAST_DAY(NOW())) AS quantidade_dias_mes,

    -- Primeiro dia do mês que vem (último dia + 1)
    DATE_ADD(LAST_DAY(NOW()), INTERVAL 1 DAY) AS primeiro_dia_prox_mes;

/*
   Resultado:
   
   coluna                    | resultado
   --------------------------+-------------
   hoje                      | 2024-10-05
   ultimo_dia_mes_atual      | 2024-10-31
   ultimo_dia_fev_2024       | 2024-02-29   ← bissexto!
   ultimo_dia_fev_2023       | 2023-02-28   ← normal
   quantidade_dias_mes       | 31
   primeiro_dia_prox_mes     | 2024-11-01
   
   ATENÇÃO: LAST_DAY já sabe se o ano é bissexto!
*/

-- ========================================================================
-- FIM
-- ========================================================================