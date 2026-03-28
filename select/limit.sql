select * 
from pessoas
limit 2; -- limito o numeros de linha que desejo ver

-- agora eu quero pegar o mais pesado

select *
from pessoas
order by peso desc -- ordeeno do maior para o menor
limit 1; -- pego só o primeiro que é o  mais pesado

