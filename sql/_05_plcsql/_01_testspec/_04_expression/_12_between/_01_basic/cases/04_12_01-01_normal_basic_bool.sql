--+ server-message on
-- Verified for CBRD-24565

-- normal: basic usage of operator 'between' with boolean values


create or replace procedure t(i int) as
    a boolean := false;
    b boolean := false;
    c boolean := true;

    function print_bool(b boolean) return varchar as
    begin
        return case when b is null then 'null' when b then 'true' else 'false' end;
    end;
begin
    dbms_output.put_line(print_bool(b between a and c));
    dbms_output.put_line(print_bool(a between b and c));
    dbms_output.put_line(print_bool(null between b and c));
    dbms_output.put_line(print_bool(a between null and c));
    dbms_output.put_line(print_bool(a between b and null));
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;


--+ server-message off
