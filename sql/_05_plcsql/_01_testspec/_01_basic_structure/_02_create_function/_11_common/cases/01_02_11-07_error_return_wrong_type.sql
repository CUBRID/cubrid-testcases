--+ server-message on

-- error: return statement in a function has a value of a wrong type

create or replace function t(i int) return int as
begin
    return true;    -- wrong type
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';


--+ server-message off
