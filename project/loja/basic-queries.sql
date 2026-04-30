USE loja;

-- Exibir todos os clientes
SELECT * FROM clientes;

-- Exibir todos os pedidos
SELECT * FROM pedidos;

-- Exibir todos os produtos
SELECT * FROM produtos;

-- Exibir todos os itens de pedido
SELECT * FROM itens_pedido;

-- Exibir todos os categorias
SELECT * FROM categorias;

-- exibir produto e preco
SELECT nome_produto AS produto,
       preco 
FROM produtos;



