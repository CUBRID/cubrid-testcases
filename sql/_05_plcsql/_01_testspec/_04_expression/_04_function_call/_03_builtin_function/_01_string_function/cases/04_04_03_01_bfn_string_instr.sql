--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    dbms_output.put_line(INSTR(NULL, 'u'));
    dbms_output.put_line(INSTR('cubrid', 'u'));
    dbms_output.put_line(INSTR('cubrid databse', 'd', 7));
    dbms_output.put_line(INSTR('cubrid databse', 'd', -1));
    dbms_output.put_line(INSTR('cubrid', NULL)); 
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
