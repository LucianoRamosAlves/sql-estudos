-- =============================================================================
-- CROSS JOIN - PRODUTO CARTESIANO
-- =============================================================================
-- O CROSS JOIN combina TODAS as linhas da primeira tabela
-- com TODAS as linhas da segunda tabela.
--
-- Resultado = (linhas da tabela A) × (linhas da tabela B)
--
--      Tabela A    CROSS JOIN  Tabela B
--      ┌────────┐               ┌────────┐
--      │  A1    │    JUNÇÃO     │  B1    │
--      │  A2    │──────────────►│  B2    │
--      │  A3    │               │  B3    │
--      └────────┘               └────────┘
--               ╔══════════════════════╗
--               ║   RESULTADO:         ║
--               ║  A1-B1, A1-B2, A1-B3║
--               ║  A2-B1, A2-B2, A2-B3║
--               ║  A3-B1, A3-B2, A3-B3║
--               ╚══════════════════════╝
--
-- ⚠️ CUIDADO: Cresce exponencialmente!
--    1000 linhas × 1000 linhas = 1.000.000 resultados!
-- =============================================================================

-- CONFIGURAÇÃO DO BANCO
-- =============================================================================
CREATE DATABASE IF NOT EXISTS estudos_joins;
USE estudos_joins;

DROP TABLE IF EXISTS sabores;
DROP TABLE IF EXISTS tamanhos;
DROP TABLE IF EXISTS ingredientes;
DROP TABLE IF EXISTS dias_semana;

-- =============================================================================
-- EXEMPLO 1: CROSS JOIN SIMPLES - Cardápio de Sorveteria
-- =============================================================================
-- Queremos criar todas as combinações possíveis de sabores × tamanhos
-- =============================================================================

CREATE TABLE sabores (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(50)
);

CREATE TABLE tamanhos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(50),
    preco_base DECIMAL(10, 2)
);

INSERT INTO sabores (nome) VALUES
('Chocolate'),
('Morango'),
('Baunilha'),
('Doce de Leite');

INSERT INTO tamanhos (nome, preco_base) VALUES
('Pequeno', 5.00),
('Médio', 8.00),
('Grande', 12.00);

-- CROSS JOIN: todas as combinações possíveis
SELECT 
    s.nome AS sabor,
    t.nome AS tamanho,
    t.preco_base AS preco
FROM sabores s
CROSS JOIN tamanhos t
ORDER BY sabor, tamanho;

-- RESULTADO (12 linhas = 4 sabores × 3 tamanhos):
-- +--------------+---------+-------+
-- | sabor        | tamanho | preco |
-- +--------------+---------+-------+
-- | Baunilha     | Pequeno |  5.00 |
-- | Baunilha     | Médio   |  8.00 |
-- | Baunilha     | Grande  | 12.00 |
-- | Chocolate    | Pequeno |  5.00 |
-- | Chocolate    | Médio   |  8.00 |
-- | Chocolate    | Grande  | 12.00 |
-- | Doce de Leite| Pequeno |  5.00 |
-- | Doce de Leite| Médio   |  8.00 |
-- | Doce de Leite| Grande  | 12.00 |
-- | Morango      | Pequeno |  5.00 |
-- | Morango      | Médio   |  8.00 |
-- | Morango      | Grande  | 12.00 |
-- +--------------+---------+-------+
-- Útil para gerar catálogos completos de produtos!


-- =============================================================================
-- EXEMPLO 2: CROSS JOIN IMPLÍCITO (sem a palavra CROSS JOIN)
-- =============================================================================
-- Você pode fazer CROSS JOIN simplesmente listando as tabelas no FROM
-- sem cláusula WHERE ou ON
-- =============================================================================

SELECT 
    s.nome AS sabor,
    t.nome AS tamanho
FROM sabores s, tamanhos t;  -- Isso é um CROSS JOIN implícito!

-- Mesmo resultado do exemplo anterior (sem o preço)
-- ⚠️ CUIDADO: se esquecer o WHERE em uma query com múltiplas tabelas,
--    você terá um CROSS JOIN sem querer!


-- =============================================================================
-- EXEMPLO 3: CROSS JOIN COM WHERE (CUIDADO!)
-- =============================================================================
-- Se você colocar WHERE, ele vira um INNER JOIN disfarçado
-- Mas ainda gera o produto cartesiano antes de filtrar (menos eficiente)
-- =============================================================================

