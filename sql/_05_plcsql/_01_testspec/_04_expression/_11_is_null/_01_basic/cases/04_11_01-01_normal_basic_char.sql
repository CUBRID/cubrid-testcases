--+ server-message on

-- normal: basic usage of operator 'is null' with char values


create or replace procedure t(i int) as
    a char := 'a';
    b char;

    function print_bool(b boolean) return varchar as
    begin
        return case when b is null then 'null' when b then 'true' else 'false' end;
    end;
begin
    dbms_output.put_line(print_bool(a is null));
    dbms_output.put_line(print_bool(b is null));
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;


--+ server-message off
