--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    -- function not work and skip IF()
/*
    dbms_output.put_line('-- IF simple compare');	
    dbms_output.put_line(IF(NULL,  NULL, NULL));
    dbms_output.put_line(IF(NULL, 'ok', 'nok'));
    dbms_output.put_line(IF(1, 'ok', 'nok'));
    dbms_output.put_line(IF(0, NULL, NULL));
    dbms_output.put_line(IF(1, 1, NULL));
    dbms_output.put_line(IF('1', 'ok', 'nok'));
    dbms_output.put_line(IF('1', 'ok', 'nok'));
    
    dbms_output.put_line('-- IF datetime compare');
    dbms_output.put_line(IF(TO_DATETIME('01/01/2000') = '01/01/2000 00:00:00.000', 'ok' , 'nok'));
    dbms_output.put_line(IF(TO_DATETIME('01/01/2000') = '01/01/2000 00:00:00', 'ok' , 'nok'));
    dbms_output.put_line(IF(TO_DATETIME('01/01/2000') = '01/01/2000', 'ok' , 'nok'));

    dbms_output.put_line('-- IF timestamp compare');
    dbms_output.put_line(IF(TIMESTAMP('01/01/2000') = TO_DATETIME('01/01/2000'), 'ok' , 'nok'));
    dbms_output.put_line(IF(TIMESTAMP('01/01/2000') = TIMESTAMP('01/01/2000'), 'ok' , 'nok'));
    dbms_output.put_line(IF(TIMESTAMP('01/01/2000') = TO_DATE('01/01/2000'), 'ok' , 'nok'));
    dbms_output.put_line(IF(TIMESTAMP('01/01/2000') = '01/01/2000 00:00:00.000', 'ok' , 'nok'));
    dbms_output.put_line(IF(TIMESTAMP('01/01/2000') = '01/01/2000 00:00:00', 'ok' , 'nok'));
    dbms_output.put_line(IF(TIMESTAMP('01/01/2000') = '01/01/2000', 'ok' , 'nok'));

    dbms_output.put_line('-- IF date compare');
    dbms_output.put_line(IF(TO_DATE('01/01/2000') = TO_DATETIME('01/01/2000'), 'ok' , 'nok'));
    dbms_output.put_line(IF(TO_DATE('01/01/2000') = TIMESTAMP('01/01/2000'), 'ok' , 'nok'));
    dbms_output.put_line(IF(TO_DATE('01/01/2000') = TO_DATE('01/01/2000'), 'ok' , 'nok'));
    dbms_output.put_line(IF(TO_DATE('01/01/2000') = '01/01/2000 00:00:00.000', 'ok' , 'nok'));
    dbms_output.put_line(IF(TO_DATE('01/01/2000') = '01/01/2000 00:00:00', 'ok' , 'nok'));
    dbms_output.put_line(IF(TO_DATE('01/01/2000') = '01/01/2000', 'ok' , 'nok'));

    dbms_output.put_line('-- IF time compare');
    dbms_output.put_line(IF(TO_TIME('00:00:00') = TO_TIME('00:00:00'), 'ok' , 'nok'));
    dbms_output.put_line(IF(TO_TIME('00:00:00') = '00:00:00', 'ok' , 'nok'));
*/
    null;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
