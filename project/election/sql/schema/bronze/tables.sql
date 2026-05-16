USE election;

-- -----------------------------
-- -------- PARTE BRONZE -------
-- -----------------------------

CREATE TABLE IF NOT EXISTS bronze_votos(
    titulo_eleitor VARCHAR(50),
    candidato_id INT,
    eleitor VARCHAR(100),
    sexo VARCHAR(50),
    cidade VARCHAR(100),
    data_voto VARCHAR(30)
);


CREATE TABLE IF NOT EXISTS bronze_candidatos(
    candidato_id INT,
    nome VARCHAR(100),
    partido VARCHAR(100),
    cargo_id INT,
    cidade VARCHAR(100),
    idade INT
);



CREATE TABLE IF NOT EXISTS bronze_cargos(
    cargo_id INT,
    nome_cargo VARCHAR(100),
    esfera VARCHAR(100),
    vagas INT,
    ano_eleicao VARCHAR(30)
);

-- confirmar tabelas criadas
SHOW TABLES;

SELECT * FROM bronze_cargos;
SELECT * FROM bronze_votos;
select * from bronze_candidatos;

SELECT *
FROM bronze_votos
LIMIT 10;


