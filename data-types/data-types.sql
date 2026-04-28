CREATE DATABASE data_types;

USE data_types;

CREATE TABLE delivery(
	id_restaurante INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nome_restaurante VARCHAR(30) NOT NULL,
    idade TINYINT UNSIGNED,
    cpf CHAR(11) NOT NULL UNIQUE,
    data_nascimento DATE NOT NULL,
    avaliação_restaurante SMALLINT UNSIGNED,
    n_pedido_restaurante INT UNSIGNED,
    ativo BOOL,
    data_cadastro TIMESTAMP,
    localizacao GEOMETRY,
    horario_funcionamento TIME,
    cardapio VARCHAR(500),
    saldo_card DECIMAL,
    configuracao JSON,
    hora_entrega TIME,
    peso_pedido FLOAT(4,2),
    comentarios TEXT
);
	