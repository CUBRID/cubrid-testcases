--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    dbms_output.put_line(MINUTE(NULL)); -- parse NULL param error
    dbms_output.put_line(MINUTE(TO_DATETIME('1999-01-11 12:34:52.333')));
    dbms_output.put_line(MINUTE(TIMESTAMP('1999-01-11 12:34:52.333')));
    dbms_output.put_line(MINUTE(TO_DATETIME('1999-01-11 12:34:52')));
    dbms_output.put_line(MINUTE(TIMESTAMP('1999-01-11')));
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
