
select
nome,
nascimento,
day(nascimento) dia,
month(nascimento) mes,
year(nascimento) ano,
dayofweek(nascimento) n_semana
from pessoas



-- pego os nome da data
select
nome,
nascimento,
date_format(nascimento, '%W') dia,
date_format(nascimento, '%M') mes
from pessoas


-- pego partes do atual
select year(now());
select month(now());
select day(now());
select hour(now());
select minute(now());
select dayofweek(now()); -- retorna a semana --

select
year(nascimento),
count(*) quantidade_ano
from pessoas
group by year(nascimento)

select
date_format(nascimento, '%M'),
count(*) quantidade_mes
from pessoas
group by date_format(nascimento, '%M')

