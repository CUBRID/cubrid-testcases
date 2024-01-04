--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    dbms_output.put_line(STRCMP(NULL, NULL));
    dbms_output.put_line(STRCMP('abc', 'abc'));
    dbms_output.put_line(STRCMP(NULL, 'abc'));
    dbms_output.put_line(STRCMP('abc', NULL));
    dbms_output.put_line(STRCMP('abcd', 'abc'));
    dbms_output.put_line(STRCMP('abc', 'abcd'));
    --dbms_output.put_line(STRCMP('abc' COLLATE utf8, 'abc' COLLATE utf8_en_ci )); -- parse error COLLATE keyword
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
