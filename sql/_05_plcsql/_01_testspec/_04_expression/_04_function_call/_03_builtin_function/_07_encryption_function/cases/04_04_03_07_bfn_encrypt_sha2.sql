--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    -- dbms_output.put_line(SHA2(NULL)); -- param NULL parse error for first param
    -- parse error for SHA2()
    /*
    dbms_output.put_line(SHA2('cubrid'));
    dbms_output.put_line(SHA2(255));
    dbms_output.put_line(SHA2('01/01/2010'));
    dbms_output.put_line(SHA2(TO_DATE('01/01/2010')));
    */
    null;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
