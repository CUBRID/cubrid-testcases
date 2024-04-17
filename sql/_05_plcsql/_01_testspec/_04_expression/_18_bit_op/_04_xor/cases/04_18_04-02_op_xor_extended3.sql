--+ server-message on

-- extended usage of operator '^'

create or replace procedure t () as
begin
	dbms_output.put_line(1234567890 ^ 128);
	dbms_output.put_line(1234567890 ^ 123456789);
	dbms_output.put_line(9223372036854775807 ^ 9223372036854775807);
	dbms_output.put_line(9223372036854775807 ^ -9223372036854775807);
	dbms_output.put_line(9223372036854775807 ^ 0);
	dbms_output.put_line(9223372036854775807 ^ -1);
	dbms_output.put_line(-9223372036854775807 ^ 9223372036854775807);
	dbms_output.put_line(-9223372036854775807 ^ -9223372036854775807);
	dbms_output.put_line(-9223372036854775807 ^ 0);
	dbms_output.put_line(-9223372036854775807 ^ -1);
	dbms_output.put_line(((9223372036854775807 ^ 0)^ 1) div ((9223372036854775807 ^ 1)^ 1));
	dbms_output.put_line(((9223372036854775807 ^ -9223372036854775807) ^ 2));
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
