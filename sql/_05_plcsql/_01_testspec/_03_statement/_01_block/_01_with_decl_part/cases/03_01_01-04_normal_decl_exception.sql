--+ server-message on

-- normal: exception can be declared in a block


create or replace procedure t(i int) as
begin
    declare
        ex exception;
    begin
        raise ex;
    exception
    when ex then
        dbms_output.put_line('OK');
    end;

    dbms_output.put_line('i=' || i);
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;

