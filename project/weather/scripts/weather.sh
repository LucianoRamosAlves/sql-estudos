#!/bin/bash

# =====================================================
# ENTRA NA PASTA DO PROJETO
# =====================================================

cd /mnt/c/Users/lramo/OneDrive/Documentos/Estudos/sql-estudos/project/weather || exit 1

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
-h 127.0.0.1 \
-D weather \
-u trucking \
-pRoger \
< sql/load_weather.sql \
> load_weather.log 2>&1

# =====================================================
# VERIFICA SUCESSO
# =====================================================

if [ $? -eq 0 ]; then

    echo "Carga executada com sucesso"

    # =================================================
    # EXECUTA PROCEDURE / ETL FINAL
    # =================================================

    mysql \
    -h 127.0.0.1 \
    -D weather \
    -u trucking \
    -pRoger \
    < sql/copy_weather.sql

    # =================================================
    # MOVE CSV PROCESSADO
    # =================================================

    mv data/weather.csv data/weather.csv.$(date +%Y%m%d%H%M%S)

    echo "Arquivo movido"

else

    echo "Erro durante carga"

fi