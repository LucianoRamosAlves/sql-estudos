
INSERT INTO ouro_eleitor(
    titulo_eleitor,
    nome,
    sexo,
    cidade
)


SELECT 
titulo_eleitor,
eleitor AS nome,
sexo,
cidade
FROM prata_votos;
