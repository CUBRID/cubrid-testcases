--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    -- [CBRD-25866] fixed : parse error INTERVAL 
    dbms_output.put_line(DATE_SUB(NULL, INTERVAL 24 HOUR)); 
    dbms_output.put_line(DATE_SUB(TO_DATE('1999-01-10'), INTERVAL 24 HOUR)); 
    dbms_output.put_line(DATE_SUB(TO_DATETIME('1999-01-10 01:00:00.000'), INTERVAL 24 HOUR)); 
    dbms_output.put_line(DATE_SUB(TIMESTAMP('1999-01-10 01:00:00.000'), INTERVAL 24 HOUR)); 

    dbms_output.put_line(SUBDATE(TO_DATE('1999-01-10'), INTERVAL 24 HOUR));
    dbms_output.put_line(SUBDATE(TO_DATETIME('1999-01-10 01:00:00.000'), INTERVAL 24 HOUR));
    dbms_output.put_line(SUBDATE(TIMESTAMP('1999-01-10 01:00:00.000'), INTERVAL 24 HOUR));

    dbms_output.put_line(SUBDATE(TO_DATE('1999-01-10'), 1));
    dbms_output.put_line(SUBDATE(TO_DATE('1999-01-10'), 0));
    dbms_output.put_line(SUBDATE(TO_DATE('1999-01-10'), -1));

    -- return value of DATETIME, TIMESTAMP for SUBDATE is not show properly
    dbms_output.put_line(SUBDATE(TO_DATETIME('1999-01-10 01:00:00.000'), -1));
    dbms_output.put_line(SUBDATE(TIMESTAMP('1999-01-10 01:00:00.000'), -0));
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
