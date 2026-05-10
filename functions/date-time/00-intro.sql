/* ========================================================================
   00 - INTRODUÇÃO: Funções de Data e Hora no MySQL
   ========================================================================
   
   O MySQL tem várias funções para trabalhar com datas e horas.
   Este arquivo apresenta as funções BÁSICAS para obter data/hora atual.
   
   Tipos de dados no MySQL:
   - DATE        → 'YYYY-MM-DD'           (ex: '2024-10-05')
   - TIME        → 'HH:MM:SS'             (ex: '14:30:00')
   - DATETIME    → 'YYYY-MM-DD HH:MM:SS'  (ex: '2024-10-05 14:30:00')
   - TIMESTAMP   → igual DATETIME, mas com fuso horário
   ======================================================================== */

-- ========================================================================
-- TABELA DE EXEMPLO (usada nos estudos)
-- ========================================================================

CREATE TABLE pessoas (
    id INT PRIMARY KEY,
    nome VARCHAR(100),
    nascimento DATE,
    email VARCHAR(100)
);

INSERT INTO pessoas VALUES 
(1, 'Ana Silva',     '1995-06-15', 'ana@email.com'),
(2, 'Carlos Souza',  '2000-10-05', 'carlos@email.com'),
(3, 'Maria Lima',    '1988-12-25', 'maria@email.com'),
(4, 'João Santos',   '2000-10-20', 'joao@email.com');

-- ========================================================================
-- 1. NOW() - Data e Hora COMPLETA do momento
-- ========================================================================

/*
   NOW() retorna a data E hora atual do servidor.
   Formato: 'YYYY-MM-DD HH:MM:SS'
   
   É a função mais usada quando se quer o momento exato!
*/

SELECT
    nome,
    nascimento,
    NOW() AS agora             -- Data+hora atual
FROM pessoas;

/*
   Resultado (exemplo):
   
   nome           | nascimento | agora
   ---------------+------------+---------------------
   Ana Silva      | 1995-06-15 | 2024-10-05 14:30:00
   Carlos Souza   | 2000-10-05 | 2024-10-05 14:30:00
   Maria Lima     | 1988-12-25 | 2024-10-05 14:30:00
   João Santos    | 2000-10-20 | 2024-10-05 14:30:00
   
   Repare: NOW() mostra o MESMO valor para todas as linhas,
   pois captura o momento da execução da consulta.
*/

-- ========================================================================
-- 2. CURDATE() / CURRENT_DATE - Apenas a DATA de hoje
-- ========================================================================

/*
   CURDATE() = CURRENT_DATE()
   Retorna SOMENTE a data (sem hora).
   Formato: 'YYYY-MM-DD'
*/

SELECT
    CURDATE()      AS hoje,                -- '2024-10-05'
    CURRENT_DATE() AS hoje_tambem;         -- mesma coisa

/*
   Diferença NOW vs CURDATE:
   
   NOW()     → '2024-10-05 14:30:00'  (data + hora)
   CURDATE() → '2024-10-05'           (só data)
*/

-- ========================================================================
-- 3. CURTIME() / CURRENT_TIME - Apenas a HORA atual
-- ========================================================================

SELECT
    CURTIME()      AS hora_agora,           -- '14:30:00'
    CURRENT_TIME() AS hora_tambem;          -- mesma coisa

-- ========================================================================
-- 4. CURRENT_TIMESTAMP - Alias do NOW()
-- ========================================================================

/*
   CURRENT_TIMESTAMP faz exatamente o mesmo que NOW().
   É o padrão SQL (mais portável entre bancos).
*/

SELECT
    NOW()              AS usando_now,
    CURRENT_TIMESTAMP  AS usando_timestamp;  -- mesmo resultado

-- ========================================================================
-- RESUMO DAS FUNÇÕES BÁSICAS
-- ========================================================================

/*
   Função              | Retorna               | Exemplo
   --------------------+-----------------------+---------------------
   NOW()               | Data + Hora           | 2024-10-05 14:30:00
   CURDATE()           | Só a Data             | 2024-10-05
   CURTIME()           | Só a Hora             | 14:30:00
   CURRENT_TIMESTAMP   | Data + Hora (padrão)  | 2024-10-05 14:30:00
   
   Dica: Quando precisar só da data, use CURDATE().
         Quando precisar do momento exato, use NOW().
*/

-- ========================================================================
-- FIM
-- ========================================================================

