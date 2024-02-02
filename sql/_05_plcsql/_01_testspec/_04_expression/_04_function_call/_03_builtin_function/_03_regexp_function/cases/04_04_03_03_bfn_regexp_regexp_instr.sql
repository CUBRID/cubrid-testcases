--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    dbms_output.put_line('-- NULL 6 value followed');
    dbms_output.put_line(REGEXP_INSTR(NULL, 'abc')); -- NULL
    dbms_output.put_line(REGEXP_INSTR('12345abcdeabcde', 'abc'));
    dbms_output.put_line('-- NULL 6 NULL 6 value followed');
    dbms_output.put_line(REGEXP_INSTR('12345abcdeabcde', NULL)); -- NULL
    dbms_output.put_line(REGEXP_INSTR('12345abcdeabcde', 'abc'));
    dbms_output.put_line(REGEXP_INSTR('12345abcdeabcde', 'abc', NULL)); -- NULL
    dbms_output.put_line(REGEXP_INSTR('12345abcdeabcde', 'abc', 1));
    dbms_output.put_line('-- NULL 6 11 NULL value followed');
    dbms_output.put_line(REGEXP_INSTR('12345abcdeabcde', 'abc', 1, NULL)); -- NULL
    dbms_output.put_line(REGEXP_INSTR('12345abcdeabcde', 'abc', 1, 1));
    dbms_output.put_line(REGEXP_INSTR('12345abcdeabcde', 'abc', 1, 2));
    dbms_output.put_line(REGEXP_INSTR('12345abcdeabcde', 'abc', 1, 1, NULL)); -- NULL
    dbms_output.put_line('-- 6 9 6 6 value followed');
    dbms_output.put_line(REGEXP_INSTR('12345abcdeabcde', 'abc', 1, 1, 0));
    dbms_output.put_line(REGEXP_INSTR('12345abcdeabcde', 'abc', 1, 1, 1));
    dbms_output.put_line(REGEXP_INSTR('12345abcdeabcde', 'abc', 1, 1, 0, 'i'));
    dbms_output.put_line(REGEXP_INSTR('12345abcdeabcde', 'abc', 1, 1, 0, 'c'));
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
