SELECT 
station_id,
trim(station_city) as station_city,
-- station_state,
CASE UPPER(TRIM(station_state))
    WHEN 'RJ' THEN 'Rio de Janeiro' 
    WHEN 'SP' THEN 'Sao Paulo' 
    WHEN 'MG' THEN 'Minas Gerais' 
    WHEN 'ES' THEN 'Espirito Santo'
    WHEN 'PR' THEN 'Parana' 
    WHEN 'SC' THEN 'Santa Catarina'
    WHEN 'RS' THEN 'Rio Grande do Sul' 
    WHEN 'MS' THEN 'Mato Grosso do Sul'
    ELSE 'Outro Estado' 
    END as state_name,     
station_lat,
station_lon,
as_of_date,
temp,
ifnull(temp, 0) AS cod_temp,
feels_like,
wind_speed,
wind_direction,
precipitation,
pressure,
REPLACE(SUBSTRING(pressure, 1, 6), '.', '/') AS cod_pressure,
visibility,
humidity,
weather_description,
sunrise,
sunset

FROM (
    SELECT *,
ROW_NUMBER() OVER (
    PARTITION BY station_id
    ORDER BY as_of_date DESC
    ) AS flag_last
    FROM current_weather_load
) t WHERE flag_last = 1

select * from current_weather_load;