--+ server-message on
-- As shown below, call of SYSDATE results in a type error.
-- There are 8 such built-in functions including SYSDATE in CUBRID
-- sys_date, sys_datetime, sys_time, sys_timestamp, sysdate, sysdatetime, systime, systimestamp

create or replace procedure test_sys_date as
begin
    dbms_output.put_line(sys_date);
end;

call test_sys_date();

create or replace procedure test_sys_datetime as
begin
    dbms_output.put_line(sys_datetime);
end;

call test_sys_datetime();

create or replace procedure test_time as
begin
    dbms_output.put_line(sys_time);
end;

call test_time();

create or replace procedure test_time_stamp as
begin
    dbms_output.put_line(sys_timestamp);
end;

call test_time_stamp();

create or replace procedure test_sysdate as
begin
    dbms_output.put_line(sysdate);
end;

call test_sysdate();

create or replace procedure test_sysdatetime as
begin
    dbms_output.put_line(sysdatetime);
end;

call test_sysdatetime();

create or replace procedure test_systime as
begin
    dbms_output.put_line(systime);
end;

call test_systime();

create or replace procedure test_systimestamp as
begin
    dbms_output.put_line(systimestamp);
end;

call test_systimestamp();

--+ server-message off
