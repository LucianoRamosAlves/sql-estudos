
-- seleciona o banco de dados que será utilizado
USE weather;

 --   -------------------------------------------------------------------
    -- INÍCIO DO PROCESSO
 --   -------------------------------------------------------------------

    -- mensagem informando início da limpeza
    SELECT 'Limpando tabela...';

    -- remove todos os dados antigos da tabela staging
    -- staging table = tabela temporária de carga
    TRUNCATE TABLE current_weather_load;

 --   -------------------------------------------------------------------
    -- CARGA DO CSV
 --   -------------------------------------------------------------------

    -- mensagem informando início da carga
    SELECT 'Carregando CSV...';

    -- carrega os dados do arquivo csv
    -- LOCAL = arquivo localizado na máquina cliente
    LOAD DATA LOCAL INFILE 
    'C:/Users/lramo/OneDrive/Documentos/Estudos/sql-estudos/project/weather/data/weather.csv'

    -- tabela que receberá os dados
    INTO TABLE current_weather_load

--    -------------------------------------------------------------------
    -- CONFIGURAÇÃO DO CSV
  --  -------------------------------------------------------------------

    -- colunas separadas por vírgula
    FIELDS TERMINATED BY ','

    -- textos envolvidos por aspas
    ENCLOSED BY '"'

    -- quebra de linha do Windows
    LINES TERMINATED BY '\r\n'

--    -------------------------------------------------------------------
    -- IGNORA CABEÇALHO
 --   -------------------------------------------------------------------

    -- ignora a primeira linha do arquivo csv
    IGNORE 1 ROWS

 --   -------------------------------------------------------------------
    -- MAPEAMENTO DAS COLUNAS
 --   -------------------------------------------------------------------

    -- ordem das colunas do csv
    (
        station_city,
        station_state,
        station_lat,
        station_lon,

        -- variável temporária
        -- usada porque a data vem como texto
        @oad,

        temp,
        feels_like,
        wind_speed,
        wind_direction,
        precipitation,
        pressure,
        visibility,
        humidity,
        weather_description,
        sunrise,
        sunset
    )

 --   -------------------------------------------------------------------
    -- TRANSFORMAÇÃO DE DADOS
 --   -------------------------------------------------------------------

    -- converte a string do csv para DATETIME
    -- formato esperado:
    -- 2025/05/10 14:30
    SET as_of_date = STR_TO_DATE(
        @oad,
        '%Y/%m/%d %H:%i'
    );

 --   -------------------------------------------------------------------
    -- FINALIZAÇÃO DA CARGA
 --   -------------------------------------------------------------------

    -- mensagem de sucesso
    SELECT 'CSV carregado com sucesso';

--    -------------------------------------------------------------------
    -- PROCESSAMENTO DOS DADOS
  --  -------------------------------------------------------------------
    --  >>>>>>POR HORA ISSO NÃO FAZ NADA<<<<<<<<


    -- chama outra procedure responsável por:
    -- validações
    -- verificações
    -- logs
    -- inserts finais
    -- CALL sp_current_load_weather();



  --  -------------------------------------------------------------------
    -- INÍCIO DO PROCESSAMENTO
 --   -------------------------------------------------------------------

    -- mensagem indicando início da procedure
    -- usado como log visual durante a execução
    SELECT 'Iniciando processo...';

  --  -------------------------------------------------------------------
    -- VERIFICAÇÃO DE AVISOS / DADOS NÃO PROCESSADOS
 --   -------------------------------------------------------------------

    -- mensagem indicando início da validação
    SELECT 'Carregando avisos...';

  --  -------------------------------------------------------------------
    -- VALIDAÇÃO DE DADOS
  --  -------------------------------------------------------------------

    -- esta consulta verifica registros presentes
    -- na tabela staging (current_weather_load)
    -- que NÃO existem na tabela final (current_weather)
    
    -- isso ajuda a identificar:
    -- dados não carregados
    -- inconsistências
    -- problemas de relacionamento
    -- falhas de processamento

    SELECT CONCAT(

        -- texto inicial da mensagem
        'Não foram carregados ',

        -- id da estação
        cwl.station_id,

        -- separador
        ': ',

        -- cidade
        cwl.station_city,

        -- separador
        ', ',

        -- estado
        cwl.station_state

    )

    -- alias da tabela staging
    FROM current_weather_load cwl

    -- verifica quais registros NÃO existem
    -- na tabela final current_weather
    WHERE cwl.station_id NOT IN (

        -- busca os ids existentes
        SELECT cw.station_id
        FROM current_weather cw

    );

  --  -------------------------------------------------------------------
    -- QUANTIDADE TOTAL DE LINHAS
  --  -------------------------------------------------------------------

    -- chama a função responsável por:
    -- contar linhas carregadas
    -- retornar mensagem formatada
    
    -- exemplo:
    -- Foram carregadas 523 linhas

    SELECT fn_total_linhas_carregadas();

 --   -------------------------------------------------------------------
    -- FINALIZAÇÃO DO PROCESSAMENTO
 --   -------------------------------------------------------------------

    -- mensagem final indicando sucesso
    SELECT 'OK';
