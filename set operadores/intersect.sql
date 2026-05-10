/* ========================================================================
   ESTUDO COMPLETO SOBRE O OPERADOR INTERSECT NO SQL
   ========================================================================
   O INTERSECT é um operador de conjuntos que retorna apenas os 
   registros que estão PRESENTES EM AMBAS as consultas (a interseção
   entre os dois conjuntos).
   
   SUMÁRIO:
   1. Regras fundamentais do INTERSECT
   2. EXEMPLO 1: Clientes que estão no Brasil E em Portugal
   3. EXEMPLO 2: INTERSECT com mais de 2 tabelas
   4. INTERSECT vs INNER JOIN vs EXISTS
   5. INTERSECT vs UNION vs EXCEPT (comparação prática)
   6. Casos de uso reais do INTERSECT
   ======================================================================== */

-- ========================================================================
-- 1. REGRAS FUNDAMENTAIS DO INTERSECT
-- ========================================================================

/* 
   REGRA #1: Mesmas regras dos outros operadores de conjunto
             (mesmo nº de colunas, tipos compatíveis)
   REGRA #2: A ordem NÃO importa! Diferente do EXCEPT,
             INTERSECT é COMUTATIVO: A ∩ B = B ∩ A
   REGRA #3: Remove duplicatas automaticamente
   REGRA #4: O nome das colunas vem da PRIMEIRA consulta
   
   Analogia matemática:
   INTERSECT = interseção entre conjuntos (A ∩ B)
   A = {1, 2, 3, 4}   B = {3, 4, 5, 6}
   A INTERSECT B = {3, 4}  (o que está em AMBOS)
   
   Diagrama de Venn:
   
       ┌─────────┐         ┌─────────┐
       │  A      │   ∩     │    B    │
       │ {1,2}   │◄─{3,4}─►│  {5,6}  │
       │         │ INTERSECT         │
       └─────────┘         └─────────┘
              └──────┬──────┘
                     ↓
               A ∩ B = {3, 4}
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

-- Inserindo dados
INSERT INTO clientes_brasil VALUES 
(1, 'Ana Silva',    'ana@email.com',     'São Paulo'),
(2, 'Carlos Souza', 'carlos@email.com',  'Rio de Janeiro'),
(3, 'Maria Lima',   'maria@email.com',   'Belo Horizonte'),
(4, 'João Santos',  'joao@email.com',    'Curitiba'),
(5, 'Pedro Alves',  'pedro@email.com',   'Salvador');

INSERT INTO clientes_portugal VALUES 
(1, 'Ana Silva',    'ana@email.com',     'Lisboa'),      -- comum
(2, 'Rui Costa',    'rui@email.com',     'Porto'),
(3, 'Maria Lima',   'maria@email.com',   'Braga'),       -- comum
(4, 'Inês Pereira', 'ines@email.com',    'Coimbra');

-- ========================================================================
-- 3. EXEMPLO 1: QUEM ESTÁ NO BRASIL E TAMBÉM EM PORTUGAL?
-- ========================================================================

/*
   Pergunta: Quais clientes estão cadastrados tanto no Brasil 
             quanto em Portugal?
   
   Conjunto Brasil  = {Ana, Carlos, Maria, João, Pedro}
   Conjunto Portugal = {Ana, Rui, Maria, Inês}
   
   Brasil INTERSECT Portugal = {Ana, Maria}
   (as únicas pessoas que existem nas duas tabelas)
*/

SELECT nome, email FROM clientes_brasil
INTERSECT
SELECT nome, email FROM clientes_portugal;

/*
   Resultado esperado (2 linhas):
   
   nome            | email
   ----------------+-----------------
   Ana Silva       | ana@email.com
   Maria Lima      | maria@email.com
   
   Interpretação: Ana e Maria são as únicas clientes que 
   possuem cadastro tanto no Brasil quanto em Portugal.
   
   Perfeito para identificar clientes que atuam em 
   múltiplos países!
*/

-- ========================================================================
-- 4. EXEMPLO 2: A ORDEM NÃO IMPORTA (COMUTATIVIDADE)
-- ========================================================================

/*
   Diferente do EXCEPT, no INTERSECT a ORDEM NÃO FAZ DIFERENÇA.
   O resultado é sempre o mesmo.
*/

-- Consulta 1: Brasil INTERSECT Portugal
SELECT nome, email FROM clientes_brasil
INTERSECT
SELECT nome, email FROM clientes_portugal;

-- Consulta 2: Portugal INTERSECT Brasil (ORDEM INVERSA)
SELECT nome, email FROM clientes_portugal
INTERSECT
SELECT nome, email FROM clientes_brasil;

/*
   Ambas as consultas retornam EXATAMENTE o mesmo resultado:
   
   nome            | email
   ----------------+-----------------
   Ana Silva       | ana@email.com
   Maria Lima      | maria@email.com
   
   Diferente do EXCEPT (A-B ≠ B-A), o INTERSECT é COMUTATIVO:
   A ∩ B = B ∩ A  →  Sempre!
*/

