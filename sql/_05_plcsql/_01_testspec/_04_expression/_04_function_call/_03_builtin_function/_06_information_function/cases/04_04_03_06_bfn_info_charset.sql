--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    dbms_output.put_line(CHARSET(NULL)); -- param NULL parse error for first paramA
    dbms_output.put_line(CHARSET('')); -- parse error delimiter for emptystring
    dbms_output.put_line(CHARSET(_utf8'')); -- parse error CHARSET() param delimiter
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
