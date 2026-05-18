CREATE VIEW vw_resumo_votos AS
SELECT

    (SELECT COUNT(*)
     FROM ouro_votos) AS total_votos,

    (SELECT COUNT(*)
     FROM ouro_votos
     WHERE status_voto = 'VALIDO') AS votos_validos,

    (SELECT COUNT(*)
     FROM ouro_votos
     WHERE status_voto = 'NULO') AS votos_nulos;


select * from vw_resumo_votos;

select * from ouro_votos;



CREATE VIEW vw_ranking_candidatos AS

SELECT

    c.nome,
    c.partido,
    COUNT(v.voto_id) AS total_votos

FROM ouro_votos v

INNER JOIN ouro_candidatos c
    ON v.candidato_id = c.candidato_id

GROUP BY c.nome

ORDER BY total_votos DESC;