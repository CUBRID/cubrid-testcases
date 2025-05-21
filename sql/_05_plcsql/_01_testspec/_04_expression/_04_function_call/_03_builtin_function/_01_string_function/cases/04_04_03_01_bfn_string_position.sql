--+ server-message on

-- normal: basic usage of a builtin function call

create or replace procedure t () as
begin
    dbms_output.put_line(POSITION(NULL)); -- param NULL parse error for first param
end;

-- [CBRD-25866] fixed : parse error POSITON() of IN keword
create or replace procedure t () as
begin
    dbms_output.put_line(POSITION('5' IN '12345abcdeabcde'));
    dbms_output.put_line(POSITION(5 IN '12345abcdeabcde'));
    dbms_output.put_line(POSITION(NULL IN '12345abcdeabcde'));
    dbms_output.put_line(POSITION(NULL IN NULL));
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
