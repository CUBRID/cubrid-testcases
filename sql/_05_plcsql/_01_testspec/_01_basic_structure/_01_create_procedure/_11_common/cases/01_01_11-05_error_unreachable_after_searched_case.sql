--+ server-message on

-- error: unreachable after searched case

create or replace procedure t(i int) as
begin
    case
    when i = 1 then
        return;
    when i = 2 then
        return;
    end case;
    null;   -- unreachable
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';


--+ server-message off
