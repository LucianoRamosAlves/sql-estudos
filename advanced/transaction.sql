
show databases;

use cadastro;

start transaction; -- começa no modo seguro, agora eu confirmo ou volto

insert into pessoas
(nome, nacionalidade)
values('Hugo', 'Brasil');

insert into pessoas
(nome, nacionalidade)
values('besk', 'India');

describe pessoas;

select * from pessoas;

rollback; -- desfaz a transação ou

commit; -- confirma a transação

select * from pessoas;

show table status like 'pessoas';