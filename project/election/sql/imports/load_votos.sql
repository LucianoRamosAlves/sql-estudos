-- seleciona o banco de dados que será utilizado
USE election;

-- remove todos os dados antigos da tabela staging
-- staging table = tabela temporária de carga
TRUNCATE TABLE bronze_votos;

-- LOCAL = arquivo localizado na máquina cliente
LOAD DATA LOCAL INFILE
'/mnt/c/Users/lramo/OneDrive/Documentos/Estudos/sql-estudos/project/election/data/raw/votos/raw_votos.csv'



-- tabela que receberá os dados
INTO TABLE bronze_votos

--    -------------------------------------------------------------------
    -- CONFIGURAÇÃO DO CSV
  --  -------------------------------------------------------------------

    -- colunas separadas por vírgula
    FIELDS TERMINATED BY ','

    -- textos envolvidos por aspas
    ENCLOSED BY '"'

    -- quebra de linha do Windows
    LINES TERMINATED BY '\r\n'

--    -------------------------------------------------------------------
    -- IGNORA CABEÇALHO
 --   -------------------------------------------------------------------

    -- ignora a primeira linha do arquivo csv
    IGNORE 1 ROWS

 --   -------------------------------------------------------------------
    -- MAPEAMENTO DAS COLUNAS
 --   -------------------------------------------------------------------

-- ordem das colunas do csv
(
titulo_eleitor,
candidato_id,
eleitor,
sexo,
cidade,
data_voto
) 