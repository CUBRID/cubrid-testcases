--+ server-message on

-- error: argument incompatible

create or replace procedure t(i int) as
    function foo(i int, j int) return varchar as
    begin
        return i || ':' || j;
    end;
begin
    dbms_output.put_line(foo(true, false));
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

