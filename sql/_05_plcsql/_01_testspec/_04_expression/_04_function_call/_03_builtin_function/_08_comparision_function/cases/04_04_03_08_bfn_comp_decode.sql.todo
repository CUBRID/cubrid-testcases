--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    dbms_output.put_line('-- DECODE simple compare');
    dbms_output.put_line(DECODE(NULL, NULL, NULL, NULL));
    dbms_output.put_line(DECODE(NULL, NULL, 'ok', 'nok'));
    dbms_output.put_line(DECODE(1, 1, 'ok', 'nok'));
    dbms_output.put_line(DECODE(1, 0, NULL, NULL));
    dbms_output.put_line(DECODE(1, 1, NULL, NULL));
    dbms_output.put_line(DECODE('1', 1, 'ok', 'nok'));
    dbms_output.put_line(DECODE('1', '1', 'ok', 'nok'));
    
    dbms_output.put_line('-- DECODE multi condition compare');
    for i in 1 .. 7 by 2 loop
        dbms_output.put_line(DECODE(i, 1, 'lowest', 3, 'low', 5, 'high', 7, 'highest' ));
    end loop;
    
    dbms_output.put_line('-- DECODE datetime compare');
    dbms_output.put_line(DECODE(TO_DATETIME('01/01/2000'), '01/01/2000 00:00:00.000', 'ok' , 'nok'));
    dbms_output.put_line(DECODE(TO_DATETIME('01/01/2000'), '01/01/2000 00:00:00', 'ok' , 'nok'));
    dbms_output.put_line(DECODE(TO_DATETIME('01/01/2000'), '01/01/2000', 'ok' , 'nok'));

    dbms_output.put_line('-- DECODE timestamp compare');
    dbms_output.put_line(DECODE(TIMESTAMP('01/01/2000'), TO_DATETIME('01/01/2000'), 'ok' , 'nok'));
    dbms_output.put_line(DECODE(TIMESTAMP('01/01/2000'), TIMESTAMP('01/01/2000'), 'ok' , 'nok'));
    dbms_output.put_line(DECODE(TIMESTAMP('01/01/2000'), TO_DATE('01/01/2000'), 'ok' , 'nok'));
    dbms_output.put_line(DECODE(TIMESTAMP('01/01/2000'), '01/01/2000 00:00:00.000', 'ok' , 'nok'));
    dbms_output.put_line(DECODE(TIMESTAMP('01/01/2000'), '01/01/2000 00:00:00', 'ok' , 'nok'));
    dbms_output.put_line(DECODE(TIMESTAMP('01/01/2000'), '01/01/2000', 'ok' , 'nok'));

    dbms_output.put_line('-- DECODE date compare');
    dbms_output.put_line(DECODE(TO_DATE('01/01/2000'), TO_DATETIME('01/01/2000'), 'ok' , 'nok'));
    dbms_output.put_line(DECODE(TO_DATE('01/01/2000'), TIMESTAMP('01/01/2000'), 'ok' , 'nok'));
    dbms_output.put_line(DECODE(TO_DATE('01/01/2000'), TO_DATE('01/01/2000'), 'ok' , 'nok'));
    dbms_output.put_line(DECODE(TO_DATE('01/01/2000'), '01/01/2000 00:00:00.000', 'ok' , 'nok'));
    dbms_output.put_line(DECODE(TO_DATE('01/01/2000'), '01/01/2000 00:00:00', 'ok' , 'nok'));
    dbms_output.put_line(DECODE(TO_DATE('01/01/2000'), '01/01/2000', 'ok' , 'nok'));

    dbms_output.put_line('-- DECODE time compare');
    dbms_output.put_line(DECODE(TO_TIME('00:00:00'), TO_TIME('00:00:00'), 'ok' , 'nok'));
    dbms_output.put_line(DECODE(TO_TIME('00:00:00'), '00:00:00', 'ok' , 'nok'));
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
