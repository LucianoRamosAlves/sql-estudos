# Automatização ETL com Cron no WSL

## Objetivo

Automatizar a execução do pipeline ETL utilizando:

* Bash
* Cron
* WSL Ubuntu
* MySQL
* CSV

Fluxo automatizado:

```text
CSV chega
    ↓
cron executa script bash
    ↓
LOAD DATA
    ↓
staging
    ↓
ETL SQL
    ↓
tabela limpa
    ↓
raw histórico
    ↓
clean histórico
    ↓
logs
```

---

# 1. Verificar se o script funciona manualmente

Antes do cron, o script precisa funcionar sozinho.

## Executar manualmente

```bash
bash scripts/weather.sh
```

Se funcionar:

* conexão MySQL OK
* CSV OK
* ETL OK
* logs OK

---

# 2. Dar permissão de execução

Na raiz do projeto:

```bash
chmod +x scripts/weather.sh
```

---

# 3. Testar execução direta

```bash
./scripts/weather.sh
```

---

# 4. Iniciar serviço cron

## Iniciar cron

```bash
sudo service cron start
```

---

## Verificar status

```bash
service cron status
```

Resultado esperado:

```text
active (running)
```

---

# 5. Abrir configuração do cron

```bash
crontab -e
```

Na primeira vez:

* escolha nano

---

# 6. Configurar agendamento

## Executar a cada 5 minutos

```cron
*/5 * * * * cd /mnt/c/Users/lramo/OneDrive/Documentos/Estudos/sql-estudos/project/weather && ./scripts/weather.sh >> cron.log 2>&1
```

---

# 7. Explicação da linha cron

| Parte                  | Significado              |
| ---------------------- | ------------------------ |
| `*/5`                  | executa a cada 5 minutos |
| `cd ...`               | entra na pasta projeto   |
| `./scripts/weather.sh` | executa o script         |
| `>> cron.log`          | salva logs               |
| `2>&1`                 | salva erros também       |

---

# 8. Salvar no nano

## Salvar

```text
CTRL + O
```

Depois:

```text
ENTER
```

---

## Sair

```text
CTRL + X
```

---

# 9. Verificar cron salvo

```bash
crontab -l
```

---

# 10. Testar automação

## Colocar novo CSV em:

```text
data/weather.csv
```

---

## Esperar execução do cron

Se estiver:

```cron
*/5 * * * *
```

executa:

* a cada 5 minutos

---

# 11. Validar processamento

Verifique:

## Arquivo saiu de:

```text
data/
```

---

## Arquivo bruto foi para:

```text
history/raw/
```

---

## Arquivo limpo foi para:

```text
history/clean/
```

---

## Logs

```bash
cat cron.log
```

ou:

```bash
tail -f cron.log
```

---

# 12. Estrutura final do projeto

```text
weather/
│
├── data/
│   └── weather.csv
│
├── history/
│   ├── raw/
│   └── clean/
│
├── logs/
│
├── scripts/
│   └── weather.sh
│
├── sql/
│   ├── load_weather.sql
│   └── copy_weather.sql
│
├── .env
├── .gitignore
└── cron.log
```

---

# 13. Estrutura ETL

## Entrada

```text
CSV bruto
```

---

## Staging

```text
weather_staging
```

Tabela temporária contendo:

* dados crus
* sem tratamento

---

## Transformação

Arquivo:

```text
copy_weather.sql
```

Responsável por:

* limpeza
* transformação
* padronização
* inserts finais

---

## Tabela final

```text
current_weather
```

Contém:

* dados limpos
* dados prontos para consumo

---

# 14. Raw vs Clean

## Raw

```text
history/raw/
```

Contém:

* CSV original
* sem alterações
* usado para auditoria

---

## Clean

```text
history/clean/
```

Contém:

* CSV tratado
* exportado da tabela final
* pronto para análise

---

# 15. Comandos úteis

## Ver cron ativo

```bash
service cron status
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

## Ver tarefas cron

```bash
crontab -l
```

---

## Remover todos os crons

```bash
crontab -r
```

---

# 16. Observações importantes

## O cron no WSL depende do WSL ativo

Se:

* Windows reiniciar
* WSL parar
* Ubuntu fechar completamente

então:

* cron para também

---

## Para projetos de estudo

Isso é totalmente aceitável.

---

# 17. O que este projeto utiliza

| Tecnologia    | Uso               |
| ------------- | ----------------- |
| Bash          | orquestração      |
| Cron          | automação         |
| MySQL         | banco dados       |
| WSL Ubuntu    | ambiente Linux    |
| LOAD DATA     | ingestão CSV      |
| SQL Procedure | transformação ETL |
| Logs          | observabilidade   |
| Staging       | camada temporária |
| History       | rastreabilidade   |

---
