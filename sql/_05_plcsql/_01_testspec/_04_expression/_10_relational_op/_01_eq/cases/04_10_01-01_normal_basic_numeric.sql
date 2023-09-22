--+ server-message on

-- normal: basic usage of operator '=' with numeric values


create or replace procedure t(i int) as
    a numeric := 3.5;
    b numeric := 5.7;

    function print_bool(b boolean) return varchar as
    begin
        return case when b is null then 'null' when b then 'true' else 'false' end;
    end;
begin
    dbms_output.put_line(print_bool(a = a));
    dbms_output.put_line(print_bool(a = b));
    dbms_output.put_line(print_bool(null = a));
    dbms_output.put_line(print_bool(a = null));
    dbms_output.put_line(print_bool(null = null));
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;

