CREATE DATABASE flaskr_test;

CREATE USER 'testuser'@'localhost' IDENTIFIED BY '123456';

GRANT ALL PRIVILEGES ON flaskr_test.* TO 'testuser'@'localhost';

FLUSH PRIVILEGES;

GRANT ALL PRIVILEGES ON bom_treino.* TO 'testuser'@'localhost';
GRANT ALL PRIVILEGES ON flaskr_test.* TO 'testuser'@'localhost';
FLUSH PRIVILEGES;

DROP TABLE IF EXISTS evolucao;
DROP TABLE IF EXISTS checkins;

select 
from flaskr_test

DROP DATABASE flaskr_test;
CREATE DATABASE flaskr_test;