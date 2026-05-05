-- =============================================================================
-- SELF JOIN - JUNTANDO UMA TABELA COM ELA MESMA
-- =============================================================================
-- SELF JOIN é quando uma tabela é JUNTADA com ela mesma.
-- Isso é útil para dados HIERÁRQUICOS ou RELACIONAIS dentro da mesma tabela.
--
-- Funciona criando "cópias virtuais" da tabela com ALIAS diferentes.
--
--      funcionarios (tabela)
--      ┌────┬──────────┬────────────┐
--      │ id │  nome    │ gerente_id │
--      ├────┼──────────┼────────────┤
--      │  1 │ João     │      NULL  │ ← Chefão (não tem gerente)
--      │  2 │ Maria    │         1  │ ← Gerente de Maria é João
--      │  3 │ Pedro    │         1  │ ← Gerente de Pedro é João
--      └────┴──────────┴────────────┘
--
--       f1 (funcionario)    f2 (gerente)
--      ┌──────────┐        ┌──────────┐
--      │  Maria   │────────►│  João    │
--      │  Pedro   │────────►│  João    │
--      └──────────┘        └──────────┘
-- =============================================================================

-- CONFIGURAÇÃO DO BANCO
-- =============================================================================
CREATE DATABASE IF NOT EXISTS estudos_joins;
USE estudos_joins;

DROP TABLE IF EXISTS funcionarios;
DROP TABLE IF EXISTS categorias;
DROP TABLE IF EXISTS cursos;

-- =============================================================================
-- EXEMPLO 1: ESTRUTURA HIERÁRQUICA - Funcionários e Gerentes
-- =============================================================================
-- Cenário clássico: uma tabela de funcionários onde cada um
-- pode ter um gerente que também é funcionário
-- =============================================================================

CREATE TABLE funcionarios (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    cargo VARCHAR(50),
    gerente_id INT,               -- NULL = é o chefe máximo
    salario DECIMAL(10, 2),
    data_contratacao DATE,
    
    -- Chave estrangeira referenciando a PRÓPRIA tabela
    FOREIGN KEY (gerente_id) REFERENCES funcionarios(id)
);

INSERT INTO funcionarios (nome, cargo, gerente_id, salario, data_contratacao) VALUES
('João CEO',       'CEO',           NULL, 50000.00, '2020-01-01'),  -- Nível 1: Chefe máximo
('Maria Diretora', 'Diretora',      1,    30000.00, '2020-06-01'),  -- Nível 2: Gerente = João
('Pedro Diretor',  'Diretor',       1,    28000.00, '2020-07-01'),  -- Nível 2: Gerente = João
('Ana Gerente',    'Gerente',       2,    15000.00, '2021-01-01'),  -- Nível 3: Gerente = Maria
('Bruno Gerente',  'Gerente',       2,    14000.00, '2021-02-01'),  -- Nível 3: Gerente = Maria
('Carla Gerente',  'Gerente',       3,    14500.00, '2021-03-01'),  -- Nível 3: Gerente = Pedro
('Daniel Dev',     'Desenvolvedor', 4,    8000.00,  '2022-01-01'),  -- Nível 4: Gerente = Ana
('Eduarda Dev',    'Desenvolvedor', 4,    8500.00,  '2022-02-01'),  -- Nível 4: Gerente = Ana
('Fernando Dev',   'Desenvolvedor', 5,    7800.00,  '2022-03-01'),  -- Nível 4: Gerente = Bruno
('Gabriela Dev',   'Desenvolvedor', 6,    8200.00,  '2022-04-01'),  -- Nível 4: Gerente = Carla
('Hugo Estágio',   'Estagiário',    7,    2000.00,  '2023-01-01'),  -- Nível 5: Gerente = Daniel
('Isabela Estágio','Estagiário',    7,    2000.00,  '2023-02-01');  -- Nível 5: Gerente = Daniel


