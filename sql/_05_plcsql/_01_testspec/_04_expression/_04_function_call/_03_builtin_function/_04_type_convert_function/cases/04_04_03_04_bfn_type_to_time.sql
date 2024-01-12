--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    dbms_output.put_line(TO_TIME(NULL, 'HH24:MI:SS'));
    dbms_output.put_line(TO_TIME('18:41:53.733', NULL));
    dbms_output.put_line(TO_TIME('184153', 'HH24MISS'));
    dbms_output.put_line(TO_TIME('64153', 'HHMISS'));
    dbms_output.put_line(TO_TIME('18:41:53', 'HH24:MI:SS'));
    dbms_output.put_line(TO_TIME('6:41:53 PM', 'HH12:MI:SS PM'));

    dbms_output.put_line('-- TO_TIME(extra)');
    dbms_output.put_line(TO_TIME('HOUR: 13 MINUTE: 10 SECOND: 30', '"HOUR:" HH24 "MINUTE:" MI "SECOND:" SS'));
    -- TO_TIME 3rd parm parese error
    /*
    dbms_output.put_line(TO_TIME('6:41:53', 'HH:MI:SS', 'en_US'));
    */
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
