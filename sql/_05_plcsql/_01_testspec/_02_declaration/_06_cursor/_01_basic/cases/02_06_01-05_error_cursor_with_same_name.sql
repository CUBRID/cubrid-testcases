--+ server-message on

-- error: variable with the same name

create or replace procedure t(i int) as
    cursor j is select * from dual;
    cursor j is select * from dual;
begin
    null;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';


--+ server-message off
