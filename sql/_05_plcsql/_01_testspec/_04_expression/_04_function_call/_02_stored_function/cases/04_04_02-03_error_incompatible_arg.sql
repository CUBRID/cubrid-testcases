--+ server-message on

-- error: argument incompatible

create or replace function foo(i int, j int) return varchar as
begin
    return i || ':' || j;
end;

create or replace procedure t(i int) as
begin
    dbms_output.put_line(foo(true, false));
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

drop function foo;
