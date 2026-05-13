# 🌦️ Weather ETL Pipeline

Pipeline ETL automatizada para ingestão, tratamento, transformação e exportação de dados meteorológicos utilizando **Bash**, **MySQL**, **WSL Ubuntu** e **Cron**.

---

# 🚀 Sobre o Projeto

Este projeto foi desenvolvido com foco em:

* 🛠️ Engenharia de Dados
* 🐧 Automação Linux
* 🔄 ETL Batch
* 🧠 SQL avançado
* ⚙️ Orquestração Bash
* 🔗 Integração WSL + MySQL
* 📂 Processamento CSV

A pipeline simula um fluxo real de ingestão e tratamento de dados meteorológicos recebidos via arquivos CSV.

---

# 🎯 Objetivo

O objetivo principal do projeto é construir uma pipeline ETL automatizada capaz de:

* 📥 receber arquivos CSV meteorológicos
* 🗄️ carregar dados no MySQL
* 🧱 utilizar camada staging
* 🧹 transformar e padronizar dados
* 🗃️ gerar histórico raw e clean
* ⏰ automatizar processamento via cron
* 📜 registrar logs operacionais
* 🧩 organizar estrutura modular de ETL

---

# 🏗️ Arquitetura do Pipeline

```text
CSV bruto
    ↓
LOAD DATA LOCAL INFILE
    ↓
current_weather_load (staging)
    ↓
transformações SQL
    ↓
current_weather (clean)
    ↓
export CSV limpo
    ↓
history/raw
history/clean
```

---

# 🧠 Arquitetura ETL Aplicada

O projeto utiliza uma arquitetura baseada em camadas:

| Camada     | Objetivo                    |
| ---------- | --------------------------- |
| 🟤 Raw     | Arquivo CSV original        |
| 🟡 Staging | Ingestão temporária         |
| 🟢 Clean   | Dados tratados              |
| 🔵 History | Histórico versionado        |
| ⚫ Logs     | Observabilidade operacional |

---

# 💻 Tecnologias Utilizadas

| Tecnologia                | Finalidade            |
| ------------------------- | --------------------- |
| 🐚 Bash                   | Orquestração ETL      |
| 🐬 MySQL                  | Persistência de dados |
| 📜 SQL                    | Transformações        |
| 🐧 WSL Ubuntu             | Ambiente Linux        |
| ⏰ Cron                    | Automação             |
| 📂 LOAD DATA LOCAL INFILE | Ingestão CSV          |
| 🌐 Git/GitHub             | Versionamento         |
| 🧠 VS Code                | Desenvolvimento       |

---

# 📁 Estrutura do Projeto

```text
weather/
├── cron.log
│
├── data
│   └── weather.csv
│
├── docs
│   ├── ETL_OPERATION_GUIDE.md
│   ├── cron_setup.md
│   ├── data_dictionary.md
│   └── mysql_terminal_execution.md
│
├── history
│   ├── clean
│   │   ├── clean_weather_20260512175929.csv
│   │   ├── clean_weather_20260512180522.csv
│   │   ├── clean_weather_20260512182003.csv
│   │   ├── clean_weather_20260512182504.csv
│   │   └── weather_clean_20260512172611.csv
│   │
│   └── raw
│       ├── h_weather.csv.20260512171005
│       ├── raw_weather_20260512175929.csv
│       ├── raw_weather_20260512180522.csv
│       ├── raw_weather_20260512182003.csv
│       ├── raw_weather_20260512182504.csv
│       └── weather_raw_20260512172611.csv
│
├── logs
│   └── load_weather.log
│
├── scripts
│   └── weather.sh
│
└── sql
    ├── copy_weather.sql
    ├── create_database.sql
    ├── create_table.sql
    ├── function.sql
    ├── load_weather.sql
    ├── query.sql
    └── tratament.sql
```

---

# 🔄 Fluxo Completo do ETL

## 📥 1. Recebimento do CSV

O arquivo bruto é enviado para:

```text
data/weather.csv
```

---

## 🚚 2. Ingestão Raw

O script:

```text
sql/load_weather.sql
```

é responsável por:

* truncar staging
* executar `LOAD DATA LOCAL INFILE`
* carregar CSV bruto
* realizar ingestão rápida

---

## 🟡 3. Camada Staging

Tabela:

```sql
current_weather_load
```

Responsável por:

* armazenar dados crus
* validar estrutura inicial
* desacoplar ingestão da transformação

---

## 🧹 4. Transformação ETL

O script:

```text
sql/copy_weather.sql
```

realiza:

* limpeza
* padronização
* enriquecimento
* tratamento de dados
* inserção final

---

## 🟢 5. Camada Clean

Tabela final:

```sql
current_weather
```

Contém:

* dados tratados
* dados padronizados
* informações prontas para análise

---

## 🗂️ 6. Histórico Raw

Arquivos brutos processados são movidos para:

```text
history/raw/
```

Objetivos:

* auditoria
* rastreabilidade
* reprocessamento

---

## 📊 7. Histórico Clean

Arquivos limpos exportados da tabela final são armazenados em:

```text
history/clean/
```

Objetivos:

* analytics
* datasets tratados
* exportação final

---

# ⚙️ Bash Orchestration

