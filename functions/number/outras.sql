/* ========================================================================
   OUTRAS FUNÇÕES NUMÉRICAS NO MySQL
   ========================================================================
   
   Além do ROUND, temos funções úteis para trabalhar com números.
   ======================================================================== */

-- ========================================================================
-- ABS  -  Valor Absoluto (distância do zero)
-- ========================================================================

/*
   ABS(5)  = 5
   ABS(-5) = 5
*/

SELECT
    ABS(5)   AS positivo,   -- 5
    ABS(-5)  AS negativo,   -- 5 (vira positivo)
    ABS(0)   AS zero;       -- 0

-- Útil para calcular diferenças ignorando sinal
SELECT ABS(10 - 25) AS diferenca;  -- 15 (distância entre 10 e 25)

-- ========================================================================
-- MOD  -  Resto da Divisão (módulo)
-- ========================================================================

/*
   MOD(dividendo, divisor)  ou  dividendo % divisor
   Retorna o RESTO da divisão inteira.
   
   10 ÷ 3 = 3 (inteiro) e SOBRA 1
   MOD(10, 3) = 1
*/

SELECT
    MOD(10, 3)  AS mod_10_3,    -- 1  (10/3 = 3, resto 1)
    MOD(15, 5)  AS mod_15_5,    -- 0  (15/5 = 3, resto 0)
    MOD(7, 2)   AS mod_7_2,     -- 1  (ímpar)
    MOD(8, 2)   AS mod_8_2;     -- 0  (par)

/*
   Caso de uso: descobrir se número é PAR ou ÍMPAR
   MOD(num, 2) = 0 → PAR
   MOD(num, 2) = 1 → ÍMPAR
*/

-- ========================================================================
-- POW / POWER  -  Potenciação (elevar ao expoente)
-- ========================================================================

/*
   POW(base, expoente)  =  base ^ expoente
   POWER é apelido do POW (mesma função)
*/

SELECT
    POW(2, 3)   AS dois_ao_cubo,      -- 8   (2*2*2)
    POW(3, 2)   AS tres_ao_quadrado,  -- 9   (3*3)
    POW(10, 0)  AS dez_a_zero,        -- 1   (qualquer nº^0 = 1)
    POW(5, 1)   AS cinco_a_um;        -- 5   (qualquer nº^1 = ele mesmo)

-- ========================================================================
-- SQRT  -  Raiz Quadrada
-- ========================================================================

SELECT
    SQRT(9)     AS raiz_9,        -- 3
    SQRT(16)    AS raiz_16,       -- 4
    SQRT(2)     AS raiz_2;        -- 1.414...

-- ========================================================================
-- SIGN  -  Sinal do número (-1, 0, 1)
-- ========================================================================

/*
   SIGN(positivo) =  1
   SIGN(zero)     =  0
   SIGN(negativo) = -1
*/

SELECT
    SIGN(10)    AS sinal_positivo,   -- 1
    SIGN(0)     AS sinal_zero,       -- 0
    SIGN(-10)   AS sinal_negativo;   -- -1

-- ========================================================================
-- RAND  -  Número aleatório entre 0 e 1
-- ========================================================================

SELECT RAND() AS aleatorio;           -- 0.12345... (valor varia)

-- Número aleatório entre 1 e 100
SELECT FLOOR(RAND() * 100) + 1 AS aleatorio_1_a_100;

-- ========================================================================
-- RESUMÃO - FUNÇÕES NUMÉRICAS MySQL
-- ========================================================================

/*
   Função     | O que faz                       | Exemplo
   -----------+---------------------------------+--------------
   ROUND()    | Arredonda (padrão escolar)      | ROUND(2.5) = 3
   CEIL()     | Arredonda pra cima (teto)       | CEIL(2.1) = 3
   FLOOR()    | Arredonda pra baixo (chão)      | FLOOR(2.9) = 2
   TRUNCATE() | Corta decimais sem arredondar   | TRUNCATE(2.57,1)=2.5
   ABS()      | Valor absoluto (tira sinal -)   | ABS(-5) = 5
   MOD()      | Resto da divisão                | MOD(10,3) = 1
   POW()      | Potenciação                     | POW(2,3) = 8
   SQRT()     | Raiz quadrada                   | SQRT(9) = 3
   SIGN()     | Sinal do número                 | SIGN(-5) = -1
   RAND()     | Número aleatório 0 a 1          | RAND() = 0.45...
*/

-- ========================================================================
-- FIM
-- ========================================================================
