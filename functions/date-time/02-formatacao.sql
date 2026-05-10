/* ========================================================================
   02 - FORMATAÇÃO: DATE_FORMAT e TIME_FORMAT
   ========================================================================
   
   DATE_FORMAT(data, 'formato') → formata uma DATA do jeito que você quiser
   TIME_FORMAT(hora, 'formato') → formata uma HORA do jeito que você quiser
   
   Você monta o formato usando % + letra (códigos).
   Caracteres NORMAIS (sem %) viram texto literal.
   
   EX: DATE_FORMAT('2024-10-05', '%d/%m/%Y') → '05/10/2024'
   
   CÓDIGOS MAIS USADOS:
   %Y = ano com 4 dígitos     %y = ano com 2 dígitos
   %m = mês (01-12)           %c = mês (1-12) sem zero
   %M = nome do mês           %b = mês abreviado (Jan)
   %d = dia (01-31)           %e = dia (1-31) sem zero
   %W = nome do dia da semana %a = dia abreviado (Mon)
   %H = hora (00-23)          %h = hora (01-12)
   %i = minuto (00-59)        %s = segundo (00-59)
   %p = AM/PM                 %r = hora 12h completa
   %T = hora 24h completa
   ======================================================================== */

-- ========================================================================
-- 1. DATE_FORMAT - Formatando datas em diferentes estilos
-- ========================================================================

/*
   A função recebe:
   1º argumento: a data que você quer formatar
   2º argumento: uma string com o formato desejado
*/

SELECT
    -- Estilo brasileiro (dia/mês/ano)
    DATE_FORMAT(NOW(), '%d/%m/%Y') AS data_br,
    
    -- Estilo brasileiro com hora
    DATE_FORMAT(NOW(), '%d/%m/%Y %H:%i:%s') AS data_hora_br,

    -- Data por extenso
    DATE_FORMAT(NOW(), '%d de %M de %Y') AS data_extenso,

    -- Dia da semana + data completa
    DATE_FORMAT(NOW(), '%W, %d de %M de %Y') AS data_completa,

    -- Apenas mês e ano
    DATE_FORMAT(NOW(), '%M de %Y') AS mes_ano,

    -- Formato americano (padrão ISO)
    DATE_FORMAT(NOW(), '%Y-%m-%d') AS formato_iso;

/*
   Resultado (exemplo para 05/10/2024):
   
   data_br      | 05/10/2024
   data_hora_br | 05/10/2024 14:30:00
   data_extenso | 5 de October de 2024
   data_completa| Saturday, 5 de October de 2024
   mes_ano      | October de 2024
   formato_iso  | 2024-10-05
*/

-- Aplicando na tabela pessoas
SELECT
    nome,
    nascimento,
    DATE_FORMAT(nascimento, '%d/%m/%Y') AS data_br,
    DATE_FORMAT(nascimento, '%W') AS dia_semana
FROM pessoas;

/*
   Resultado:
   
   nome           | nascimento | data_br    | dia_semana
   ---------------+------------+------------+-----------
   Ana Silva      | 1995-06-15 | 15/06/1995 | Thursday
   Carlos Souza   | 2000-10-05 | 05/10/2000 | Thursday
   Maria Lima     | 1988-12-25 | 25/12/1988 | Sunday
   João Santos    | 2000-10-20 | 20/10/2000 | Friday
*/

-- ========================================================================
-- 2. TIME_FORMAT - Formatando horas
-- ========================================================================

/*
   TIME_FORMAT é igual ao DATE_FORMAT mas específico para horas.
   Usa os mesmos códigos de hora (%H, %h, %i, %s, %p, %r, %T)
*/

SELECT
    CURTIME() AS hora_original,

    -- Hora no formato HH:MM:SS (24h)
    TIME_FORMAT(CURTIME(), '%H:%i:%s') AS hora_24h,

    -- Hora no formato HH:MM:SS AM/PM (12h)
    TIME_FORMAT(CURTIME(), '%h:%i:%s %p') AS hora_12h,

    -- Hora completa em 12h
    TIME_FORMAT(CURTIME(), '%r') AS hora_completa_12h,

    -- Hora completa em 24h
    TIME_FORMAT(CURTIME(), '%T') AS hora_completa_24h,

    -- Personalizado
    TIME_FORMAT(CURTIME(), '%H hours %i minutes and %s seconds') AS por_extenso;

/*
   Resultado (exemplo para 14:30:45):
   
   hora_original      | 14:30:45
   hora_24h           | 14:30:45
   hora_12h           | 02:30:45 PM
   hora_completa_12h  | 02:30:45 PM
   hora_completa_24h  | 14:30:45
   por_extenso        | 14 hours 30 minutes and 45 seconds
*/

-- ========================================================================
-- 3. DICA: Formatando com mês e dia em português
-- ========================================================================

/*
   Por padrão, %M e %W retornam em INGLÊS (January, Monday...).
   Para português, você precisa configurar o locale do MySQL:
   
   SET lc_time_names = 'pt_BR';
   
   Após isso, %M = Janeiro, %W = Segunda-feira, etc.
*/

SET lc_time_names = 'pt_BR';  -- ativa português

SELECT
    DATE_FORMAT(NOW(), '%W, %d de %M de %Y') AS data_em_portugues;

/*
   Resultado: "Sábado, 05 de Outubro de 2024"
*/

SET lc_time_names = 'en_US';  -- volta para inglês (padrão)

-- ========================================================================
-- FIM
-- ========================================================================