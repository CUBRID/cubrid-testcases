--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    -- dbms_output.put_line(SEC_TO_TIME(NULL)); -- parse NULL param error
    dbms_output.put_line(SEC_TO_TIME(1));
    dbms_output.put_line(SEC_TO_TIME('1'));
    dbms_output.put_line(SEC_TO_TIME('82800.3'));
    dbms_output.put_line(SEC_TO_TIME(82800.3));
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
