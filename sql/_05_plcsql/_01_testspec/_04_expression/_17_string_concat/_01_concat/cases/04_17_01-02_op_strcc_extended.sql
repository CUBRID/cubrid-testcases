--+ server-message on

-- extended usage of string concatenation operator '||'

create or replace procedure t() as
begin
    dbms_output.put_line( 1 || ' world');
    dbms_output.put_line( -1 || ' world');
    dbms_output.put_line( -1.2 || ' world');
    dbms_output.put_line( -(-1.2) || ' world');
    dbms_output.put_line( null || null);
    dbms_output.put_line( null || ' world');
    dbms_output.put_line( null || null);
    dbms_output.put_line('cubrid ' || null);
    dbms_output.put_line('cubrid ' || 11.4);
exception
    when VALUE_ERROR then
	dbms_output.put_line('VALUE_ERROR ouccers');
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
