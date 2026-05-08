use word;

select * from continentes ; /* Select -- seleciono o que e From aonde*/

select continente_nome, populacao from continentes
where continente_nome = 'Oceania'; /* esse é um filtro Where */ 

/* select controla as colunas, veja que mostrei 2, e where comtrola as linhas, veja que mostrei 1*/

select continente_nome, populacao from continentes
order by continente_nome;

select continente_nome, populacao from continentes
order by populacao;

select continente_nome, populacao from continentes
order by populacao desc;


/* ainda posso usar o desc com where*/
select continente_nome, populacao from continentes
where populacao > 50000000
order by populacao;