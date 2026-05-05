-- =============================================================================
-- USING vs ON - DIFERENÇAS E QUANDO USAR CADA UM
-- =============================================================================
-- Tanto USING quanto ON servem para especificar a condição de junção.
-- Mas há diferenças importantes:
--
-- ON:  Mais flexível, permite qualquer condição (=, >, <, AND, OR, etc.)
-- USING: Mais conciso, mas só funciona quando as colunas têm o MESMO NOME
-- =============================================================================

-- CONFIGURAÇÃO
-- =============================================================================
CREATE DATABASE IF NOT EXISTS estudos_joins;
USE estudos_joins;

DROP TABLE IF EXISTS pedidos;
DROP TABLE IF EXISTS clientes;

CREATE TABLE clientes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100),
    email VARCHAR(100)
);

CREATE TABLE pedidos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    cliente_id INT,              -- Nome DIFERENTE da coluna em clientes
    produto VARCHAR(100),
    valor DECIMAL(10, 2)
);

INSERT INTO clientes VALUES
(1, 'Ana', 'ana@email.com'),
(2, 'Bruno', 'bruno@email.com'),
(3, 'Carla', 'carla@email.com');

INSERT INTO pedidos VALUES
(1, 1, 'Notebook', 2500.00),
(2, 1, 'Mouse', 50.00),
(3, 2, 'Teclado', 150.00);

-- =============================================================================
-- EXEMPLO 1: USANDO ON (SEMPRE FUNCIONA)
-- =============================================================================
-- ON precisa especificar tabela.coluna para cada lado
-- =============================================================================

SELECT c.nome, p.produto, p.valor
FROM clientes c
INNER JOIN pedidos p ON c.id = p.cliente_id;  -- Colunas com nomes diferentes

-- Funciona perfeitamente porque especificamos c.id = p.cliente_id


-- =============================================================================
-- EXEMPLO 2: TENTANDO USING (NÃO FUNCIONA AQUI!)
-- =============================================================================
-- USING só funciona se as colunas tiverem o MESMO NOME em ambas as tabelas
-- =============================================================================

-- Isto daria ERRO:
-- SELECT c.nome, p.produto
-- FROM clientes c
-- INNER JOIN pedidos p USING (id);  -- ERRO! 'id' existe nas duas mas não é a chave

-- USING (cliente_id) também daria erro porque clientes não tem cliente_id


-- =============================================================================
-- EXEMPLO 3: QUANDO USING FUNCIONA (COLUNAS COM MESMO NOME)
-- =============================================================================
-- Vamos criar tabelas com colunas de mesmo nome
-- =============================================================================

CREATE TABLE usuarios (
    usuario_id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100)
);

CREATE TABLE permissoes (
    usuario_id INT,
    permissao VARCHAR(50),
    PRIMARY KEY (usuario_id, permissao)
);

INSERT INTO usuarios VALUES (1, 'Ana'), (2, 'Bruno'), (3, 'Carla');
INSERT INTO permissoes VALUES
(1, 'admin'), (1, 'editor'),
(2, 'leitor'),
(3, 'admin');

-- COM ON:
SELECT u.nome, p.permissao
FROM usuarios u
INNER JOIN permissoes p ON u.usuario_id = p.usuario_id;

-- COM USING (mais limpo, mesmo resultado):
SELECT u.nome, p.permissao
FROM usuarios u
INNER JOIN permissoes p USING (usuario_id);  -- Mesmo nome nas duas tabelas!

-- Ambos produzem o mesmo resultado:
-- +-------+-----------+
-- | nome  | permissao |
-- +-------+-----------+
-- | Ana   | admin     |
-- | Ana   | editor    |
-- | Bruno | leitor    |
-- | Carla | admin     |
-- +-------+-----------+


-- =============================================================================
-- EXEMPLO 4: DIFERENÇA NO SELECT - USING NÃO DUPLICA A COLUNA
-- =============================================================================
-- A principal diferença prática está nas colunas selecionadas
-- =============================================================================

-- COM ON: a coluna de junção aparece DUAS vezes se você usar *
SELECT *
FROM usuarios u
INNER JOIN permissoes p ON u.usuario_id = p.usuario_id;
-- Resultado: usuario_id, nome, usuario_id, permissao
--           (usuario_id aparece 2 vezes!)

-- COM USING: a coluna de junção aparece UMA vez
SELECT *
FROM usuarios u
INNER JOIN permissoes p USING (usuario_id);
-- Resultado: usuario_id, nome, permissao
--           (usuario_id aparece 1 vez só!)


