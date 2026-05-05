USE bank_trigger;

DELIMITER //
CREATE TRIGGER tr_credito_bd
    BEFORE DELETE ON credito
    FOR EACH ROW
BEGIN
    IF (OLD.credito_score > 700) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Não é possível excluir um crédito com score maior que 700';
    END IF;
END//

DELIMITER ;

DELETE FROM credito
WHERE id_credito = 1;