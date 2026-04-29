CREATE DATABASE police_db; -- cria o banco de dados

USE police_db;               -- seleciona o banco para trabalhar


CREATE TABLE location (
    location_id INT PRIMARY KEY,        -- id único da localização
    location_name VARCHAR(100)          -- nome do local
);


CREATE TABLE suspect (
    suspect_id INT PRIMARY KEY,         -- id do suspeito
    suspect_name VARCHAR(100)           -- nome do suspeito
);

CREATE TABLE crime (
    crime_id INT PRIMARY KEY,           -- id do crime
    location_id INT,                    -- ligação com location
    suspect_id INT,                     -- ligação com suspect (pode ser NULL)
    crime_name VARCHAR(100),            -- nome do crime

    FOREIGN KEY (location_id) REFERENCES location(location_id),
    FOREIGN KEY (suspect_id) REFERENCES suspect(suspect_id)
);

INSERT INTO location VALUES
(1, 'Corner of Main and Elm'),
(2, 'Family Donut Shop'),
(3, 'House of Vegan Restaurant');

INSERT INTO suspect VALUES
(1, 'Eileen Sideways'),
(2, 'Hugo Hefty');

INSERT INTO crime VALUES
(1, 1, 1, 'Jaywalking'),
(2, 2, 2, 'Larceny: Donut'),
(3, 3, NULL, 'Receiving Salad Under False Pretenses');

SELECT c.crime_name,        -- nome do crime
       l.location_name,     -- local do crime
       s.suspect_name       -- suspeito (se houver)

FROM crime c                -- tabela principal

JOIN location l             -- INNER → todo crime tem localização
ON c.location_id = l.location_id

LEFT JOIN suspect s         -- LEFT → pode não ter suspeito
ON c.suspect_id = s.suspect_id

WHERE s.suspect_name IS  NULL;   -- filtra crimes sem suspeito