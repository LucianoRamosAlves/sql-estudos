-- consultas de tratamento


USE weather;

-- aaqui vou verifica as qualidades da minha tabela
DESCRIBE current_weather_load;

-- vejo se tem duplicatas ou linhas nulas
SELECT station_id, 
COUNT(*) AS total
FROM current_weather_load
GROUP BY station_id
HAVING total > 1 OR station_id IS NULL;

-- caso haja duplicatas, ou linhas nulas e vou classificar pelo mais recente, pois vou optar em manter o mais recente
SELECT *,
ROW_NUMBER() OVER (
    PARTITION BY station_id
    ORDER BY as_of_date DESC
) AS flag_last
FROM current_weather_load


-- veja que aparecu flag_last = 1, ou seja, o mais recente
-- se tiver 2 significa que tem duplicatas, já é repitido


-- pego tudo que tem flag_last = 1
-- ou seja, o mais recente, não tem duplicatas ou se tem são recentes
SELECT * 

FROM (
    SELECT *,
ROW_NUMBER() OVER (
    PARTITION BY station_id
    ORDER BY as_of_date DESC
    ) AS flag_last
    FROM current_weather_load
) t WHERE flag_last = 1


-- aqui eu pego flag_last diferente de 1, ou seja, ja tem duplicatas
SELECT * 
FROM (
    SELECT *,
ROW_NUMBER() OVER (
    PARTITION BY station_id
    ORDER BY as_of_date DESC
    ) AS flag_last
    FROM current_weather_load
) t WHERE flag_last != 1

-- aqui pego as tabelas não limpas, ou seja, tem espaços no inicio e no fim
select station_city
from current_weather_load
where station_city != trim(station_city);

-- analiso todas as colunas


-- pego as colunas e so uso aonde tem espaco no inicio ou no fim
select
station_id,
trim(station_city) as station_city,
station_state,
wind_direction,
weather_description
from current_weather_load

-- veja que agora temos algun valores restritos e vamos verificar eles, tipo uma tabela aceitar F ou M, generos

-- temos algumas colunas com valores restritos
SELECT DISTINCT wind_direction
FROM current_weather_load

SELECT DISTINCT station_state
FROM current_weather_load


-- agora digamos que eu quero pegar as temperaturas que estao abaixo de 0 ou nulas
select temp
from current_weather_load
where temp < 0 or temp is null;

select * from current_weather_load;


