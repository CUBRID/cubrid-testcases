--+ server-message on

-- normal: we can declare an exception and use it in a raise statement.


create or replace procedure t(i int) as
    my_exception exception;
begin
    raise my_exception;
exception
when my_exception then
    dbms_output.put_line('OK');
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;


--+ server-message off
