/* ========================================================================
   06 - PRÁTICA: Consultas reais com datas
   ========================================================================
   
   Aqui juntamos TUDO que aprendemos em consultas do dia a dia:
   - WHERE com datas (filtrar por período)
   - GROUP BY por ano/mês (relatórios)
   - ORDER BY por data (ordenar)
   - Cálculo de idade
   - Aniversariantes do mês
   ======================================================================== */

-- ========================================================================
-- 1. FILTRANDO COM WHERE - Pessoas nascidas em um período
-- ========================================================================

/*
   WHERE com datas funciona com os operadores normais:
   >  (maior que / depois de)
   <  (menor que / antes de)
   =  (igual)
   BETWEEN (entre)
*/

-- Pessoas nascidas DEPOIS de 01/01/2000
SELECT nome, nascimento
FROM pessoas
WHERE nascimento > '2000-01-01';

/*
   Resultado:
   
   nome           | nascimento
   ---------------+------------
   Carlos Souza   | 2000-10-05
   João Santos    | 2000-10-20
   
   PERCEBA: > '2000-01-01' pega quem nasceu DEPOIS de 01/01/2000
*/

-- Pessoas nascidas ANTES de 1990
SELECT nome, nascimento
FROM pessoas
WHERE nascimento < '1990-01-01';

/*
   Resultado:
   
   nome           | nascimento
   ---------------+------------
   Maria Lima     | 1988-12-25
*/

-- Pessoas nascidas ENTRE duas datas (inclusive)
SELECT nome, nascimento
FROM pessoas
WHERE nascimento BETWEEN '2000-01-01' AND '2000-12-31';

/*
   Resultado:
   
   nome           | nascimento
   ---------------+------------
   Carlos Souza   | 2000-10-05
   João Santos    | 2000-10-20
   
   BETWEEN é INCLUSIVO: pega de 01/01/2000 até 31/12/2000
*/

-- ========================================================================
// ... existing code ...

-- Pessoas nascidas em 2000 usando YEAR()
SELECT nome, nascimento
FROM pessoas
WHERE YEAR(nascimento) = 2000;

/*
   Resultado:
   
   nome           | nascimento
   ---------------+------------
   Carlos Souza   | 2000-10-05
   João Santos    | 2000-10-20
*/

-- Pessoas nascidas em OUTUBRO (mês 10)
SELECT nome, nascimento
FROM pessoas
WHERE MONTH(nascimento) = 10;

/*
   Resultado:
   
   nome           | nascimento
   ---------------+------------
   Carlos Souza   | 2000-10-05
   João Santos    | 2000-10-20
*/

