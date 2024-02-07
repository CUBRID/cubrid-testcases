--+ server-message on

-- error: BOOLEAN may not be the return type of stored functions

create or replace function t(i int) return boolean as
begin
    return null;
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';


--+ server-message off
