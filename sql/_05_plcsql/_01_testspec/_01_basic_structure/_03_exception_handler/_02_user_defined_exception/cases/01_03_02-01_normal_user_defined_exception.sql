--+ server-message on

-- normal: user defined exception can be used in raise statement and exception handler when clause


create or replace procedure t(i int) as
    my_error exception;
begin
    raise my_error;
exception
when my_error then
    dbms_output.put_line('my_error');
    raise;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;



--+ server-message off
