-- aqui tenho que tomar cuidado para não mudar toda a tabela

update pessoas 
set nacionalidade = 'peru' -- só até aqui, ele vai mudar  todas as nacionalidades para peru
where id = 5 -- tem qwu tem essa condição, para limitar a mudançand

-- para maior segurança eu posso verificar qual linha vai ser alterado

select *
from pessoas
where id = 5

-- para varias mudanças de uma vez

update pessoas
set nascimento = '1200-10-05',
	altura = 1.20
where id = 5




update pessoas
set nascimento = '2000-10-05'
where nascimento is null and id > 0 -- esse and id é por causa da trava de segurança ao alterar varias linhas ao mesmo tempo

select *
from pessoas
where nascimento is null