-- 2. ORDENANDO COM ORDER BY - Por data
+-- ========================================================================
+
+/*
+   ORDER BY com datas funciona naturalmente:
+   ASC  (padrão): mais antigas primeiro (crescente)
+   DESC: mais recentes primeiro (decrescente)
+*/
+
+-- Ordem crescente (mais velho primeiro)
+SELECT nome, nascimento
+FROM pessoas
+ORDER BY nascimento;  -- ASC é o padrão
+
+/*
+   Resultado:
+   
+   nome           | nascimento
+   ---------------+------------
+   Maria Lima     | 1988-12-25  ← mais velha
+   Ana Silva      | 1995-06-15
+   Carlos Souza   | 2000-10-05
+   João Santos    | 2000-10-20  ← mais novo
+*/
+
+-- Ordem decrescente (mais novo primeiro)
+SELECT nome, nascimento
+FROM pessoas
+ORDER BY nascimento DESC;
+
+/*
+   Resultado:
+   
+   nome           | nascimento
+   ---------------+------------
+   João Santos    | 2000-10-20  ← mais novo
+   Carlos Souza   | 2000-10-05
+   Ana Silva      | 1995-06-15
+   Maria Lima     | 1988-12-25  ← mais velha
+*/
+
+-- ========================================================================
+-- 3. AGRUPANDO COM GROUP BY - Relatórios por data
+-- ========================================================================
+
+/*
+   GROUP BY com datas é muito usado para relatórios:
+   - Quantos clientes por ano?
+   - Quantos clientes por mês?
+   - etc.
+*/
+
+-- Quantidade de pessoas por ANO de nascimento
+SELECT
+    YEAR(nascimento) AS ano,
+    COUNT(*) AS quantidade
+FROM pessoas
+GROUP BY YEAR(nascimento)
+ORDER BY ano;
+
+/*
+   Resultado:
+   
+   ano  | quantidade
+   -----+------------
+   1988 | 1
+   1995 | 1
+   2000 | 2           ← duas pessoas nasceram em 2000!
+*/
+
+-- Quantidade de pessoas por MÊS (nome do mês)
+SELECT
+    DATE_FORMAT(nascimento, '%M') AS mes,
+    COUNT(*) AS quantidade
+FROM pessoas
+GROUP BY DATE_FORMAT(nascimento, '%M')
+ORDER BY quantidade DESC;
+
+/*
+   Resultado:
+   
+   mes       | quantidade
+   ----------+------------
+   October   | 2           ← outubro tem 2 aniversariantes
+   June      | 1
+   December  | 1
+*/
+
+-- ========================================================================
+-- 4. CALCULANDO IDADE
+-- ========================================================================
+
+/*
+   A forma mais correta de calcular idade no MySQL:
+   TIMESTAMPDIFF(YEAR, nascimento, CURDATE())
+   
+   Isso já considera se a pessoa já fez aniversário este ano!
+*/
+
+SELECT
+    nome,
+    nascimento,
+    TIMESTAMPDIFF(YEAR, nascimento, CURDATE()) AS idade,
+    CASE
+        WHEN MONTH(nascimento) = MONTH(CURDATE())
+             AND DAY(nascimento) = DAY(CURDATE())
+        THEN 'Faz aniversário HOJE!'
+        WHEN MONTH(nascimento) = MONTH(CURDATE())
+        THEN 'Faz aniversário este mês'
+        ELSE 'Aniversário em outro mês'
+    END AS status_aniversario
+FROM pessoas
+ORDER BY idade DESC;
+
+/*
+   Resultado (exemplo):
+   
+   nome           | nascimento | idade | status_aniversario
+   ---------------+------------+-------+-------------------
+   Maria Lima     | 1988-12-25 | 35    | Aniversário em outro mês
+   Ana Silva      | 1995-06-15 | 29    | Aniversário em outro mês
+   Carlos Souza   | 2000-10-05 | 24    | Faz aniversário HOJE!
+   João Santos    | 2000-10-20 | 24    | Faz aniversário este mês
+*/
+
+-- ========================================================================
+-- 5. ANIVERSARIANTES DO MÊS
+-- ========================================================================
+
+/*
+   Para buscar aniversariantes do mês atual:
+   MONTH(nascimento) = MONTH(CURDATE())
+*/
+
+SELECT
+    nome,
+    nascimento,
+    DATE_FORMAT(nascimento, '%d/%m') AS dia_mes_aniversario,
+    TIMESTAMPDIFF(YEAR, nascimento, CURDATE()) AS idade_que_faz
+FROM pessoas
+WHERE MONTH(nascimento) = MONTH(CURDATE())
+ORDER BY DAY(nascimento);
+
+/*
+   Resultado (se for outubro):
+   
+   nome           | nascimento | dia_mes_aniversario | idade_que_faz
+   ---------------+------------+---------------------+--------------
+   Carlos Souza   | 2000-10-05 | 05/10               | 24
+   João Santos    | 2000-10-20 | 20/10               | 24
+*/
+
+-- ========================================================================
+-- 6. DESAFIO: Quem já fez aniversário este ano?
+-- ========================================================================
+
+/*
+   Já fez aniversário este ano se:
+   - O aniversário (dia/mês) já passou neste ano
+   
+   Lógica:
+   Pega a data de aniversário deste ano (ano atual + mês/dia do nascimento)
+   e compara com a data de hoje.
+*/
+
+SELECT
+    nome,
+    nascimento,
+    CONCAT(YEAR(CURDATE()), '-', MONTH(nascimento), '-', DAY(nascimento))
+        AS aniversario_este_ano
+FROM pessoas
+WHERE
+    CONCAT(YEAR(CURDATE()), '-', MONTH(nascimento), '-', DAY(nascimento))
+    <= CURDATE()
+ORDER BY aniversario_este_ano;
+
+/*
+   Resultado (se for 05/10/2024):
+   
+   nome           | nascimento | aniversario_este_ano
+   ---------------+------------+---------------------
+   Ana Silva      | 1995-06-15 | 2024-06-15     ← já passou
+   Maria Lima     | 1988-12-25 | 2024-12-25     ← ainda não (futuro)
+   Carlos Souza   | 2000-10-05 | 2024-10-05     ← hoje!
+   
+   PERCEBA: João não aparece porque o aniversário dele (20/10)
+   ainda não chegou (só vai passar depois de 20/10).
+*/
+
+-- ========================================================================
+-- DICA FINAL: Combinando TUDO
+-- ========================================================================
+
+/*
+   Exemplo completo: relatório de aniversariantes do mês que vem
+*/
+
+SELECT
+    nome,
+    nascimento,
+    DATE_FORMAT(nascimento, '%d/%m/%Y') AS data_br,
+    TIMESTAMPDIFF(YEAR, nascimento, CURDATE()) AS idade,
+    DATEDIFF(
+        CONCAT(YEAR(CURDATE()), '-', MONTH(nascimento), '-', DAY(nascimento)),
+        CURDATE()
+    ) AS dias_para_aniversario
+FROM pessoas
+WHERE MONTH(nascimento) = MONTH(DATE_ADD(CURDATE(), INTERVAL 1 MONTH))
+ORDER BY DAY(nascimento);
+
+/*
+   Esta consulta:
+   1. Filtra quem faz aniversário no mês que vem
+   2. Mostra a data em formato brasileiro
+   3. Calcula a idade que a pessoa vai fazer
+   4. Mostra quantos dias faltam para o aniversário
+*/
+
+-- ========================================================================
+-- FIM
