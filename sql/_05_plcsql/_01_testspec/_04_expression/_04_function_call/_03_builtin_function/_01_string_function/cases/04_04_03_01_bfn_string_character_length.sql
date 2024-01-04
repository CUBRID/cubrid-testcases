--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    -- dbms_output.put_line(CHARACTER_LENGTH(NULL)); -- parse error NULL
    dbms_output.put_line(CHARACTER_LENGTH(''));
    dbms_output.put_line(CHARACTER_LENGTH('CUBRID')); -- param type mismath 
    dbms_output.put_line(CHARACTER_LENGTH('큐브리드'));
    --dbms_output.put_line(CHARACTER_LENGTH(B'01010101')); -- parse error type literal define parenthesis

    dbms_output.put_line(CHAR_LENGTH(''));
    dbms_output.put_line(CHAR_LENGTH('CUBRID')); -- param type mismath
    dbms_output.put_line(CHAR_LENGTH('큐브리드'));

    dbms_output.put_line(LENGTH(''));
    dbms_output.put_line(LENGTH('CUBRID')); -- param type mismath
    dbms_output.put_line(LENGTH('큐브리드'));

    dbms_output.put_line(LENGTHB(''));
    dbms_output.put_line(LENGTHB('CUBRID')); -- param type mismath
    dbms_output.put_line(LENGTHB('큐브리드'));
end; 

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
