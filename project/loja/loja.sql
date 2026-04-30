-- aqui eu crio um banco de dados
create database loja;
use loja;

-- aqui eu crio uma tabela
create table clientes (
    clientes_id int primary key auto_increment,
    nome varchar(50)
);

-- aqui eu crio uma tabela
create table pedidos (
    pedidos_id int primary key auto_increment,
    clientes_id int,
    data_pedido date,
    foreign key (clientes_id) references clientes(clientes_id)
);

-- aqui eu crio uma tabela categorias
create table categorias (
    categorias_id int primary key auto_increment,
    nome_categoria varchar(50)
);

-- aqui eu crio uma tabela produtos
create table produtos (
    produtos_id int primary key auto_increment,
    nome_produto varchar(50),
    preco decimal(10, 2),
    categorias_id int,
    foreign key (categorias_id) references categorias(categorias_id)
);

-- crio a tabela associativa
create table itens_pedido (
    pedidos_id int
    produtos_id int,
    primary key (pedidos_id, produtos_id),
    foreign key (pedidos_id) references pedidos(pedidos_id),
    foreign key (produtos_id) references produtos(produtos_id)
);

-- inserir dados na tabela clientes
insert into clientes (nome) values ('João');
insert into clientes (nome) values ('Maria');
insert into clientes (nome) values ('Pedro');
insert into clientes (nome) values ('Ana');
insert into clientes (nome) values ('Julia');
insert into clientes (nome) values ('Rhafa');
insert into clientes (nome) values ('Miguel');
insert into clientes (nome) values ('Ana');

-- inserir dados na tabela pedidos
insert into pedidos (clientes_id, data_pedido) values (1, '2023-01-01');
insert into pedidos (clientes_id, data_pedido) values (2, '2023-01-02');
insert into pedidos (clientes_id, data_pedido) values (3, '2023-01-03');
insert into pedidos (clientes_id, data_pedido) values (4, '2023-01-04');
insert into pedidos (clientes_id, data_pedido) values (5, '2023-01-05');
insert into pedidos (clientes_id, data_pedido) values (6, '2023-01-06');
insert into pedidos (clientes_id, data_pedido) values (7, '2023-01-07');
insert into pedidos (clientes_id, data_pedido) values (8, '2023-01-08');

-- inserir dados na tabela categorias
insert into categorias (nome_categoria) values ('Alimentos');
insert into categorias (nome_categoria) values ('Bebidas');
insert into categorias (nome_categoria) values ('Limpeza');
insert into categorias (nome_categoria) values ('Higiene');

-- inserir dados na tabela produtos
insert into produtos (nome_produto, preco, categorias_id) values ('Pizza', 10.99, 1);
insert into produtos (nome_produto, preco, categorias_id) values ('Suco', 2.99, 2);
insert into produtos (nome_produto, preco, categorias_id) values ('Papel Higiênico', 5.99, 3);
insert into produtos (nome_produto, preco, categorias_id) values ('Shampoo', 9.99, 4);

-- inserir dados na tabela itens_pedido
insert into itens_pedido (pedidos_id, produtos_id) values (1, 1);
insert into itens_pedido (pedidos_id, produtos_id) values (2, 2);
insert into itens_pedido (pedidos_id, produtos_id) values (3, 3);
insert into itens_pedido (pedidos_id, produtos_id) values (4, 4);
insert into itens_pedido (pedidos_id, produtos_id) values (5, 1);
insert into itens_pedido (pedidos_id, produtos_id) values (6, 2);
insert into itens_pedido (pedidos_id, produtos_id) values (7, 3);
insert into itens_pedido (pedidos_id, produtos_id) values (8, 4);

