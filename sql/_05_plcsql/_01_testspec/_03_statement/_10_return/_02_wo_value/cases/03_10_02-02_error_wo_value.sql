--+ server-message on

-- error: return statement in a function body must have a value

create or replace function t(i int) return int as
begin
    dbms_output.put_line('OK');
    return;
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

--+ server-message off
