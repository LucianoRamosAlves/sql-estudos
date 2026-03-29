/* quando eu quero todos os dados de uma tabela com todos os dados que tem o id iguual
se na gtabela A for clinetes e na B por produtos, além de eu oegar todos com o id iguais, pego tudo da tabela B*/



select 
	pe.id,
    pe.nome,
    pe.sexo,
    pr.nome,
    pr.preco
from pessoas as pe
right join produto as pr 
on pe.id = pr.id



-- aqui eu junto tudo


select *
from pessoas
left join produto on pessoas.id = produto.id

union

select *
from pessoas
right join produto on pessoas.id = produto.id

