USE election;

CREATE TABLE IF NOT EXISTS ouro_eleitor(
    eleitor_id INT AUTO_INCREMENT PRIMARY KEY,
    titulo_eleitor BIGINT UNIQUE NOT NULL,
    nome VARCHAR(100),
    sexo VARCHAR(20),
    cidade VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE IF NOT EXISTS ouro_cargos(
    cargo_id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100),
    esfera VARCHAR(20),
    vagas INT,
    status_cargo VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS ouro_candidatos(
    candidato_id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    partido VARCHAR(10) NOT NULL,
    cargo_id INT NOT NULL,
    idade TINYINT UNSIGNED,
    cidade VARCHAR(50),
    status_elegibilidade VARCHAR(20),
    info_elegibilidade VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (cargo_id) REFERENCES ouro_cargos(cargo_id)
);

CREATE TABLE IF NOT EXISTS ouro_votos(
    voto_id INT AUTO_INCREMENT PRIMARY KEY,
    status_voto VARCHAR(20),
    data_voto DATE NOT NULL,
    hora_voto TIME NOT NULL,
    cidade VARCHAR(50),
    titulo_eleitor BIGINT NOT NULL,
    candidato_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (titulo_eleitor) REFERENCES ouro_eleitor(titulo_eleitor),
    FOREIGN KEY (candidato_id) REFERENCES ouro_candidatos(candidato_id)
);