-- SELF JOIN: Listar cada funcionário com seu gerente
SELECT 
    f.nome AS funcionario,
    f.cargo AS cargo_funcionario,
    g.nome AS gerente,
    g.cargo AS cargo_gerente
FROM funcionarios f                    -- f = funcionario (tabela principal)
LEFT JOIN funcionarios g               -- g = gerente (mesma tabela, alias diferente)
ON f.gerente_id = g.id;                -- Condição: gerente_id = id do gerente

-- RESULTADO ESPERADO:
-- +------------------+---------------------+-----------------+---------------+
-- | funcionario      | cargo_funcionario   | gerente         | cargo_gerente |
-- +------------------+---------------------+-----------------+---------------+
-- | João CEO         | CEO                 | NULL            | NULL          |← Chefe máximo
-- | Maria Diretora   | Diretora            | João CEO        | CEO           |
-- | Pedro Diretor    | Diretor             | João CEO        | CEO           |
-- | Ana Gerente      | Gerente             | Maria Diretora  | Diretora      |
-- | Bruno Gerente    | Gerente             | Maria Diretora  | Diretora      |
-- | Carla Gerente    | Gerente             | Pedro Diretor   | Diretor       |
-- | Daniel Dev       | Desenvolvedor       | Ana Gerente     | Gerente       |
-- | Eduarda Dev      | Desenvolvedor       | Ana Gerente     | Gerente       |
-- | Fernando Dev     | Desenvolvedor       | Bruno Gerente   | Gerente       |
-- | Gabriela Dev     | Desenvolvedor       | Carla Gerente   | Gerente       |
-- | Hugo Estágio     | Estagiário          | Daniel Dev      | Desenvolvedor |
-- | Isabela Estágio  | Estagiário          | Daniel Dev      | Desenvolvedor |
-- +------------------+---------------------+-----------------+---------------+
-- Note: LEFT JOIN é usado porque o CEO não tem gerente (NULL)


-- =============================================================================
-- EXEMPLO 2: FUNCIONÁRIOS QUE GANHAM MAIS QUE O GERENTE
-- =============================================================================
-- Situação incomum: funcionário com salário maior que o chefe
-- SELF JOIN permite comparar linhas diferentes da mesma tabela!
-- =============================================================================

SELECT 
    f.nome AS funcionario,
    f.salario AS salario_funcionario,
    g.nome AS gerente,
    g.salario AS salario_gerente,
    (f.salario - g.salario) AS diferenca
FROM funcionarios f
INNER JOIN funcionarios g ON f.gerente_id = g.id
WHERE f.salario > g.salario
ORDER BY diferenca DESC;

-- Se algum funcionário ganhar mais que o gerente, apareceria aqui
-- É uma ótima query para auditoria de RH!


-- =============================================================================
-- EXEMPLO 3: ENCONTRAR A CADEIA HIERÁRQUICA (2 níveis)
-- =============================================================================
-- Funcionário → Gerente → Gerente do Gerente
-- =============================================================================

SELECT 
    f.nome AS funcionario,
    g1.nome AS gerente_direto,
    g2.nome AS gerente_do_gerente
FROM funcionarios f
LEFT JOIN funcionarios g1 ON f.gerente_id = g1.id
LEFT JOIN funcionarios g2 ON g1.gerente_id = g2.id
ORDER BY f.id;

-- RESULTADO:
-- +------------------+-----------------+---------------------+
-- | funcionario      | gerente_direto  | gerente_do_gerente  |
-- +------------------+-----------------+---------------------+
-- | João CEO         | NULL            | NULL                |
-- | Maria Diretora   | João CEO        | NULL                |
-- | Pedro Diretor    | João CEO        | NULL                |
-- | Ana Gerente      | Maria Diretora  | João CEO            |
-- | Bruno Gerente    | Maria Diretora  | João CEO            |
-- | Carla Gerente    | Pedro Diretor   | João CEO            |
-- | Daniel Dev       | Ana Gerente     | Maria Diretora      |
-- | Eduarda Dev      | Ana Gerente     | Maria Diretora      |
-- | Fernando Dev     | Bruno Gerente   | Maria Diretora      |
-- | Gabriela Dev     | Carla Gerente   | Pedro Diretor       |
-- | Hugo Estágio     | Daniel Dev      | Ana Gerente         |
-- | Isabela Estágio  | Daniel Dev      | Ana Gerente         |
-- +------------------+-----------------+---------------------+


