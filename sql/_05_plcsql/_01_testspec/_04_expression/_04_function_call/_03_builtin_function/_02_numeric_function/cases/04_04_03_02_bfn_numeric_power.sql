--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    dbms_output.put_line(POWER(2,5));
    dbms_output.put_line(POWER(-2,5));
    dbms_output.put_line(POWER(0,0));
    dbms_output.put_line(POWER(1,0));
    dbms_output.put_line(POWER(2,-5.1));
    dbms_output.put_line(POWER(-2,-5.1));
exception
    when VALUE_ERROR then
	dbms_output.put_line('VALUE_ERROR raised');
    when SQL_ERROR then
	dbms_output.put_line('SQL_ERROR raised');
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
