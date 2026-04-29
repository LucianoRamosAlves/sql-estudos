create database treino_join;
use treino_join;

create table funcionarios (
	id int primary key auto_increment,
    nome varchar(50),
    gerente_id int
);

insert into funcionarios (nome, gerente_id) 
values
('joão', NULL), -- chef
('pedro', 1),
('maria', 1),
('ana', 2),
('lais', 1);

select * from funcionarios;

select f.nome as funcionario,
	   g.nome as gerente
from funcionarios f
left join funcionarios g
on f.gerente_id = g.id;