-- =============================================================================
-- EXEMPLO 4: SUBORDINADOS DIRETOS DE CADA GERENTE
-- =============================================================================
-- Quantas pessoas cada gerente supervisiona diretamente?
-- =============================================================================

SELECT 
    g.nome AS gerente,
    g.cargo AS cargo_gerente,
    COUNT(f.id) AS subordinados_diretos,
    GROUP_CONCAT(f.nome ORDER BY f.nome SEPARATOR ', ') AS equipe
FROM funcionarios g
LEFT JOIN funcionarios f ON g.id = f.gerente_id
WHERE g.gerente_id IS NOT NULL  -- Só gerentes (excluindo subordinados sem equipe)
   OR f.id IS NOT NULL          -- Ou quem tem subordinados
GROUP BY g.id, g.nome, g.cargo
HAVING COUNT(f.id) > 0          -- Só quem tem ao menos 1 subordinado
ORDER BY COUNT(f.id) DESC;

-- RESULTADO:
-- +------------------+-----------------+----------------------+---------------------------+
-- | gerente          | cargo_gerente   | subordinados_diretos | equipe                    |
-- +------------------+-----------------+----------------------+---------------------------+
-- | Maria Diretora   | Diretora        |                    2 | Ana Gerente, Bruno Gerente|
-- | Daniel Dev       | Desenvolvedor   |                    2 | Hugo Estágio, Isabela Est.|
-- | Ana Gerente      | Gerente         |                    2 | Daniel Dev, Eduarda Dev   |
-- | Pedro Diretor    | Diretor         |                    1 | Carla Gerente             |
-- | Bruno Gerente    | Gerente         |                    1 | Fernando Dev              |
-- | Carla Gerente    | Gerente         |                    1 | Gabriela Dev              |
-- | João CEO         | CEO             |                    2 | Maria Diretora, Pedro Dir.|
-- +------------------+-----------------+----------------------+---------------------------+
-- GROUP_CONCAT junta os nomes em uma única string separada por vírgula


-- =============================================================================
-- EXEMPLO 5: SELF JOIN COM DADOS DE CATEGORIAS
-- =============================================================================
-- Outro uso comum: categorias e subcategorias
-- =============================================================================

CREATE TABLE categorias (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    categoria_pai_id INT,     -- Referência à própria tabela (categoria pai)
    FOREIGN KEY (categoria_pai_id) REFERENCES categorias(id)
);

INSERT INTO categorias (nome, categoria_pai_id) VALUES
('Eletrônicos', NULL),             -- 1 - Categoria principal
('Eletrodomésticos', NULL),        -- 2 - Categoria principal
('Informática', 1),                -- 3 - Subcategoria de Eletrônicos
('Áudio e Vídeo', 1),             -- 4 - Subcategoria de Eletrônicos
('Geladeiras', 2),                 -- 5 - Subcategoria de Eletrodomésticos
('Fogões', 2),                     -- 6 - Subcategoria de Eletrodomésticos
('Notebooks', 3),                  -- 7 - Sub de Informática
('Tablets', 3),                    -- 8 - Sub de Informática
('Fones de Ouvido', 4),           -- 9 - Sub de Áudio
('Caixas de Som', 4),             -- 10 - Sub de Áudio
('Geladeira Frost Free', 5),      -- 11 - Sub de Geladeiras
('Geladeira Simples', 5);         -- 12 - Sub de Geladeiras

-- Listar categorias com suas subcategorias (1 nível)
SELECT 
    c.nome AS categoria,
    sc.nome AS subcategoria
