# Weather Table Dictionary

# Tabela: `current_weather_load`

Tabela responsável pela ingestão de dados meteorológicos brutos provenientes de arquivos CSV carregados via:

```sql
LOAD DATA LOCAL INFILE
```

---

# Data Dictionary

| Coluna                | Tipo           | Exemplo               | Obrigatório | Descrição                                     |
| --------------------- | -------------- | --------------------- | ----------- | --------------------------------------------- |
| `station_id`          | `INT`          | `1`                   | ✅           | Identificador único da estação meteorológica. |
| `station_city`        | `VARCHAR(100)` | `São Luís`            | ✅           | Nome da cidade da estação meteorológica.      |
| `station_state`       | `CHAR(2)`      | `MA`                  | ❌           | Sigla do estado brasileiro.                   |
| `station_lat`         | `DECIMAL(6,4)` | `-2.5307`             | ✅           | Latitude da estação meteorológica.            |
| `station_lon`         | `DECIMAL(7,4)` | `-44.3028`            | ✅           | Longitude da estação meteorológica.           |
| `as_of_date`          | `DATETIME`     | `2026-05-12 15:30:00` | ❌           | Data e horário da coleta meteorológica.       |
| `temp`                | `INT`          | `31`                  | ✅           | Temperatura registrada no momento da coleta.  |
| `feels_like`          | `INT`          | `35`                  | ✅           | Sensação térmica percebida.                   |
| `wind_speed`          | `INT`          | `18`                  | ✅           | Velocidade do vento em km/h.                  |
| `wind_direction`      | `VARCHAR(3)`   | `NE`                  | ❌           | Direção cardinal do vento.                    |
| `precipitation`       | `DECIMAL(3,1)` | `12.5`                | ❌           | Quantidade de precipitação/chuva.             |
| `pressure`            | `DECIMAL(6,2)` | `1013.25`             | ❌           | Pressão atmosférica.                          |
| `visibility`          | `DECIMAL(3,1)` | `10.0`                | ✅           | Distância de visibilidade atmosférica.        |
| `humidity`            | `INT`          | `85`                  | ❌           | Percentual de umidade relativa do ar.         |
| `weather_description` | `VARCHAR(100)` | `Cloudy`              | ✅           | Descrição textual do clima.                   |
| `sunrise`             | `TIME`         | `05:48:00`            | ❌           | Horário do nascer do sol.                     |
| `sunset`              | `TIME`         | `17:59:00`            | ❌           | Horário do pôr do sol.                        |

---

# Constraints de Validação

| Campo            | Validação                 |
| ---------------- | ------------------------- |
| `station_lat`    | Entre `-90` e `90`        |
| `station_lon`    | Entre `-180` e `180`      |
| `temp`           | Entre `-30` e `170`       |
| `feels_like`     | Entre `-30` e `170`       |
| `wind_speed`     | Entre `0` e `300`         |
| `precipitation`  | Entre `0` e `400`         |
| `pressure`       | Entre `0` e `1100`        |
| `visibility`     | Entre `0` e `20`          |
| `humidity`       | Entre `0` e `100`         |
| `wind_direction` | Valores cardinais válidos |
| `station_state`  | UFs válidas do Brasil     |

---

# Tabela Final: `current_weather`

Tabela derivada da staging contendo dados tratados e enriquecidos.

---

# Colunas Adicionadas na Camada Clean

| Coluna         | Tipo           | Exemplo    | Descrição                                        |
| -------------- | -------------- | ---------- | ------------------------------------------------ |
| `state_name`   | `VARCHAR(100)` | `Maranhão` | Nome completo do estado.                         |
| `cod_temp`     | `VARCHAR(50)`  | `HIGH`     | Classificação categórica da temperatura.         |
| `cod_pressure` | `VARCHAR(50)`  | `NORMAL`   | Classificação categórica da pressão atmosférica. |
| `flag_last`    | `INT`          | `1`        | Indica o registro mais recente da estação.       |

---

# Arquitetura ETL

```text
CSV bruto
    ↓
current_weather_load
    ↓
transformações SQL
    ↓
current_weather
```

---

# Objetivo da Arquitetura

| Camada                 | Objetivo                          |
| ---------------------- | --------------------------------- |
| `current_weather_load` | Receber dados crus do CSV         |
| `current_weather`      | Armazenar dados limpos e tratados |

---

# Conceitos Aplicados

* ETL batch
* staging layer
* clean layer
* data validation
* data quality
* SQL transformation
* weather analytics
