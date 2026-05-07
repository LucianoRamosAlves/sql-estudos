USE weather;

-- sempre limpo a tabela antes de carregar novos dados
DELETE FROM current_weather_load;

-- carrego os dados, peque essse arquivo para
LOAD DATA INFILE '/var/lib/mysql-files/weather.csv'
-- essa tabela
INTO TABLE current_weather_load

-- as colunas separadas por vírgula
FIELDS TERMINATED BY ','

-- ordem das colunas
(station_id,
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
    station_id,
    ': ',
    station_city,
    ', ',
    station_state
)
FROM current_weather cw
WHERE cw.station_id NOT IN (
    SELECT cwl.station_id
    FROM current_weather_load cwl
);