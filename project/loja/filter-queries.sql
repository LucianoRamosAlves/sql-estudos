USE loja;

-- Exibir compras superior a 100 reais
SELECT * FROM produtos WHERE preco > 5;


-- Exibir compras feitas em 2023 depois de 5 de janeiro
SELECT * FROM pedidos WHERE data_pedido > '2023-01-05';