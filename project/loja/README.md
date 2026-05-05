# 🏪 Projeto Loja - Aprendendo SQL do Zero

## 📋 Sobre o Projeto

Este projeto foi criado com **objetivo didático** para ensinar SQL do básico ao avançado, usando o contexto de uma **loja** para tornar o aprendizado mais prático e aplicável.

## 📁 Estrutura dos Arquivos

Os arquivos estão organizados em **ordem didática** - execute e estude na sequência abaixo:

| Ordem | Arquivo | O que você vai aprender |
|:-----:|---------|------------------------|
| **00** | `00_estrutura_completa.sql` | Criação do banco, tabelas, relacionamentos e inserção de dados |
| **01** | `01_basico.sql` | SELECT, FROM, WHERE, ORDER BY, LIMIT, AS (alias), operadores |
| **02** | `02_filtros_avancados.sql` | LIKE, NOT, IS NULL, datas, COUNT, SUM, AVG, MAX, MIN, GROUP BY, HAVING |
| **03** | `03_joins.sql` | INNER JOIN, LEFT JOIN, RIGHT JOIN - juntando tabelas |
| **04** | `04_funcoes.sql` | Criando funções, parâmetros, RETURN, SELECT...INTO |
| **05** | `05_procedures.sql` | Procedures, IN/OUT, transações, validações, loops |
| **06** | `06_triggers.sql` | Triggers, NEW/OLD, BEFORE/AFTER, logs automáticos |

---

## 📚 Conteúdo Detalhado

### 1️⃣ `00_estrutura_completa.sql` - Modelagem do Banco

**Diagrama das tabelas e seus relacionamentos:**

```
┌─────────────┐       ┌──────────────┐       ┌──────────────────┐
│  clientes   │       │   pedidos    │       │  itens_pedido    │
├─────────────┤       ├──────────────┤       ├──────────────────┤
│ clientes_id │──1:N──│ clientes_id  │──1:N──│ pedidos_id       │
│ nome        │       │ pedidos_id   │       │ produtos_id      │
│ data_nasc   │       │ data_pedido  │       │ quantidade       │
└─────────────┘       └──────────────┘       └──────┬───────────┘
                                                     │ N:1
                                                     ▼
                                            ┌──────────────────┐
                                            │    produtos      │
                                            ├──────────────────┤
                                            │ produtos_id      │
                                            │ nome_produto     │
                                            │ preco            │
                                            │ categorias_id    │──N:1──┐
                                            │ estoque          │       │
                                            └──────────────────┘       │
                                                                       │
                                                                       ▼
                                                                ┌──────────────┐
                                                                │  categorias  │
                                                                ├──────────────┤
                                                                │ categorias_id│
                                                                │ nome_categoria│
                                                                └──────────────┘
```

### 2️⃣ `01_basico.sql` - Comandos Básicos

```sql
-- Selecionar tudo de uma tabela
SELECT * FROM clientes;

-- Selecionar colunas específicas
SELECT nome, preco FROM produtos;

-- Filtrar registros
SELECT * FROM produtos WHERE preco > 5;

-- Ordenar resultados
SELECT * FROM produtos ORDER BY preco DESC;

-- Limitar resultados
SELECT * FROM produtos LIMIT 3;

-- Apelidos (alias)
SELECT nome_produto AS produto FROM produtos;
```

### 3️⃣ `02_filtros_avancados.sql` - Filtros e Agregações

```sql
-- Busca por padrão (LIKE)
SELECT * FROM clientes WHERE nome LIKE 'M%';  -- Começa com M

-- Funções de agregação
SELECT COUNT(*) FROM clientes;        -- Contar
SELECT AVG(preco) FROM produtos;     -- Média
SELECT SUM(preco) FROM produtos;     -- Soma
SELECT MAX(preco) FROM produtos;     -- Máximo
SELECT MIN(preco) FROM produtos;     -- Mínimo

-- Agrupar resultados
SELECT categorias_id, COUNT(*) 
FROM produtos 
GROUP BY categorias_id;

-- Filtrar grupos
SELECT categorias_id, COUNT(*) 
FROM produtos 
GROUP BY categorias_id 
HAVING COUNT(*) > 1;
```

### 4️⃣ `03_joins.sql` - Juntando Tabelas

```sql
-- INNER JOIN: só o que existe nas duas tabelas
SELECT c.nome, p.data_pedido
FROM clientes c
INNER JOIN pedidos p ON c.clientes_id = p.clientes_id;

-- LEFT JOIN: todos os clientes, mesmo sem pedidos
SELECT c.nome, p.data_pedido
FROM clientes c
LEFT JOIN pedidos p ON c.clientes_id = p.clientes_id;

-- JOIN de várias tabelas
SELECT c.nome, pr.nome_produto, ip.quantidade
FROM clientes c
INNER JOIN pedidos p ON c.clientes_id = p.clientes_id
INNER JOIN itens_pedido ip ON p.pedidos_id = ip.pedidos_id
INNER JOIN produtos pr ON ip.produtos_id = pr.produtos_id;
```

### 5️⃣ `04_funcoes.sql` - Criando Funções

```sql
-- Estrutura de uma função
DELIMITER //
CREATE FUNCTION nome_funcao(parametro TIPO)
RETURNS tipo_retorno
DETERMINISTIC
BEGIN
    DECLARE variavel TIPO;
    -- lógica
    RETURN variavel;
END //
DELIMITER ;

-- Exemplo: Calcular desconto
SELECT f_aplicar_desconto(preco, 10) FROM produtos;

-- Exemplo: Classificar preço
SELECT nome_produto, f_classificar_preco(preco) FROM produtos;
```

