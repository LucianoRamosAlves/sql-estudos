/* aqui eu vou juntar tabelas que tem alguma coisa igual, seja cahves, id, codigos, etc.

pego uma coisa que tem em A e em B, sejam iguai

INNER JOIN */


select 
	pe.id, -- nesse campo eu falo o que vai jungtar e aparecer na tabela
    pe.nome,
    pe.sexo,
    pr.nome,
    pr.preco
from pessoas as pe -- aqui eu só personalozei o nome para não ter que repitir nome grande
inner join produto as pr
on pe.id = pr.id -- condição de id igual, nesse caso