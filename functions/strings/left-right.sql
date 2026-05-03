select continente_nome,
    left(continente_nome, 3) as primeiras_sigla
from continentes;


select continente_nome,
    right(continente_nome, 3) as ultimas_sigla
from continentes;