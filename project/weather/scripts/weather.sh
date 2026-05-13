#!/bin/bash



# =====================================================
# ENTRA NA PASTA DO PROJETO
# =====================================================

cd /mnt/c/Users/lramo/OneDrive/Documentos/Estudos/sql-estudos/project/weather || exit 1

# =====================================================
# CARREGA VARIAVEIS AMBIENTE
# =====================================================

source .env

mkdir -p history/raw
mkdir -p history/clean
mkdir -p logs

# =====================================================
# VERIFICA SE CSV EXISTE
# =====================================================

if [ ! -f data/weather.csv ]; then

    echo "Arquivo weather.csv nao encontrado"

    exit 0

fi

# =====================================================
# EXECUTA CARGA STAGING
# =====================================================

mysql --local_infile=1 \
-h $DB_HOST \
-D $DB_NAME \
-u $DB_USER \
-p$DB_PASSWORD \
< sql/load_weather.sql \
> logs/load_weather.log 2>&1

# =====================================================
# CAPTURA STATUS
# =====================================================

LOAD_STATUS=$?

# =====================================================
# VERIFICA STAGING
# =====================================================

if [ $LOAD_STATUS -eq 0 ]; then

    echo "Carga staging executada com sucesso"

    # =================================================
    # EXECUTA ETL FINAL
    # =================================================

    mysql \
    -h $DB_HOST \
    -D $DB_NAME \
    -u $DB_USER \
    -p$DB_PASSWORD \
    < sql/copy_weather.sql

    # =================================================
    # CAPTURA STATUS ETL
    # =================================================

    COPY_STATUS=$?

    # =================================================
    # VALIDA ETL FINAL
    # =================================================

    if [ $COPY_STATUS -eq 0 ]; then

        TIMESTAMP=$(date +%Y%m%d%H%M%S)

        # =====================================================
        # MOVE CSV BRUTO
        # =====================================================

        mv data/weather.csv history/raw/raw_weather_$TIMESTAMP.csv

        # =====================================================
        # EXPORTA CSV LIMPO
        # =====================================================

        mysql \
        -h $DB_HOST \
        -D $DB_NAME \
        -u $DB_USER \
        -p$DB_PASSWORD \
        --batch \
        --raw \
        -e "SELECT * FROM current_weather;" \
        | sed 's/\t/,/g' \
        > history/clean/clean_weather_$TIMESTAMP.csv

        echo "Arquivo processado com sucesso"

    else

        echo "Erro no ETL final"

    fi

else

    echo "Erro durante carga staging"

fi