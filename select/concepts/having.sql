

select
sexo,
count(sexo),
sum(peso) 
from pessoas
group by sexo
having sum(peso) > 100 -- usa isso, para filtrar depois eu agrupar se eu quizer filtar antes uso o where

