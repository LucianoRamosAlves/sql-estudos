USE weather;


-- =========================================================
-- REMOVE PROCEDURE ANTIGA
-- =========================================================
DROP PROCEDURE IF EXISTS prc_load_current_weather;

DELIMITER $$

CREATE PROCEDURE prc_load_current_weather()

BEGIN

    -- =====================================================
    -- VARIÁVEIS DE CONTROLE
    -- =====================================================

    -- armazena horário inicial
    DECLARE v_start DATETIME;

    -- armazena horário final
    DECLARE v_end DATETIME;

    -- armazena tempo total em segundos
    DECLARE v_duration INT;

    -- quantidade de linhas inseridas
    DECLARE v_rows INT;


    -- =====================================================
    -- TRATAMENTO DE ERRO (TRY/CATCH MYSQL)
    -- =====================================================

    /*
        EXIT HANDLER funciona como um CATCH.

        Se QUALQUER ERRO SQL acontecer:
        -> desfaz tudo
        -> mostra mensagem
        -> encerra procedure
    */

    DECLARE EXIT HANDLER FOR SQLEXCEPTION

    BEGIN

        -- desfaz transação
        ROLLBACK;

        -- mostra mensagem de erro
        SELECT
            'ERRO AO EXECUTAR PROCEDURE' AS status,
            NOW() AS error_time;

    END;


    -- =====================================================
    -- INÍCIO CRONÔMETRO
    -- =====================================================

    SET v_start = NOW();


    -- =====================================================
    -- INÍCIO TRANSAÇÃO
    -- =====================================================

    /*
        Tudo será executado como bloco único.

        Se der erro:
        -> rollback

        Se funcionar:
        -> commit
    */

    START TRANSACTION;


    -- =====================================================
    -- LIMPA TABELA FINAL
    -- =====================================================

    TRUNCATE TABLE current_weather;


    -- =====================================================
    -- INSERT PRINCIPAL ETL
    -- =====================================================

    INSERT INTO current_weather
    (
        station_city,
        station_state,
        state_name,
        station_lat,
        station_lon,
        as_of_date,
        temp,
        cod_temp,
        feels_like,
        wind_speed,
        wind_direction,
        precipitation,
        pressure,
        cod_pressure,
        visibility,
        humidity,
        weather_description,
        sunrise,
        sunset,
        flag_last
    )

    SELECT

        -- =====================================================
        -- LIMPEZA DE TEXTO
        -- =====================================================

        CONCAT(
            UPPER(LEFT(TRIM(REPLACE(station_city, '  ', ' ')), 1)),
            LOWER(SUBSTRING(TRIM(REPLACE(station_city, '  ', ' ')), 2))
        ) AS station_city,


        -- =====================================================
        -- PADRONIZAÇÃO
        -- =====================================================

        UPPER(TRIM(station_state)) AS station_state,


        -- =====================================================
        -- DE -> PARA
        -- =====================================================

        CASE UPPER(TRIM(station_state))

            WHEN 'RJ' THEN 'Rio de Janeiro'
            WHEN 'SP' THEN 'Sao Paulo'
            WHEN 'MG' THEN 'Minas Gerais'
            WHEN 'ES' THEN 'Espirito Santo'
            WHEN 'PR' THEN 'Parana'
            WHEN 'SC' THEN 'Santa Catarina'
            WHEN 'RS' THEN 'Rio Grande do Sul'
            WHEN 'MS' THEN 'Mato Grosso do Sul'

            ELSE 'Estado Desconhecido'

        END AS state_name,


        -- =====================================================
        -- NULOS
        -- =====================================================

        IFNULL(station_lat, 0) AS station_lat,
        IFNULL(station_lon, 0) AS station_lon,


        -- =====================================================
        -- DATA
        -- =====================================================

        DATE(as_of_date) AS as_of_date,


        -- =====================================================
        -- ARREDONDAMENTO
        -- =====================================================

        ROUND(temp, 1) AS temp,


        -- =====================================================
        -- CLASSIFICAÇÃO
        -- =====================================================

        CASE

            WHEN temp >= 35 THEN 'Muito Quente'
            WHEN temp >= 25 THEN 'Quente'
            WHEN temp >= 15 THEN 'Agradavel'
            WHEN temp >= 5 THEN 'Frio'

            ELSE 'Muito Frio'

        END AS cod_temp,


        -- =====================================================
        -- TRATAMENTO VALORES INVÁLIDOS
        -- =====================================================

        CASE

            WHEN feels_like < -50 THEN NULL
            ELSE ROUND(feels_like, 1)

        END AS feels_like,


        -- =====================================================
        -- PADRÃO
        -- =====================================================

        IFNULL(wind_speed, 0) AS wind_speed,


        -- =====================================================
        -- TEXTO
        -- =====================================================

        IFNULL(UPPER(TRIM(wind_direction)), 'N/A') AS wind_direction,


        -- =====================================================
        -- OUTLIERS
        -- =====================================================

        CASE

            WHEN precipitation > 1000 THEN NULL
            ELSE IFNULL(precipitation, 0)

        END AS precipitation,


        -- =====================================================
        -- STRING
        -- =====================================================

        REPLACE(pressure, 'hPa', '') AS pressure,


        -- =====================================================
        -- EXTRAÇÃO
        -- =====================================================

        LEFT(pressure, 5) AS cod_pressure,


        -- =====================================================
        -- REGRAS NEGÓCIO
        -- =====================================================

        CASE

            WHEN visibility < 0 THEN 0
            WHEN visibility > 10000 THEN 10000

            ELSE visibility

        END AS visibility,


        -- =====================================================
        -- LIMITES
        -- =====================================================

        CASE

            WHEN humidity > 100 THEN 100
            WHEN humidity < 0 THEN 0

            ELSE humidity

        END AS humidity,


        -- =====================================================
        -- CAPITALIZAÇÃO
        -- =====================================================

        CONCAT(

            UPPER(LEFT(TRIM(weather_description), 1)),
            LOWER(SUBSTRING(TRIM(weather_description), 2))

        ) AS weather_description,


        -- =====================================================
        -- DATETIME
        -- =====================================================

        TIME(sunrise) AS sunrise,
        TIME(sunset) AS sunset,


        -- =====================================================
        -- FLAG
        -- =====================================================

        flag_last


    FROM (

        SELECT *,

            -- =================================================
            -- WINDOW FUNCTION
            -- =================================================

            ROW_NUMBER() OVER (

                PARTITION BY station_id
                ORDER BY as_of_date DESC

            ) AS flag_last

        FROM current_weather_load

    ) t


    -- =========================================================
    -- FILTROS
    -- =========================================================

    WHERE flag_last = 1
    AND station_city IS NOT NULL
    AND temp BETWEEN -20 AND 60
    AND station_state IS NOT NULL;


    -- =====================================================
    -- CAPTURA LINHAS INSERIDAS
    -- =====================================================

    SET v_rows = ROW_COUNT();


    -- =====================================================
    -- FINALIZA TRANSAÇÃO
    -- =====================================================

    COMMIT;


    -- =====================================================
    -- FINALIZA CRONÔMETRO
    -- =====================================================

    SET v_end = NOW();

    SET v_duration = TIMESTAMPDIFF(SECOND, v_start, v_end);


    -- =====================================================
    -- LOG FINAL
    -- =====================================================

    SELECT

        'PROCESSO EXECUTADO COM SUCESSO' AS status,
        v_rows AS linhas_inseridas,
        v_start AS inicio,
        v_end AS fim,
        CONCAT(v_duration, ' segundos') AS tempo_execucao;

END $$

DELIMITER ;