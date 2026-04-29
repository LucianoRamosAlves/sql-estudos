use meubanco;

select * from usuarios;

show create table usuarios; -- mostro a estrutura da tabela

create table pedido (
	id int auto_increment primary key,
    usuario_id int,
    produto varchar(50),
    
    foreign key (usuario_id) references usuarios(id));
    
select produto from pedido;
    
insert into pedido (usuario_id, produto )
values (1, 'arroz');

insert into pedido (usuario_id, produto )
values (2, 'carne');

insert into pedido (usuario_id, produto )
values (3, 'batata');

insert into pedido ( produto )
values ('peixe');

select nome, produto -- seleciono as colunas que pretendo ver
from usuarios u-- tabela principal, esse u é um apelido para simplificar
inner join pedido p-- escolho a tabela que vai juntar
on u.id = p.usuario_id; -- aqui é tabela.coluna

