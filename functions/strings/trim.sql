
-- remove o caracter '*' do inicio
SELECT TRIM(LEADING '*' FROM '**Introduction**');

-- remove o caracter '*' do final
SELECT TRIM(TRAILING '*' FROM '**Introduction**');

-- remove o caracter '*' do inicio e final
SELECT TRIM(BOTH '*' FROM '**Introduction**');