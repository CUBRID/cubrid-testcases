--+ server-message on

-- normal: basic usage of 'like' operator


create or replace procedure t(i int) as

    function print_bool(b boolean) return varchar as
    begin
        return case when b is null then 'null' when b then 'true' else 'false' end;
    end;
begin
    dbms_output.put_line(print_bool('abc%' like 'abc\%' escape '\'));
    dbms_output.put_line(print_bool('abc%' like 'abc.%' escape '.'));
    dbms_output.put_line(print_bool('abc%' like 'abc*%' escape '*'));
    dbms_output.put_line(print_bool('abc%' like 'abc%%' escape '%'));

    dbms_output.put_line(print_bool('abc' like 'abc\%' escape '\'));
    dbms_output.put_line(print_bool('abc' like 'abc.%' escape '.'));
    dbms_output.put_line(print_bool('abc' like 'abc*%' escape '*'));
    dbms_output.put_line(print_bool('abc' like 'abc%%' escape '%'));

    dbms_output.put_line(print_bool('abc_' like 'abc\_' escape '\'));
    dbms_output.put_line(print_bool('abc_' like 'abc._' escape '.'));
    dbms_output.put_line(print_bool('abc_' like 'abc*_' escape '*'));
    dbms_output.put_line(print_bool('abc_' like 'abc__' escape '_'));

    dbms_output.put_line(print_bool('abc' like 'abc\_' escape '\'));
    dbms_output.put_line(print_bool('abc' like 'abc._' escape '.'));
    dbms_output.put_line(print_bool('abc' like 'abc*_' escape '*'));
    dbms_output.put_line(print_bool('abc' like 'abc__' escape '_'));
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;


--+ server-message off
