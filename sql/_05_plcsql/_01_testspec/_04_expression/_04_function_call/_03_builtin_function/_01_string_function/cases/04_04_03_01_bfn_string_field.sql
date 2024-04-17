--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    dbms_output.put_line(FIELD(NULL, NULL));
    dbms_output.put_line(FIELD('abc', 'a', 'ab', 'abc', 'abcd', 'abcde'));
    dbms_output.put_line(FIELD('abc', 'a', 'ab', null));
    dbms_output.put_line(FIELD('123', 1, 12, 123.0, 1234, 12345));
    dbms_output.put_line(FIELD(123, 1, 12, '123.0', -1234, 12345));
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
