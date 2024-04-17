--+ server-message on

-- normal: multiple exceptions can be combined in an exception handler when clause using 'or'


create or replace procedure t(i int) as
    my_error exception;
begin
    raise my_error;
exception
when case_not_found or my_error then
    dbms_output.put_line('msg=' || sqlerrm);
    raise;
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;


--+ server-message off