-- ========================================================================
-- 5. EXEMPLO 3: INTERSECT COM MAIS DE 2 TABELAS
-- ========================================================================

/*
   Queremos saber quem está NO BRASIL, EM PORTUGAL E NA ESPANHA.
   Ou seja, clientes globais presentes nos 3 países.
*/

CREATE TABLE clientes_espanha (
    id INT PRIMARY KEY,
    nome VARCHAR(100),
    email VARCHAR(100),
    cidade VARCHAR(50)
);

INSERT INTO clientes_espanha VALUES 
(1, 'Maria Lima',   'maria@email.com',   'Madrid'),       -- comum nos 3
(2, 'Luis Garcia',  'luis@email.com',    'Barcelona'),
(3, 'Ana Silva',    'ana@email.com',     'Sevilla');      -- comum nos 3 também

-- Quem está nos 3 países ao mesmo tempo?
SELECT nome, email FROM clientes_brasil
INTERSECT
SELECT nome, email FROM clientes_portugal
INTERSECT
SELECT nome, email FROM clientes_espanha;

/*
   Resultado:
   
   nome            | email
   ----------------+-----------------
   Ana Silva       | ana@email.com
   Maria Lima      | maria@email.com
   
   Interpretação: Ana e Maria são clientes GLOBAIS, 
   presentes nos 3 países!
   
   Pensando em conjuntos:
   Brasil ∩ Portugal ∩ Espanha = {Ana, Maria}
   
   Passo a passo:
   1º: Brasil ∩ Portugal = {Ana, Maria}
   2º: {Ana, Maria} ∩ Espanha = {Ana, Maria}
*/

-- ========================================================================
-- 6. INTERSECT COM ORDER BY
-- ========================================================================

SELECT nome, email, cidade FROM clientes_brasil
INTERSECT
SELECT nome, email, cidade FROM clientes_portugal
ORDER BY nome;

/*
   Resultado:
   
   nome            | email             | cidade
   ----------------+-------------------+-----------------
   Ana Silva       | ana@email.com     | São Paulo
   Maria Lima      | maria@email.com   | Belo Horizonte
   
   OBS: A cidade veio da PRIMEIRA consulta (clientes_brasil).
   Se invertêssemos a ordem, viriam as cidades de Portugal!
*/

-- ========================================================================
-- 7. INTERSECT vs INNER JOIN (FORMA ALTERNATIVA)
-- ========================================================================

/*
   O INTERSECT pode ser substituído por um INNER JOIN ou EXISTS.
   
   INTERSECT:   Mais limpo, compara CONJUNTOS INTEIROS
   INNER JOIN:  Mais flexível, permite colunas extras
   EXISTS:      Geralmente mais performático
*/

-- Forma com INNER JOIN
SELECT DISTINCT b.nome, b.email
FROM clientes_brasil b
INNER JOIN clientes_portugal p 
    ON b.email = p.email;

-- Forma com EXISTS
SELECT b.nome, b.email
FROM clientes_brasil b
WHERE EXISTS (
    SELECT 1 FROM clientes_portugal p
    WHERE p.email = b.email
);

/*
   Todos retornam o mesmo resultado:
   
   nome            | email
   ----------------+-----------------
   Ana Silva       | ana@email.com
   Maria Lima      | maria@email.com
   
   INTERSECT vs JOIN:
   
   Característica        | INTERSECT  | INNER JOIN
   ----------------------+------------+---------------
   Colunas extras        | ❌ Não     | ✅ Sim
   (ex: trazer cidade)   |            |
   Duplicatas            | Remove     | Pode gerar
   Legibilidade          | ✅ Melhor  | ⚠️ Médio
   Performance           | ⚠️ Médio   | ✅ Melhor
*/

-- Exemplo onde JOIN é melhor (precisa de mais colunas)
SELECT b.nome, b.email, b.cidade AS cidade_brasil, 
       p.cidade AS cidade_portugal
FROM clientes_brasil b
INNER JOIN clientes_portugal p 
    ON b.email = p.email;

/*
   Resultado:
   
   nome         | email            | cidade_brasil   | cidade_portugal
   -------------+------------------+-----------------+-----------------
   Ana Silva    | ana@email.com    | São Paulo       | Lisboa
   Maria Lima   | maria@email.com  | Belo Horizonte  | Braga
   
   O INTERSECT NÃO permite esse tipo de consulta com colunas 
   extras de ambas as tabelas. Para isso, use JOIN.
*/

-- ========================================================================
-- 8. INTERSECT vs EXISTS (EFICIÊNCIA)
-- ========================================================================

/*
   Em bancos como PostgreSQL, o EXISTS geralmente é mais eficiente
   que o INTERSECT, especialmente com tabelas grandes.
   
   Regra prática:
   - Tabelas PEQUENAS: INTERSECT (mais legível)
   - Tabelas GRANDES: EXISTS (mais rápido)
   - Precisa de colunas extras: JOIN
*/

