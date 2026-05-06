use bank_trigger;

on schedule every 1 hour -- a cada 1 hora
starts '2023-01-01 08:00' -- inicio do event
ends '2023-01-01 10:00' -- fim do event
-- executa as 09h e 10h

on schedule every 1 minute -- a cada 5 minutos
starts current_timestamp -- comecar agora
ends current_timestamp + interval 1 hour -- terminar em 1 hora 

