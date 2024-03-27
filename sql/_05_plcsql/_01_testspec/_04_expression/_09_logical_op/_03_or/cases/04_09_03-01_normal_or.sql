--+ server-message on
-- Verified for CBRD-24565

-- normal: basic usage of logical operator OR


create or replace procedure t(i int) as
    function print_bool(b boolean) return varchar as
    begin
        return case when b is null then 'null' when b then 'true' else 'false' end;
    end;
begin
    dbms_output.put_line(print_bool(true or true));
    dbms_output.put_line(print_bool(true or false));
    dbms_output.put_line(print_bool(true or null));
    dbms_output.put_line(print_bool(false or true));
    dbms_output.put_line(print_bool(false or false));
    dbms_output.put_line(print_bool(false or null));
    dbms_output.put_line(print_bool(null or true));
    dbms_output.put_line(print_bool(null or false));
    dbms_output.put_line(print_bool(null or null));
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;


--+ server-message off
