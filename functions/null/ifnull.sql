/* ========================================================================
   IFNULL - Função específica do MySQL para tratar NULL
   ========================================================================
   
   IFNULL(expressao, valor_padrao)
   → Se a expressão for NULL, retorna o valor_padrao
   → Se a expressão NÃO for NULL, retorna a própria expressão
   
   Diferença do COALESCE:
   - IFNULL: só aceita 2 argumentos (mais simples e rápido)
   - COALESCE: aceita vários argumentos (mais flexível, padrão SQL)
   ======================================================================== */

-- ========================================================================
-- 1. IFNULL BÁSICO - Substituindo NULL por um valor
-- ========================================================================

/*
   IFNULL(valor, substituto)
   
   Se valor = NULL  → retorna substituto
   Se valor ≠ NULL  → retorna o próprio valor
*/

SELECT
    IFNULL(NULL, 'Valor padrão') AS caso_null,             -- 'Valor padrão'
    IFNULL('Texto real', 'Valor padrão') AS caso_nao_null; -- 'Texto real'

/*
   Resultado:
   
   caso_null        | caso_nao_null
   -----------------+---------------
   Valor padrão     | Texto real
*/

-- ========================================================================
-- 2. IFNULL vs COALESCE - Quando usar cada um
-- ========================================================================

/*
   Ambos fazem a MESMA coisa quando você tem 2 argumentos.
   A diferença aparece com 3+ argumentos.
*/

SELECT
    -- IFNULL só pode com 2 argumentos
    IFNULL(telefone, 'Sem telefone') AS com_ifnull,

    -- COALESCE pode com vários (mas aqui é equivalente)
    COALESCE(telefone, 'Sem telefone') AS com_coalesce

FROM usuarios;

/*
   Resultado (exemplo):
   
   nome    | com_ifnull      | com_coalesce
   --------+-----------------+-----------------
   Ana     | 11999999999     | 11999999999
   Carlos  | Sem telefone    | Sem telefone    ← NULL substituído
   
   Quando usar IFNULL em vez de COALESCE?
   - IFNULL é ligeiramente MAIS RÁPIDO (otimização MySQL)
   - COALESCE é padrão SQL (portável para outros bancos)
   - Com 2 argumentos dá no mesmo, escolha o que preferir
*/

-- ========================================================================
-- 3. IFNULL com cálculos e expressões
-- ========================================================================

/*
   IFNULL também funciona com expressões, não só com colunas.
   Muito útil para evitar NULL em operações matemáticas.
*/

SELECT
    nome,
    preco,
    desconto,
    -- Se desconto for NULL, usa 0 para não quebrar a conta
    preco - IFNULL(desconto, 0) AS preco_com_desconto,
    preco * IFNULL(percentual, 0) / 100 AS valor_desconto_calculado
FROM produtos;

/*
   Se desconto = NULL:
   - Sem IFNULL: preco - NULL = NULL (ERRADO!)
   - Com IFNULL: preco - 0 = preco (CERTO!)
   
   REGRA DE OURO: SEMPRE use IFNULL ou COALESCE em cálculos
   que envolvem colunas que podem ser NULL!
*/

-- ========================================================================
-- 4. IFNULL em ORDER BY - Controlando onde NULL aparece
-- ========================================================================

/*
   Por padrão, NULL vem primeiro em ORDER BY ASC.
   Com IFNULL podemos controlar isso.
*/

-- NULL por último (ASC)
SELECT nome, data_ultimo_acesso
FROM usuarios
ORDER BY IFNULL(data_ultimo_acesso, '9999-12-31') ASC;

/*
   Explicação: 
   - Se data_ultimo_acesso é NULL, substitui por '9999-12-31' (futuro distante)
   - Assim os NULL vão para o final da ordenação crescente
   
   Sem IFNULL: NULL, 2024-01-01, 2024-06-15 (NULL primeiro)
   Com IFNULL: 2024-01-01, 2024-06-15, NULL (NULL por último)
*/

-- ========================================================================
-- 5. IFNULL em GROUP BY e COUNT
-- ========================================================================

/*
   IFNULL também é útil em agregações para substituir NULL
   antes de agrupar.
*/

SELECT
    IFNULL(categoria, 'Sem categoria') AS categoria_tratada,
    COUNT(*) AS total
FROM produtos
GROUP BY IFNULL(categoria, 'Sem categoria');

/*
   Resultado:
   
   categoria_tratada | total
   ------------------+-------
   Eletrônicos       | 10
   Roupas            | 8
   Sem categoria     | 3      ← produtos com categoria NULL agrupados aqui
*/

-- ========================================================================
-- 6. IFNULL com CONCAT - Evitando NULL na concatenação
-- ========================================================================

/*
   No MySQL, CONCAT já ignora NULL. 
   Mas se você usar o operador ||, NULL quebra a concatenação.
   IFNULL resolve isso.
*/

SELECT
    -- CONCAT já ignora NULL (específico MySQL)
    CONCAT(nome, ' - ', IFNULL(sobrenome, '')) AS nome_completo
FROM pessoas;

/*
   Resultado:
   
   nome   | sobrenome  | nome_completo
   -------+------------+------------------
   João   | Silva      | João - Silva
   Maria  | NULL       | Maria -
   
   O IFNULL substitui sobrenome NULL por vazio para não ficar
   "Maria - " (com traço pendurado).
   
   Solução melhor: CONCAT_WS(' - ', nome, sobrenome)
   (já vimos no CONCAT_WS que ele lida com NULL perfeitamente)
*/

-- ========================================================================
-- FIM
-- ========================================================================