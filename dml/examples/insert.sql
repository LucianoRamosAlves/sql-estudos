USE sport;

-- quero pegar os valores de uma tabela e colocar em outra e acrescentrar dados e colunas


-- crio uma nova tabela
create table ficha_atleta(
    nome varchar(50),
    pais varchar(30),
    phone varchar(30),
    data_nascimento date
);

-- pego as colunas que eu quero na nova tabela
INSERT INTO ficha_atleta (nome, pais, phone, data_nascimento)

-- pego as colunas que eu quero na tabela original
SELECT nome,
    pais,
    'Desconhecido', 
    NULL
FROM player;

-- esqueci de colocar o id 
ALTER TABLE ficha_atleta
ADD COLUMN id int PRIMARY KEY AUTO_INCREMENT FIRST;


select * from ficha_atleta