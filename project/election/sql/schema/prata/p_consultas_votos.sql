USE election;


-- aqui eu só pego as consultas da bronze verifico aqui
-- copio b_consultas_votos.sql
select *,
ROW_NUMBER() OVER(PARTITION BY titulo_eleitor ORDER BY data_voto DESC) AS flag_last
FROM prata_votos
WHERE titulo_eleitor = '553369732191';


select *,
ROW_NUMBER() OVER(PARTITION BY titulo_eleitor ORDER BY data_voto DESC) AS flag_last
FROM prata_votos



SELECT * 
FROM(
    select *,
    ROW_NUMBER() OVER(PARTITION BY titulo_eleitor ORDER BY data_voto DESC) AS flag_last
    FROM prata_votos
)
t WHERE flag_last != 1


SELECT eleitor
from prata_votos
where eleitor != trim(eleitor);


SELECT sexo
from prata_votos
where sexo != trim(sexo);


SELECT cidade
from prata_votos
where cidade != trim(cidade);


SELECT DISTINCT sexo
from prata_votos


SELECT *
FROM prata_votos
WHERE candidato_id NOT IN (SELECT candidato_id FROM prata_candidatos);





