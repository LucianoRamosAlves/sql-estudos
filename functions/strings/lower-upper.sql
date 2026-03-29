select
nome,
nacionalidade,
-- concat(nome,'-', nacionalidade) as nome_nacionalidade -- eu junto palavras
lower(nome) as nome_minusculo,
upper(nome) as nome_maisculo
from pessoas