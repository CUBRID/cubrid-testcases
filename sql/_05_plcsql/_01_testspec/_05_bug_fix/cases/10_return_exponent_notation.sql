--+ server-message on
-- Verified for CBRD-25010

create or replace procedure exponent_test as
begin
    dbms_output.put_line('default:   11.0 -> ' || 11.0);
    dbms_output.put_line('float:    11.0f -> ' || 11.0f);
    dbms_output.put_line('float:    11.0F -> ' || 11.0F);
    dbms_output.put_line('double:  11.0e1 -> ' || 11.0e1);
    dbms_output.put_line('double:  11.0E1 -> ' || 11.0E1);
    dbms_output.put_line('double: 11.0e1f -> ' || 11.0e1f);
    dbms_output.put_line('double: 11.0E1F -> ' || 11.0E1F);
    dbms_output.put_line('double: 11.0E1f -> ' || 11.0E1f);
    dbms_output.put_line('double: 11.0e1F -> ' || 11.0e1F);
end;

call exponent_test();

drop procedure exponent_test;

--+ server-message off
