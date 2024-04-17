--+ server-message on

-- error: usage of operator '>' with sys_refcursor values

create or replace procedure t(i int) as
    a sys_refcursor;
    b sys_refcursor;

    function print_bool(b sys_refcursor) return varchar as
    begin
        return case when b is null then 'null' when b then 'true' else 'false' end;
    end;
begin
    dbms_output.put_line(print_bool(a > b));
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';


--+ server-message off
