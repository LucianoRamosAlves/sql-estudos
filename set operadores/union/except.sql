/* ========================================================================
   ESTUDO COMPLETO SOBRE O OPERADOR EXCEPT (ou MINUS) NO SQL
   ========================================================================
   O EXCEPT (chamado de MINUS no Oracle) é um operador de conjuntos 
   que retorna os registros que estão na PRIMEIRA consulta, mas NÃO 
   estão na SEGUNDA consulta.
   
   SUMÁRIO:
   1. Regras fundamentais do EXCEPT
   2. EXEMPLO 1: Clientes que só estão no Brasil
   3. EXEMPLO 2: Clientes que só estão em Portugal
   4. EXCEPT vs NOT IN vs NOT EXISTS
   5. Ordenação com ORDER BY
   6. Múltiplos EXCEPT na mesma consulta
   ======================================================================== */

-- ========================================================================
-- 1. REGRAS FUNDAMENTAIS DO EXCEPT
-- ========================================================================

/* 
   REGRA #1: Mesmas regras do UNION (mesmo nº de colunas, tipos compatíveis)
   REGRA #2: A ORDEM importa! EXCEPT NÃO é comutativo
             A - B é DIFERENTE de B - A
   REGRA #3: Remove duplicatas automaticamente (como SELECT DISTINCT)
   REGRA #4: O nome das colunas vem da PRIMEIRA consulta
   
   Analogia matemática:
   EXCEPT = diferença entre conjuntos (A - B)
   A = {1, 2, 3, 4}   B = {3, 4, 5, 6}
   A EXCEPT B = {1, 2}  (o que tem em A mas não em B)
*/

-- ========================================================================
-- 2. RECRIANDO AS TABELAS DE EXEMPLO
-- ========================================================================

-- Tabela: clientes_brasil
CREATE TABLE clientes_brasil (
    id INT PRIMARY KEY,
    nome VARCHAR(100),
    email VARCHAR(100),
    cidade VARCHAR(50)
);

-- Tabela: clientes_portugal
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
(4, 'João Santos',  'joao@email.com',   'Curitiba'),
(5, 'Pedro Alves',  'pedro@email.com',  'Salvador');

-- Inserindo dados em Portugal
INSERT INTO clientes_portugal VALUES 
(1, 'Ana Silva',    'ana@email.com',     'Lisboa'),   -- mesma pessoa
(2, 'Rui Costa',    'rui@email.com',     'Porto'),
(3, 'Maria Lima',   'maria@email.com',   'Braga'),    -- mesma pessoa
(4, 'Inês Pereira', 'ines@email.com',    'Coimbra');

-- ========================================================================
-- 3. EXEMPLO 1: QUEM ESTÁ NO BRASIL MAS NÃO EM PORTUGAL?
-- ========================================================================

/*
   Pergunta: Quais clientes estão cadastrados no Brasil 
   mas NÃO estão cadastrados em Portugal?
   
   Conjunto Brasil = {Ana, Carlos, Maria, João, Pedro}
   Conjunto Portugal = {Ana, Rui, Maria, Inês}
   
   Brasil EXCEPT Portugal = {Carlos, João, Pedro}
   (Ana e Maria estão nos DOIS, então são excluídas)
*/

SELECT nome, email FROM clientes_brasil
EXCEPT
SELECT nome, email FROM clientes_portugal;

/*
   Resultado esperado (3 linhas):
   
   nome            | email
   ----------------+-----------------
   Carlos Souza    | carlos@email.com
   João Santos     | joao@email.com
   Pedro Alves     | pedro@email.com
   
   Explicação:
   - Ana e Maria foram EXCLUÍDAS porque existem em AMBAS as tabelas
   - Carlos, João e Pedro só existem no Brasil, então aparecem
*/

-- ========================================================================
-- 4. EXEMPLO 2: QUEM ESTÁ EM PORTUGAL MAS NÃO NO BRASIL? (ORDEM INVERSA)
-- ========================================================================

/*
   Aqui mostramos que a ORDEM IMPORTA!
   Agora a primeira consulta é Portugal, segunda é Brasil.
*/

SELECT nome, email FROM clientes_portugal
EXCEPT
SELECT nome, email FROM clientes_brasil;

/*
   Resultado esperado (2 linhas):
   
   nome            | email
   ----------------+-----------------
   Rui Costa       | rui@email.com
   Inês Pereira    | ines@email.com
   
   Importante: O mesmo EXCEPT, mas invertendo a ordem,
   deu resultados COMPLETAMENTE DIFERENTES!
   
   Brasil EXCEPT Portugal = {Carlos, João, Pedro}
   Portugal EXCEPT Brasil = {Rui, Inês}
   
   Isso prova que EXCEPT NÃO é comutativo (A - B ≠ B - A)
*/

-- ========================================================================
-- 5. EXCEPT COM ORDER BY
-- ========================================================================

/*
   O ORDER BY sempre vai no FINAL, igual no UNION.
*/

SELECT nome, email, cidade FROM clientes_brasil
EXCEPT
SELECT nome, email, cidade FROM clientes_portugal
ORDER BY nome;

/*
   Resultado (ordenado por nome):
   
   nome            | email             | cidade
   ----------------+-------------------+---------------
   Carlos Souza    | carlos@email.com  | Rio de Janeiro
   João Santos     | joao@email.com    | Curitiba
   Pedro Alves     | pedro@email.com   | Salvador
*/

-- ========================================================================
-- 6. EXCEPT COM COLUNA LITERAL
-- ========================================================================

/*
   Identificando a origem dos dados com coluna literal.
*/

SELECT nome, email, cidade, 'Apenas no Brasil' AS status FROM clientes_brasil
EXCEPT
SELECT nome, email, cidade, 'Apenas no Brasil' FROM clientes_portugal
ORDER BY nome;