-- NÃO FAÇA ISSO (ineficiente):
SELECT s.nome, t.nome
FROM sabores s, tamanhos t
WHERE s.id = 1;  -- Gera 12 combinações, depois filtra 9

-- Prefira isso:
SELECT s.nome, t.nome
FROM sabores s
CROSS JOIN tamanhos t
WHERE s.id = 1;  -- WHERE depois do CROSS também gera tudo antes


-- =============================================================================
-- EXEMPLO 4: USO PRÁTICO - Gerando Calendário de Horários
-- =============================================================================
-- CROSS JOIN é ótimo para gerar grades de horários disponíveis
-- =============================================================================

CREATE TABLE dias_semana (
    dia VARCHAR(20)
);

CREATE TABLE horarios (
    hora TIME
);

INSERT INTO dias_semana VALUES
('Segunda'), ('Terça'), ('Quarta'), ('Quinta'), ('Sexta');

INSERT INTO horarios VALUES
('08:00'), ('09:00'), ('10:00'), ('11:00'),
('14:00'), ('15:00'), ('16:00'), ('17:00');

-- Grade completa de horários disponíveis
SELECT 
    d.dia,
    h.hora
FROM dias_semana d
CROSS JOIN horarios h
ORDER BY 
    FIELD(d.dia, 'Segunda', 'Terça', 'Quarta', 'Quinta', 'Sexta'),
    h.hora;

-- RESULTADO (40 linhas = 5 dias × 8 horários):
-- +----------+----------+
-- | dia      | hora     |
-- +----------+----------+
-- | Segunda  | 08:00:00 |
-- | Segunda  | 09:00:00 |
-- | Segunda  | 10:00:00 |
-- | ...      | ...      |
-- | Sexta    | 17:00:00 |
-- +----------+----------+


-- =============================================================================
-- EXEMPLO 5: CROSS JOIN COM VALORES (Substituindo uma tabela)
-- =============================================================================
-- Você pode gerar combinações sem criar tabelas físicas
-- Útil para relatórios que precisam de todas as combinações
-- =============================================================================

-- Gerar combinações de cores e tamanhos sem tabelas
SELECT 
    cores.valor AS cor,
    tamanhos.valor AS tamanho
FROM 
    (SELECT 'Vermelho' AS valor UNION SELECT 'Azul' UNION SELECT 'Verde') AS cores
CROSS JOIN
    (SELECT 'P' AS valor UNION SELECT 'M' UNION SELECT 'G' UNION SELECT 'GG') AS tamanhos;

-- RESULTADO (12 combinações):
-- +----------+---------+
-- | cor      | tamanho |
-- +----------+---------+
-- | Vermelho | P       |
-- | Vermelho | M       |
-- | Vermelho | G       |
-- | Vermelho | GG      |
-- | Azul     | P       |
-- | ...      | ...     |
-- +----------+---------+


-- =============================================================================
-- EXEMPLO 6: CROSS JOIN PARA GERAR DADOS FALTANTES
-- =============================================================================
-- Útil quando você precisa de todas as combinações mesmo sem dados
-- Exemplo: Vendas por mês e produto (incluindo meses sem venda)
-- =============================================================================

CREATE TABLE produtos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100)
);

CREATE TABLE vendas (
    id INT PRIMARY KEY AUTO_INCREMENT,
    produto_id INT,
    mes INT,
    ano INT,
    valor DECIMAL(10, 2),
    FOREIGN KEY (produto_id) REFERENCES produtos(id)
);

INSERT INTO produtos (nome) VALUES
('Notebook'), ('Mouse'), ('Teclado');

INSERT INTO vendas (produto_id, mes, ano, valor) VALUES
(1, 1, 2024, 5000.00),   -- Notebook em Jan
(1, 2, 2024, 3000.00),   -- Notebook em Fev
(2, 1, 2024, 500.00),    -- Mouse em Jan
(3, 3, 2024, 1500.00);   -- Teclado em Mar

-- Queremos ver TODOS os produtos mesmo nos meses sem venda
-- Primeiro geramos todas as combinações possíveis com CROSS JOIN
SELECT 
    p.nome AS produto,
    meses.mes,
    meses.ano,
    COALESCE(v.valor, 0) AS valor_venda
