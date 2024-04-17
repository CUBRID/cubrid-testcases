--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    dbms_output.put_line(LOCATE(NULL, ''));
    dbms_output.put_line(LOCATE('', 'cubrid'));
    dbms_output.put_line(LOCATE('', NULL));
    dbms_output.put_line(LOCATE('d', 'cubrid'));
    dbms_output.put_line(LOCATE('d', 'cubrid databse', 7));
    dbms_output.put_line(LOCATE('d', 'cubrid databse', -1));
    dbms_output.put_line(LOCATE('d', NULL, NULL)); 
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
