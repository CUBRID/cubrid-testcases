--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    -- parse error TO_NUMBER('digit')
    /*
    dbms_output.put_line(TO_NUMBER(NULL,'9,999,999,999'));
    dbms_output.put_line(TO_NUMBER('1234567'));
    dbms_output.put_line(TO_NUMBER('1234567', '9999999'));
    dbms_output.put_line(TO_NUMBER('1,234,567','9,999,999'));
    dbms_output.put_line(TO_NUMBER('123.4567','999.9999'));
    dbms_output.put_line(TO_NUMBER('1,234,567.890','9,999,999.999'));
    dbms_output.put_line(TO_NUMBER('1,234,567,890.123456789','9,999,999,999.999999999'));
    dbms_output.put_line(TO_NUMBER('1,234,567,890,123,456,789','9,999,999,999,999,999,999'));
    */
    null;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
