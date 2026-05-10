/* ========================================================================
   ROUND - Arredondamento de números no MySQL
   ========================================================================
   
   ROUND(número, casas_decimais)
   - Arredonda para o valor MAIS PRÓXIMO
   - .5 ou mais → arredonda PARA CIMA
   - .4 ou menos → arredonda PARA BAIXO
   ======================================================================== */

SELECT
    -- Número original para referência
    2.517 AS valor_original,

    -- 2 casas: 2.517 → olha o 7 (3ª casa) que é ≥ 5 → sobe
    ROUND(2.517, 2) AS round_2,    -- 2.52

    -- 1 casa: 2.517 → olha o 1 (2ª casa) que é < 5 → mantém
    ROUND(2.517, 1) AS round_1,    -- 2.5

    -- 0 casas: 2.517 → olha o 5 (1ª casa) que é ≥ 5 → sobe
    ROUND(2.517, 0) AS round_0;    -- 3

/* ========================================================================
   RESULTADO:
   
   valor_original | round_2 | round_1 | round_0
   ---------------+---------+---------+---------
   2.517          | 2.52    | 2.5     | 3
   
   Explicação passo a passo:
   
   ROUND(2.517, 2): olha a 3ª casa decimal (7) → 7 ≥ 5 → 2.52  ✔️
   ROUND(2.517, 1): olha a 2ª casa decimal (1) → 1 < 5 → 2.5   ✔️
   ROUND(2.517, 0): olha a 1ª casa decimal (5) → 5 ≥ 5 → 3     ✔️
   ======================================================================== */

-- ========================================================================
-- CEIL / CEILING  -  Arredonda SEMPRE PARA CIMA (teto)
-- FLOOR           -  Arredonda SEMPRE PARA BAIXO (chão)
-- ========================================================================

/*
   CEIL(2.1)  = 3   (sempre sobe, mesmo 2.0001 vira 3)
   FLOOR(2.9) = 2   (sempre desce, mesmo 2.9999 vira 2)
*/

SELECT
    CEIL(2.1)   AS ceil_2_1,    -- 3
    CEIL(2.9)   AS ceil_2_9,    -- 3
    FLOOR(2.1)  AS floor_2_1,   -- 2
    FLOOR(2.9)  AS floor_2_9;   -- 2

/* ========================================================================
   Resultado:
   
   ceil_2_1 | ceil_2_9 | floor_2_1 | floor_2_9
   ---------+----------+-----------+----------
   3        | 3        | 2         | 2
   ======================================================================== */

-- ========================================================================
-- TRUNCATE  -  CORTA as casas decimais SEM arredondar
-- ========================================================================

/*
   TRUNCATE(2.517, 2) = 2.51  (só corta, não arredonda)
   ROUND(2.517, 2)    = 2.52  (arredonda)
   
   Diferença sutil mas importante:
   - TRUNCATE simplesmente DESCARTAs as casas decimais
   - ROUND analisa se sobe ou desce
*/

SELECT
    TRUNCATE(2.517, 2) AS truncate_2,    -- 2.51 (cortou o 7)
    ROUND(2.517, 2)    AS round_2;        -- 2.52 (arredondou pra cima)

/* ========================================================================
   Resultado:
   
   truncate_2 | round_2
   -----------+---------
   2.51       | 2.52
   
   Resumo das funções de arredondamento:
   
   Função      | O que faz                        | 2.517 vira...
   ------------+----------------------------------+--------------
   ROUND(,2)   | Arredonda (≥ .5 sobe)            | 2.52
   TRUNCATE(,2)| Corta sem arredondar              | 2.51
   CEIL()      | Sempre para cima (inteiro)        | 3
   FLOOR()     | Sempre para baixo (inteiro)       | 2
   ======================================================================== */

-- ========================================================================
-- FIM
-- ========================================================================