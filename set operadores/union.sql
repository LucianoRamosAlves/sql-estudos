/* ========================================================================
   ESTUDO COMPLETO SOBRE O OPERADOR UNION NO SQL
   ========================================================================
   O UNION é um operador de conjuntos (SET operator) que combina 
   os resultados de duas ou mais consultas SELECT em um único 
   resultado, eliminando linhas duplicadas automaticamente.
   
   SUMÁRIO:
   1. Regras fundamentais do UNION
   2. UNION vs UNION ALL
   3. Exemplos práticos com tabelas
   4. Ordenação com ORDER BY
   5. Diferenças entre UNION, INTERSECT e EXCEPT
   ======================================================================== */

-- ========================================================================
-- 1. REGRAS FUNDAMENTAIS DO UNION
-- ========================================================================

/* 
   REGRA #1: Todas as consultas devem ter o MESMO NÚMERO de colunas.
   REGRA #2: Os tipos de dados das colunas correspondentes devem ser 
             compatíveis (podem ser convertidos implicitamente).
   REGRA #3: A ordem das colunas é definida pela PRIMEIRA consulta.
   REGRA #4: O UNION remove duplicatas automaticamente (como SELECT DISTINCT).
   REGRA #5: O nome das colunas no resultado final vem da PRIMEIRA consulta.
*/

-- ========================================================================
-- 2. CRIANDO TABELAS DE EXEMPLO
-- ========================================================================

-- Tabela: clientes_brasil (clientes do Brasil)
CREATE TABLE clientes_brasil (
    id INT PRIMARY KEY,
    nome VARCHAR(100),
    email VARCHAR(100),
    cidade VARCHAR(50)
);

-- Tabela: clientes_portugal (clientes de Portugal)
CREATE TABLE clientes_portugal (
    id INT PRIMARY KEY,
    nome VARCHAR(100),
    email VARCHAR(100),
    cidade VARCHAR(50)
);

-- Inserindo dados no Brasil
INSERT INTO clientes_brasil VALUES 
(1, 'Ana Silva',    'ana@email.com',    'São Paulo'),
(2, 'Carlos Souza', 'carlos@email.com', 'Rio de Janeiro'),
(3, 'Maria Lima',   'maria@email.com',  'Belo Horizonte'),
(4, 'João Santos',  'joao@email.com',   'Curitiba');

-- Inserindo dados em Portugal
INSERT INTO clientes_portugal VALUES 
(1, 'Ana Silva',    'ana@email.com',     'Lisboa'),    -- mesma pessoa do Brasil
(2, 'Rui Costa',    'rui@email.com',     'Porto'),
(3, 'Maria Lima',   'maria@email.com',   'Braga'),     -- mesma pessoa do Brasil
(4, 'Inês Pereira', 'ines@email.com',    'Coimbra');

-- ========================================================================
-- 3. UNION - COMBINANDO E REMOVENDO DUPLICATAS
-- ========================================================================

/*
   EXEMPLO 1: UNION simples
   Queremos uma lista ÚNICA de todos os clientes (sem repetir nomes).
   
   Observe: Ana Silva e Maria Lima aparecem nas DUAS tabelas.
   O UNION vai mostrá-las apenas UMA vez no resultado final.
*/

-- Consulta com UNION (remove duplicatas automaticamente)
SELECT nome, email FROM clientes_brasil
UNION
SELECT nome, email FROM clientes_portugal;

/*
   Resultado esperado (6 linhas - não 8, pois Ana e Maria são únicas):
   
   nome            | email
   ----------------+-----------------
   Ana Silva       | ana@email.com
   Carlos Souza    | carlos@email.com
   Maria Lima      | maria@email.com
   João Santos     | joao@email.com
   Rui Costa       | rui@email.com
   Inês Pereira    | ines@email.com
   
   Repare: Ana Silva e Maria Lima apareceram APENAS UMA VEZ,
   mesmo estando nas duas tabelas. Isso é o UNION fazendo seu trabalho!
*/

-- ========================================================================
-- 4. UNION ALL - COMBINANDO SEM REMOVER DUPLICATAS
-- ========================================================================

/*
   EXEMPLO 2: UNION ALL
   Quando queremos TODAS as linhas, inclusive duplicatas.
   É mais RÁPIDO que o UNION porque não precisa verificar duplicatas.
   
   Use UNION ALL quando:
   - Você SABE que não há duplicatas entre as consultas
   - Você QUER manter as duplicatas
   - Performance é crítica (UNION ALL é mais rápido)
*/

-- Consulta com UNION ALL (MANTÉM duplicatas)
SELECT nome, email FROM clientes_brasil
UNION ALL
SELECT nome, email FROM clientes_portugal;

/*
   Resultado esperado (8 linhas - todas as linhas, incluindo repetições):
   
   nome            | email
   ----------------+-----------------
   Ana Silva       | ana@email.com      <- Brasil
   Carlos Souza    | carlos@email.com   <- Brasil
   Maria Lima      | maria@email.com    <- Brasil
   João Santos     | joao@email.com     <- Brasil
   Ana Silva       | ana@email.com      <- Portugal (duplicada!)
   Rui Costa       | rui@email.com      <- Portugal
   Maria Lima      | maria@email.com    <- Portugal (duplicada!)
   Inês Pereira    | ines@email.com     <- Portugal
   
   Diferença fundamental:
   UNION  = 6 linhas (removeu Ana e Maria repetidas)
   UNION ALL = 8 linhas (manteve TODAS as linhas)
*/

-- ========================================================================
-- 5. UNION COM ORDER BY
-- ========================================================================

