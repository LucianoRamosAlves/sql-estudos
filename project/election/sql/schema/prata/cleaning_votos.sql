USE election;
--  aqui eu pego os que nao tem duplicatas

INSERT INTO prata_votos(
titulo_eleitor, 
candidato_id,
status_votos,
eleitor, 
sexo, 
cidade, 
data_voto
)

SELECT 
titulo_eleitor,
candidato_id,
CASE
WHEN candidato_id IN (
    SELECT candidato_id 
    FROM bronze_candidatos) THEN 'VALIDO'
    ELSE 'NULO'
END AS status_votos,
TRIM(eleitor) as eleitor,
CASE
WHEN UPPER(TRIM(sexo)) IN ('M', 'MASC', 'masculino') THEN 'MASCULINO'
WHEN UPPER(TRIM(sexo)) IN ('F', 'FEM', 'feminino') THEN 'FEMININO'
ELSE 'N/A'
END AS sexo,
cidade,
data_voto
FROM(
    select *,
    ROW_NUMBER() OVER(PARTITION BY titulo_eleitor ORDER BY data_voto DESC) AS flag_last
    FROM bronze_votos
)
t WHERE flag_last = 1 AND ((titulo_eleitor IS NOT NULL) 
AND (titulo_eleitor != ''));

SELECT * FROM prata_votos

