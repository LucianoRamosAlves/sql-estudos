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
    data_criacao DATETIME
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

DELIMITER $$

CREATE TRIGGER tr_delete_usuarios
AFTER DELETE ON usuarios
FOR EACH ROW -- para cada linha que for inserida
BEGIN -- o que eu quero fazer com trigger
    INSERT INTO logs_usuarios (mensagem, data_criacao)
    -- old representa o que foi deletado
    VALUES (CONCAT('usuário deletado: ', OLD.nome), NOW());
END $$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER tr_update_usuarios
AFTER UPDATE ON usuarios
FOR EACH ROW -- para cada linha que for inserida
BEGIN -- o que eu quero fazer com trigger
    INSERT INTO logs_usuarios (mensagem, data_criacao)
    -- new representa o que foi inserido
    VALUES (CONCAT(
        'Nome mudou de: ', OLD.nome, ' para: ', NEW.nome), NOW());
END $$

DELIMITER ;

INSERT INTO usuarios (nome) VALUES ('João');
INSERT INTO usuarios (nome) VALUES ('Maria');
INSERT INTO usuarios (nome) VALUES ('Pedro');
INSERT INTO usuarios (nome) VALUES ('Laisa');
INSERT INTO usuarios (nome) VALUES ('Lucas');

DELETE FROM usuarios WHERE id = 4;

UPDATE usuarios SET nome = 'Joaquim' WHERE id = 1;


SELECT * from usuarios;
SELECT * from logs_usuarios;
