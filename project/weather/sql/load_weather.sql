USE weather;

-- sempre limpo a tabela antes de carregar novos dados
TRUNCATE table current_weather_load;
/* fluxo , no terminal conectar assim   -->    mysql --local-infile=1 -u root -p
verifica tem que esta on
SHOW VARIABLES LIKE 'local_infile';
 
caso nao esteja
 SET GLOBAL local_infile = on;

depois roda o arquivo sql SOURCE C:/Users/lramo/OneDrive/Documentos/Estudos/sql-estudos/project/load_weather.sql;

*/

select * FROM current_weather_load;

-- carrego os dados, peque essse arquivo para
LOAD DATA LOCAL INFILE 'C:/Users/lramo/OneDrive/Documentos/Estudos/sql-estudos/project/weather/data/weather.csv'
INTO TABLE current_weather_load

-- as colunas separadas por vírgula
FIELDS TERMINATED BY ','

ENCLOSED BY '"'


-- as linhas separadas por quebra de linha
LINES TERMINATED BY '\r\n'


-- ignorar a primeira linha
IGNORE 1 ROWS

-- ordem das colunas
(
station_city,
station_state,
station_lat,
station_lon,
@oad, -- isso pq o campo as_of_date tem um formato date
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

-- data no formato string
SET as_of_date = STR_TO_DATE(@oad, '%Y/%m/%d %H:%i');

SHOW WARNINGS; -- isto mostra os erros

-- baseado nas linhas carregadas, informo quais dados não foram carregados
SELECT CONCAT(
    'Não foram carregados ',
    cwl.station_id,
    ': ',
    cwl.station_city,
    ', ',
    cwl.station_state
)
FROM current_weather_load cwl
WHERE cwl.station_id NOT IN (
    SELECT cw.station_id
    FROM current_weather cw
);