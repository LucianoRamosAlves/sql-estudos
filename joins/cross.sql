create database treino_join;
use treino_join;

create table produto (
    nome varchar(50)
);

insert into produto (nome) 
values
('pizza'),
('pastel'),
('hot dog');

create table bebida (
    nome varchar(50)
);

insert into bebida (nome) 
values
('suco'),
('agua'),
('coca');

select * from bebida;

select p.nome as produto,
	   b.nome as bebida
from bebida b 
cross join produto p;


