--+ server-message on

-- error: unreachable after return

create or replace procedure t(i int) as
begin
    case i
    when 1 then
        return;
    when 2 then
        return;
    end case;
    null;   -- unreachable
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

