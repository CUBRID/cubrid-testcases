--+ server-message on

-- error: SQL must be a string type

create or replace procedure t(i int) as
    s double;
begin
    execute immediate s;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

