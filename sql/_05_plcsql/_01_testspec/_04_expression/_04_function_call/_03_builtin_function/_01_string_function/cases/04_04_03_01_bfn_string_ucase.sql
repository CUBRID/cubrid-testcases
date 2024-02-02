--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    -- dbms_output.put_line(UCASE(NULL)); -- param NULL parse error for first param
    dbms_output.put_line(UCASE(''));
    dbms_output.put_line(UCASE('cubrid'));

    -- dbms_output.put_line(UPPER(NULL)); -- param NULL parse error for first param
    dbms_output.put_line(UPPER(''));
    dbms_output.put_line(UPPER('cubrid'));
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
