select
nome,
left(nome, 2) as primeiro_letras,
right(nome, 1) as ultima_letra
from pessoas