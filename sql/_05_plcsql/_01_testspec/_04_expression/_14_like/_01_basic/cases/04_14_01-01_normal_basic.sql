--+ server-message on
-- Verified for CBRD-24565

-- normal: basic usage of 'like' operator


create or replace procedure t(i int) as

    function print_bool(b boolean) return varchar as
    begin
        return case when b is null then 'null' when b then 'true' else 'false' end;
    end;
begin
    dbms_output.put_line(print_bool('' like ''));

    dbms_output.put_line(print_bool('abc' like 'a_c'));
    dbms_output.put_line(print_bool('abc' like 'a%c'));

    dbms_output.put_line(print_bool('abc' like 'a_'));
    dbms_output.put_line(print_bool('abc' like 'a%'));

    dbms_output.put_line(print_bool('abc' like '_c'));
    dbms_output.put_line(print_bool('abc' like '%c'));

    dbms_output.put_line(print_bool('abc' like 'abc'));
    dbms_output.put_line(print_bool('abc' like 'abcd'));
    dbms_output.put_line(print_bool('abc' like 'ab'));
    dbms_output.put_line(print_bool('abc' like 'bc'));

    dbms_output.put_line(print_bool('abc' like 'abc_'));
    dbms_output.put_line(print_bool('abc' like 'abcd_'));
    dbms_output.put_line(print_bool('abc' like 'ab_'));
    dbms_output.put_line(print_bool('abc' like 'bc_'));

    dbms_output.put_line(print_bool('abc' like '_abc_'));
    dbms_output.put_line(print_bool('abc' like '_abcd_'));
    dbms_output.put_line(print_bool('abc' like '_ab_'));
    dbms_output.put_line(print_bool('abc' like '_bc_'));

    dbms_output.put_line(print_bool('abc' like '_abc'));
    dbms_output.put_line(print_bool('abc' like '_abcd'));
    dbms_output.put_line(print_bool('abc' like '_ab'));
    dbms_output.put_line(print_bool('abc' like '_bc'));

    dbms_output.put_line(print_bool('abc' like 'abc%'));
    dbms_output.put_line(print_bool('abc' like 'abcd%'));
    dbms_output.put_line(print_bool('abc' like 'ab%'));
    dbms_output.put_line(print_bool('abc' like 'bc%'));

    dbms_output.put_line(print_bool('abc' like '%abc%'));
    dbms_output.put_line(print_bool('abc' like '%abcd%'));
    dbms_output.put_line(print_bool('abc' like '%ab%'));
    dbms_output.put_line(print_bool('abc' like '%bc%'));

    dbms_output.put_line(print_bool('abc' like '%abc'));
    dbms_output.put_line(print_bool('abc' like '%abcd'));
    dbms_output.put_line(print_bool('abc' like '%ab'));
    dbms_output.put_line(print_bool('abc' like '%bc'));
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;


--+ server-message off
