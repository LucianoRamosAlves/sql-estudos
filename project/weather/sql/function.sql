USE weather;

-- função para ver a quantidade de linhas inseridas

DELIMITER //

CREATE FUNCTION fn_total_linhas_carregadas()
RETURNS VARCHAR(100)

READS SQL DATA

BEGIN

    DECLARE v_total INT;

    SELECT COUNT(*)
    INTO v_total
    FROM current_weather_load;

    RETURN CONCAT(
        'Foram carregadas ',
        v_total,
        ' linhas'
    );

END//

DELIMITER ;