--+ server-message on

-- error: exit must be in a loop

create or replace procedure t(i int) as
begin
    exit;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';


--+ server-message off