/*
   Resultado:
   
   nome            | email             | cidade          | status
   ----------------+-------------------+-----------------+------------------
   Carlos Souza    | carlos@email.com  | Rio de Janeiro  | Apenas no Brasil
   João Santos     | joao@email.com    | Curitiba        | Apenas no Brasil
   Pedro Alves     | pedro@email.com   | Salvador        | Apenas no Brasil
*/

-- ========================================================================
-- 7. EXCEPT vs NOT IN (FORMA ALTERNATIVA)
-- ========================================================================

/*
   O EXCEPT pode ser substituído por NOT IN ou NOT EXISTS.
   Cada abordagem tem suas vantagens:
   
   EXCEPT:    Mais LIMPO e LEGÍVEL para diferença entre conjuntos
   NOT IN:    Útil quando precisa de condições adicionais
   NOT EXISTS: MAIS EFICIENTE em muitos bancos de dados
*/

-- Forma com NOT IN (mesmo resultado do EXCEPT)
SELECT nome, email FROM clientes_brasil
WHERE email NOT IN (
    SELECT email FROM clientes_portugal
);

-- Forma com NOT EXISTS (geralmente mais performática)
SELECT b.nome, b.email FROM clientes_brasil b
WHERE NOT EXISTS (
    SELECT 1 FROM clientes_portugal p
    WHERE p.email = b.email
);

/*
   Resultado dos 3 métodos é o mesmo:
   
   nome            | email
   ----------------+-----------------
   Carlos Souza    | carlos@email.com
   João Santos     | joao@email.com
   Pedro Alves     | pedro@email.com
   
   Qual usar?
   - EXCEPT: quando quer diferença COMPLETA entre conjuntos
   - NOT EXISTS: melhor performance com tabelas grandes
   - NOT IN: cuidado com NULLS! Se a subconsulta retornar NULL,
             o NOT IN retorna vazio (comportamento inesperado)
*/

-- ========================================================================
-- 8. EXCEPT COM MÚLTIPLAS TABELAS
-- ========================================================================

/*
   Podemos usar vários EXCEPT em sequência.
   Exemplo: registros que estão no Brasil, mas não em Portugal nem na Espanha
*/

-- Criando uma terceira tabela
CREATE TABLE clientes_espanha (
    id INT PRIMARY KEY,
    nome VARCHAR(100),
    email VARCHAR(100),
    cidade VARCHAR(50)
);

INSERT INTO clientes_espanha VALUES 
(1, 'Maria Lima',   'maria@email.com',   'Madrid'),   -- também está no BR e PT
(2, 'Luis Garcia',  'luis@email.com',    'Barcelona');

-- Quem está no Brasil, mas NÃO está em Portugal E NÃO está na Espanha?
SELECT nome, email FROM clientes_brasil
EXCEPT
SELECT nome, email FROM clientes_portugal
EXCEPT
SELECT nome, email FROM clientes_espanha;

/*
   Resultado:
   
   nome            | email
   ----------------+-----------------
   Carlos Souza    | carlos@email.com
   João Santos     | joao@email.com
   Pedro Alves     | pedro@email.com
   
   Maria foi removida porque está em Portugal E na Espanha
   Ana foi removida porque está em Portugal
*/

-- ========================================================================
-- 9. RESUMO VISUAL
-- ========================================================================

/*
   CONJUNTOS:
   
   Brasil (B): {Ana, Carlos, Maria, João, Pedro}
   Portugal (P): {Ana, Rui, Maria, Inês}
   Espanha (E): {Maria, Luis}
   
   OPERAÇÕES:
   
   B EXCEPT P  = {Carlos, João, Pedro}  (brasileiros exclusivos)
   P EXCEPT B  = {Rui, Inês}            (portugueses exclusivos)  
   B EXCEPT E  = {Ana, Carlos, João, Pedro} (Maria está na Espanha)
   
   B EXCEPT P EXCEPT E = {Carlos, João, Pedro}
   (Ana: está em Portugal → removida)
   (Maria: está em Portugal e Espanha → removida)
   
   COMPARAÇÃO COM OUTROS OPERADORES:
   
   OPERADOR    |  O QUE FAZ?                              |  RESULTADO (B e P)
   ------------+------------------------------------------+---------------------
   UNION       |  Todos da B + todos da P (sem repetir)   | {Ana,Carlos,Maria,
               |                                          |  João,Pedro,Rui,Inês}
   UNION ALL   |  Todos da B + todos da P (repete)        | {Ana,Carlos,Maria,
               |                                          |  João,Pedro,Ana,Rui,
               |                                          |  Maria,Inês}
   INTERSECT   |  Quem está em B E em P (comum)           | {Ana, Maria}
   EXCEPT      |  Quem está em B mas NÃO em P             | {Carlos, João, Pedro}
*/

-- ========================================================================
-- 10. ATENÇÃO: EXCEPT vs MINUS
-- ========================================================================

/*
   Dependendo do banco de dados, o nome muda:
   
   PostgreSQL, SQL Server, SQLite: EXCEPT
   Oracle:                        MINUS (mesma função, nome diferente)
   MySQL:                         Não tem EXCEPT (use NOT IN ou NOT EXISTS)
   
   O comportamento é IDÊNTICO, só muda o nome!
*/

-- ========================================================================
-- 11. LIMPANDO AS TABELAS DE EXEMPLO
-- ========================================================================

-- Descomente se quiser remover as tabelas:
-- DROP TABLE IF EXISTS clientes_brasil;
-- DROP TABLE IF EXISTS clientes_portugal;
-- DROP TABLE IF EXISTS clientes_espanha;

-- ========================================================================
-- FIM DO ESTUDO
-- ========================================================================
