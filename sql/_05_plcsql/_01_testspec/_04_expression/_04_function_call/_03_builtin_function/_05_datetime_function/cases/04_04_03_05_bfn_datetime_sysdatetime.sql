--+ server-message on

-- Verification for CBRD-25058

create or replace procedure t as
    a datetime := sys_datetime;
    b datetime := sysdatetime - 1000;
begin
    dbms_output.put_line(case a is null when true then 'not ok' else 'ok' end);
    dbms_output.put_line(case b is null when true then 'not ok' else 'ok' end);
    dbms_output.put_line(case (a-b) > 0 when true then 'ok' else 'not ok' end);
end;


call t();

drop procedure t;

--+ server-message off

