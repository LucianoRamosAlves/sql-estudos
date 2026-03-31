-- ============================================================================
-- FUNÇÃO: COALESCE
-- ============================================================================
-- DESCRIÇÃO:
--   A função COALESCE retorna o primeiro valor NÃO NULO de uma lista de
--   expressões. Se todos os valores forem NULL, retorna NULL.
--
-- SINTAXE:
--   COALESCE(expressao1, expressao2, expressao3, ...)
--
-- PARÂMETROS:
--   - expressao1, expressao2, ...: Valores a serem avaliados em ordem
--
-- RETORNO:
--   - Primeiro valor não nulo encontrado
--   - NULL se todos os valores forem nulos
--
-- EXEMPLOS DIDÁTICOS:
--
-- 1. BÁSICO - Substituir NULL por um valor padrão
--   SELECT COALESCE(altura, 'Não informado') AS altura
--   FROM pessoas;
--   Resultado: Se altura é NULL, retorna 'Não informado'
--
-- 2. MÚLTIPLOS VALORES - Verificar várias colunas
--   SELECT COALESCE(telefone_celular, telefone_comercial, telefone_residencial, 'Sem telefone')
--   FROM contatos;
--   Resultado: Prioriza celular > comercial > residencial > padrão
--
-- 3. COM EXPRESSÕES - Combinar com cálculos
--   SELECT COALESCE(desconto, 0) * preco AS valor_desconto
--   FROM produtos;
--   Resultado: Se desconto é NULL, usa 0 para cálculo
--
-- 4. CONCATENAÇÃO - Unir valores evitando NULL
--   SELECT CONCAT(nome, ', ', COALESCE(sobrenome, '')) AS nome_completo
--   FROM pessoas;
--   Resultado: Evita concatenação com NULL
--
-- DIFERENÇAS IMPORTANTES:
--   - COALESCE: Aceita múltiplas expressões, mais flexível
--   - ISNULL: Aceita apenas 2 argumentos, mais específico
--   - CASE WHEN: Mais verboso mas mais controle fino
--
-- CASOS DE USO:
--   ✓ Tratamento de valores ausentes em relatórios
--   ✓ Definir valores padrão em cálculos
--   ✓ Priorizar dados de múltiplas colunas
--   ✓ Garantir que resultados não sejam vazios
--
-- PERFORMANCE:
--   - Rápido: Avaliação de curto-circuito (para na primeira valor não-nulo)
--   - Ideal para grandes volumes de dados
--
-- ============================================================================
select altura
from pessoas
WHERE altura IS NULL;

-- 1. BÁSICO - Substituir NULL por um valor padrão
SELECT COALESCE(altura, 'Não informado') AS altura
FROM pessoas;

-- 2. MÚLTIPLOS VALORES - Verificar várias colunas
SELECT COALESCE(telefone_celular, telefone_comercial, telefone_residencial, 'Sem telefone') AS telefone
FROM contatos;

-- 3. COM EXPRESSÕES - Combinar com cálculos
SELECT COALESCE(desconto, 0) * preco AS valor_desconto
FROM produtos;

-- 4. CONCATENAÇÃO - Unir valores evitando NULL
SELECT CONCAT(nome, ', ', COALESCE(sobrenome, '')) AS nome_completo
FROM pessoas;

-- COMPARAÇÃO: COALESCE vs ISNULL vs CASE WHEN
SELECT 
    altura,
    COALESCE(altura, 'N/A') AS coalesce_ex,
    ISNULL(altura, 'N/A') AS isnull_ex,
    CASE WHEN altura IS NULL THEN 'N/A' ELSE altura END AS case_ex
FROM pessoas;

-- CASOS DE USO: Tratamento em relatórios
SELECT nome, COALESCE(departamento, 'Não atribuído') AS depto
FROM funcionarios;

-- PERFORMANCE: Curto-circuito em expressões
SELECT COALESCE(bonus, comissao, 0) AS remuneracao_adicional
FROM vendedores;