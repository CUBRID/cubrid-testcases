--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    dbms_output.put_line(TRANSLATE(NULL, '', ''));
    dbms_output.put_line(TRANSLATE('', NULL, ''));
    dbms_output.put_line(TRANSLATE('', '', NULL));
    dbms_output.put_line(TRANSLATE('12345abcdeabcde','abcde', NULL));
    dbms_output.put_line(TRANSLATE('12345abcdeabcde', 'abcde', '12345'));
    dbms_output.put_line(TRANSLATE('12345abcdeabcde', 'AbCdE', '12345'));
    dbms_output.put_line(TRANSLATE('12345abcdeabcde','abcde', '123'));
    dbms_output.put_line(TRANSLATE('12345abcdeabcde','abcde', ''));
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
