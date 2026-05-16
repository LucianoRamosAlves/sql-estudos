
SELECT * FROM prata_cargos;

INSERT INTO prata_cargos(
    nome_cargo,
    esfera,
    vagas,
    status_vagas,
    ano_eleicao
)


SELECT 
    UPPER(TRIM(nome_cargo)) AS nome_cargo,
    UPPER(TRIM(esfera)) AS esfera,
    CASE WHEN vagas = NULL THEN 0 ELSE vagas END AS vagas,
    CASE WHEN vagas = 0 THEN 'INDISPONIVEL'
    ELSE 'DISPONIVEL'
    END AS status_vagas,
    CASE WHEN ano_eleicao != 2026 THEN '2026' 
    ELSE ano_eleicao
    END AS ano_eleicao

FROM (

    SELECT *,

           ROW_NUMBER() OVER(
               PARTITION BY
                   UPPER(TRIM(nome_cargo)),
                   UPPER(TRIM(esfera))
               ORDER BY vagas ASC
           ) AS flag_last

    FROM bronze_cargos

    WHERE ano_eleicao <= YEAR(CURDATE())

) t

WHERE flag_last = 1
AND nome_cargo != ''
AND esfera != '';