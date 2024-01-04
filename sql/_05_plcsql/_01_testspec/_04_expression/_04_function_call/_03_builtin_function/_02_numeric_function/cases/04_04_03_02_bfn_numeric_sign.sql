--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    dbms_output.put_line(SIGN(12.3));
    dbms_output.put_line(SIGN(-12.3));
    dbms_output.put_line(SIGN(0));
    dbms_output.put_line(SIGN(''));
    --dbms_output.put_line(SIGN(NULL)); -- when builtin function gets null as parms get parse error
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
