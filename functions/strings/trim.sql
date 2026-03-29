select
nome,
nacionalidade
from pessoas
where nome != trim(nome) -- aqui eu pego as palavras com espacos vazios