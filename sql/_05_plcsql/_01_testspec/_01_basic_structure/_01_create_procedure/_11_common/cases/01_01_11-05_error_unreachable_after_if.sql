--+ server-message on

-- error: unreachable after if

create or replace procedure t(i int) as
begin
    loop
        if false then
            exit;
        elsif false then
            continue;
        elsif false then
            return;
        elsif false then
            raise case_not_found;
        else
            continue;
        end if;

        null;   -- unreachable
    end loop;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';


--+ server-message off
