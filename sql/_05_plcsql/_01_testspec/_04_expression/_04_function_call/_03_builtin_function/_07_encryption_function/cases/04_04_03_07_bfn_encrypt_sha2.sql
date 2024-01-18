--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    dbms_output.put_line(SHA2(NULL)); -- param NULL parse error for first param
    dbms_output.put_line(SHA2('cubrid', 224); -- parse error for SHA2() param desired length
    dbms_output.put_line(SHA2(255, 256); -- parse error for SHA2() param desired length
    dbms_output.put_line(SHA2('01/01/2010', 384)); -- parse error for SHA2() param desired length
    dbms_output.put_line(SHA2(TO_DATE('01/01/2010'), 512)); -- parse error for SHA2() param desired length
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
