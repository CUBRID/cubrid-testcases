--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    -- parse error for LIST_DBS() 
    dbms_output.put_line(LIST_DBS());
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
