CREATE DATABASE IF NOT EXISTS estudo_trigger;

USE estudo_trigger;



CREATE TABLE IF NOT EXISTS usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100)
);

-- aqui é o caderno de registro
CREATE TABLE IF NOT EXISTS logs_usuarios (
    id_log INT AUTO_INCREMENT PRIMARY KEY,
    mensagem VARCHAR(100),
    data_criacao DATETIME,
    FOREIGN KEY (id_log) REFERENCES usuarios(id)
);

DELIMITER $$

CREATE TRIGGER tr_insert_usuarios
AFTER INSERT ON usuarios
FOR EACH ROW -- para cada linha que for inserida
BEGIN -- o que eu quero fazer com trigger
    INSERT INTO logs_usuarios (mensagem, data_criacao)
    -- new representa o que foi inserido
    VALUES (CONCAT('Novo usuário cadastrado: ', NEW.nome), NOW());
END $$

DELIMITER ;

INSERT INTO usuarios (nome) VALUES ('João');
INSERT INTO usuarios (nome) VALUES ('Maria');
INSERT INTO usuarios (nome) VALUES ('Pedro');
INSERT INTO usuarios (nome) VALUES ('Laisa');


SELECT * from usuarios;
SELECT * from logs_usuarios;
