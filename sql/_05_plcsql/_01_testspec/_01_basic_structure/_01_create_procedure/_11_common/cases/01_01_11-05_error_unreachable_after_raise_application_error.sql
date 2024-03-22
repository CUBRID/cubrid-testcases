--+ server-message on
-- related CBRD-24481, but raise_application_error is unimplement function
-- error: unreachable after raise_application_error

create or replace procedure t(i int) as
begin
    raise_application_error(1, 'hello');
    null;   -- unreachable
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';


--+ server-message off
