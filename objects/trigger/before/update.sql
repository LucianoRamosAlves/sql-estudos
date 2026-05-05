USE bank_trigger;

delimiter $$
CREATE TRIGGER tr_credito_bu
    BEFORE UPDATE ON credito
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

UPDATE credito
SET credito_score = 700
WHERE id_credito = 4;

UPDATE credito
SET credito_score = 100 -- vai dar erro, vira 300
WHERE id_credito = 2;

SELECT * FROM credito;