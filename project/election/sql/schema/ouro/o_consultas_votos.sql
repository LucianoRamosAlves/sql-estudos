-- =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
-- votos
-- =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
-- contriindo eleiror
-- =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

use election;

select * from prata_votos;
select * from prata_candidatos;
SELECT * FROM prata_cargos;

SELECT 
titulo_eleitor,
eleitor AS nome,
sexo,
cidade
FROM prata_votos;


-- consulta cargos

/*
 cargo_id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100),
    esfera VARCHAR(20),
    vagas INT,
    status_cargo VARCHAR(20),*/


SELECT 
nome_cargo,
esfera,
vagas,
status_vagas
FROM prata_cargos;


-- consulta candidatos

/*
  candidato_id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    partido VARCHAR(10) NOT NULL,
    idade TINYINT UNSIGNED,
    cidade VARCHAR(50),
    status_elegibilidade VARCHAR(20),
    info_elegibilidade VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
*/


select 
nome,
partido,
idade,
cidade,
status_elegibilidade,
motivo_elegibilidade
from prata_candidatos p
INNER JOIN ouro_cargos 
on cargo_id = cargo_id
where idade >= 0;

desc prata_candidatos


/*
    voto_id INT AUTO_INCREMENT PRIMARY KEY,
    status_voto VARCHAR(20),
    data_voto DATE NOT NULL,
    hora_voto TIME NOT NULL,
    cidade VARCHAR(50),
    eleitor_id INT NOT NULL,
    candidato_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (eleitor_id) REFERENCES ouro_eleitor(eleitor_id),
    FOREIGN KEY (candidato_id) REFERENCES ouro_candidatos(candidato_id)*/
SELECT 
pv.status_votos,
pv.data_voto,
pv.hora_voto,
pv.cidade,
oe.titulo_eleitor,
oc.candidato_id

FROM prata_votos pv
INNER JOIN ouro_eleitor oe
ON pv.titulo_eleitor = oe.titulo_eleitor
INNER JOIN ouro_candidatos oc
ON pv.candidato_id = oc.candidato_id

desc prata_votos