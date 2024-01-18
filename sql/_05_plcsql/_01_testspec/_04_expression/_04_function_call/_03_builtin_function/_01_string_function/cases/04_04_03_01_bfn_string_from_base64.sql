--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    dbms_output.put_line(FROM_BASE64(NULL)); -- param NULL parse error for first param
    dbms_output.put_line(FROM_BASE64('YWJjZA=='));
    dbms_output.put_line(FROM_BASE64('SGVsbG8gQ1VCUklE'));
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