-- =============================================================================
-- EXEMPLO 5: USING COM MÚLTIPLAS COLUNAS
-- =============================================================================
-- Quando a junção precisa de mais de uma coluna com mesmo nome
-- =============================================================================

CREATE TABLE turma_a (
    disciplina VARCHAR(50),
    semestre INT,
    aluno VARCHAR(100)
);

CREATE TABLE turma_b (
    disciplina VARCHAR(50),
    semestre INT,
    aluno VARCHAR(100)
);

INSERT INTO turma_a VALUES
('Matemática', 1, 'Ana'),
('Matemática', 1, 'Bruno'),
('Português', 1, 'Ana');

INSERT INTO turma_b VALUES
('Matemática', 1, 'Ana'),    -- Ana está nas duas turmas de Matemática
('Matemática', 1, 'Carla'),
('Português', 1, 'Bruno');

-- Alunos que estão nas duas turmas na MESMA disciplina e semestre
SELECT *
FROM turma_a a
INNER JOIN turma_b b 
    USING (disciplina, semestre, aluno);  -- Múltiplas colunas!

-- Equivalente com ON:
SELECT a.*
FROM turma_a a
INNER JOIN turma_b b 
    ON a.disciplina = b.disciplina 
    AND a.semestre = b.semestre 
    AND a.aluno = b.aluno;

-- USING é bem mais limpo para múltiplas colunas com mesmo nome!


-- =============================================================================
-- EXEMPLO 6: LEFT/RIGHT JOIN COM USING
-- =============================================================================
-- USING funciona com qualquer tipo de JOIN
-- =============================================================================

SELECT u.nome, p.permissao
FROM usuarios u
LEFT JOIN permissoes p USING (usuario_id);

-- Todos os usuários, mesmo sem permissão
-- +-------+-----------+
-- | nome  | permissao |
-- +-------+-----------+
-- | Ana   | admin     |
-- | Ana   | editor    |
-- | Bruno | leitor    |
-- | Carla | admin     |
-- +-------+-----------+

-- Se houver um usuário sem permissão, apareceria com NULL


-- =============================================================================
-- EXEMPLO 7: NATURAL JOIN (EVITE USAR!)
-- =============================================================================
-- MySQL tem NATURAL JOIN que junta automaticamente por colunas de mesmo nome
-- ⚠️ PERIGOSO: Pode juntar por colunas que você não quer!
-- =============================================================================

SELECT *
FROM usuarios
NATURAL JOIN permissoes;
-- Junta automaticamente por todas as colunas com mesmo nome

-- ⚠️ POR QUE EVITAR:
-- 1. Pega implicitamente TODAS as colunas com mesmo nome
-- 2. Se adicionar uma coluna nova com nome igual em outra tabela, quebra
-- 3. Código fica menos legível (não fica explícito o que está juntando)
-- 4. Pode causar bugs silenciosos


-- =============================================================================
-- TABELA COMPARATIVA
-- =============================================================================
/*
╔══════════════════════════════════════════════════════════════════════════════╗
║                   ON                    │            USING                  ║
╠═════════════════════════════════════════╪════════════════════════════════════╣
║  SELECT * duplica a coluna de junção   │  SELECT * NÃO duplica a coluna    ║
║                                         │                                    ║
║  Funciona com QUALQUER condição         │  Só funciona com IGUALDADE (=)    ║
║  (>, <, LIKE, BETWEEN, etc.)           │                                    ║
║                                         │                                    ║
║  Colunas podem ter nomes DIFERENTES     │  Colunas PRECISAM ter MESMO nome  ║
║                                         │                                    ║
║  Precisa especificar tabela.coluna      │  Não precisa de alias na condição ║
║                                         │                                    ║
║  Mais VERBOSO                           │  Mais CONCISO                      ║
║                                         │                                    ║
║  Padrão da indústria (mais usado)       │  Menos comum, mas útil            ║
╚═════════════════════════════════════════╪════════════════════════════════════╝
║                                                                              ║
║  REGRA DE OURO:                                                              ║
║  - Use ON quando as colunas têm nomes DIFERENTES ou condição COMPLEXA       ║
║  - Use USING quando as colunas têm o MESMO nome e condição simples (=)      ║
║  - NUNCA use NATURAL JOIN (muito implícito, propenso a erros)               ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝
*/

-- LIMPEZA (opcional)
-- DROP DATABASE IF EXISTS estudos_joins;
