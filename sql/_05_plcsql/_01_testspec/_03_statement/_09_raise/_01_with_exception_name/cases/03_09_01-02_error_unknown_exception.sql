--+ server-message on

-- error: raising unknown exception

create or replace procedure t(i int) as
begin
    raise e;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

