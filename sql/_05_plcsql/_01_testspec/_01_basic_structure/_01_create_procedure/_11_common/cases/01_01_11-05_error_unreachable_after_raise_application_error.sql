--+ server-message on

-- error: unreachable after raise_application_error

create or replace procedure t(i int) as
begin
    raise_application_error(1, "hello");
    null;   -- unreachable
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

