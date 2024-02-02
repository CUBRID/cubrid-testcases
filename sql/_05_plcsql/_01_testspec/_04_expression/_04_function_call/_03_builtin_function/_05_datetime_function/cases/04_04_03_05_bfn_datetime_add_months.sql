--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    dbms_output.put_line(ADD_MONTHS(NULL, NULL));
    dbms_output.put_line(ADD_MONTHS(TO_DATETIME('1999-01-08'), NULL));
    dbms_output.put_line(ADD_MONTHS(TO_DATE('1999-01-08'), NULL));
    dbms_output.put_line(ADD_MONTHS(TO_TIME('12:00:00'), NULL));
    dbms_output.put_line(ADD_MONTHS(TIMESTAMP('1999-01-08 12:00:00'), NULL));
    dbms_output.put_line(ADD_MONTHS(NULL, TO_TIME('02:30:52')));
    dbms_output.put_line(ADD_MONTHS('1999-01-08', 0)); 
    dbms_output.put_line(ADD_MONTHS(('1999-01-08', -5)); 
    dbms_output.put_line(ADD_MONTHS('1999-01-08 12:00:00', 5)); 
    dbms_output.put_line(ADD_MONTHS('1999-01-08 12:00:00', -5.5)); 
    dbms_output.put_line(ADD_MONTHS('1999-01-08', 5.5)); 
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
