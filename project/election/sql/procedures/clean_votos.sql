use election;

DELIMITER $$

CREATE PROCEDURE sp_carga_prata_votos()
BEGIN

    -- =========================
    -- VARIÁVEIS
    -- =========================

    DECLARE v_inicio DATETIME;
    DECLARE v_fim DATETIME;
    DECLARE v_tempo_execucao INT;

    -- =========================
    -- TRATAMENTO DE ERRO
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

            'ERRO' AS status_execucao,
            v_inicio AS inicio_execucao,
            v_fim AS fim_execucao,
            CONCAT(v_tempo_execucao, ' segundos') AS tempo_execucao;

    END;

    -- =========================
    -- INÍCIO
    -- =========================

    SET v_inicio = NOW();

    START TRANSACTION;

    -- =========================
    -- LIMPA TABELA
    -- =========================

    TRUNCATE TABLE prata_votos;

    -- =========================
    -- INSERT
    -- =========================

    INSERT INTO prata_votos(

        titulo_eleitor,
        candidato_id,
        status_votos,
        eleitor,
        sexo,
        cidade,
        data_voto,
        hora_voto

    )

    SELECT 

        titulo_eleitor,

        candidato_id,

        CASE

            WHEN candidato_id IN (

                SELECT candidato_id
                FROM bronze_candidatos

            )

            THEN 'VALIDO'

            ELSE 'NULO'

        END AS status_votos,

        UPPER(TRIM(eleitor)) AS eleitor,

        CASE

            WHEN UPPER(TRIM(sexo)) IN (
                'M',
                'MASC',
                'MASCULINO'
            )

            THEN 'MASCULINO'

            WHEN UPPER(TRIM(sexo)) IN (
                'F',
                'FEM',
                'FEMININO'
            )

            THEN 'FEMININO'

            ELSE 'N/A'

        END AS sexo,

        UPPER(TRIM(cidade)) AS cidade,

        DATE(data_voto) AS data_voto,

        TIME_FORMAT(
            data_voto,
            '%H:%i:%s'
        ) AS hora_voto

    FROM(

        SELECT *,

               ROW_NUMBER() OVER(

                   PARTITION BY titulo_eleitor

                   ORDER BY data_voto DESC

               ) AS flag_last

        FROM bronze_votos

    ) t

    WHERE flag_last = 1

      AND titulo_eleitor IS NOT NULL
      AND titulo_eleitor <> '';

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
        CONCAT(v_tempo_execucao, ' segundos') AS tempo_execucao,

        (
            SELECT COUNT(*)
            FROM prata_votos
            WHERE status_votos = 'NULO'
        ) AS total_votos_nulos,

        (
            SELECT COUNT(*)
            FROM prata_votos
            WHERE status_votos = 'VALIDO'
        ) AS total_votos_validos;

END $$

DELIMITER ;