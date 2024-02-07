--+ server-message on

-- error caused usage of operator '&'

create or replace procedure t () as
begin
    dbms_output.put_line('a' & 2);
exception
    when value_error then
	dbms_output.put_line('value_error ouccers');
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
