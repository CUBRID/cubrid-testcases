--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    dbms_output.put_line(RPAD(NULL, ''));
    dbms_output.put_line(RPAD('cubrid', NULL));
    dbms_output.put_line(RPAD('cubrid', 10, '!' ));
    dbms_output.put_line(RPAD('cubrid', 4, '!' ));
    dbms_output.put_line(RPAD('큐브리드', 10, '!')); -- multibyte korean dbms_output unrecognizable
    dbms_output.put_line(RPAD('큐브리드', 2, '!')); -- multibyte korean dbms_output unrecognizable
    dbms_output.put_line(RPAD('cubrid', 10, NULL));
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
