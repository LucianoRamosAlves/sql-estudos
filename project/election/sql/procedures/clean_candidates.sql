DELIMITER $$

CREATE PROCEDURE sp_carga_prata_candidatos()
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

    TRUNCATE TABLE prata_candidatos;

    -- =========================
    -- INSERT
    -- =========================
    INSERT INTO prata_candidatos(
        candidato_id,
        nome,
        status_elegibilidade,
        partido,
        cargo_id,
        cidade,
        idade,
        motivo_elegibilidade
    )
    SELECT 
    candidato_id,
    CASE WHEN UPPER(TRIM(nome)) = '' 
    OR UPPER(TRIM(nome)) IS NULL
    THEN 'Desconhecido' ELSE UPPER(TRIM(nome)) END AS nome,
    CASE WHEN UPPER(TRIM(nome)) = ''
    OR idade > 60  
    OR cargo_id > 21
    THEN 'Inelegivel' 
    ELSE 'Elegivel' END AS status_elegibilidade,
    UPPER(TRIM(partido)) AS partido,
    cargo_id,
    CASE WHEN UPPER(TRIM(cidade)) IS NULL THEN 'N/A' ELSE UPPER(TRIM(cidade)) END AS cidade,
    idade,
    CASE
    WHEN UPPER(TRIM(nome)) = '' OR nome IS NULL THEN 'Nome Invalido'
    WHEN idade > 60 THEN 'Idade acima de 60 anos'
    WHEN cargo_id > 21 THEN 'Cargo inexistente'
    ELSE 'Sem problemas' END
    AS motivo_elegibilidade
    FROM(
        select *,
        ROW_NUMBER() OVER(PARTITION BY candidato_id ORDER BY candidato_id DESC) AS flag_last
        FROM bronze_candidatos
    )
    t WHERE flag_last = 1
    ORDER BY nome ASC;

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
