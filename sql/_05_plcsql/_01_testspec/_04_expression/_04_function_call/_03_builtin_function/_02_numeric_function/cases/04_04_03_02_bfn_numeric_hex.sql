--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    dbms_output.put_line(HEX('ab'));
    dbms_output.put_line(HEX(128));
    dbms_output.put_line(HEX('金'));
    dbms_output.put_line(HEX(255));
    dbms_output.put_line(HEX('fF'));
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
