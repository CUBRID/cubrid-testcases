--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    -- dbms_output.put_line(CONCAT_WS(NULL)); -- param NULL parse error for first param
    dbms_output.put_line(CONCAT_WS(' ', 'CUBRID', '2024' , '11.4'));
    -- dbms_output.put_line(CONCAT_WS('/', 'CUBRID', '2024' , 11.4)); -- param NULL parse error
    -- dbms_output.put_line(CONCAT_WS('', 'CUBRID', NULL , 11.4));
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
