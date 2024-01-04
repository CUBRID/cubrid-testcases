--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    -- dbms_output.put_line(ASCII(NULL)); -- param NULL parse error
    dbms_output.put_line(ASCII(''));
    dbms_output.put_line(ASCII('5'));
    dbms_output.put_line(ASCII(53));
    dbms_output.put_line(ASCII('김'));
    dbms_output.put_line(ASCII('a'));
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
