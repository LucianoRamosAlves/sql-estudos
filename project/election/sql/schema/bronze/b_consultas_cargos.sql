USE election;

SELECT *
from bronze_cargos;

SELECT *
from bronze_candidatos;

select DISTINCT UPPER(TRIM(nome_cargo)) AS cargo_limpo,
count(*)
from bronze_cargos
group by cargo_limpo;

SELECT DISTINCT
    UPPER(TRIM(nome_cargo)) AS nome_cargo,
    UPPER(TRIM(esfera)) AS esfera
FROM bronze_cargos;

SELECT DISTINCT
    UPPER(TRIM(nome_cargo)) AS nome_cargo,
    UPPER(TRIM(esfera)) AS esfera
FROM(
    select *,
    ROW_NUMBER() OVER(PARTITION BY nome_cargo ORDER BY ano_eleicao DESC) AS flag_last
    FROM bronze_cargos
)
t WHERE flag_last = 1
AND (nome_cargo != '' AND esfera != '');



SELECT DISTINCT
    UPPER(TRIM(nome_cargo)) AS nome_cargo,
    UPPER(TRIM(esfera)) AS esfera

FROM (

    SELECT *,

           ROW_NUMBER() OVER(
               PARTITION BY
                   UPPER(TRIM(nome_cargo)),
                   UPPER(TRIM(esfera))
               ORDER BY vagas DESC
           ) AS flag_last

    FROM bronze_cargos

    WHERE ano_eleicao <= YEAR(CURDATE())

) t

WHERE flag_last = 1
AND nome_cargo != ''
AND esfera != '';


SELECT
    nome_cargo,
    esfera,
    vagas,
    ano_eleicao,
    COUNT(*)

FROM bronze_cargos

GROUP BY
    nome_cargo,
    esfera,
    vagas,
    ano_eleicao;





SELECT
cargo_id,
COUNT(*)
FROM bronze_cargos
GROUP BY cargo_id
HAVING COUNT(*) = 1 or cargo_id IS NULL;

select nome_cargo,
esfera,
count(*)
FROM bronze_cargos
WHERE nome_cargo = 'Deputado Estadual'
AND esfera = 'Estadual';



