USE bank_trigger;

drop event if exists event_bank_trigger;


delimiter //
create event event_bank_trigger
on schedule every 1 minute -- run every 1 minute
starts current_timestamp
do -- execute
begin
    update credito
    set credito_score = credito_score + 1;
end//
delimiter ;

show variables like 'event_scheduler'; -- verificar se o scheduler está ativado

SET GLOBAL event_scheduler = off; -- desativar o scheduler

SELECT * FROM credito;

show events;



delimiter //
create event event_bank_trigger_delete
on schedule every 1 month -- run every 1 mes
starts '2023-01-01 00:00:00'
do -- execute
begin
    delete from credito -- apaga creditos antigos 
    where id_credito < 5;
end//
delimiter ;


