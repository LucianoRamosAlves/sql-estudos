select -- aqui eu seleciono a coluna
sexo,
sum(peso) -- se sexo for igual, ele pega os peso e soma
from pessoas
group by sexo -- ele basicamente, soma os peso de sexo iguais

select
sexo,
nome,
sum(peso) 
from pessoas
group by sexo , nome -- aqui eu adciono outras informação na tabela

select
sexo,
count(sexo), -- aqui eu conto as quantidades
sum(peso) 
from pessoas
group by sexo

-- DISTINCT: Remove linhas duplicadas
select distinct sexo from pessoas;

-- ORDER BY: Ordena resultados (ASC = crescente, DESC = decrescente)
select sexo, nome from pessoas order by nome asc;
select sexo, nome from pessoas order by nome desc;

-- LIMIT: Limita número de linhas retornadas
select * from pessoas limit 10;
select * from pessoas limit 5 offset 10; -- pula 10 e pega 5

-- WHERE: Filtra linhas antes do agrupamento
select sexo, sum(peso) from pessoas where idade > 18 group by sexo;

-- HAVING: Filtra grupos após agrupamento (usa-se com GROUP BY)
select sexo, count(*) from pessoas group by sexo having count(*) > 2;

-- CASE: Condição dentro do SELECT
select nome, case when peso > 70 then 'Pesado' else 'Leve' end as categoria from pessoas;

-- JOIN: Combina dados de múltiplas tabelas
select p.nome, e.empresa from pessoas p join empresas e on p.id = e.pessoa_id;

-- UNION: Combina resultados de múltiplos SELECTs
select nome from pessoas where sexo = 'M' union select nome from pessoas where sexo = 'F';

-- Operadores de comparação
select * from pessoas where peso between 60 and 80;
select * from pessoas where nome like 'J%'; -- começa com J
select * from pessoas where sexo in ('M', 'F');