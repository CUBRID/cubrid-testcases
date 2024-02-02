--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    dbms_output.put_line(INSERT(NULL, 2, 1, '[]'));
    dbms_output.put_line(INSERT('cubrid', 2, 1, '[]'));
    dbms_output.put_line(INSERT('cubrid', 2, 2, '[ ]'));
    dbms_output.put_line(INSERT('cubrid', 1, -1, '[]'));
    dbms_output.put_line(INSERT('cubrid', NULL, 1, '[]'));
    dbms_output.put_line(INSERT('cubrid', 2, NULL, '[]'));
    dbms_output.put_line(INSERT('cubrid', 2, 1, NULL)); 
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
