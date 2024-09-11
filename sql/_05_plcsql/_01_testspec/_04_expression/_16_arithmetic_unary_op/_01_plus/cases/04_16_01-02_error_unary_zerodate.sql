-- error : basic usage of unary operator '-'  with zero date, datetime and time values
-- Verified for CBRD-25015

create or replace procedure t() as
    a date := date'0000-00-00';
    b date := -a;
begin
    dbms_output.put_line(a);
    dbms_output.put_line(b);
end;

create or replace procedure t() as
    a datetime := datetime'0000-00-00 00:00:00.000';
    b datetime := -a;
begin
    dbms_output.put_line(a);
    dbms_output.put_line(b);
end;


create or replace procedure t() as
    a time := time'00:00:00';
    b time := -a;
begin
    dbms_output.put_line(a);
    dbms_output.put_line(b);
end;


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

