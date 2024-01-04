--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    -- dbms_output.put_line(BIN(NULL)); -- parse error NULL
    dbms_output.put_line(BIN(0));
    dbms_output.put_line(BIN(1));
    dbms_output.put_line(BIN(9223372036854775807));
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
