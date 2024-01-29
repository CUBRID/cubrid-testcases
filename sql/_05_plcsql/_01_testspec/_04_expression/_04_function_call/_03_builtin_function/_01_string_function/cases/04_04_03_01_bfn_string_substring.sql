--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    dbms_output.put_line(SUBSTRING(NULL, 0, 0));
    dbms_output.put_line(SUBSTRING('12345abcdeabcde',6, 4));
    dbms_output.put_line(SUBSTRING('12345abcdeabcde',6, 0));
    dbms_output.put_line(SUBSTRING('12345abcdeabcde',-6, 4));
    dbms_output.put_line(SUBSTRING('12345abcdeabcde',6, -4));

    -- parse error SUBSTRING() in FROM/FOR
    dbms_output.put_line(SUBSTRING('12345abcdeabcde' FROM 6 FOR 4));
    dbms_output.put_line(SUBSTRING('12345abcdeabcde' FROM 6 FOR 0));
    dbms_output.put_line(SUBSTRING('12345abcdeabcde' FROM -6 FOR 4));
    dbms_output.put_line(SUBSTRING('12345abcdeabcde' FROM 6 FOR -4));
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
