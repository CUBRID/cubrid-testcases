--+ server-message on

-- error: unreachable after raise

create or replace procedure t(i int) as
begin
    raise case_not_found;
    null;   -- unreachable
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';


--+ server-message off
