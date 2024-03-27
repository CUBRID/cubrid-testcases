--+ server-message on
-- Verified for CBRD-24565

-- extended usage of operator '~'

create or replace procedure t () as
begin
	dbms_output.put_line(~0);
	dbms_output.put_line(~1);
	dbms_output.put_line(~-1);
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
