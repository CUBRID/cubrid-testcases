--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    dbms_output.put_line(REPLACE(NULL, NULL));
    dbms_output.put_line(REPLACE('CUBRID DATABASE', NULL));
    dbms_output.put_line(REPLACE('CUBRID DATABASE', 'C', NULL));
    dbms_output.put_line(REPLACE('CUBRID DATABASE', 'C'));
    dbms_output.put_line(REPLACE('CUBRID DATABASE', 'D', 'd'));
    dbms_output.put_line(REPLACE('CUBRID DATABASE', 3.0));
    dbms_output.put_line(REPLACE('CUBRID DATABASE', 32000000));
    dbms_output.put_line(REPLACE('你好我好大家好','好','开心'));
    -- dbms_output.put_line(REPLACE(_binary'abcdefg', 'abcd')); -- parse error type literal define parenthesis
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
