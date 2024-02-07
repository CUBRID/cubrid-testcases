--+ server-message on

-- error: unknown function

create or replace procedure t(i int) as
begin
    dbms_output.put_line(foo(1, 2));
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';


--+ server-message off
