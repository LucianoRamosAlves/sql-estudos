USE exemplos;

SELECT DATABASE();
-- nessse caso eu irei copiar os dados da tabela exemplos para a tabela exemplos_backup

CREATE TABLE exemplos_backup (
    nome VARCHAR(50),
    idade INT
);

INSERT INTO exemplos_backup (nome, idade)

SELECT nome, idade
FROM  exemplos
WHERE idade > 30;