/* quando eu quero todos os dados de uma tabela com todos os dados que tem o id iguual
se na gtabela A for clinetes e na B por produtos, além de eu oegar todos com o id iguais, pego tudo da tabela A*/



select 
	pe.id,
    pe.nome,
    pe.sexo,
    pr.nome,
    pr.preco
from pessoas as pe
left join produto as pr
on pe.id = pr.id
;

-- ============================================================================
-- GUIA COMPLETO DE JOINS NO MYSQL - PARA ESTUDOS
-- ============================================================================

-- ============================================================================
-- 1. INNER JOIN (Junção Interna)
-- ============================================================================
-- Retorna APENAS as linhas que têm correspondência em AMBAS as tabelas
-- Se um ID não existe em ambas, não aparece no resultado

select 
    pe.id,           -- ID da pessoa
    pe.nome,         -- Nome da pessoa
    pe.sexo,         -- Sexo da pessoa
    pr.nome,         -- Nome do produto
    pr.preco         -- Preço do produto
from pessoas as pe
inner join produto as pr  -- Explicitly specifying INNER (opcional, é o padrão)
on pe.id = pr.id_pessoa   -- Condição: ID da pessoa = ID da pessoa no produto
;
-- Exemplo: Se pessoa 1 não tem produtos, ela não aparece no resultado


-- ============================================================================
-- 2. LEFT JOIN (Junção à Esquerda)
-- ============================================================================
-- Retorna TODAS as linhas da tabela À ESQUERDA (primeira tabela)
-- Mais apenas as linhas correspondentes da tabela À DIREITA
-- Se não houver correspondência, preencherá com NULL

select 
    pe.id,           -- ID da pessoa (SEMPRE vai aparecer)
    pe.nome,         -- Nome da pessoa (SEMPRE vai aparecer)
    pe.sexo,         -- Sexo da pessoa (SEMPRE vai aparecer)
    pr.nome,         -- Nome do produto (PODE ser NULL se não houver)
    pr.preco         -- Preço do produto (PODE ser NULL se não houver)
from pessoas as pe
left join produto as pr  -- "LEFT" = todos de pessoas + correspondências em produto
on pe.id = pr.id_pessoa
;
-- Exemplo: Pessoa sem produtos ainda vai aparecer com NULL nas colunas de produto


-- ============================================================================
-- 3. RIGHT JOIN (Junção à Direita)
-- ============================================================================
-- Retorna TODAS as linhas da tabela À DIREITA (segunda tabela)
-- Mais apenas as linhas correspondentes da tabela À ESQUERDA
-- Se não houver correspondência, preencherá com NULL

select 
    pe.id,           -- ID da pessoa (PODE ser NULL se não houver)
    pe.nome,         -- Nome da pessoa (PODE ser NULL se não houver)
    pe.sexo,         -- Sexo da pessoa (PODE ser NULL se não houver)
    pr.nome,         -- Nome do produto (SEMPRE vai aparecer)
    pr.preco         -- Preço do produto (SEMPRE vai aparecer)
from pessoas as pe
right join produto as pr  -- "RIGHT" = todos de produto + correspondências em pessoas
on pe.id = pr.id_pessoa
;
-- Exemplo: Todos os produtos aparecerão, mesmo que não tenha pessoa associada


-- ============================================================================
-- 4. FULL OUTER JOIN (Junção Completa)
-- ============================================================================
-- MySQL não tem FULL OUTER JOIN nativo, então usamos UNION
-- Retorna TODAS as linhas de AMBAS as tabelas
-- Preencherá com NULL onde não houver correspondência

select 
    pe.id,
    pe.nome,
    pe.sexo,
    pr.nome,
    pr.preco
from pessoas as pe
left join produto as pr
on pe.id = pr.id_pessoa

union  -- UNION combina resultados de duas queries

select 
    pe.id,
    pe.nome,
    pe.sexo,
    pr.nome,
    pr.preco
from pessoas as pe
right join produto as pr
on pe.id = pr.id_pessoa
;
-- Resultado: Todas as pessoas E todos os produtos, mesmo sem correspondência


