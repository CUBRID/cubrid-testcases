--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    -- dbms_output.put_line(RTRIM(NULL)); -- param NULL parse error for first param
    dbms_output.put_line('[' ||RTRIM('   CUBRID   ') || ']');
    dbms_output.put_line(RTRIM('   CUBRID   ', NULL));
    dbms_output.put_line(RTRIM('aaaCUBRIDaaaa', 'a'));
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
