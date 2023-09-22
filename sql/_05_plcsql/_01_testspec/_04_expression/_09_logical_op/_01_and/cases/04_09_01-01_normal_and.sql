--+ server-message on

-- normal: basic usage of logical operator AND


create or replace procedure t(i int) as
    function print_bool(b boolean) return varchar as
    begin
        return case when b is null then 'null' when b then 'true' else 'false' end;
    end;
begin
    dbms_output.put_line(print_bool(true and true));
    dbms_output.put_line(print_bool(true and false));
    dbms_output.put_line(print_bool(true and null));
    dbms_output.put_line(print_bool(false and true));
    dbms_output.put_line(print_bool(false and false));
    dbms_output.put_line(print_bool(false and null));
    dbms_output.put_line(print_bool(null and true));
    dbms_output.put_line(print_bool(null and false));
    dbms_output.put_line(print_bool(null and null));
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;

