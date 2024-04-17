--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    dbms_output.put_line(LEAST(NULL)); -- param NULL parse error for first param
    dbms_output.put_line(LEAST(NULL, 255));
    dbms_output.put_line(LEAST(1, 255));
    dbms_output.put_line(LEAST(1, NULL));
    dbms_output.put_line(LEAST('cub', 'cubrid'));
    dbms_output.put_line(LEAST(1, 3, 5));
    dbms_output.put_line(LEAST(1, 2, 4, 8));
    dbms_output.put_line(LEAST(0.1, 0.2, 0.4, 0.8));
    dbms_output.put_line(LEAST(TO_DATE('01/01/2010'), TO_DATE('01/02/2010')));
    dbms_output.put_line(LEAST(TO_DATETIME('01/01/2010'), TO_DATETIME('01/02/2010')));
    dbms_output.put_line(LEAST(TIMESTAMP('01/02/2010'), TIMESTAMP('01/01/2010')));
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