-- Com EXISTS (mais rápido em tabelas grandes)
SELECT nome, email, cidade FROM clientes_brasil b
WHERE EXISTS (
    SELECT 1 FROM clientes_portugal p
    WHERE p.email = b.email
)
ORDER BY nome;

/*
   Mesmo resultado do INTERSECT, mas geralmente mais eficiente.
*/

-- ========================================================================
-- 9. COMPARAÇÃO COMPLETA: UNION vs INTERSECT vs EXCEPT
-- ========================================================================

/*
   Usando os mesmos dados de exemplo:
   
   Brasil  (B) = {Ana, Carlos, Maria, João, Pedro}
   Portugal(P) = {Ana, Rui, Maria, Inês}
   
   ┌────────────────────────────────────────────────────────────┐
   │                       BRASIL                               │
   │   ┌───────────┐                                            │
   │   │ Ana       │                                            │
   │   │ Maria     │  ◄── INTERSECT ──►  ┌───────────┐         │
   │   ├───────────┤                     │ Ana       │         │
   │   │ Carlos    │                     │ Maria     │         │
   │   │ João      │                     ├───────────┤         │
   │   │ Pedro     │                     │ Rui       │         │
   │   └───────────┘                     │ Inês      │         │
   │         │                           └───────────┘         │
   │         │                              │                  │
   │         └─────── EXCEPT ───────────────┘                  │
   │                    {Carlos, João, Pedro}                  │
   └────────────────────────────────────────────────────────────┘
   
   OPERAÇÃO        |  RESULTADO                     | LINHAS
   ----------------+---------------+-----------------+-------
   UNION           |  Todos (sem repetir)           |  7
   UNION ALL       |  Todos (com repetição)         |  9
   INTERSECT       |  Presentes em AMBOS            |  2 (Ana, Maria)
   EXCEPT (B - P)  |  Só no BRASIL                  |  3 (Carlos, João, Pedro)
   EXCEPT (P - B)  |  Só em PORTUGAL                |  2 (Rui, Inês)
*/

-- ========================================================================
-- 10. CASOS DE USO REAIS DO INTERSECT
-- ========================================================================

/*
   O INTERSECT é muito útil em situações como:
   
   1. CLIENTES COMUNS: Quem comprou nos dois sites (loja física e online)
   2. ALUNOS MATRICULADOS: Quem está em duas turmas ao mesmo tempo
   3. FUNCIONÁRIOS: Quem trabalha em dois departamentos
   4. PRODUTOS: Itens que estão em mais de um armazém
   5. USUÁRIOS: Quem tem permissão em múltiplos sistemas
*/

-- Exemplo de caso real: alunos matriculados em 2 cursos
CREATE TABLE alunos_matematica (
    id INT PRIMARY KEY,
    nome VARCHAR(100),
    email VARCHAR(100)
);

CREATE TABLE alunos_fisica (
    id INT PRIMARY KEY,
    nome VARCHAR(100),
    email VARCHAR(100)
);

INSERT INTO alunos_matematica VALUES 
(1, 'João',   'joao@email.com'),
(2, 'Maria',  'maria@email.com'),
(3, 'Pedro',  'pedro@email.com');

INSERT INTO alunos_fisica VALUES 
(1, 'Ana',    'ana@email.com'),
(2, 'Maria',  'maria@email.com'),     -- Maria está nos 2
(3, 'Carlos', 'carlos@email.com');

-- Quem está matriculado em AMBOS os cursos?
SELECT nome, email FROM alunos_matematica
INTERSECT
SELECT nome, email FROM alunos_fisica;

/*
   Resultado:
   
   nome   | email
   -------+-----------------
   Maria  | maria@email.com
   
   Apenas Maria está matriculada em Matemática e Física.
   Ótimo para identificar alunos com dupla matrícula!
*/

-- ========================================================================
-- 11. INTERSECT COM FILTROS (WHERE)
-- ========================================================================

/*
   Cada SELECT pode ter seu próprio WHERE antes do INTERSECT.
*/

-- Clientes do Brasil (de SP ou RJ) que também estão em Portugal
SELECT nome, email FROM clientes_brasil
WHERE cidade IN ('São Paulo', 'Rio de Janeiro')
INTERSECT
SELECT nome, email FROM clientes_portugal;

/*
   Resultado:
   
   nome            | email
   ----------------+-----------------
   Ana Silva       | ana@email.com
   
   Explicação:
   - Maria é de BH, então foi filtrada pelo WHERE
   - Ana é de São Paulo, passou pelo filtro E está em Portugal
*/

-- ========================================================================
-- 12. LIMPANDO AS TABELAS DE EXEMPLO
-- ========================================================================

-- Descomente se quiser remover as tabelas:
-- DROP TABLE IF EXISTS clientes_brasil;
-- DROP TABLE IF EXISTS clientes_portugal;
-- DROP TABLE IF EXISTS clientes_espanha;
-- DROP TABLE IF EXISTS alunos_matematica;
-- DROP TABLE IF EXISTS alunos_fisica;

-- ========================================================================
-- FIM DO ESTUDO
-- ========================================================================
