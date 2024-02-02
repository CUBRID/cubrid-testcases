--+ server-message on

-- error: unreachable after continue

create or replace procedure t(i int) as
begin
    loop
        continue;
        null;   -- unreachable
    end loop;
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';


--+ server-message off
