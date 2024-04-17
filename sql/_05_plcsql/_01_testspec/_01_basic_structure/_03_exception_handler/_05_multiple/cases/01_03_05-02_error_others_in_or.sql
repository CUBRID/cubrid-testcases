--+ server-message on

-- error: others cannot be combined with another exception using 'or'

create or replace procedure t(i int) as
    my_error exception;
begin
    raise my_error;
exception
when others or my_error then
    dbms_output.put_line('msg=' || sqlerrm);
    raise;
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';


--+ server-message off
