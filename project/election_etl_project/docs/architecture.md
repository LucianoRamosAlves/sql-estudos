# 🗂️ Arquitetura do Projeto

## ⚙️ config/

Arquivos de configuração do projeto.

- `.env`
- credenciais
- variáveis ambiente
- caminhos

---

## 📁 data/

Armazena os arquivos CSV do pipeline.

### 🥉 raw/

Dados brutos/originais.

Relaciona com a camada bronze.

- votos sujos
- candidatos sujos
- cargos sujos

### 🥈 processed/

Dados tratados/intermediários.

Relaciona com a camada silver.

### 🥇 exports/

Saídas finais do projeto.

Relaciona com a camada gold.

#### 📜 auditoria/

Exports de auditoria e rastreamento.

#### 🧑 eleitores/

Exports relacionados aos eleitores.

#### 📊 ranking/

Ranking final de votos.

#### 🏆 vencedores/

Resultado final da eleição.

---

## 📚 docs/

Documentação do projeto.

### 🏗️ architecture.md

Explica a arquitetura geral do projeto.

### 📋 business_rules.md

Documenta regras de negócio.

### 📖 data_dictionary.md

Explica colunas e tabelas.

### 🔄 pipeline_flow.md

Explica o fluxo ETL do pipeline.

---

## 📝 logs/

Logs operacionais do pipeline.

### ⏰ cron/

Logs de automações agendadas.

### 📤 exports/

Logs de exportação.

### 📥 imports/

Logs de importação CSV.

### ⚡ processing/

Logs de processamento e limpeza.

---

## 🛠️ scripts/

Scripts Bash de automação.

### 📥 import_csv.sh

Executa os imports CSV.

### ⚡ process_pipeline.sh

Executa o pipeline ETL.

### 📤 export_reports.sh

Executa exports finais.

### 💾 backup.sh

Executa backups do projeto/banco.

---

## 🐬 sql/

Toda lógica do MySQL.

---

### 🧱 schema/

Estrutura do banco de dados.

#### 📄 tables.sql

Criação das tabelas bronze, silver e gold.

#### 🔒 constraints.sql

PRIMARY KEY, FOREIGN KEY, UNIQUE, CHECK e NOT NULL.

#### 🚀 indexes.sql

Índices de performance.

---

### 📥 imports/

Importação dos CSVs brutos para tabelas bronze.

#### 🗳️ import_raw_votes.sql

Importa votos CSV.

#### 🧑‍💼 import_raw_candidates.sql

Importa candidatos CSV.

#### 🏛️ import_raw_cargos.sql

Importa cargos CSV.

---

### ⚡ procedures/

Procedures responsáveis pelo ETL.

#### 🗳️ process_votes.sql

Processa votos bronze → silver.

#### 🧹 clean_candidates.sql

Limpa e normaliza candidatos.

#### 📊 export_reports.sql

Gera relatórios finais gold.

---

### 🔔 triggers/

Triggers de validação e auditoria.

#### 🚫 before_triggers.sql

Validações BEFORE INSERT/UPDATE/DELETE.

#### 📜 audit_triggers.sql

Auditoria AFTER UPDATE/DELETE.

---

### 👁️ views/

Views analíticas e relatórios.

#### 📊 vw_ranking.sql

View ranking candidatos.

#### 🏆 vw_winners.sql

View vencedores.

#### 📜 vw_auditoria.sql

View auditoria.

---

### 🌱 seeds/

Dados iniciais/fixos do sistema.

#### 📦 initial_data.sql

Carga inicial de dados.

---

## 🏗️ Camadas do Pipeline

### 🥉 Bronze

Dados crus importados diretamente dos CSVs.

Exemplo:

- bronze_votos
- bronze_candidatos
- bronze_cargos

---

### 🥈 Silver

Dados tratados, limpos e normalizados.

Exemplo:

- silver_votos
- silver_candidatos
- silver_cargos

---

### 🥇 Gold

Dados finais analíticos e relatórios.

Exemplo:

- gold_ranking
- gold_vencedores
- gold_auditoria

---

## 📘 README.md

Arquivo principal do projeto.

Explica:

- objetivo
- stack
- arquitetura
- execução
- fluxo ETL