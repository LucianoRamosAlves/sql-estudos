use sport;

-- escrevo o que eu quero alterar, mas nao altero nada ainda
UPDATE ficha_atleta
SET phone = '+55 ___ ____-____'
WHERE pais = 'Brasil';

-- confirmo a alteraçao vejo o que vai ser alterado
SELECT * 
FROM ficha_atleta
WHERE pais = 'Brasil';

SELECT * 
FROM ficha_atleta

-- alterar varias linhas ao mesmo tempo
UPDATE ficha_atleta
SET nome = 'Joaquim',
    pais = 'Portugal'
WHERE id = 5;

-- sempre que eu quero ver o que vai ser alterado
SELECT * 
FROM ficha_atleta
WHERE id = 5
