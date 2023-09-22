--+ server-message on

-- error: undefind exception name is used in an exception handler when clause

create or replace procedure t(i int) as
begin
    null;
exception
when foo then
    null;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

