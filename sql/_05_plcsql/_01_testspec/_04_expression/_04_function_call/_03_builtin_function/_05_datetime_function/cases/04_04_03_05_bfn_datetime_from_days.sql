--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    dbms_output.put_line(FROM_DAYS(NULL)); -- parse NULL param error
    dbms_output.put_line(FROM_DAYS(0));
    dbms_output.put_line(FROM_DAYS(1));
    dbms_output.put_line(FROM_DAYS(365));
    dbms_output.put_line(FROM_DAYS('366'));
    dbms_output.put_line(FROM_DAYS(652424));
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
