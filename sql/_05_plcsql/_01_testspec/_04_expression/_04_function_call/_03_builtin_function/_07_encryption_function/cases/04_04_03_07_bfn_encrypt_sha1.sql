--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    -- dbms_output.put_line(SHA1(NULL)); -- param NULL parse error for first param
    dbms_output.put_line(SHA1('cubrid'));
    dbms_output.put_line(SHA1(255));
    dbms_output.put_line(SHA1('01/01/2010'));
    dbms_output.put_line(SHA1(TO_DATE('01/01/2010')));
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
