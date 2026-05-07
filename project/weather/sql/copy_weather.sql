USE weather;

-- agora os dados limpos vem tabela oficial

TRUNCATE TABLE current_weather;

INSERT INTO current_weather
(station_id,
station_city,
station_state,
station_lat,
station_lon,
as_of_date,
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
SELECT
station_id,
station_city,
station_state,
station_lat,
station_lon,
as_of_date,
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
FROM current_weather_load;

-- pego os dados esta na parte FROM, pego os dados dessa tabela, SELECT seleciono quuais dados e coloco no insert, leia de baixo pra cima.


# BUG falta finalizaar a conecção com o banco