--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    -- dbms_output.put_line(CHARSET(NULL)); -- param NULL parse error for first paramA
    -- parse error CHARSET() param delimiter
    /*
    dbms_output.put_line(CHARSET(''));
    dbms_output.put_line(CHARSET(_utf8''));
    */
    NULL;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
