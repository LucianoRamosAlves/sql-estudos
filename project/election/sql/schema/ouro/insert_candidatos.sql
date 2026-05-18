
INSERT INTO ouro_candidatos(
    nome,
    partido,
    cargo_id,
    idade,
    cidade,
    status_elegibilidade,
    info_elegibilidade
)


select 
p.nome,
p.partido,
p.cargo_id,
p.idade,
p.cidade,
p.status_elegibilidade,
p.motivo_elegibilidade
from prata_candidatos p
INNER JOIN ouro_cargos o
ON p.cargo_id = o.cargo_id
where idade >= 0;


SELECT * from ouro_candidatos
order by candidato_id;