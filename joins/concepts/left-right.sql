use meubanco;

select * from usuarios;

show create table usuarios; -- mostro a estrutura da tabela
    
select produto from pedido;

select nome, produto -- seleciono as colunas que pretendo ver
from usuarios u-- tabela principal, esse u é um apelido para simplificar
inner join pedido p-- escolho a tabela que vai juntar
on u.id = p.usuario_id; -- aqui é tabela.coluna

select u.nome, p.produto -- seleciono as colunas que pretendo ver, esse U é da tabela usuarios
from usuarios u-- tabela principal, esse u é um apelido para simplificar
left join pedido p-- aaqui eu mostro tudo da esquerda, idenpendente das combinações, mesmo com nome seu pedido
on u.id = p.usuario_id; -- aqui é tabela.coluna


select u.nome, p.produto -- seleciono as colunas que pretendo ver, esse U é da tabela usuarios
from usuarios u-- tabela principal, esse u é um apelido para simplificar
right join pedido p-- aaqui eu mostro o opposto do de cima, mostro tudo da direita
on u.id = p.usuario_id; -- aqui é tabela.coluna



