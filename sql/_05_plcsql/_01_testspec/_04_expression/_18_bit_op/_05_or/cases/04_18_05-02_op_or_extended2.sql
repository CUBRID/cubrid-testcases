--+ server-message on

-- extended usage of operator '|'

create or replace procedure t () as
begin
	dbms_output.put_line(1 | 2);
	dbms_output.put_line(100 | 2);
	dbms_output.put_line(1102322432 | 2);
	dbms_output.put_line('1' | 2);
	dbms_output.put_line(NULL | 2);
	dbms_output.put_line(1 | '2');
	dbms_output.put_line('1' | '2');
	dbms_output.put_line(NULL | '2');
	dbms_output.put_line(1 | NULL);
	dbms_output.put_line('1' | NULL);
	dbms_output.put_line(NULL | NULL);
exception
	when SQL_ERROR then
		dbms_output.put_line('SQL_ERROR ouccers');
	when VALUE_ERROR then
		dbms_output.put_line('VALUE_ERROR ouccers');
	when ZERO_DIVIDE then
		dbms_output.put_line('ZERO_DIVIDE ouccers');
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
