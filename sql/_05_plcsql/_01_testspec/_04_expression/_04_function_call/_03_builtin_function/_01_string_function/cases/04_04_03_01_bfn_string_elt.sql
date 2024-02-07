--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    dbms_output.put_line(ELT(NULL, NULL)); -- param NULL parse error for first param
    dbms_output.put_line(ELT(1, 'CUBRID', '2024' , '11.4'));
    dbms_output.put_line(ELT(2, 'CUBRID', '2024' , 11.4));
    dbms_output.put_line(ELT(2, 'CUBRID', NULL , 11.4));
    dbms_output.put_line(ELT(4, 'CUBRID', NULL , 11.4));
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
