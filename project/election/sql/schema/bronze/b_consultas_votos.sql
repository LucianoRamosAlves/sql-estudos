
-- aqui vamos fazer algumas consultas de tratamento

USE election;

-- primeiro vamos analisar a tabela de votos
SELECT * FROM bronze_votos;

-- vamos verificar se tem duplicatas
SELECT
titulo_eleitor,
COUNT(*)
FROM bronze_votos
GROUP BY titulo_eleitor
HAVING COUNT(*) > 1 or titulo_eleitor IS NULL;


USE election;


-- (1) verificamos que tem duplicdas no titulo eleitor, agora vamos pegar apenas um comecando pelp id,
-- tenho que esclher 1, e o criterio vai ser o mais recente, ou seja, o mais recente vai ser o que aparece primeiro na tabela
select *,
-- (2) vamos pegar o mais recente
ROW_NUMBER() OVER(PARTITION BY titulo_eleitor ORDER BY data_voto DESC) AS flag_last
FROM bronze_votos
WHERE titulo_eleitor = '553369732191';

-- aqui eu vejo todos, se tiver mais de 1, significa que tem duplicatas e vou pegar o mais recente
select *,
ROW_NUMBER() OVER(PARTITION BY titulo_eleitor ORDER BY data_voto DESC) AS flag_last
FROM bronze_votos



--  aqui eu pego os que tem duplicatas
SELECT * 
FROM(
    select *,
    ROW_NUMBER() OVER(PARTITION BY titulo_eleitor ORDER BY data_voto DESC) AS flag_last
    FROM bronze_votos
)
t WHERE flag_last != 1




-- VAMOS TRATAR OS VALORES TEXTO,, OLHAR TODOOS E VER QUAL TEM ESPACO AO INICIO E FIM

-- agora é o espaço
-- tem espaco ao inicio
SELECT eleitor
from bronze_votos
where eleitor != trim(eleitor);

-- agora é o espaço
-- NO DATA.. NAO TEM ESPACO AO INICIO
SELECT sexo
from bronze_votos
where sexo != trim(sexo);

-- agora é o espaço
-- NO DATA.. NAO TEM ESPACO AO INICIO
SELECT cidade
from bronze_votos
where cidade != trim(cidade);

-- sexo possui valores restritos M/F
-- eleitor nao possui restricoes
-- cidade nao possui restricoes

SELECT DISTINCT sexo
from bronze_votos

-- agora vou verificar os votos que não tem prata_candidatos

SELECT *
FROM bronze_votos
WHERE candidato_id NOT IN (SELECT candidato_id FROM bronze_candidatos);







