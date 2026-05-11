# EXECUÇÃO DO PROJETO WEATHER PELO TERMINAL MYSQL

Este passo a passo mostra como:

1. Abrir o terminal
2. Conectar no MySQL
3. Habilitar `LOAD DATA LOCAL INFILE`
4. Executar os arquivos SQL
5. Rodar a procedure
6. Verificar resultados

---

# PASSO 1 — ABRIR O TERMINAL

No Windows:

- pressione:

```bash
WIN + R
```

- digite:

```bash
cmd
```

- pressione:

```bash
ENTER
```

Isso abrirá o Prompt de Comando.

---

# PASSO 2 — CONECTAR NO MYSQL

## IMPORTANTE

Usamos:

```bash
--local-infile=1
```

para permitir:

```sql
LOAD DATA LOCAL INFILE
```

## Comando

```bash
mysql --local-infile=1 -u root -p
```

## Explicação

### mysql

Inicia o cliente MySQL.

### --local-infile=1

Habilita importação de arquivos CSV locais.

### -u root

Usuário do banco.

### -p

Solicita senha.

Após executar:

- digite sua senha
- pressione ENTER

---

# PASSO 3 — VERIFICAR SE local_infile ESTÁ ATIVADO

Dentro do MySQL execute:

```sql
SHOW VARIABLES LIKE 'local_infile';
```

## Resultado esperado

```text
+---------------+-------+
| Variable_name | Value |
+---------------+-------+
| local_infile  | ON    |
+---------------+-------+
```

---

# PASSO 4 — CASO local_infile ESTEJA OFF

Execute:

```sql
SET GLOBAL local_infile = ON;
```

Depois:

- saia do MySQL
- conecte novamente

---

# PASSO 5 — ENTRAR NA PASTA DO PROJETO (OPCIONAL)

Você pode navegar até a pasta do projeto:

```bash
cd C:\Users\lramo\OneDrive\Documentos\Estudos\sql-estudos\project\weather
```

---

# PASSO 6 — EXECUTAR O ARQUIVO SQL

Dentro do MySQL execute:

```sql
SOURCE C:/Users/lramo/OneDrive/Documentos/Estudos/sql-estudos/project/weather/sql/load_weather.sql;
```

---

# IMPORTANTE

- use `/`
- não use `\`
- finalize com `;`

---

# O QUE O SOURCE FAZ

O comando:

```sql
SOURCE
```

executa todo o arquivo SQL:

- cria procedures
- cria functions
- executa cargas
- roda inserts
- executa scripts completos

---

# PAASO 7 NÃO DISPONIVEL
# PASSO 7 — EXECUTAR A PROCEDURE

Após carregar o arquivo:

```sql
CALL sp_load_weather_file();
```

Essa procedure irá:

1. limpar tabela staging
2. carregar CSV
3. converter datas
4. validar dados
5. chamar outras procedures
6. mostrar mensagens/logs

---

# PASSO 8 — VERIFICAR DADOS CARREGADOS

## Visualizar tabela staging

```sql
SELECT *
FROM current_weather_load;
```

## Contar linhas

```sql
SELECT COUNT(*)
FROM current_weather_load;
```

---

# PASSO 9 — EXECUTAR FUNÇÃO DE CONTAGEM

Execute:

```sql
SELECT fn_total_linhas_carregadas();
```

## Exemplo de retorno

```text
Foram carregadas 523 linhas
```

---

# PASSO 10 — VERIFICAR POSSÍVEIS ERROS

Caso aconteça erro durante:

```sql
LOAD DATA
```

Verifique:

1. caminho do CSV
2. extensão do arquivo
3. `local_infile`
4. permissões
5. delimitadores CSV

---

# PASSO 11 — EXEMPLO COMPLETO DE EXECUÇÃO

## Conectar no MySQL

```bash
mysql --local-infile=1 -u root -p
```

## Verificar configuração

```sql
SHOW VARIABLES LIKE 'local_infile';
```

## Executar script

```sql
SOURCE C:/Users/lramo/OneDrive/Documentos/Estudos/sql-estudos/project/weather/sql/load_weather.sql;
```

## Executar procedure

```sql
CALL sp_load_weather_file();
```

## Verificar total carregado

```sql
SELECT fn_total_linhas_carregadas();
```

---

# RESUMO DO FLUXO ETL

```text
CSV
 ↓
LOAD DATA
 ↓
staging table
 ↓
validações
 ↓
processamento
 ↓
tabela final
```