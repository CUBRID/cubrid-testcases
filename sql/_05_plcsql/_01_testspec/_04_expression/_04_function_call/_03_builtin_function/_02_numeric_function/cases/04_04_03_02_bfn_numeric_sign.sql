--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    dbms_output.put_line(SIGN(NULL)); -- param NULL parse error for first param
    dbms_output.put_line(SIGN(12.3));
    dbms_output.put_line(SIGN(-12.3));
    dbms_output.put_line(SIGN(0));
    dbms_output.put_line(SIGN(''));
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
