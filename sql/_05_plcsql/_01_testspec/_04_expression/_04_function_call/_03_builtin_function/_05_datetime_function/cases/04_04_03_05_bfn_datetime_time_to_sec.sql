--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    dbms_output.put_line(TIME_TO_SEC(NULL)); -- parse NULL param error
    dbms_output.put_line(TIME_TO_SEC(TO_DATETIME('1999-01-11 12:34:52.533')));
    dbms_output.put_line(TIME_TO_SEC(TIMESTAMP('1999-01-11 12:34:52.533')));
    dbms_output.put_line(TIME_TO_SEC(TO_TIME('12:34:52')));
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
