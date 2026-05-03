CREATE DATABASE IF NOT EXISTS microempresa;

USE microempresa;

CREATE TABLE IF NOT EXISTS folha_pagamento (
    
    funcionario VARCHAR(50),

    -- salario anual
    salario DECIMAL(10, 2),

    -- descontos
    descontos DECIMAL(10, 2),

    -- bonus
    bonus DECIMAL(10, 2),


    imposto DECIMAL(5, 2)
);

-- inserir dados
INSERT INTO folha_pagamento (funcionario, salario, descontos, bonus, imposto)
VALUES
    ('João', 5000, 100, 500, 10),
    ('Maria', 6000, 200, 1000, 15),
    ('Pedro', 7000, 300, 1500, 20),
    ('Ana', 8000, 400, 2000, 25),
    ('Lucas', 9000, 500, 2500, 30),
    ('Mariana', 10000, 600, 3000, 35),
    ('Rafael', 11000, 700, 3500, 40),
    ('Fernanda', 12000, 800, 4000, 45),
    ('Guilherme', 13000, 900, 4500, 50),
    ('Camila', 14000, 1000, 5000, 55);

-- calcular o salario liquido
SELECT
    funcionario,
    salario,
    descontos,
    bonus,
    imposto
FROM
    folha_pagamento;

-- calcular o salario liquido
SELECT
    funcionario,

    -- salario menos o descontos
    salario - descontos AS salario_liquido,

    -- salario com bonus
    salario + bonus AS salario_total,

    -- valor do imposto
    salario * (imposto / 100) AS valor_imposto,

    -- salario mensal com decimais
    salario / 12 AS salario_mensal,

    -- salario inteiro mensal
    salario / 12 AS salario_mensal_int
FROM
    folha_pagamento;