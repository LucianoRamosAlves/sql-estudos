USE election;

select * from prata_candidatos
order by candidato_id

select * from prata_cargos
;
-- veja qure tem chave segundaria..iremos ver se esta relacionda

select *
from prata_candidatos
where cargo in (select nome_cargo  from prata_cargos);

SELECT *
FROM(
    select *,
    ROW_NUMBER() OVER(PARTITION BY candidato_id ORDER BY idade DESC) AS flag_last
    FROM prata_candidatos
)
t WHERE flag_last = 1


SELECT * 
FROM(
    select *,
    ROW_NUMBER() OVER(PARTITION BY candidato_id ORDER BY candidato_id DESC) AS flag_last
    FROM prata_candidatos
)
t WHERE flag_last != 1


SELECT count(*) as total_candidatos_unicos
FROM(
    select *,
    ROW_NUMBER() OVER(PARTITION BY candidato_id ORDER BY idade DESC) AS flag_last
    FROM prata_candidatos
)
t WHERE flag_last = 1





SELECT count(*) as total_candidatos_sujos
FROM(
    select *,
    ROW_NUMBER() OVER(PARTITION BY candidato_id ORDER BY candidato_id DESC) AS flag_last
    FROM prata_candidatos
)
t WHERE flag_last != 1


SELECT
*
FROM(
    select *,
    ROW_NUMBER() OVER(PARTITION BY nome ORDER BY candidato_id DESC) AS flag_last
    FROM prata_candidatos
)
t WHERE flag_last = 1 AND nome = ''


SELECT
nome,
COUNT(*)
FROM prata_candidatos
GROUP BY nome
HAVING COUNT(*) > 1 or nome IS NULL;

select *
from prata_candidatos
where nome = ''




SELECT
candidato_id,
COUNT(*)
FROM prata_candidatos
GROUP BY candidato_id
HAVING COUNT(*) > 1 or candidato_id IS NULL;


SELECT DISTINCT cargo
FROM prata_candidatos


SELECT
partido,
COUNT(*)
FROM prata_candidatos
GROUP BY partido
HAVING COUNT(*) > 1 or partido IS NULL;


select cidade
from prata_candidatos
where cidade  is NULL;