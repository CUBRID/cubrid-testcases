--+ server-message on

-- error: unreachable after exit

create or replace procedure t(i int) as
begin
    loop
        exit;
        null;   -- unreachable
    end loop;
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';


--+ server-message off
