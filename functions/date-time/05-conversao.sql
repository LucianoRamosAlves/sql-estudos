/* ========================================================================
   05 - CONVERSÃO: STR_TO_DATE, DATE(), TIME(), CONVERT
   ========================================================================
   
   Às vezes precisamos converter texto em data, ou extrair 
   só a data ou só a hora de um DATETIME.
   
   FUNÇÕES:
   STR_TO_DATE(texto, formato)  → converte STRING em DATA
   DATE(datetime)               → extrai só a DATA de um DATETIME
   TIME(datetime)               → extrai só a HORA de um DATETIME
   CONVERT(valor, tipo)         → converte entre tipos
   CAST(valor AS tipo)          → converte entre tipos (padrão SQL)
   ======================================================================== */

-- ========================================================================
-- 1. STR_TO_DATE - Convertendo STRING em DATA
-- ========================================================================

/*
   STR_TO_DATE('texto', 'formato')
   
   Útil quando você recebe uma data em formato de texto
   (ex: de um arquivo, formulário, API) e precisa converter
   para o tipo DATE do MySQL.
   
   O formato usa os mesmos códigos % do DATE_FORMAT.
*/

SELECT
    -- Convertendo string no formato brasileiro para data
    STR_TO_DATE('31/12/2023', '%d/%m/%Y') AS data_convertida,

    -- String com mês por extenso
    STR_TO_DATE('25 de December de 2023', '%d de %M de %Y') AS data_extensa,

    -- String com hora incluída
    STR_TO_DATE('05/10/2024 14:30:00', '%d/%m/%Y %H:%i:%s') AS data_hora;

/*
   Resultado:
   
   data_convertida | 2023-12-31
   data_extensa    | 2023-12-25
   data_hora       | 2024-10-05 14:30:00
   
   PERCEBA: O MySQL entendeu o formato brasileiro (dia/mês/ano)
   e converteu para o formato interno (YYYY-MM-DD)!
*/

-- ========================================================================
-- 2. DATE() - Extraindo só a DATA de um DATETIME
-- ========================================================================

/*
   DATE(datetime) → remove a hora e mantém só a data
   
   Muito útil quando você tem um DATETIME mas só quer a data.
*/

SELECT
    NOW()              AS datetime_completo,   -- 2024-10-05 14:30:45
    DATE(NOW())        AS so_data,             -- 2024-10-05
    TIME(NOW())        AS so_hora;             -- 14:30:45

/*
   Resultado:
   
   datetime_completo    | so_data    | so_hora
   ---------------------+------------+----------
   2024-10-05 14:30:45  | 2024-10-05 | 14:30:45
   
   DICA: DATE() é como se fosse um "extrator de data"
         TIME() é como se fosse um "extrator de hora"
*/

-- ========================================================================
-- 3. CONVERT e CAST - Convertendo entre tipos
-- ========================================================================

/*
   CONVERT(valor, tipo_destino)
   CAST(valor AS tipo_destino)
   
   Ambos fazem a MESMA coisa: convertem um valor para outro tipo.
   CONVERT é MySQL, CAST é padrão SQL.
*/

SELECT
    -- Convertendo string para DATE
    CONVERT('2023-12-31', DATE) AS com_convert,
    CAST('2023-12-31' AS DATE)  AS com_cast,

    -- Convertendo string para DATETIME
    CONVERT('2023-12-31 14:30:00', DATETIME) AS datetime_convert,
    CAST('2023-12-31 14:30:00' AS DATETIME)  AS datetime_cast,

    -- Convertendo número para texto
    CONVERT(2024, CHAR) AS numero_para_texto;

/*
   Resultado:
   
   com_convert  | com_cast    | datetime_convert    | datetime_cast      | numero_para_texto
   -------------+-------------+---------------------+--------------------+------------------
   2023-12-31   | 2023-12-31  | 2023-12-31 14:30:00 | 2023-12-31 14:30:00| 2024
   
   PERCEBA: CONVERT e CAST deram o MESMO resultado.
   Use CONVERT (MySQL) ou CAST (padrão SQL), os dois funcionam.
*/

-- ========================================================================
-- 4. RESUMO - Quando usar cada função de conversão
-- ========================================================================

/*
   Função          | Quando usar                          | Exemplo
   ----------------+---------------------------------------+--------------------------
   STR_TO_DATE()   | String em formato DIFERENTE do MySQL  | '31/12/2023' → DATE
   DATE()          | Tem DATETIME mas quer só a DATA       | '2024-10-05 14:30' → '2024-10-05'
   TIME()          | Tem DATETIME mas quer só a HORA       | '2024-10-05 14:30' → '14:30:00'
   CONVERT()       | Converter entre tipos genéricos       | '2023-12-31' → DATE
   CAST()          | Mesmo que CONVERT, padrão SQL         | '2023-12-31' → DATE
*/

-- ========================================================================
-- FIM
-- ========================================================================