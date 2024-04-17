--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    dbms_output.put_line(COALESCE(NULL)); -- param NULL parse error for first param
    dbms_output.put_line(COALESCE(NULL, 'cubrid'));
    dbms_output.put_line(COALESCE(NULL, 255));
    dbms_output.put_line(COALESCE(TO_DATE('01/01/2010'), NULL, TO_DATE('01/02/2010')));
    dbms_output.put_line(COALESCE(TO_DATETIME('01/01/2010'), TO_DATETIME('01/01/2010'), NULL));
    dbms_output.put_line(COALESCE(NULL, TIMESTAMP('01/02/2010'), TIMESTAMP('01/01/2010')));
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
