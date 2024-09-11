-- error : basic usage of unary operator '-'  with zero date, datetime and time values
-- Verified for CBRD-25015

create or replace procedure t as
begin
    dbms_output.put_line(date'0000-00-00' + 1);
end;
        
call t();

create or replace procedure t as
begin
    dbms_output.put_line(datetime'0000-00-00 00:00:00.000' + 1);
end; 

call t();

create or replace procedure t as
begin
    dbms_output.put_line(timestamp'0000-00-00 00:00:00' + 1);
end;

call t();

--+ server-message off

