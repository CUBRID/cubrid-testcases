--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    dbms_output.put_line(BIT_LENGTH(NULL)); -- parse error NULL
    dbms_output.put_line(BIT_LENGTH('')); -- param error '', Semantic: Cannot coerce host var to type bit varying.
    dbms_output.put_line(BIT_LENGTH('CUBRID')); -- param type mismath 
    dbms_output.put_line(BIT_LENGTH('큐브리드'));
    dbms_output.put_line(BIT_LENGTH(B'01010101')); -- parse error type literal define parenthesis
end; 

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
