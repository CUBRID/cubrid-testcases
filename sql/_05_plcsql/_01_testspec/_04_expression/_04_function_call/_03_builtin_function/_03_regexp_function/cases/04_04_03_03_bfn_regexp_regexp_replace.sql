--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    dbms_output.put_line(REGEXP_REPLACE(NULL, NULL, NULL)); -- should be NULL
    dbms_output.put_line(REGEXP_REPLACE('12345abcdeabcde', '5+ab', '#'));
    dbms_output.put_line(REGEXP_REPLACE('12345abcdeabcde', '5+ab', NULL)); 
    dbms_output.put_line(REGEXP_REPLACE('12345abcdeabcde', 'ab+c', '#', 1)); 
    dbms_output.put_line(REGEXP_REPLACE('12345abcdeabcde', 'ab+c', '#', 9)); 
    dbms_output.put_line(REGEXP_REPLACE('12345abcdeabcde', 'ab+c', '#', NULL)); 
    dbms_output.put_line(REGEXP_REPLACE('12345abcdeabcde', '[a-c]', '#', 1, 1)); 
    dbms_output.put_line(REGEXP_REPLACE('12345abcdeabcde', '[a-c]', '#', 1, 2)); 
    dbms_output.put_line(REGEXP_REPLACE('12345abcdeabcde', '[a-c]', '#', 1, NULL)); 
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
