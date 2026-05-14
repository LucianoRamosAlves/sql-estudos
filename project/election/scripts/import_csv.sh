#!/bin/bash

# =====================================================
# CARREGA VARIÁVEIS DO .ENV
# =====================================================

# source:
# carrega variáveis ambiente para dentro do script
#
# exemplo:
# MYSQL_HOST
# MYSQL_USER
# MYSQL_PASSWORD
# PROJECT_PATH
#
# IMPORTANTE:
# o source precisa acontecer ANTES do uso das variáveis
#
# também é importante entrar primeiro na pasta do projeto
# para o bash conseguir encontrar o arquivo .env

cd /mnt/c/Users/lramo/OneDrive/Documentos/Estudos/sql-estudos/project/election || exit 1

source config/.env

# =====================================================
# VARIÁVEIS DO PROJETO
# =====================================================

# pasta raiz do projeto
PROJECT_PATH="/mnt/c/Users/lramo/OneDrive/Documentos/Estudos/sql-estudos/project/election"

# pasta onde ficam os arquivos processados
ARCHIVE_PATH="$PROJECT_PATH/data/history/imports"

# pasta onde ficam os arquivos sql de importação
SQL_PATH="$PROJECT_PATH/sql/imports"

# pasta onde os logs serão armazenados
LOG_PATH="$PROJECT_PATH/logs/imports"

# data/hora atual
# será utilizada dentro dos logs
DATE=$(date '+%Y-%m-%d %H:%M:%S')

# =====================================================
# GARANTE QUE A PASTA DE LOG EXISTA
# =====================================================

# mkdir -p:
# cria a pasta caso ela não exista
#
# o -p evita erro se a pasta já existir

mkdir -p "$LOG_PATH"

mkdir -p "$ARCHIVE_PATH/h_cargos"
mkdir -p "$ARCHIVE_PATH/h_votos"
mkdir -p "$ARCHIVE_PATH/h_candidatos"



# =====================================================
# DEFINE NOME DO LOG
# =====================================================

# arquivo final:
# logs/imports/import_cargos.log

LOG_FILE="$LOG_PATH/import_cargos.log" 

# =====================================================
# INÍCIO DO PROCESSO
# =====================================================

# >>
# adiciona texto ao final do arquivo
# sem apagar logs antigos

# exemplo resultado:
# [2026-05-13 14:00:00] START IMPORT bronze_cargos

echo "[$DATE] START IMPORT bronze_cargos" >> "$LOG_FILE"

# =====================================================
# EXECUTA IMPORTAÇÃO MYSQL
# =====================================================

# --local-infile=1
# habilita LOAD DATA LOCAL INFILE
#
# -h
# host/ip do mysql
#
# -u
# usuário mysql
#
# -p
# solicita senha mysql
#
# <
# envia o arquivo sql para o mysql executar
#
# >>
# salva saída normal no log
#
# 2>&1
# salva erros no mesmo log
#
# stdout = saída normal
# stderr = saída erro
#
# com 2>&1:
# tudo vai para o mesmo arquivo

# =====================================================
# TESTA CONEXÃO MYSQL
# =====================================================

echo "[$DATE] Testando conexão com MySQL..." >> "$LOG_FILE"

mysql -sN \
-e "SELECT 1;" \
>> "$LOG_FILE" 2>&1

# =====================================================
# VERIFICA SE O MYSQL EXECUTOU COM SUCESSO e CONEXAÇO
# =====================================================

# $? = status do último comando executado
#
# 0 = sucesso
# diferente de 0 = erro

# =====================================================
# VERIFICA CONEXÃO
# =====================================================

if [ $? -eq 0 ]; then

    echo "[$DATE] Conexão MySQL estabelecida com sucesso" >> "$LOG_FILE"

    # =====================================================
    # IMPORTAÇÃO CSV
    # =====================================================

    echo "[$DATE] Carregando CSV cargos..." >> "$LOG_FILE"

    mysql --local-infile=1 \
    < "$SQL_PATH/load_cargos.sql" \
    >> "$LOG_FILE" 2>&1

    # =====================================================
    # VERIFICA IMPORTAÇÃO
    # =====================================================

    if [ $? -eq 0 ]; then

        echo "[$DATE] CSV carregado com sucesso" >> "$LOG_FILE"

        echo "[$DATE] Dados inseridos com sucesso" >> "$LOG_FILE"

        mv "$PROJECT_PATH/data/raw/cargos/raw_cargos.csv" \
        "$ARCHIVE_PATH/h_cargos/h_cargos_$(date '+%Y%m%d_%H%M%S').csv"

        echo "[$DATE] PROCESSO EXECUTADO COM SUCESSO" >> "$LOG_FILE"

        echo "=-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=" >> "$LOG_FILE"

    else

        echo "[$DATE] ERRO ao importar CSV cargos" >> "$LOG_FILE"

        echo "=-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=" >> "$LOG_FILE"

    fi

