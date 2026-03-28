select * from pessoas; -- seleciono todos
-- --------------------------------------------------------------------------
select -- aqui eu posso selecionar alguns
	nome,
	nacionalidade,
    sexo -- posso mudar a ordem que aparece
from pessoas;
-- -----------------------------------------------------------------------
select  -- aqui eu coloco todos * , ou espcecifico o nome da coluna
	nome,
    peso
from pessoas-- aqui é o nome da tabela
where peso > 50 --  aqui é a condição

select * 
from pessoas
where nacionalidade = 'Brasil'
