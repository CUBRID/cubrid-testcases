--+ server-message on

-- error: exit must be in a loop

create or replace procedure t(i int) as
begin
    exit;
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';


--+ server-message off
