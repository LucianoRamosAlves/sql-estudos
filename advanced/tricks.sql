
-- isso serve para saber quais tabelas existem
SELECT TABLE_schema, TABLE_NAME 
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'word';




-- isso serve para saber quando uma tabela foi criada
SELECT TABLE_SCHEMA, CREATE_TIME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'estudos_procedure';


use word;

-- isso serve para saber quantas linhas tem uma tabela
-- caso eu queira apagar e confiro se esta em uso
select count(*) from continentes;

-- dicas 

/* 

sempre que for criar uma coisa eu confirmo com o select
++ ao deletar algo eu confirmo com o select
++ ao alterar algo eu confirmo com o select
++ ao inserir algo eu confirmo com o select
++ sempre verifico se estou no banco certo

*/