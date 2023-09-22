--+ server-message on

-- error: unreachable after body

create or replace procedure t(i int) as
begin
    loop
        begin
            continue;
        exception
            when case_not_found then
                continue;
            when others then
                continue;
        end;

        null;   -- unreachable
    end loop;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

