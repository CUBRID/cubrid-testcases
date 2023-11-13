--+ server-message on

-- normal: others in exception handler when clause


create or replace procedure t(i int) as
    my_error exception;
begin
    raise my_error;
exception
when others then
    dbms_output.put_line('others ' || sqlerrm);
    raise;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;


--+ server-message off
