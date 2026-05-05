CREATE DATABASE IF NOT EXISTS estudo_trigger_livro;

USE estudo_trigger_livro;

CREATE TABLE IF NOT EXISTS autor (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100),
    sobrenome VARCHAR(100),
    nacionalidade VARCHAR(100),
    paginas INT
);

CREATE TABLE IF NOT EXISTS autor_log (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100),
    sobrenome VARCHAR(100),
    nacionalidade VARCHAR(100),
    paginas INT,
    data_criacao DATETIME
)

INSERT INTO autor (nome, sobrenome, nacionalidade, paginas)
VALUES ('J.K.', 'Rowling', 'Inglaterra', 400),
    ('V.S.', 'Tolkien', 'Italia', 545),
    ('O.O.R.', 'Tanaka', 'Japão', 798),
    ('J.Ç.R.', 'Bradbury', 'Algéria', 308),
    ('K.U.R.', 'Clark', 'Inglaterra', 479),
    ('L.R.W.', 'Hoover', 'Inglaterra', 268);


delimiter //
CREATE TRIGGER tr_autor_delete -- criando um trigger
AFTER DELETE ON autor -- depois de deletar um autor
FOR EACH ROW 
BEGIN
    INSERT INTO autor_log (nome, sobrenome, nacionalidade, paginas, data_criacao)
    VALUES (OLD.nome,
        OLD.sobrenome, 
        OLD.nacionalidade, 
        OLD.paginas, 
        NOW());
END//
delimiter ;

SELECT * FROM autor;

DELETE FROM autor WHERE id = 2;