FROM produtos p
CROSS JOIN (
    SELECT 1 AS mes, 2024 AS ano
    UNION SELECT 2, 2024
    UNION SELECT 3, 2024
) AS meses
LEFT JOIN vendas v 
    ON p.id = v.produto_id 
    AND meses.mes = v.mes 
    AND meses.ano = v.ano
ORDER BY p.nome, meses.mes;

-- RESULTADO:
-- +----------+-----+------+------------+
-- | produto  | mes | ano  | valor_venda|
-- +----------+-----+------+------------+
-- | Mouse    |   1 | 2024 |     500.00 |
-- | Mouse    |   2 | 2024 |       0.00 | ← Sem venda em Fev
-- | Mouse    |   3 | 2024 |       0.00 | ← Sem venda em Mar
-- | Notebook |   1 | 2024 |    5000.00 |
-- | Notebook |   2 | 2024 |    3000.00 |
-- | Notebook |   3 | 2024 |       0.00 | ← Sem venda em Mar
-- | Teclado  |   1 | 2024 |       0.00 | ← Sem venda em Jan
-- | Teclado  |   2 | 2024 |       0.00 | ← Sem venda em Fev
-- | Teclado  |   3 | 2024 |    1500.00 |
-- +----------+-----+------+------------+
-- Técnica PODEROSA: CROSS JOIN + LEFT JOIN para preencher lacunas!


-- =============================================================================
-- EXEMPLO 7: CROSS JOIN - Riscos e Performance
-- =============================================================================
-- Demonstração do crescimento exponencial
-- =============================================================================

-- Pequeno: 10 linhas
SELECT 'A' AS tabela UNION SELECT 'B' UNION SELECT 'C';

-- Médio: 100 linhas (10×10)
-- 10 itens × 10 itens = 100 combinações

-- Grande: 10.000 linhas (100×100)
-- 100 itens × 100 itens = 10.000 combinações

-- Perigoso: 1.000.000 linhas (1000×1000)
-- ⚠️ 1000 produtos × 1000 clientes = 1 MILHÃO de combinações!

-- SEMPRE verifique o tamanho das tabelas antes de usar CROSS JOIN
SELECT 
    (SELECT COUNT(*) FROM sabores) AS linhas_sabores,
    (SELECT COUNT(*) FROM tamanhos) AS linhas_tamanhos,
    (SELECT COUNT(*) FROM sabores) * (SELECT COUNT(*) FROM tamanhos) AS combinacoes;


-- =============================================================================
-- RESUMO DO CROSS JOIN
-- =============================================================================
/*
╔═══════════════════════════════════════════════════════════════════╗
║                      CROSS JOIN                                  ║
╠═══════════════════════════════════════════════════════════════════╣
║  SINTAXE:                                                        ║
║  SELECT colunas                                                  ║
║  FROM tabela_A                                                   ║
║  CROSS JOIN tabela_B                                             ║
║                                                                  ║
║  Ou (implícito):                                                 ║
║  SELECT colunas FROM tabela_A, tabela_B                          ║
║                                                                  ║
║  CARACTERÍSTICAS:                                                ║
║  ✓ Combina CADA linha de A com CADA linha de B (produto cartes.)║
║  ✓ NÃO precisa de condição ON                                    ║
║  ✓ Resultado = linhas_A × linhas_B                               ║
║  ✓ Cresce EXPONENCIALMENTE - use com CUIDADO!                    ║
║                                                                  ║
║  QUANDO USAR:                                                    ║
║  - Gerar combinações de produtos (ex: cardápios)                 ║
║  - Criar grades de horários                                      ║
║  - Preencher dados faltantes em relatórios                       ║
║  - Gerar dados de teste                                          ║
║  - Combinar atributos independentes                              ║
║                                                                  ║
║  CUIDADOS:                                                       ║
║  ⚠️  Pode gerar BILHÕES de linhas em tabelas grandes            ║
║  ⚠️  Esquecer WHERE em múltiplas tabelas vira CROSS JOIN        ║
║  ⚠️  SEMPRE use LIMIT para testar antes                          ║
║  ⚠️  Verifique o tamanho com COUNT(*) antes                      ║
╚═══════════════════════════════════════════════════════════════════╝
*/

-- LIMPEZA (opcional)
-- DROP DATABASE IF EXISTS estudos_joins;
