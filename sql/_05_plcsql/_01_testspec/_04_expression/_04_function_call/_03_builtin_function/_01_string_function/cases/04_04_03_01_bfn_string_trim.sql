--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    dbms_output.put_line(TRIM(NULL)); -- param NULL parse error for first param
    dbms_output.put_line('[' || TRIM('   CUBRID   ') || ']');

    -- TRIM() keyword FROM/LEADING/TRAILING/BOTH parse error
    dbms_output.put_line(TRIM('a' FROM 'aaaCUBRIDaaaa'));
    dbms_output.put_line(TRIM(LEADING 'a' FROM 'aaaCUBRIDaaaa'));
    dbms_output.put_line(TRIM(TRAILING 'a' FROM 'aaaCUBRIDaaaa'));
    dbms_output.put_line(TRIM(BOTH 'a' FROM 'aaaCUBRIDaaaa'));
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