/*
   REGRA IMPORTANTE: O ORDER BY só pode ser usado no FINAL de toda
   a consulta UNION, e deve referenciar colunas pelo nome ou posição
   definidos na PRIMEIRA consulta.
   
   NÃO pode ter ORDER BY dentro de cada SELECT individual!
   (A menos que esteja dentro de subconsultas, mas foge do escopo básico)
*/

-- ERRADO (vai dar erro na maioria dos bancos):
-- SELECT nome FROM clientes_brasil ORDER BY nome
-- UNION
-- SELECT nome FROM clientes_portugal;

-- CERTO: ORDER BY no final
SELECT nome, cidade FROM clientes_brasil
UNION
SELECT nome, cidade FROM clientes_portugal
ORDER BY nome;  -- ordena o resultado final por nome

/*
   Resultado esperado (ordenado alfabeticamente):
   
   nome            | cidade
   ----------------+-----------------
   Ana Silva       | São Paulo        <- Só aparece uma vez
   Carlos Souza    | Rio de Janeiro
   Inês Pereira    | Coimbra
   João Santos     | Curitiba
   Maria Lima      | Belo Horizonte   <- Só aparece uma vez
   Rui Costa       | Porto
*/

-- Também pode ordenar por posição da coluna (1 = primeira coluna)
SELECT nome, cidade FROM clientes_brasil
UNION
SELECT nome, cidade FROM clientes_portugal
ORDER BY 1 DESC;  -- ordena pela 1ª coluna (nome) em ordem decrescente

-- ========================================================================
-- 6. UNION COM FILTROS (WHERE)
-- ========================================================================

/*
   Cada SELECT individual pode ter seu próprio WHERE.
   Isso permite filtrar dados de formas diferentes em cada consulta.
*/

-- Exemplo: filtrando clientes de cidades específicas em cada país
SELECT nome, cidade, 'Brasil' AS pais FROM clientes_brasil
WHERE cidade IN ('São Paulo', 'Rio de Janeiro')

UNION

SELECT nome, cidade, 'Portugal' AS pais FROM clientes_portugal
WHERE cidade IN ('Lisboa', 'Porto')

ORDER BY nome;

/*
   Resultado esperado:
   
   nome            | cidade          | pais
   ----------------+-----------------+---------
   Ana Silva       | São Paulo       | Brasil
   Carlos Souza    | Rio de Janeiro  | Brasil
   Rui Costa       | Porto           | Portugal
   
   Note: adicionamos uma coluna literal 'pais' para identificar
   a origem de cada registro (muito útil em relatórios!).
*/

-- ========================================================================
-- 7. COLUNA LITERAL PARA IDENTIFICAR A ORIGEM
-- ========================================================================

/*
   Técnica comum: adicionar uma coluna extra identificando 
   qual tabela cada registro veio.
*/

SELECT nome, email, 'Brasil' AS origem FROM clientes_brasil
UNION ALL
SELECT nome, email, 'Portugal' AS origem FROM clientes_portugal
ORDER BY nome;

/*
   Resultado:
   
   nome            | email             | origem
   ----------------+-------------------+----------
   Ana Silva       | ana@email.com     | Brasil
   Ana Silva       | ana@email.com     | Portugal
   Carlos Souza    | carlos@email.com  | Brasil
   Inês Pereira    | ines@email.com    | Portugal
   João Santos     | joao@email.com    | Brasil
   Maria Lima      | maria@email.com   | Brasil
   Maria Lima      | maria@email.com   | Portugal
   Rui Costa       | rui@email.com     | Portugal
   
   Dica: aqui usamos UNION ALL de propósito para VER as duplicatas
   e saber em qual país cada registro aparece.
*/

-- ========================================================================
-- 8. UNION COM AGRUPAMENTO (GROUP BY)
-- ========================================================================

/*
   Podemos usar GROUP BY no resultado final do UNION.
*/

-- Exemplo: quantidade de clientes por país
SELECT 'Brasil' AS pais, COUNT(*) AS total FROM clientes_brasil
UNION
SELECT 'Portugal' AS pais, COUNT(*) AS total FROM clientes_portugal
ORDER BY pais;

/*
   Resultado:
   
   pais     | total
   ---------+-------
   Brasil   | 4
   Portugal | 4
*/

-- ========================================================================
-- 9. RESUMO: UNION vs UNION ALL vs OUTROS OPERADORES
-- ========================================================================

/*
   OPERADOR    |  O QUE FAZ?                              |  DUPLICATAS?
   ------------+------------------------------------------+--------------
   UNION       |  Combina resultados e remove duplicatas  |  Remove
   UNION ALL   |  Combina resultados, MANTÉM duplicatas   |  Mantém
   INTERSECT   |  Retorna apenas registros COMUNS         |  Remove
   EXCEPT/MINUS|  Retorna registros que estão na 1ª mas   |  Remove
               |  NÃO estão na 2ª consulta                |
   
   REGRA DE OURO:
   - Se você NÃO precisa remover duplicatas, use UNION ALL
   - UNION ALL é MAIS RÁPIDO que UNION
   - UNION faz um SELECT DISTINCT implícito no resultado final
*/

-- ========================================================================
-- 10. LIMPANDO AS TABELAS DE EXEMPLO
-- ========================================================================

-- Descomente as linhas abaixo se quiser remover as tabelas de exemplo:

-- DROP TABLE IF EXISTS clientes_brasil;
-- DROP TABLE IF EXISTS clientes_portugal;

-- ========================================================================
-- FIM DO ESTUDO
-- ========================================================================
