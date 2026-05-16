INSERT INTO prata_candidatos(
    candidato_id,
    nome,
    status_elegibilidade,
    partido,
    cargo,
    cidade,
    idade
)
SELECT 
candidato_id,
CASE WHEN UPPER(TRIM(nome)) = '' 
OR UPPER(TRIM(nome)) IS NULL
THEN 'Desconhecido' ELSE UPPER(TRIM(nome)) END AS nome,
CASE WHEN UPPER(TRIM(nome)) = ''
OR idade > 60  THEN 'Inelegivel' 
ELSE 'Elegivel' END AS status_elegibilidade,
UPPER(TRIM(partido)) AS partido,
TRIM(cargo) AS cargo,
CASE WHEN UPPER(TRIM(cidade)) IS NULL THEN 'N/A' ELSE UPPER(TRIM(cidade)) END AS cidade,
idade
FROM(
    select *,
    ROW_NUMBER() OVER(PARTITION BY candidato_id ORDER BY candidato_id DESC) AS flag_last
    FROM bronze_candidatos
)
t WHERE flag_last = 1
ORDER BY nome DESC;

truncate table prata_candidatos