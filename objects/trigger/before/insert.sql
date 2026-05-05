CREATE DATABASE IF NOT EXISTS bank_trigger;

USE bank_trigger;

CREATE TABLE IF NOT EXISTS credito (
    id_credito INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50),
    credito_score INT
);

delimiter $$
CREATE TRIGGER tr_credito_bi
    BEFORE INSERT ON credito
    FOR EACH ROW
BEGIN
    IF (NEW.credito_score < 300) THEN
    -- caso o score seja menor que 300 ele será 300
        SET NEW.credito_score = 300;
    END IF;
 -- score entre 300 e 850
    IF (NEW.credito_score > 850) THEN
        SET NEW.credito_score = 850;
    END IF;
END%%
delimiter ;



INSERT INTO credito (nome, credito_score)
VALUES
('João', 1000), -- maior que 850 vira 850
('Maria', 500),
('Pedro', 200), -- menor que 300 vira 300
('Ana', 400);

SELECT * FROM credito;