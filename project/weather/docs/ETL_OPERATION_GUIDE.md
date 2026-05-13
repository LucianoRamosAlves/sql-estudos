# Guia Completo - Iniciar e Validar Pipeline ETL Weather

# Objetivo

Este documento mostra:

* como iniciar o projeto
* validar conexão MySQL
* verificar WSL
* validar `.env`
* verificar logs
* testar cron
* validar `local_infile`
* executar pipeline ETL manualmente

---

# 1. VALIDAR SE A PASTA DO PROJETO EXISTE

No Ubuntu/WSL:

```bash
ls -la "/mnt/c/Users/lramo/OneDrive/Documentos/Estudos/sql-estudos/project/weather"
```

Se aparecer:

```text
No such file or directory
```

então:

* caminho está errado
* OneDrive mudou pasta
* projeto foi movido

---

# 2. ENTRAR NA PASTA DO PROJETO

```bash
cd /mnt/c/Users/lramo/OneDrive/Documentos/Estudos/sql-estudos/project/weather
```

---

# 3. VALIDAR ESTRUTURA DO PROJETO

```bash
ls
```

Deve existir algo parecido:

```text
data
history
logs
scripts
sql
.env
```

---

# 4. CARREGAR VARIÁVEIS AMBIENTE

```bash
source .env
```

Se não aparecer erro:

* `.env` foi carregado corretamente

---

# 5. VALIDAR VARIÁVEIS DO `.env`

## Ver host

```bash
echo $DB_HOST
```

---

## Ver usuário

```bash
echo $DB_USER
```

---

## Ver banco

```bash
echo $DB_NAME
```

---

# 6. TESTAR CONEXÃO MYSQL

```bash
mysql -h $DB_HOST -u $DB_USER -p
```

Digite senha.

Se conectar:

* MySQL OK
* rede OK
* usuário OK
* WSL OK

---

# 7. VALIDAR `local_infile`

Entrar no MySQL:

```bash
mysql -h $DB_HOST -u $DB_USER -p
```

---

## Verificar variável

```sql
SHOW GLOBAL VARIABLES LIKE 'local_infile';
```

Resultado esperado:

```text
ON
```

---

## Se estiver OFF

Ativar:

```sql
SET GLOBAL local_infile = 1;
```

---

# 8. VALIDAR CSV

Verificar se arquivo existe:

```bash
ls data
```

Resultado esperado:

```text
weather.csv
```

---

# 9. VALIDAR SCRIPT BASH

Executar manualmente:

```bash
bash scripts/weather.sh
```

---

# 10. POSSÍVEIS RESULTADOS

## Sucesso

```text
Carga staging executada com sucesso
Arquivo processado com sucesso
```

---

## Falha staging

```text
Erro durante carga staging
```

Ver log:

```bash
cat logs/load_weather.log
```

---

## Falha ETL

```text
Erro no ETL final
```

Verificar:

* procedure
* tabelas
* SQL
* permissões

---

# 11. VALIDAR LOGS

## Ver logs completos

```bash
cat logs/load_weather.log
```

---

## Ver últimas linhas

```bash
tail logs/load_weather.log
```

---

## Acompanhar tempo real

```bash
tail -f logs/load_weather.log
```

---

# 12. VALIDAR CRON

## Ver status

```bash
service cron status
```

Resultado esperado:

```text
active (running)
```

---

## Iniciar cron

```bash
sudo service cron start
```

---

## Reiniciar cron

```bash
sudo service cron restart
```

---

## Parar cron

```bash
sudo service cron stop
```

---

# 13. VER TAREFAS CRON

```bash
crontab -l
```

---

# 14. EDITAR CRON

```bash
crontab -e
```

---

# 15. EXEMPLO CRON PIPELINE

Executa a cada 5 minutos:

```cron
*/5 * * * * cd /mnt/c/Users/lramo/OneDrive/Documentos/Estudos/sql-estudos/project/weather && ./scripts/weather.sh >> cron.log 2>&1
```

---

# 16. TESTAR CRON

## Colocar novo CSV em:

```text
data/weather.csv
```

---

## Esperar cron executar

Depois verificar:

```text
history/raw/
history/clean/
```

---

# 17. VER LOGS DO CRON

```bash
cat cron.log
```

---

# 18. VALIDAR TABELAS MYSQL

Entrar MySQL:

```bash
mysql -h $DB_HOST -u $DB_USER -p
```

---

## Ver tabelas

```sql
SHOW TABLES;
```

---

## Ver staging

```sql
SELECT *
FROM weather_staging
LIMIT 10;
```

---

## Ver tabela final

```sql
SELECT *
FROM current_weather
LIMIT 10;
```

---

# 19. FLUXO COMPLETO DO PIPELINE

```text
weather.csv
    ↓
load_weather.sql
    ↓
weather_staging
    ↓
copy_weather.sql
    ↓
current_weather
    ↓
history/raw
    ↓
history/clean
```

---

# 20. RESPONSABILIDADE DE CADA CAMADA

| Camada          | Função             |
| --------------- | ------------------ |
| data            | entrada CSV        |
| staging         | dados crus         |
| current_weather | dados limpos       |
| history/raw     | histórico bruto    |
| history/clean   | histórico limpo    |
| logs            | auditoria execução |
| scripts         | automação          |
| sql             | ETL                |

---

# 21. PROBLEMAS MAIS COMUNS

| Problema         | Solução                    |
| ---------------- | -------------------------- |
| Unknown host     | verificar DB_HOST          |
| Access denied    | verificar usuário/senha    |
| local_infile OFF | ativar variável            |
| CSV not found    | validar caminho            |
| CRLF             | trocar para LF             |
| staging vazio    | validar CSV                |
| cron não executa | iniciar serviço cron       |
| logs vazios      | verificar redirecionamento |

---

# 22. COMANDOS IMPORTANTES

## Ver processos cron

```bash
ps aux | grep cron
```

---

## Ver permissões script

```bash
ls -l scripts/weather.sh
```

---

## Tornar executável

```bash
chmod +x scripts/weather.sh
```

---

## Ver arquivos history

```bash
ls history/raw
ls history/clean
```

---

# 23. OBSERVAÇÃO IMPORTANTE SOBRE WSL

O cron no WSL:

* funciona enquanto WSL estiver ativo
* para se Windows reiniciar
* para se WSL for encerrado

Para projetos de estudo:

isso é totalmente aceitável.
