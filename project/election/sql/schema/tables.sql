USE election;

-- -----------------------------
-- -------- PARTE BRONZE -------
-- -----------------------------

CREATE TABLE IF NOT EXISTS bronze_votos(
    titulo_eleitor INT,
    candidato_id INT,
    eleitor VARCHAR(100),
    sexo VARCHAR(50),
    cidade VARCHAR(100),
    data_voto DATETIME
);


CREATE TABLE IF NOT EXISTS bronze_candidatos(
    candidato_id INT,
    nome VARCHAR(100),
    partido VARCHAR(100),
    cargo VARCHAR(100),
    cidade VARCHAR(100),
    idade INT
);


CREATE TABLE IF NOT EXISTS bronze_cargos(
    cargo_id INT,
    nome_cargo VARCHAR(100),
    esfera VARCHAR(100),
    vagas INT,
    ano_eleicao DATE
);

-- confirmar tabelas criadas
SHOW TABLES;

SELECT * FROM bronze_cargos;
SELECT * FROM bronze_votos;
select * from bronze_candidatos;

SELECT *
FROM bronze_votos
LIMIT 5;