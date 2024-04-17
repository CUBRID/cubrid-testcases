--+ server-message on

-- extended usage of operator '^'

create or replace procedure t () as
begin
	dbms_output.put_line(0 ^  0);
	dbms_output.put_line(0 ^  1);
	dbms_output.put_line(0 ^ -1);
	dbms_output.put_line(1 ^  0);
	dbms_output.put_line(1 ^  1);
	dbms_output.put_line(1 ^ -1);
	dbms_output.put_line(-1 ^ 0);
	dbms_output.put_line(-1 ^ 1);
	dbms_output.put_line(-1 ^ -1);
exception
	when SQL_ERROR then
		dbms_output.put_line('SQL_ERROR ouccers');
	when VALUE_ERROR then
		dbms_output.put_line('VALUE_ERROR ouccers');
	when ZERO_DIVIDE then
		dbms_output.put_line('ZERO_DIVIDE ouccers');
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
