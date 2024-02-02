--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    dbms_output.put_line(REGEXP_LIKE(NULL, NULL)); -- NULL
    dbms_output.put_line(REGEXP_LIKE('12345abcdeabcde', NULL)); -- NULL not 0
    dbms_output.put_line(REGEXP_LIKE('12345abcdeabcde', 'ab+c'));
    dbms_output.put_line(REGEXP_LIKE('12345aBcdeabcde', '5+ab', 'i'));
    dbms_output.put_line(REGEXP_LIKE('12345abcdeabcde', '5+aB', 'c'));
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
