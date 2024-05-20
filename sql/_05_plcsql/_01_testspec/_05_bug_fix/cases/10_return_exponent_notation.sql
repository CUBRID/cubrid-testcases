--+ server-message on
-- Verified for CBRD-25010

create or replace procedure exponent_test as
begin
    dbms_output.put_line('float:   11.0f -> ' || 11.0f);
    dbms_output.put_line('double: 11.0e1 -> ' || 11.0e1);
    dbms_output.put_line('default:  11.0 -> ' || 11.0);
end;

call exponent_test();

drop procedure exponent_test;

--+ server-message off
