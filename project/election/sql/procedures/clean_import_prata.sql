DELIMITER $$

CREATE PROCEDURE sp_pipeline_silver()
BEGIN

    DECLARE v_inicio DATETIME;
    DECLARE v_fim DATETIME;

    SET v_inicio = NOW();

    CALL sp_carga_prata_candidatos();

    CALL sp_carga_prata_cargos();

    CALL sp_carga_prata_votos();

    SET v_fim = NOW();

    SELECT
        'PIPELINE SILVER FINALIZADA' AS status,
        v_inicio AS inicio,
        v_fim AS fim;

END $$

DELIMITER ;