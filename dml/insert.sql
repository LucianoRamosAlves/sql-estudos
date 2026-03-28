insert into pessoas (nome, sexo, peso, nacionalidade) -- inserir dados
values
	('max', 'M', '40', 'Brasil'),
    ('rata', 'M', '90', 'Brasil'),
    ('vivi', 'F', '60.5', 'Brasil'),
    ('mah', 'F', '50', 'Bolivia'),
    ('yiuri', 'M', '78.9', 'Brasil');
    
    select * from pessoas -- exibir a tabela
    
    -- agora eu posso pegar os dados de uma tabela e inseeir em outra tabela vazia
    
create table pessoas_masculino(
	id int,
    nome varchar(30),
    sexo char(1),
    nascionalidade varchar(30),
    telefone int );
    
select * from pessoas_masculino    
    
insert into pessoas_masculino (id, nome, sexo, nascionalidade, telefone)
select -- 1 primeio eu olho a tabela original e me organizo
id,
nome,
sexo,
nacionalidade,
null -- já pensando que vou criar um coluna telefone
from pessoas
where sexo = 'M' -- 2 aqui eu filtro, agora tratado os dados originais, posso colocar na vazia

