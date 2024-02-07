--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    dbms_output.put_line(COLLATION(USER()));
    dbms_output.put_line(COLLATION(''));
    dbms_output.put_line(COLLATION(_utf8'abc'))); -- parse error _charset' delimiter
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
