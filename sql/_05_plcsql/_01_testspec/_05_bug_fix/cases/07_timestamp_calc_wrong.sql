--+ server-message on
-- Verified for CBRD-25006

create or replace procedure poo as
    s timestamp := timestamp'2023-09-21 01:02:03';
    t timestamp := timestamp'2023-09-21 01:02:04';
begin
    dbms_output.put_line(s + 5);
    dbms_output.put_line(s - 5);
    dbms_output.put_line(t - s);
end;

call poo();

drop procedure poo;

--+ server-message off
