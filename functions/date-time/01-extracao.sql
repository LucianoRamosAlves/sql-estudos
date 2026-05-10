/* ========================================================================
   01 - EXTRAÇÃO: Extraindo partes de uma Data/Hora
   ========================================================================
   
   Aqui aprendemos a "quebrar" uma data em partes menores:
   ano, mês, dia, hora, minuto, segundo, etc.
   
   É útil para:
   - Agrupar por ano/mês (relatórios)
   - Filtrar aniversariantes do mês
   - Calcular idade
   - etc.
   ======================================================================== */

-- ========================================================================
-- 1. YEAR() / MONTH() / DAY() - As mais usadas
-- ========================================================================

/*
   YEAR(data)  → Extrai o ANO (ex: 2024)
   MONTH(data) → Extrai o MÊS (1 a 12)
   DAY(data)   → Extrai o DIA (1 a 31)
*/

SELECT
    nome,
    nascimento,
    YEAR(nascimento)  AS ano,       -- ex: 1995
    MONTH(nascimento) AS mes,       -- ex: 6
    DAY(nascimento)   AS dia        -- ex: 15
FROM pessoas;

/*
   Resultado:
   
   nome           | nascimento | ano  | mes | dia
   ---------------+------------+------+-----+-----
   Ana Silva      | 1995-06-15 | 1995 | 6   | 15
   Carlos Souza   | 2000-10-05 | 2000 | 10  | 5
   Maria Lima     | 1988-12-25 | 1988 | 12  | 25
   João Santos    | 2000-10-20 | 2000 | 10  | 20
*/

-- ========================================================================
-- 2. HOUR() / MINUTE() / SECOND() - Para horas
-- ========================================================================

SELECT
    NOW()           AS agora,
    HOUR(NOW())     AS hora,      -- 0-23
    MINUTE(NOW())   AS minuto,    -- 0-59
    SECOND(NOW())   AS segundo;   -- 0-59

/*
   Resultado (exemplo para 14:30:45):
   
   agora              | hora | minuto | segundo
   -------------------+------+--------+---------
   2024-10-05 14:30:45| 14   | 30     | 45
*/

-- ========================================================================
-- 3. DAYOFWEEK() / DAYNAME() / MONTHNAME() - Nomes e posições
-- ========================================================================

/*
   DAYOFWEEK(data) → Número do dia da SEMANA
                     (1=Domingo, 2=Segunda, ..., 7=Sábado)
   
   DAYNAME(data)   → Nome do dia em INGLÊS (Monday, Tuesday...)
   MONTHNAME(data) → Nome do mês em INGLÊS (January, February...)
*/

SELECT
    nome,
    nascimento,
    DAYOFWEEK(nascimento) AS n_semana,    -- 1 a 7
    DAYNAME(nascimento)   AS dia_nome,    -- Monday, Tuesday...
    MONTHNAME(nascimento) AS mes_nome     -- January, February...
FROM pessoas;

/*
   Resultado:
   
   nome           | nascimento | n_semana | dia_nome | mes_nome
   ---------------+------------+----------+----------+----------
   Ana Silva      | 1995-06-15 | 5        | Thursday | June
   Carlos Souza   | 2000-10-05 | 5        | Thursday | October
   Maria Lima     | 1988-12-25 | 1        | Sunday   | December
   João Santos    | 2000-10-20 | 6        | Friday   | October
   
   Dica: No Brasil usamos DATE_FORMAT com %W e %M (em português
   se o servidor estiver configurado para pt_BR).
   Veremos isso no arquivo de FORMATAÇÃO.
*/

-- ========================================================================
-- 4. QUARTER() / WEEK() / DAYOFYEAR() - Outras extrações
-- ========================================================================

/*
   QUARTER(data)   → Trimestre (1 a 4)
   WEEK(data)      → Número da semana no ano (1 a 53)
   DAYOFYEAR(data) → Dia do ano (1 a 366)
*/

