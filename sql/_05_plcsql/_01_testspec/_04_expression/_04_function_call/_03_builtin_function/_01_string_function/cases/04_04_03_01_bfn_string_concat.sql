--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    -- dbms_output.put_line(CONCAT(NULL)); -- param NULL parse error for first param
    dbms_output.put_line(CONCAT('CUBRID ', '2024 ' , '11.4'));
    dbms_output.put_line(CONCAT('CUBRID ', '2024 ' , 11.4));
    -- dbms_output.put_line(CONCAT('CUBRID ', NULL , 11.4)); -- param NULL parse error
    -- dbms_output.put_line(CONCAT(14909886 USING utf8)); -- parse error for USING keyord and RPAREN
    -- dbms_output.put_line(CONCAT(_utf8'ま')); -- parse error type literal define parenthesis
    -- dbms_output.put_line(CONCAT(_utf8'E381BE')); -- parse error type literal define parenthesis
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
