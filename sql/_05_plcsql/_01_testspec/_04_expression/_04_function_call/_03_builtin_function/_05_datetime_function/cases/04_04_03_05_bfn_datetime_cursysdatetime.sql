--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    dbms_output.put_line(case CURDATE() - CURDATE() <= 0 when true then 'ok' else 'not ok' end);
    dbms_output.put_line(case CURRENT_DATE() - CURRENT_DATE() <= 0 when true then 'ok' else 'not ok' end);
    dbms_output.put_line(case CURRENT_DATE - CURRENT_DATE <= 0 when true then 'ok' else 'not ok' end);
    dbms_output.put_line(case CURRENT_DATETIME - CURRENT_DATETIME <= 0 when true then 'ok' else 'not ok' end);
    dbms_output.put_line(case CURTIME() - CURTIME() <= 0 when true then 'ok' else 'not ok' end);
    dbms_output.put_line(case CURRENT_TIME - CURRENT_TIME <= 0 when true then 'ok' else 'not ok' end);
    dbms_output.put_line(case LOCALTIME - LOCALTIME <= 0 when true then 'ok' else 'not ok' end);
    dbms_output.put_line(case LOCALTIMESTAMP - LOCALTIMESTAMP <= 0 when true then 'ok' else 'not ok' end);
    dbms_output.put_line(case SYS_DATE - SYS_DATE <= 0 when true then 'ok' else 'not ok' end);
    dbms_output.put_line(case SYSDATE - SYSDATE <= 0 when true then 'ok' else 'not ok' end);
    dbms_output.put_line(case SYS_DATETIME - SYS_DATETIME <= 0 when true then 'ok' else 'not ok' end);
    dbms_output.put_line(case SYSDATETIME - SYSDATETIME <= 0 when true then 'ok' else 'not ok' end);
    dbms_output.put_line(case SYS_DATE - SYS_DATE <= 0 when true then 'ok' else 'not ok' end);
    dbms_output.put_line(case SYS_TIME - SYS_TIME <= 0 when true then 'ok' else 'not ok' end);
    dbms_output.put_line(case SYS_TIMESTAMP - SYS_TIMESTAMP <= 0 when true then 'ok' else 'not ok' end);
    dbms_output.put_line(case SYSTIMESTAMP - SYSTIMESTAMP <= 0 when true then 'ok' else 'not ok' end);
    dbms_output.put_line(case NOW() - NOW() <= 0 when true then 'ok' else 'not ok' end);
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
