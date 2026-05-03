USE word;

select
continente_nome as continente,
lower(continente_nome) as nome_minusculo,
upper(continente_nome) as nome_maisculo
from continentes;