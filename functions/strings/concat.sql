select
nome,
nacionalidade,
concat(nome,'-', nacionalidade) as nome_nacionalidade -- eu junto palavras
from pessoas