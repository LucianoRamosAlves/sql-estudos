DELIMITER $$

CREATE PROCEDURE sp_carga_prata_cargos()
BEGIN

    -- =========================
    -- VARIÁVEIS
    -- =========================
    
    DECLARE v_inicio DATETIME;
    DECLARE v_fim DATETIME;
    DECLARE v_tempo_execucao INT;

    -- =========================
    -- CAPTURA DE ERRO
    -- =========================

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN

        ROLLBACK;

        SET v_fim = NOW();

        SET v_tempo_execucao = TIMESTAMPDIFF(
            SECOND,
            v_inicio,
            v_fim
        );

        SELECT 
            'ERRO AO EXECUTAR PROCEDURE' AS status_execucao,
            v_inicio AS inicio_execucao,
            v_fim AS fim_execucao,
            CONCAT(v_tempo_execucao, ' segundos') AS tempo_execucao;

    END;

    -- =========================
    -- INÍCIO EXECUÇÃO
    -- =========================

    SET v_inicio = NOW();

    START TRANSACTION;

    -- =========================
    -- INSERT SILVER
    -- =========================

    INSERT INTO prata_cargos(

        nome_cargo,
        esfera,
        vagas,
        status_vagas,
        ano_eleicao

    )

    SELECT 

        UPPER(TRIM(nome_cargo)) AS nome_cargo,

        UPPER(TRIM(esfera)) AS esfera,

        CASE 
            WHEN vagas IS NULL THEN 0 
            ELSE vagas 
        END AS vagas,

        CASE 
            WHEN vagas = 0 
                 OR vagas IS NULL
            THEN 'INDISPONIVEL'

            ELSE 'DISPONIVEL'
        END AS status_vagas,

        CASE 
            WHEN ano_eleicao <> 2026 THEN 2026
            ELSE ano_eleicao
        END AS ano_eleicao

    FROM (

        SELECT *,

               ROW_NUMBER() OVER(

                   PARTITION BY

                       UPPER(TRIM(nome_cargo)),
                       UPPER(TRIM(esfera))

                   ORDER BY vagas ASC

               ) AS flag_last

        FROM bronze_cargos

        WHERE ano_eleicao <= YEAR(CURDATE())

    ) t

    WHERE flag_last = 1
      AND nome_cargo <> ''
      AND esfera <> '';

    -- =========================
    -- FINALIZA
    -- =========================

    COMMIT;

    SET v_fim = NOW();

    SET v_tempo_execucao = TIMESTAMPDIFF(
        SECOND,
        v_inicio,
        v_fim
    );

    -- =========================
    -- RETORNO
    -- =========================

    SELECT 

        'SUCESSO' AS status_execucao,
        v_inicio AS inicio_execucao,
        v_fim AS fim_execucao,
        CONCAT(v_tempo_execucao, ' segundos') AS tempo_execucao;

END $$

DELIMITER ;

CALL sp_carga_prata_cargos();