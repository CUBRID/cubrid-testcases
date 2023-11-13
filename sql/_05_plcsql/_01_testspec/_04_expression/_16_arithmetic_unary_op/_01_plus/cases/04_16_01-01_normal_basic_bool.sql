--+ server-message on

-- normal: basic usage of unary operator '+' with boolean values


create or replace procedure t(i int) as
    a boolean := false;
    b boolean := +a;

    function print_bool(b boolean) return varchar as
    begin
        return case when b is null then 'null' when b then 'true' else 'false' end;
    end;
begin
    dbms_output.put_line(print_bool(a));
    dbms_output.put_line(print_bool(b));
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;


--+ server-message off