-- ============================================================================
-- 5. CROSS JOIN (Produto Cartesiano)
-- ============================================================================
-- Faz uma combinação de TODAS as linhas de uma tabela com TODAS as linhas da outra
-- Resultado = linhas_tabela_A × linhas_tabela_B (MUITO grande!)

select 
    pe.id,
    pe.nome,
    pr.nome,
    pr.preco
from pessoas as pe
cross join produto as pr
;
-- Exemplo: 5 pessoas × 10 produtos = 50 linhas combinadas


-- ============================================================================
-- 6. SELF JOIN (Junção Consigo Mesma)
-- ============================================================================
-- Junta uma tabela com ela mesma
-- Útil para dados hierárquicos (funcionários e seus gerentes, etc)

select 
    f1.id,              -- ID do funcionário
    f1.nome,            -- Nome do funcionário
    f2.id,              -- ID do gerente
    f2.nome             -- Nome do gerente
from funcionarios as f1  -- Primeira instância da tabela
left join funcionarios as f2  -- Segunda instância da tabela
on f1.gerente_id = f2.id  -- Funcionário 1 gerenciado por Funcionário 2
;
-- Exemplo: Mostra cada funcionário e quem é seu gerente


-- ============================================================================
-- 7. MÚLTIPLOS JOINs (Juntando mais de 2 tabelas)
-- ============================================================================
-- Você pode juntar quantas tabelas precisar

select 
    pe.id,
    pe.nome,
    pr.nome,
    pr.preco,
    ca.nome_categoria  -- Terceira tabela
from pessoas as pe
inner join produto as pr on pe.id = pr.id_pessoa
inner join categoria as ca on pr.id_categoria = ca.id
;
-- Ordem de execução: pessoas → produto → categoria


-- ============================================================================
-- 8. JOINs COM MÚLTIPLAS CONDIÇÕES (ON com AND/OR)
-- ============================================================================
-- Você pode adicionar várias condições à cláusula ON

select 
    pe.id,
    pe.nome,
    pr.nome,
    pr.preco
from pessoas as pe
inner join produto as pr
on pe.id = pr.id_pessoa          -- Primeira condição
and pr.preco > 100               -- Segunda condição (opcional)
and pe.sexo = 'M'                -- Terceira condição (opcional)
;
-- Apenas retorna registros que atendem a TODAS as condições


-- ============================================================================
-- 9. JOINs COM WHERE (Filtragem Adicional)
-- ============================================================================
-- Diferença: ON filtra ANTES da junção, WHERE filtra DEPOIS

select 
    pe.id,
    pe.nome,
    pr.nome,
    pr.preco
from pessoas as pe
left join produto as pr on pe.id = pr.id_pessoa
where pr.preco > 100 or pr.preco is null  -- Filtro APÓS a junção
;


-- ============================================================================
-- 10. DICAS E BOAS PRÁTICAS
-- ============================================================================

/*
✓ SEMPRE use aliases (as) para tabelas longas - facilita leitura
✓ Use LEFT JOIN quando quiser manter dados da tabela principal
✓ Use INNER JOIN para garantir que ambas as tabelas têm correspondência
✓ Adicione comments explicando a lógica de junção
✓ Teste com LIMIT para não sobrecarregar o banco
✓ Índices nas colunas de junção (ON) melhoram performance
✓ Evite CROSS JOIN em tabelas grandes (cresce exponencialmente)
✓ Use WHERE para filtrar DEPOIS da junção
✓ Use ON para filtrar ANTES da junção (em JOINs, é mais eficiente)
*/

-- ============================================================================
-- RESUMO VISUAL
-- ============================================================================

/*
INNER JOIN:      [A ∩ B]           (só o que tem em comum)
LEFT JOIN:       [A ∪ (A ∩ B)]     (tudo de A + correspondências em B)
RIGHT JOIN:      [(A ∩ B) ∪ B]     (tudo de B + correspondências em A)
FULL JOIN:       [A ∪ B]           (tudo de A e tudo de B)
CROSS JOIN:      [A × B]           (todas as combinações)
*/