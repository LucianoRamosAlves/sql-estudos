USE loja;

SELECT nome AS nome,
    produtos_id AS produto
FROM clientes c
LEFT JOIN itens_pedido p
ON c.clientes_id = p.produtos_id

# BUG AQUI -- FALTA TERMINAR A QUERY 