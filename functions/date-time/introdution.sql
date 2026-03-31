
select
nome,
nascimento,
'2000-10-05' data_igual,
now() Agora
from pessoas
-- ===== FUNÇÕES DE DATA E HORA NO MYSQL =====

-- 1. FUNÇÕES PARA OBTER DATA/HORA ATUAL
select
    now() as data_hora_atual,           -- Retorna data e hora completa (YYYY-MM-DD HH:MM:SS)
    curdate() as data_atual,             -- Retorna apenas a data (YYYY-MM-DD)
    curtime() as hora_atual,             -- Retorna apenas a hora (HH:MM:SS)
    current_timestamp() as timestamp_sql; -- Alias para NOW()

-- 2. EXTRAIR PARTES DE UMA DATA
select
    year(now()) as ano,                  -- Extrai o ano
    month(now()) as mes,                 -- Extrai o mês (1-12)
    day(now()) as dia,                   -- Extrai o dia do mês
    quarter(now()) as trimestre,         -- Extrai o trimestre (1-4)
    week(now()) as semana,               -- Extrai a semana do ano
    dayname(now()) as dia_semana,        -- Nome do dia da semana
    monthname(now()) as mes_nome;        -- Nome completo do mês

-- 3. OPERAÇÕES COM DATAS
select
    date_add(now(), interval 7 day) as proxima_semana,      -- Adiciona 7 dias
    date_sub(now(), interval 1 month) as mes_passado,       -- Subtrai 1 mês
    adddate(now(), 30) as mais_30_dias,                     -- Alias do DATE_ADD
    subdate(now(), 7) as menos_7_dias,                      -- Alias do DATE_SUB
    date_add(now(), interval '1-2' year_month) as mais_1a2m; -- Adiciona 1 ano e 2 meses

-- 4. DIFERENÇAS ENTRE DATAS
select
    datediff(now(), '2000-10-05') as dias_diferenca,        -- Diferença em DIAS apenas
    timestampdiff(day, '2000-10-05', now()) as dias_exato,  -- Diferença precisa em dias
    timestampdiff(year, '2000-10-05', now()) as anos_exato, -- Diferença em anos
    timestampdiff(month, '2000-10-05', now()) as meses_exato, -- Diferença em meses
    timestampdiff(hour, '2000-10-05 10:00:00', now()) as horas; -- Diferença em horas

-- 5. FORMATAÇÃO DE DATAS
select
    date_format(now(), '%d/%m/%Y') as data_br,              -- Formato brasileiro
    date_format(now(), '%d de %M de %Y') as data_extenso,   -- Data extensa
    date_format(now(), '%H:%i:%s') as hora_formatada,       -- Hora formatada
    date_format(now(), '%W, %d de %M de %Y') as data_completa; -- Dia da semana + data

-- 6. CONVERSÕES
select
    str_to_date('31/12/2023', '%d/%m/%Y') as data_convertida,    -- String para DATA
    date(now()) as so_data,                                      -- Timestamp para DATA
    time(now()) as so_hora,                                      -- Timestamp para HORA
    convert('2023-12-31', date) as metodo_convert;               -- Outro método de conversão

-- 7. ÚLTIMOS DIAS DO MÊS
select
    last_day(now()) as ultimo_dia_mes,                      -- Retorna o último dia do mês
    day(last_day(now())) as quantidade_dias_mes;            -- Quantidade de dias no mês atual

-- 8. CONDIÇÕES COM DATAS (WHERE)
-- Exemplo: Buscar pessoas nascidas após 2000
where nascimento > '2000-01-01'
    and nascimento <= curdate()                             -- Nascidos até hoje
    and year(nascimento) = 2000                             -- Nascidos especificamente em 2000
    and month(nascimento) = 10;                             -- E no mês 10 (outubro)

-- 9. ORDENAÇÃO COM DATAS
order by nascimento desc;                                 -- Mais recentes primeiro



