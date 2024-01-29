--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    -- parse error ISNULL()
    dbms_output.put_line(ISNULL(NULL));
    dbms_output.put_line(ISNULL(DECODE('a','a',NULL,'a')));
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
