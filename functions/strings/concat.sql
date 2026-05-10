/* ========================================================================
   ESTUDO: CONCAT - Função de Concatenação de Strings no SQL
   ========================================================================
   CONCAT junta (concatena) duas ou mais strings em uma só.
   É como colar pedaços de texto lado a lado.
   
   SUMÁRIO:
   1. Sintaxe básica
   2. Concat com separador
   3. Concat com valores fixos
   4. Concat vs operador ||
   5. Tratamento de NULL
   ======================================================================== */

-- ========================================================================
-- 1. CONCAT BÁSICO - Juntando colunas
-- ========================================================================

-- Tabela de exemplo
CREATE TABLE pessoas (
    id INT PRIMARY KEY,
    nome VARCHAR(100),
    nacionalidade VARCHAR(50)
);

INSERT INTO pessoas VALUES 
(1, 'Ana Silva',     'Brasileira'),
(2, 'Carlos Souza',  'Português'),
(3, 'Maria Lima',    'Espanhola');

/*
   CONCAT( valor1, valor2, valor3, ... )
   - Pode receber QUANTOS argumentos quiser
   - Junta TUDO em uma única string, sem separador automático
*/

-- Exemplo básico: juntar nome e nacionalidade
SELECT
    nome,
    nacionalidade,
    CONCAT(nome, nacionalidade) AS nome_junto  -- sem separador!
FROM pessoas;

/*
   Resultado:
   
   nome           | nacionalidade | nome_junto
   ---------------+---------------+------------------------
   Ana Silva      | Brasileira    | Ana SilvaBrasileira
   Carlos Souza   | Português     | Carlos SouzaPortuguês
   Maria Lima     | Espanhola     | Maria LimaEspanhola
   
   Problema: as palavras ficaram GRUDADAS!
   Solução: adicionar um separador (próximo exemplo)
*/

-- ========================================================================
-- 2. CONCAT COM SEPARADOR
-- ========================================================================

/*
   Para juntar com separador, basta adicioná-lo como argumento.

   CONCAT(nome, ' - ', nacionalidade)
            ↑       ↑         ↑
          coluna  separador  coluna
*/

SELECT
    nome,
    nacionalidade,
    CONCAT(nome, ' - ', nacionalidade) AS nome_nacionalidade
FROM pessoas;

/*
   Resultado:
   
   nome           | nacionalidade | nome_nacionalidade
   ---------------+---------------+----------------------------
   Ana Silva      | Brasileira    | Ana Silva - Brasileira
   Carlos Souza   | Português     | Carlos Souza - Português
   Maria Lima     | Espanhola     | Maria Lima - Espanhola
   
   Agora sim! O separador ' - ' deu espaçamento entre os textos.
*/

-- ========================================================================
-- 3. CONCAT COM VALORES FIXOS (TEXTO LITERAL)
-- ========================================================================

/*
   Podemos misturar colunas com texto fixo.
   Texto fixo deve estar entre aspas SIMPLES 'assim'.
*/

SELECT
    nome,
    CONCAT('Sr(a). ', nome, ' - Nacionalidade: ', nacionalidade) AS apresentacao
FROM pessoas;

/*
   Resultado:
   
   nome           | apresentacao
   ---------------+------------------------------------------
   Ana Silva      | Sr(a). Ana Silva - Nacionalidade: Brasileira
   Carlos Souza   | Sr(a). Carlos Souza - Nacionalidade: Português
   Maria Lima     | Sr(a). Maria Lima - Nacionalidade: Espanhola
   
   Texto fixo é ótimo para formatar relatórios e mensagens!
*/

-- ========================================================================
-- 4. CONCAT vs OPERADOR || 
-- ========================================================================

/*
   Em alguns bancos (PostgreSQL, SQLite) dá pra usar || no lugar do CONCAT.
   No MySQL e MariaDB, || é OU lógico (não concatena) - use CONCAT.
   
   PostgreSQL / SQLite:   'a' || 'b' = 'ab'
   MySQL / MariaDB:       'a' || 'b' = 0 (não funciona!)
   MySQL / MariaDB:       CONCAT('a','b') = 'ab' ✔️
*/

-- Exemplo com || (funciona no PostgreSQL)
SELECT nome || ' - ' || nacionalidade AS nome_nacionalidade
FROM pessoas;

-- Equivalente com CONCAT (funciona em TODOS os bancos)
SELECT CONCAT(nome, ' - ', nacionalidade) AS nome_nacionalidade
FROM pessoas;

/*
   Recomendação: use CONCAT para ser compatível com todos os bancos.
*/

-- ========================================================================
-- 5. CONCAT e TRATAMENTO DE NULL
-- ========================================================================

/*
   VANTAGEM do CONCAT: ele IGNORA valores NULL em vez de 
   retornar NULL que nem o operador ||.
   
   CONCAT(NULL, 'texto') = 'texto'  ← retorna o texto
   NULL || 'texto'       = NULL     ← retorna NULL (em alguns bancos)
*/

SELECT
    nome,
    CONCAT(nome, ' - ', NULL, ' - ', nacionalidade) AS testando_null
FROM pessoas;

/*
   Resultado:
   
   nome           | testando_null
   ---------------+---------------------------------
   Ana Silva      | Ana Silva -  - Brasileira
   Carlos Souza   | Carlos Souza -  - Português
   Maria Lima     | Maria Lima -  - Espanhola
   
   O NULL foi IGNORADO, mas o separador ainda aparece!
   Para evitar isso, use CONCAT_WS (next passo).
*/

-- ========================================================================
-- 6. BÔNUS: CONCAT_WS (Concat With Separator)
-- ========================================================================

/*
   CONCAT_WS é uma variação que já recebe o SEPARADOR 
   como PRIMEIRO argumento.
   
   CONCAT_WS(separador, valor1, valor2, ...)
   
   Vantagem: IGNORA valores NULL sem deixar espaços extras!
*/

SELECT
    nome,
    CONCAT_WS(' - ', nome, NULL, nacionalidade) AS com_ws
FROM pessoas;

/*
   Resultado:
   
   nome           | com_ws
   ---------------+---------------------------
   Ana Silva      | Ana Silva - Brasileira
   Carlos Souza   | Carlos Souza - Português
   Maria Lima     | Maria Lima - Espanhola
   
   O NULL sumiu completamente, sem espaços extras!
   CONCAT_WS é ideal quando há valores nulos no meio.
*/

-- ========================================================================
-- 7. LIMPANDO
-- ========================================================================

-- DROP TABLE IF EXISTS pessoas;

-- ========================================================================
-- FIM
-- ========================================================================