FROM categorias c
LEFT JOIN categorias sc ON c.id = sc.categoria_pai_id
WHERE c.categoria_pai_id IS NULL  -- Só categorias principais
ORDER BY c.nome, sc.nome;

-- RESULTADO:
-- +------------------+----------------------+
-- | categoria        | subcategoria         |
-- +------------------+----------------------+
-- | Eletrodomésticos | Fogões               |
-- | Eletrodomésticos | Geladeiras           |
-- | Eletrônicos      | Áudio e Vídeo        |
-- | Eletrônicos      | Informática          |
-- +------------------+----------------------+


-- =============================================================================
-- EXEMPLO 6: SELF JOIN PARA ENCONTRAR PARES/DUPLICATAS
-- =============================================================================
-- Encontrar funcionários contratados no mesmo mês/ano
-- =============================================================================

SELECT 
    f1.nome AS funcionario_1,
    f1.data_contratacao,
    f2.nome AS funcionario_2,
    f2.data_contratacao,
    TIMESTAMPDIFF(MONTH, f1.data_contratacao, f2.data_contratacao) AS meses_diferenca
FROM funcionarios f1
INNER JOIN funcionarios f2 
    ON f1.id < f2.id  -- Evita duplicatas (A,B e B,A)
    AND YEAR(f1.data_contratacao) = YEAR(f2.data_contratacao)
    AND MONTH(f1.data_contratacao) = MONTH(f2.data_contratacao)
ORDER BY f1.data_contratacao;

-- Encontra funcionários contratados no mesmo período


-- =============================================================================
-- EXEMPLO 7: SELF JOIN PARA COMPARAR SALÁRIOS (PAR A PAR)
-- =============================================================================
-- Quem tem salário próximo? Diferença menor que 500
-- =============================================================================

SELECT 
    f1.nome AS funcionario_1,
    f1.salario AS salario_1,
    f2.nome AS funcionario_2,
    f2.salario AS salario_2,
    ABS(f1.salario - f2.salario) AS diferenca
FROM funcionarios f1
INNER JOIN funcionarios f2 
    ON f1.id < f2.id  -- Para não ter pares repetidos
WHERE ABS(f1.salario - f2.salario) < 500
ORDER BY diferenca;

-- Útil para encontrar funcionários com salários similares


-- =============================================================================
-- RESUMO DO SELF JOIN
-- =============================================================================
/*
╔═══════════════════════════════════════════════════════════════════╗
║                       SELF JOIN                                  ║
╠═══════════════════════════════════════════════════════════════════╣
║  SINTAXE:                                                        ║
║  SELECT colunas                                                  ║
║  FROM tabela alias_1                                             ║
║  JOIN tabela alias_2 ON condição                                 ║
║                                                                  ║
║  CARACTERÍSTICAS:                                                ║
║  ✓ Junta a tabela com ELA MESMA                                  ║
║  ✓ Usa ALIAS diferentes para cada "cópia"                       ║
║  ✓ Pode usar INNER, LEFT, RIGHT (depende dos NULLs)             ║
║  ✓ MUITO útil para dados hierárquicos                            ║
║                                                                  ║
║  QUANDO USAR:                                                    ║
║  - Hierarquias: funcionário × gerente                            ║
║  - Categorias e subcategorias                                    ║
║  - Comparar linhas da mesma tabela                               ║
║  - Encontrar duplicatas ou pares                                 ║
║  - Sequências temporais                                          ║
║                                                                  ║
║  DICAS:                                                          ║
║  ✓ f1 e f2 são bons nomes de alias para self join               ║
║  ✓ LEFT JOIN para manter registros sem correspondência           ║
║  ✓ Use f1.id < f2.id para evitar pares duplicados               ║
║  ✓ Pode encadear vários SELF JOINs para níveis hierárquicos      ║
╚═══════════════════════════════════════════════════════════════════╝
*/

-- LIMPEZA (opcional)
-- DROP DATABASE IF EXISTS estudos_joins;
