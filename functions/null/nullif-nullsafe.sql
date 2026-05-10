/* ========================================================================
   NULLIF e <=> (NULL-Safe) - Funções avançadas para NULL
   ========================================================================
   
   NULLIF(valor1, valor2)
   → Se valor1 = valor2, retorna NULL
   → Se valor1 ≠ valor2, retorna o valor1
   
   Útil para evitar divisões por zero e comparar dados duplicados.
   
   <=> (Operador NULL-Safe / Spaceship)
   → Compara dois valores tratando NULL como um valor válido
   
   Diferença crucial:
   NULL <=> NULL → 1 (verdadeiro)  ← <=> trata NULL igual
   NULL  =  NULL → NULL (falso)    ←  =  não funciona com NULL
   ======================================================================== */

-- ========================================================================
-- 1. NULLIF - Transformando valores iguais em NULL
-- ========================================================================

/*
   NULLIF(valor1, valor2)
   
   Lógica: "Se os dois valores forem IGUAIS, retorna NULL.
            Se forem DIFERENTES, retorna o primeiro valor."
   
   Caso de uso clássico: evitar divisão por zero.
   NULLIF(0, 0) = NULL, então 10 / NULL = NULL (não quebra!)
*/

SELECT
    NULLIF(10, 10) AS iguais,      -- NULL (são iguais)
    NULLIF(10, 5)  AS diferentes,  -- 10 (são diferentes)
    NULLIF('A', 'A') AS texto_igual,   -- NULL
    NULLIF('A', 'B') AS texto_diferente;  -- 'A'

/*
   Resultado:
   
   iguais | diferentes | texto_igual | texto_diferente
   -------+------------+-------------+-----------------
   NULL   | 10         | NULL        | A
*/

-- ========================================================================
-- 2. NULLIF - Caso de uso: evitar divisão por zero
-- ========================================================================

/*
   O caso de uso MAIS COMUM do NULLIF é evitar DIVISÃO POR ZERO.
   
   Problema: 100 / 0 = ERRO (division by zero)
   Solução:  100 / NULLIF(0, 0) = 100 / NULL = NULL (sem erro!)
   
   NULLIF(0, 0) retorna NULL porque 0 = 0 são iguais.
   NULLIF(5, 0) retorna 5 porque 5 ≠ 0 são diferentes.
*/

SELECT
    -- Sem proteção: vai dar erro se o divisor for 0
    -- 100 / 0 AS erro,  -- ERRO: division by zero!

    -- Com NULLIF: protege contra divisão por zero
    100 / NULLIF(0, 0) AS divisao_protegida,   -- NULL (não quebra)
    100 / NULLIF(5, 0) AS divisao_normal;      -- 20 (5 é diferente de 0)

/*
   Resultado:
   
   divisao_protegida | divisao_normal
   ------------------+----------------
   NULL              | 20.0000
   
   PERCEBA: ao invés de dar ERRO, retorna NULL.
   Depois você pode usar COALESCE ou IFNULL para tratar:
   COALESCE(100 / NULLIF(0, 0), 0) → 0
*/

-- Exemplo prático: média de avaliação (evitando divisão por 0)
SELECT
    produto,
    total_avaliacoes,
    soma_notas,
    -- Proteção: se total_avaliacoes for 0, retorna NULL
    soma_notas / NULLIF(total_avaliacoes, 0) AS media
FROM avaliacoes;

/*
   Resultado:
   
   produto  | total_avaliacoes | soma_notas | media
   ---------+------------------+------------+-------
   TV       | 10               | 85         | 8.5
   Rádio    | 0                | 0          | NULL  ← sem erro!
*/

-- ========================================================================
-- 3. NULLIF - Comparando dados entre tabelas
-- ========================================================================

/*
   NULLIF também é útil para comparar dados duplicados.
   Se duas colunas têm o MESMO valor, retorna NULL (não mostra).
   Se são DIFERENTES, mostra o valor original.
*/

SELECT
    nome,
    endereco_cobranca,
    endereco_entrega,
    NULLIF(endereco_cobranca, endereco_entrega) AS endereco_diferente
FROM pedidos;

/*
   Resultado:
   
   nome    | endereco_cobranca  | endereco_entrega    | endereco_diferente
   --------+--------------------+---------------------+-------------------
   Ana     | Rua A, 123         | Rua A, 123          | NULL   ← iguais
   Carlos  | Rua B, 456         | Rua C, 789          | Rua B, 456 ← diferente
   
   PERCEBA: Para a Ana, como os endereços são IGUAIS, retornou NULL.
   Isso é útil para destacar APENAS as diferenças entre colunas.
*/

-- ========================================================================
-- 4. <=> (NULL-Safe) - Comparando NULL como valor normal
-- ========================================================================

/*
   O operador <=> (também chamado de "spaceship") compara dois valores
   TRATANDO NULL como um valor normal.
   
   Diferença fundamental:
   
   =       | NULL = NULL  → NULL  (não funciona, falso)
   <=>     | NULL <=> NULL → 1    (funciona, verdadeiro!)
   IS NULL | NULL IS NULL  → 1    (só para NULL, não compara)
   
   <=> é o único operador que retorna TRUE quando compara NULL com NULL!
*/

SELECT
    -- Comparando valores normais
    1 <=> 1  AS igual_normal,         -- 1 (verdadeiro)
    1 <=> 2  AS diferente_normal,     -- 0 (falso)

    -- Comparando com NULL
    NULL <=> NULL AS null_com_null,    -- 1 (verdadeiro! ← mágica aqui)
    1 <=> NULL AS valor_com_null,     -- 0 (falso)
    NULL <=> 1 AS null_com_valor,     -- 0 (falso)

    -- Comparação com = para ver a diferença
    NULL = NULL AS igual_normal_falha;  -- NULL (falso!)

/*
   Resultado:
   
   igual_normal | diferente_normal | null_com_null | valor_com_null | null_com_valor | igual_normal_falha
   -------------+------------------+---------------+----------------+----------------+--------------------
   1            | 0                | 1             | 0              | 0              | NULL
   
   REPARE: NULL <=> NULL = 1 (TRUE), enquanto NULL = NULL = NULL (falso)!
*/

-- ========================================================================
// ... existing code ...

-- ========================================================================
// ... existing code ...

-- ========================================================================
// ... existing code ...
