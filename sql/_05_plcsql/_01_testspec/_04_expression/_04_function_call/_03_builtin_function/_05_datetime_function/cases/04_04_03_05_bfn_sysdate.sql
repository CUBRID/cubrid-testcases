--+ server-message on

-- As shown below, call of SYSDATE results in a type error.
-- There are 8 such built-in functions including SYSDATE in CUBRID
-- sys_date, sys_datetime, sys_time, sys_timestamp, sysdate, sysdatetime, systime, systimestamp

create or replace procedure test_sys as
     a date      := sys_date;
     b datetime  := sys_datetime;
     c time      := sys_time;
     d timestamp := sys_timestamp;
     e date      := sysdate;
     f datetime  := sysdatetime;
     g time      := systime;
     h timestamp := systimestamp;
begin
    dbms_output.put_line(case a is null when true then 'not ok' else 'ok' end);
    dbms_output.put_line(case b is null when true then 'not ok' else 'ok' end);
    dbms_output.put_line(case c is null when true then 'not ok' else 'ok' end);
    dbms_output.put_line(case d is null when true then 'not ok' else 'ok' end);
    dbms_output.put_line(case e is null when true then 'not ok' else 'ok' end);
    dbms_output.put_line(case f is null when true then 'not ok' else 'ok' end);
    dbms_output.put_line(case g is null when true then 'not ok' else 'ok' end);
    dbms_output.put_line(case h is null when true then 'not ok' else 'ok' end);
end;

call test_sys();

drop procedure test_sys;

--+ server-message off