### 6️⃣ `05_procedures.sql` - Procedimentos Armazenados

```sql
-- Estrutura de uma procedure
DELIMITER //
CREATE PROCEDURE sp_nome(IN param TIPO, OUT resultado TIPO)
BEGIN
    -- lógica (pode ter INSERT, UPDATE, DELETE)
    SELECT COUNT(*) INTO resultado FROM tabela;
END //
DELIMITER ;

-- Como chamar
CALL sp_nome(valor, @variavel);
SELECT @variavel;
```

### 7️⃣ `06_triggers.sql` - Gatilhos Automáticos

```sql
-- Estrutura de uma trigger
DELIMITER //
CREATE TRIGGER nome_trigger
BEFORE INSERT ON tabela
FOR EACH ROW
BEGIN
    -- NEW = dados novos
    -- OLD = dados antigos (só em UPDATE/DELETE)
    IF NEW.campo = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro!';
    END IF;
END //
DELIMITER ;
```

---

## 🎯 Como Usar Este Projeto

### Passo a Passo:

1. **Abra seu MySQL** (Workbench, linha de comando, DBeaver, etc.)
2. **Execute os arquivos em ordem numérica**
3. **Leia os comentários** - cada arquivo tem explicações detalhadas
4. **Faça os desafios** - no final de cada arquivo tem exercícios
5. **Experimente** - modifique as queries, crie suas próprias variações

### Recomendação de Estudo:

```
Semana 1: Arquivos 00 e 01  → Modelagem e SELECT básico
Semana 2: Arquivo 02        → Filtros e agregações
Semana 3: Arquivo 03        → JOINs
Semana 4: Arquivo 04        → Funções
Semana 5: Arquivo 05        → Procedures
Semana 6: Arquivo 06        → Triggers
```

---

## 🛠️ Dicas Importantes

### Sintaxe MySQL

| Comando | Descrição |
|---------|-----------|
| `USE loja;` | Seleciona o banco de dados |
| `SELECT` | Consulta dados |
| `INSERT INTO` | Insere novos dados |
| `UPDATE ... SET` | Atualiza dados existentes |
| `DELETE FROM` | Remove dados |
| `CREATE TABLE` | Cria nova tabela |
| `ALTER TABLE` | Modifica tabela existente |
| `DROP TABLE` | Remove tabela |

### Boas Práticas

- ✅ Sempre use `USE` para selecionar o banco
- ✅ Nomeie tabelas no plural (`clientes`, `produtos`)
- ✅ Use prefixos: `f_` para funções, `sp_` para procedures, `trg_` para triggers
- ✅ Comente seu código (como neste projeto)
- ✅ Teste sempre depois de criar/modificar
- ✅ Use transações (`START TRANSACTION`/`COMMIT`/`ROLLBACK`) em operações críticas

---

## 🐛 Erros Comuns e Soluções

| Erro | Causa | Solução |
|------|-------|---------|
| `Table already exists` | Tabela já criada | Use `DROP TABLE IF EXISTS` antes |
| `Foreign key constraint fails` | Tentou excluir/alterar algo referenciado | Remova referências primeiro ou use `ON DELETE CASCADE` |
| `Function already exists` | Função já existe | Use `DROP FUNCTION IF EXISTS` |
| `Not allowed to return a result set` | Função com SELECT sem INTO | Use `SELECT ... INTO variavel` |
| `Data too long for column` | Valor maior que o campo | Aumente o tamanho do VARCHAR |
| `Column cannot be null` | Tentou inserir NULL em NOT NULL | Preencha o campo obrigatório |

---

## 📖 Conceitos SQL Explicados

### Relacionamentos

```
1:1 (um para um)      → 1 cliente tem 1 CPF (tabelas separadas)
1:N (um para muitos)  → 1 cliente tem N pedidos
N:N (muitos p/ muitos)→ N produtos em N pedidos (tabela associativa)
```

### Chaves

```
PRIMARY KEY   → Identifica cada linha (único, não nulo)
FOREIGN KEY   → Liga uma tabela a outra (referência)
COMPOSITE KEY → Chave composta por 2+ colunas
```

### Normalização

```
1FN → Cada coluna tem um único valor
2FN → Toda coluna não-chave depende da chave completa
3FN → Nenhuma coluna depende de outra não-chave
```

---

## 🚀 Desafios Extras

Depois de estudar todos os arquivos, tente:

1. **Criar uma view** que mostre o resumo de vendas por cliente
2. **Criar um índice** para melhorar performance das consultas
3. **Criar uma procedure** que gere relatório mensal de vendas
4. **Criar um evento** que limpe logs antigos automaticamente
5. **Adicionar mais dados** e testar cenários diferentes

---

## 📌 Recursos Úteis

- [MySQL Documentation](https://dev.mysql.com/doc/)
- [MySQL Tutorial](https://www.mysqltutorial.org/)
- [SQL Style Guide](https://www.sqlstyle.guide/)

---

## ✅ Checklist de Aprendizado

- [ ] Entendo a diferença entre banco, tabela, coluna e registro
- [ ] Sei criar tabelas com chaves estrangeiras
- [ ] Consigo fazer SELECT com WHERE, ORDER BY e LIMIT
- [ ] Sei usar funções de agregação (COUNT, SUM, AVG)
- [ ] Consigo fazer JOIN entre 2 ou mais tabelas
- [ ] Sei criar funções com RETURN
- [ ] Sei criar procedures com parâmetros IN/OUT
- [ ] Entendo o funcionamento de triggers

---

**Bons estudos! 🚀** Qualquer dúvida, consulte os comentários nos arquivos SQL ou pesquise na documentação oficial do MySQL.
