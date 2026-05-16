USE election;
-- -----------------------------
-- -------- PARTE prata -------
-- -----------------------------

CREATE TABLE IF NOT EXISTS prata_votos(
    titulo_eleitor VARCHAR(20),
    candidato_id INT,
    status_votos VARCHAR(20),
    eleitor VARCHAR(100),
    sexo VARCHAR(50),
    cidade VARCHAR(100),
    data_voto VARCHAR(30),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE IF NOT EXISTS prata_candidatos(
    candidato_id INT,
    nome VARCHAR(100),
    partido VARCHAR(100),
    cargo VARCHAR(100),
    cidade VARCHAR(100),
    idade INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);



CREATE TABLE IF NOT EXISTS prata_cargos(
    cargo_id INT,
    nome_cargo VARCHAR(100),
    esfera VARCHAR(100),
    vagas INT,
    ano_eleicao VARCHAR(30),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- confirmar tabelas criadas
SHOW TABLES;

SELECT * FROM prata_cargos;
SELECT * FROM prata_votos;
select * from prata_candidatos;