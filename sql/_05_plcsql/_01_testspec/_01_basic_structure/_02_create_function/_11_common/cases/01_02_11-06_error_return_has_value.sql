--+ server-message on

-- error: return statement in a function does not have a value

create or replace function t(i int) return int as
begin
    return;
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';


--+ server-message off
