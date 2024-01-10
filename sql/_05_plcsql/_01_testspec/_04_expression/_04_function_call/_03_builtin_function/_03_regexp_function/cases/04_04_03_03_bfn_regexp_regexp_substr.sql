--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    dbms_output.put_line(REGEXP_SUBSTR(NULL, NULL)); -- NULL
    dbms_output.put_line(REGEXP_SUBSTR('12345abcdeabcde', NULL));
    dbms_output.put_line(REGEXP_SUBSTR('12345abcdeabcde', '5+ab', NULL)); 
    dbms_output.put_line(REGEXP_SUBSTR('12345abcdeabcde', 'ab+c', 1)); 
    dbms_output.put_line(REGEXP_SUBSTR('12345abcdeabcde', 'ab+c', 9)); 
    dbms_output.put_line(REGEXP_SUBSTR('12345abcdeabcde', 'ab+c', NULL)); 
    dbms_output.put_line(REGEXP_SUBSTR('12345abcdeabcde', '[a-c]', 1, 1)); 
    dbms_output.put_line(REGEXP_SUBSTR('12345abcdeabcde', '[a-c]', 1, 2)); 
    dbms_output.put_line(REGEXP_SUBSTR('12345abcdeabcde', '[a-c]', 1, NULL)); 
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
