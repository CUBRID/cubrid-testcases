--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    dbms_output.put_line(LTRIM(NULL)); -- param NULL parse error for first param
    dbms_output.put_line('[' || LTRIM('   CUBRID   ') || ']');
    dbms_output.put_line(LTRIM('   CUBRID   ', NULL));
    dbms_output.put_line(LTRIM('aaaCUBRIDaaaa', 'a'));
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
