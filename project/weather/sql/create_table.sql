USE weather;

SELECT DATABASE();

SHOW VARIABLES LIKE 'secure_file_priv';

-- ativo o modo segurança, tenho que confirmar as mudanças
-- para maior praticidade nos estudos, deixei o autocommit ligado
SET AUTOCOMMIT = ON;

CREATE TABLE IF NOT EXISTS current_weather_load(
    station_id INT PRIMARY KEY AUTO_INCREMENT, -- id da estacao
    station_city VARCHAR(100) NOT NULL, -- cidade da estacao
    station_state CHAR(2), -- estado da estacao
    station_lat DECIMAL(6,4) NOT NULL, -- latitude
    station_lon DECIMAL(7,4) NOT NULL, -- longitude
    as_of_date DATETIME , -- data e hora da leitura na coleta
    temp INT NOT NULL, -- temperatura
    feels_like INT NOT NULL, -- sensacao termica
    wind_speed INT NOT NULL, -- velocidade do vento
    wind_direction VARCHAR(3), -- direcao do vento
    precipitation DECIMAL(3,1), -- precipitacao
    pressure DECIMAL(6,2), -- pressao atmosferica
    visibility DECIMAL(3,1) NOT NULL, -- visibilidade
    humidity INT, -- umidade
    weather_description VARCHAR(100) NOT NULL, -- descricao do clima
    sunrise TIME, -- hora do sol
    sunset  TIME, -- hora da lua

    -- algumas varidações de dados
    CONSTRAINT CHECK(station_lon BETWEEN -180 AND 180),
    CONSTRAINT CHECK(station_lat BETWEEN -90 AND 90),
    CONSTRAINT CHECK(feels_like BETWEEN -30 AND 170),
    CONSTRAINT CHECK(temp BETWEEN -30 AND 170),
    CONSTRAINT CHECK(wind_speed BETWEEN 0 AND 300),
    CONSTRAINT CHECK(wind_direction IN ('N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW')),
    CONSTRAINT CHECK(station_state IN ('AC', 'AL', 'AP', 'AM', 'BA', 'CE', 'DF', 'ES', 'GO', 'MA', 'MT', 'MS', 'MG', 'PA', 'PB', 'PR', 'PE', 'PI', 'RJ', 'RN', 'RS', 'RO', 'RR', 'SC', 'SP', 'SE', 'TO')),
    CONSTRAINT CHECK(precipitation BETWEEN 0 AND 400),
    CONSTRAINT CHECK(pressure BETWEEN 0 AND 1100),
    CONSTRAINT CHECK(visibility BETWEEN 0 AND 20),
    CONSTRAINT CHECK(humidity BETWEEN 0 AND 100)
);

-- COMMIT;

-- verifico a estrutura da tabela
DESC current_weather_load;

-- crio uma tabela com o mesmo esquema
CREATE TABLE current_weather LIKE current_weather_load;



