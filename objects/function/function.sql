USE word; -- sempre usa o USE para indicar qual banco de dados quer usar

SHOW TABLES;

-- Muda o delimitador padrão (;) para //
-- Isso é necessário porque dentro da função usamos ; várias vezes
DELIMITER //

-- Remove a função caso ela já exista (evita erro ao recriar)
DROP FUNCTION IF EXISTS f_quantidade_populacao //

-- Cria a função
CREATE FUNCTION f_quantidade_populacao(

    -- Parâmetro de entrada:
    -- nome do continente que vamos pesquisar
    pesquisa_continente VARCHAR(50)

)
-- Tipo de retorno da função
RETURNS BIGINT

-- Informa que a função sempre retorna o mesmo resultado
-- para a mesma entrada (boa prática)
DETERMINISTIC

-- Diz que a função apenas lê dados do banco (não altera nada)
READS SQL DATA

BEGIN

    -- Declara uma variável para armazenar o resultado
    DECLARE quantidade_var BIGINT DEFAULT 0;

    -- Busca a soma da população no continente informado
    -- e guarda o resultado dentro da variável
    SELECT FORMAT(SUM(populacao), 0)
    INTO quantidade_var
    FROM continentes
    WHERE continente_nome = pesquisa_continente;

    -- Retorna o valor calculado
    RETURN quantidade_var;

-- Final da função (usa // por causa do DELIMITER)
END //

-- Volta o delimitador ao padrão ;
DELIMITER ;

select f_quantidade_populacao('Oceania');

