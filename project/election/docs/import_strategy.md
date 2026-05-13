# 📥 Estratégia de Importação CSV

O MySQL possui duas formas principais de importar arquivos CSV:

- `LOAD DATA INFILE`
- `LOAD DATA LOCAL INFILE`

---

# 🖥️ LOAD DATA INFILE

O próprio MySQL acessa o arquivo diretamente no servidor.

## Características

- mais usado em ambientes profissionais
- maior controle de segurança
- melhor performance para arquivos grandes
- comum em pipelines ETL corporativos

## Fluxo

```text
Servidor/Storage
        ↓
MySQL lê o arquivo diretamente
```

## Observações

O arquivo CSV precisa existir em um local acessível pelo MySQL.

---

# 💻 LOAD DATA LOCAL INFILE

O cliente MySQL envia o arquivo para o servidor.

## Características

- mais comum em projetos locais
- mais simples para desenvolvimento
- ideal para estudos e automações pequenas

## Fluxo

```text
Cliente/Notebook
        ↓
Cliente MySQL envia
        ↓
Servidor MySQL importa
```

## Observações

O arquivo pode estar dentro do projeto local, como:

```text
data/raw/
```

---

# 📌 Resumo

| Tipo | Quem lê o arquivo |
|---|---|
| INFILE | MySQL servidor |
| LOCAL INFILE | Cliente MySQL |

---

# 🏗️ Estratégia deste Projeto

Neste projeto será utilizado principalmente:

```sql
LOAD DATA LOCAL INFILE
```

Porque os arquivos CSV estão armazenados localmente dentro da estrutura do projeto.