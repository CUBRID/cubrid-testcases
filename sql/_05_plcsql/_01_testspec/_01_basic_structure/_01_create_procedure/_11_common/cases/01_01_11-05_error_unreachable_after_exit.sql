--+ server-message on

-- error: unreachable after exit

create or replace procedure t(i int) as
begin
    loop
        exit;
        null;   -- unreachable
    end loop;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

