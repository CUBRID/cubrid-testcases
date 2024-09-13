--+ server-message on

-- normal: basic usage of unary operator '+' with zero date, datetime and time values
-- Verified for CBRD-25015

create or replace procedure t() as
    a date := date'0000-00-00';
    b date := +a;
begin
    dbms_output.put_line(a);
    dbms_output.put_line(b);
end;
call t();


create or replace procedure t() as
    a datetime := datetime'0000-00-00 00:00:00.000';
    b datetime := +a;
begin
    dbms_output.put_line(a);
    dbms_output.put_line(b);
end;
call t();


create or replace procedure t() as
    a datetime := timestamp'0000-00-00 00:00:00';
    b datetime := +a;
begin
    dbms_output.put_line(a);
    dbms_output.put_line(b);
end;
call t();


create or replace procedure t() as
    a time := time'00:00:00';
    b time := +a;
begin
    dbms_output.put_line(a);
    dbms_output.put_line(b);
end;
call t();

drop procedure t;

--+ server-message off