SELECT
    nome,
    nascimento,
    QUARTER(nascimento)  AS trimestre,     -- 1=Jan-Mar, 2=Abr-Jun, etc
    WEEK(nascimento)     AS semana_ano,    -- qual semana do ano
    DAYOFYEAR(nascimento) AS dia_ano       -- dia 1 a 366
FROM pessoas;

/*
   Resultado:
   
   nome           | nascimento | trimestre | semana_ano | dia_ano
   ---------------+------------+-----------+------------+---------
   Ana Silva      | 1995-06-15 | 2         | 24         | 166
   Carlos Souza   | 2000-10-05 | 4         | 40         | 279
   Maria Lima     | 1988-12-25 | 4         | 52         | 360
   João Santos    | 2000-10-20 | 4         | 42         | 294
   
   INTERPRETAÇÃO:
   - Trimestre 2 = Abril a Junho (Ana)
   - Trimestre 4 = Outubro a Dezembro (Carlos, Maria, João)
   - Semana 24 = junho (Ana)
   - Dia 166 = 15 de junho (166º dia do ano)
*/

-- ========================================================================
-- 5. EXTRACT() - Função padrão SQL para extrair QUALQUER parte
-- ========================================================================

/*
   EXTRACT é a função PADRÃO do SQL (funciona em vários bancos).
   Sintaxe: EXTRACT(unidade FROM data)
   
   Unidades: YEAR, MONTH, DAY, HOUR, MINUTE, SECOND, QUARTER, WEEK...
*/

SELECT
    nome,
    nascimento,
    EXTRACT(YEAR  FROM nascimento) AS ano,
    EXTRACT(MONTH FROM nascimento) AS mes,
    EXTRACT(DAY   FROM nascimento) AS dia
FROM pessoas;

/*
   Resultado (mesmo do YEAR/MONTH/DAY):
   
   nome           | ano  | mes | dia
   ---------------+------+-----+-----
   Ana Silva      | 1995 | 6   | 15
   Carlos Souza   | 2000 | 10  | 5
   Maria Lima     | 1988 | 12  | 25
   João Santos    | 2000 | 10  | 20
   
   EXTRACT vs YEAR/MONTH/DAY:
   - EXTRACT: padrão SQL (funciona em PostgreSQL, Oracle, etc)
   - YEAR()/MONTH()/DAY(): funções específicas do MySQL (mais curtas)
   
   Ambos funcionam no MySQL, use o que preferir!
*/

-- ========================================================================
-- 6. Extraindo HORA, MINUTO, SEGUNDO com EXTRACT
-- ========================================================================

/*
   EXTRACT também funciona para partes de hora.
*/

SELECT
    NOW() AS agora,
    EXTRACT(HOUR   FROM NOW()) AS hora,
    EXTRACT(MINUTE FROM NOW()) AS minuto,
    EXTRACT(SECOND FROM NOW()) AS segundo;

/*
   Resultado:
   
   agora               | hora | minuto | segundo
   --------------------+------+--------+---------
   2024-10-05 14:30:45 | 14   | 30     | 45
*/

-- ========================================================================
-- 7. RESUMO DE TODAS AS FUNÇÕES DE EXTRAÇÃO
-- ========================================================================

/*
   Função          | O que extrai          | Exemplo (data: 2024-10-05)
   ----------------+-----------------------+--------------------------
   YEAR()          | Ano                   | 2024
   MONTH()         | Mês (1-12)            | 10
   DAY()           | Dia (1-31)            | 5
   HOUR()          | Hora (0-23)           | 14
   MINUTE()        | Minuto (0-59)         | 30
   SECOND()        | Segundo (0-59)        | 45
   DAYOFWEEK()     | Dia da semana (1-7)   | 7 (Sábado)
   DAYNAME()       | Nome do dia           | Saturday
   MONTHNAME()     | Nome do mês           | October
   QUARTER()       | Trimestre (1-4)       | 4
   WEEK()          | Semana do ano (1-53)  | 40
   DAYOFYEAR()     | Dia do ano (1-366)    | 279
   EXTRACT()       | Qualquer parte (padrão SQL) | depende da unidade
*/

-- ========================================================================
-- FIM
-- ========================================================================