else

    echo "[$DATE] ERRO na conexão com MySQL" >> "$LOG_FILE"

    echo "=-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=" >> "$LOG_FILE"

fi

# =====================================================
# GERA HASH DE INTEGRIDADE
# =====================================================

sha256sum "$LOG_FILE" > "$LOG_FILE.sha256"


# =====================================================
# FIM DO PROCESSO
# =====================================================






# =====================================================
# Agora o script de votos
# =====================================================

LOG_FILE="$LOG_PATH/import_votos.log" 

# =====================================================

echo "[$DATE] START IMPORT bronze_votos" >> "$LOG_FILE"

echo "[$DATE] Testando conexão com MySQL..." >> "$LOG_FILE"

mysql -sN \
-e "SELECT 1;" \
>> "$LOG_FILE" 2>&1


if [ $? -eq 0 ]; then

    echo "[$DATE] Conexão MySQL estabelecida com sucesso" >> "$LOG_FILE"

    echo "[$DATE] Carregando CSV votos..." >> "$LOG_FILE"

    mysql --local-infile=1 \
    < "$SQL_PATH/load_votos.sql" \
    >> "$LOG_FILE" 2>&1

    if [ $? -eq 0 ]; then

        echo "[$DATE] CSV carregado com sucesso" >> "$LOG_FILE"

        echo "[$DATE] Dados inseridos com sucesso" >> "$LOG_FILE"

        mv "$PROJECT_PATH/data/raw/votos/raw_votos.csv" \
        "$ARCHIVE_PATH/h_votos/h_votos_$(date '+%Y%m%d_%H%M%S').csv"

        echo "[$DATE] PROCESSO EXECUTADO COM SUCESSO" >> "$LOG_FILE"



        echo "=-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=" >> "$LOG_FILE"

    else

        echo "[$DATE] ERRO ao importar CSV votos" >> "$LOG_FILE"

        echo "=-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=" >> "$LOG_FILE"

    fi

else

    echo "[$DATE] ERRO na conexão com MySQL" >> "$LOG_FILE"

    echo "=-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=" >> "$LOG_FILE"

fi

# =====================================================
# GERA HASH DE INTEGRIDADE
# =====================================================

sha256sum "$LOG_FILE" > "$LOG_FILE.sha256"


# =====================================================
# FIM DO PROCESSO
# =====================================================




# =====================================================
# Agora o script de candidatos
# =====================================================

LOG_FILE="$LOG_PATH/import_candidatos.log" 

# =====================================================

echo "[$DATE] START IMPORT bronze_candidatos" >> "$LOG_FILE"


echo "[$DATE] Testando conexão com MySQL..." >> "$LOG_FILE"

mysql -sN \
-e "SELECT 1;" \
>> "$LOG_FILE" 2>&1


if [ $? -eq 0 ]; then

    echo "[$DATE] Conexão MySQL estabelecida com sucesso" >> "$LOG_FILE"

    echo "[$DATE] Carregando CSV candidatos..." >> "$LOG_FILE"

    mysql --local-infile=1 \
    < "$SQL_PATH/load_candidatos.sql" \
    >> "$LOG_FILE" 2>&1

    if [ $? -eq 0 ]; then

        echo "[$DATE] CSV carregado com sucesso" >> "$LOG_FILE"

        echo "[$DATE] Dados inseridos com sucesso" >> "$LOG_FILE"

        echo "[$DATE] PROCESSO EXECUTADO COM SUCESSO" >> "$LOG_FILE"

        mv "$PROJECT_PATH/data/raw/candidatos/raw_candidatos.csv" \
        "$ARCHIVE_PATH/h_candidatos/h_candidatos_$(date '+%Y%m%d_%H%M%S').csv"

        echo "=-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=" >> "$LOG_FILE"

    else

        echo "[$DATE] ERRO ao importar CSV candidatos" >> "$LOG_FILE"

        echo "=-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=" >> "$LOG_FILE"

    fi

else

    echo "[$DATE] ERRO na conexão com MySQL" >> "$LOG_FILE"

    echo "=-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=" >> "$LOG_FILE"

fi

# =====================================================
# GERA HASH DE INTEGRIDADE
# =====================================================

sha256sum "$LOG_FILE" > "$LOG_FILE.sha256"


# =====================================================
# FIM DO PROCESSO
# =====================================================