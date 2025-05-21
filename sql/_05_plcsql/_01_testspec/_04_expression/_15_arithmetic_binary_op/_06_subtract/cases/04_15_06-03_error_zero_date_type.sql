--+ server-message on

-- Verified for CBRD-25015

create or replace procedure poo as
begin
    dbms_output.put_line(date'0000-00-00' - 1);
end;
        
call poo();

create or replace procedure poo as
begin
    dbms_output.put_line(datetime'0000-00-00 00:00:00.000' - 1);
end; 

call poo();

create or replace procedure poo as
begin
    dbms_output.put_line(timestamp'0000-00-00 00:00:00' - 1);
end;

call poo();

drop procedure poo;

--+ server-message off
