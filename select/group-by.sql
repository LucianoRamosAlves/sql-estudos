select -- aqui eu seleciono a coluna
sexo,
sum(peso) -- se sexo for igual, ele pega os peso e soma
from pessoas
group by sexo -- ele basicamente, soma os peso de sexo iguais

select
sexo,
nome,
sum(peso) 
from pessoas
group by sexo , nome -- aqui eu adciono outras informação na tabela

select
sexo,
count(sexo), -- aqui eu conto as quantidades
sum(peso) 
from pessoas
group by sexo

