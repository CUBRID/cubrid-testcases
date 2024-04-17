--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    dbms_output.put_line(CHR(NULL)); -- param NULL parse error
    dbms_output.put_line(CHR(68));
    dbms_output.put_line(CHR(68-2));
    dbms_output.put_line(CHR(14909886 USING utf8)); -- parse error for USING keyord and RPAREN
    dbms_output.put_line(CHR(_utf8'ま')); -- parse error type literal define parenthesis
    dbms_output.put_line(CHR(_utf8'E381BE')); -- parse error type literal define parenthesis
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
