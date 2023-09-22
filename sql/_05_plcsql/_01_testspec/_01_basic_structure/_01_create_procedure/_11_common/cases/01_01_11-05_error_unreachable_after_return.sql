--+ server-message on

-- error: unreachable after simple case

create or replace procedure t(i int) as
begin
    return;
    null;   -- unreachable
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

