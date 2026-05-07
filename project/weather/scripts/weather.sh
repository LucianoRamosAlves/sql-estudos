
# esse arquivo é um script bash
#!/bin/bash 

cd  /home/project/weather/

# esse if verifica se o arquivo weather.csv existe
if [ ! -f weather.csv ]; then
    exit 0
fi

# esse comando carrega os dados no banco
mysql --local_infile=1 \
-h 127.0.0.1 \
-D weather \
-u trucking \
-pRoger\
< sql/load_weather.sql \
> load_weather.log

if [ ! -s load_weather.log ]; then #se nao houver erro
    mysql -h 127.0.0.1 \
    -D weather \
    -u trucking \
    -pRoger \
    < sql/copy_weather.sql

    mv weather.csv weather.csv.$(date +%Y%m%d%H%M%S)
fi
