insert into ouro_votos(
    status_voto,
    data_voto,
    hora_voto,
    cidade,
    titulo_eleitor,
    candidato_id
)

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

