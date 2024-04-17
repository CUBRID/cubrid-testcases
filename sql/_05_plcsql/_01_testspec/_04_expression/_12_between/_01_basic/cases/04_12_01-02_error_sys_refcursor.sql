--+ server-message on

-- error: usage of operator 'between' with sys_refcursor values

create or replace procedure t(i int) as
    a sys_refcursor;
    b sys_refcursor;
    c sys_refcursor;

    function print_bool(b boolean) return varchar as
    begin
        return case when b is null then 'null' when b then 'true' else 'false' end;
    end;
begin
    dbms_output.put_line(print_bool(a between b and c));
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

--+ server-message off
