--+ server-message on

-- error: argument length too big

create or replace procedure t(i int) as
    function foo(i int, j int) return varchar as
    begin
        return i || ':' || j;
    end;
begin
    dbms_output.put_line(foo(2, 3, 4));
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

--+ server-message off