A pipeline é controlada pelo script:

```text
scripts/weather.sh
```

Responsabilidades:

* carregar `.env`
* validar CSV
* executar scripts SQL
* controlar erros
* capturar logs
* exportar datasets
* mover arquivos processados
* automatizar ETL

---

# ⏰ Automação com Cron

Automação configurada utilizando:

```cron
*/5 * * * * cd /mnt/c/Users/lramo/OneDrive/Documentos/Estudos/sql-estudos/project/weather && ./scripts/weather.sh >> cron.log 2>&1
```

Executa automaticamente:

* 🔁 a cada 5 minutos

---

# ✅ Funcionalidades Implementadas

* [x] 📥 Ingestão CSV
* [x] 📂 LOAD DATA LOCAL INFILE
* [x] 🔄 Pipeline ETL
* [x] 🧱 Camada staging
* [x] 🧹 Transformação SQL
* [x] ⚙️ Procedures
* [x] 🧠 Functions
* [x] 🐚 Automação Bash
* [x] ⏰ Scheduler Cron
* [x] 📜 Logging operacional
* [x] 🗃️ Histórico raw/clean
* [x] 📤 Exportação CSV
* [x] 🔐 Variáveis ambiente
* [x] 🐧 Integração WSL + MySQL
* [x] 🧩 Estrutura modular SQL
* [x] ✅ Data validation
* [x] 🛡️ Check constraints

---

# 🧾 Estrutura SQL

| Arquivo               | Objetivo               |
| --------------------- | ---------------------- |
| `create_database.sql` | Criação banco          |
| `create_table.sql`    | Criação tabelas        |
| `load_weather.sql`    | Ingestão CSV           |
| `copy_weather.sql`    | Transformação ETL      |
| `function.sql`        | Funções SQL            |
| `query.sql`           | Queries análise        |
| `tratament.sql`       | Tratamentos adicionais |

---

# 🧬 Modelo de Dados

O projeto utiliza:

* tabela staging
* tabela clean
* constraints
* validações SQL
* arquitetura raw/clean

📘 Documentação detalhada disponível em:

```text
docs/data_dictionary.md
```

---

# 📜 Logs

Logs utilizados:

```text
logs/load_weather.log
cron.log
```

Objetivos:

* troubleshooting
* auditoria
* monitoramento
* rastreabilidade

---

# 🔐 Variáveis Ambiente

Arquivo:

```text
.env
```

Exemplo:

```bash
DB_HOST=172.xxx.xxx.xxx
DB_NAME=weather
DB_USER=root
DB_PASSWORD=*******
```

---

# ▶️ Como Executar Manualmente

## 📂 Entrar na pasta projeto

```bash
cd /mnt/c/Users/lramo/OneDrive/Documentos/Estudos/sql-estudos/project/weather
```

---

## 🚀 Executar pipeline

```bash
bash scripts/weather.sh
```

---

# ⏰ Como Configurar o Cron

## ▶️ Iniciar serviço

```bash
sudo service cron start
```

---

## 📊 Verificar status

```bash
service cron status
```

---

## ✏️ Editar agendamentos

```bash
crontab -e
```

---

# 🧯 Troubleshooting

Durante o desenvolvimento foram resolvidos problemas relacionados a:

* 🌐 WSL networking
* 🖥️ host remoto MySQL
* 🔐 permissões MySQL
* 📂 `LOCAL INFILE`
* 🔄 CRLF vs LF
* 🐚 automação bash
* ⏰ cron jobs
* 📤 exportação CSV
* 🔑 variáveis ambiente
* 🛠️ troubleshooting Linux/MySQL

---

# 🧠 Conceitos de Engenharia de Dados Aplicados

* 🔄 ETL batch
* 🧱 staging layer
* 🟤 raw vs 🟢 clean architecture
* ✅ data quality
* 🧹 SQL transformation
* 🐧 Linux automation
* ⚙️ Bash orchestration
* 📡 operational pipelines
* 📂 CSV ingestion
* 📜 observabilidade
* 📝 logging
* ⏰ scheduling

---

# 📚 Documentação

Documentação disponível em:

```text
docs/
```

| Documento                     | Objetivo              |
| ----------------------------- | --------------------- |
| `ETL_OPERATION_GUIDE.md`      | Guia operacional ETL  |
| `cron_setup.md`               | Configuração cron     |
| `mysql_terminal_execution.md` | Execução manual MySQL |
| `data_dictionary.md`          | Dicionário dados      |

---

# 🚀 Melhorias Futuras

* incremental load
* validação arquivos corrompidos
* data quality pipeline
* Docker
* Python ETL
* Pandas
* Airflow
* APIs meteorológicas
* monitoramento
* observabilidade
* dashboards analytics

---

# 📖 Aprendizados Técnicos

Este projeto envolveu prática real de:

* SQL
* MySQL
* Bash scripting
* Linux
* WSL
* ETL
* Automação
* Cron
* Data Engineering
* Troubleshooting
* Arquitetura de dados

---

# 👨‍💻 Autor

Projeto desenvolvido para estudos práticos de:

* Engenharia de Dados
* Automação Linux
* ETL
* SQL
* MySQL
* Bash Scripting
* Arquitetura de Dados
