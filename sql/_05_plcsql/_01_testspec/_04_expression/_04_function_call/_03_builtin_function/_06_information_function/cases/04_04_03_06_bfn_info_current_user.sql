--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    dbms_output.put_line(CURRENT_USER);
    dbms_output.put_line(SYSTEM_USER);
    dbms_output.put_line(USER);
    dbms_output.put_line(CASE WHEN CURRENT_USER() = CURRENT_USER() THEN 'ok' ELSE 'no' END);
    dbms_output.put_line(CASE WHEN SYSTEM_USER() = SYSTEM_USER() THEN 'ok' ELSE 'no' END);
    dbms_output.put_line(CASE WHEN USER() = USER() THEN 'ok' ELSE 'no' END);
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
