--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    dbms_output.put_line(CURDATE() - CURDATE()); -- not support
    dbms_output.put_line(CURRENT_DATE() - CURRENT_DATE());
    dbms_output.put_line(CURRENT_DATE - CURRENT_DATE);
    dbms_output.put_line(CURRENT_DATETIME - CURRENT_DATETIME); -- parse timing gap makes wrong result
    dbms_output.put_line(CURTIME() - CURTIME()); -- not support
    dbms_output.put_line(CURRENT_TIME - CURRENT_TIME);
    dbms_output.put_line(LOCALTIME - LOCALTIME);
    dbms_output.put_line(LOCALTIMESTAMP - LOCALTIMESTAMP);
    dbms_output.put_line(SYS_DATE - SYS_DATE);
    dbms_output.put_line(SYSDATE - SYSDATE);
    dbms_output.put_line(SYS_DATETIME - SYS_DATETIME); -- parse timing gap makes wrong result
    dbms_output.put_line(SYSDATETIME - SYSDATETIME); -- parse timing gap makes wrong result
    dbms_output.put_line(SYS_DATE - SYS_DATE);
    dbms_output.put_line(SYS_TIME - SYS_TIME);
    dbms_output.put_line(SYS_TIMESTAMP - SYS_TIMESTAMP);
    dbms_output.put_line(SYSTIMESTAMP - SYSTIMESTAMP);
    dbms_output.put_line(NOW() - NOW()); -- not support
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
