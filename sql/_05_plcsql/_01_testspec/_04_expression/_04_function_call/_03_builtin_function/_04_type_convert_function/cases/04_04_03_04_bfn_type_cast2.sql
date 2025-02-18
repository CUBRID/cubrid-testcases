--+ server-message on

-- normal: basic usage of a builtin function call
-- CAST( AS ) parse case : char, varchar

evaluate 'CHAR';
create or replace procedure t () as
begin
    dbms_output.put_line(CAST('87654321098765432109876543210987654321' AS CHAR));
end;
call t();

create or replace procedure t () as
begin
    dbms_output.put_line(CAST('-87654321098765432109876543210987654321' AS CHAR(10)));
end;
call t();

create or replace procedure t () as
begin
    dbms_output.put_line(CAST('87654321098765432109876543210987654321' AS CHAR(20)));
end;
call t();
    
create or replace procedure t () as
begin
    dbms_output.put_line(CAST('-87654321098765432109876543210987654321' AS CHAR(30)));
end;
call t();

create or replace procedure t () as
begin
    dbms_output.put_line('-- CHAR SUCCESS CASE');
    dbms_output.put_line(CAST('0.87654321098765432109876543210987654321' AS CHAR(100)));
    dbms_output.put_line(CAST('-0.87654321098765432109876543210987654321' AS CHAR(1000)));
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t();

evaluate 'VARCHAR';
create or replace procedure t () as
begin
    dbms_output.put_line(CAST('-87654321098765432109876543210987654321' AS VARCHAR(10)));
end;
call t();

create or replace procedure t () as
begin
    dbms_output.put_line(CAST('87654321098765432109876543210987654321' AS VARCHAR(20)));
end;
call t();

create or replace procedure t () as
begin
    dbms_output.put_line(CAST('-87654321098765432109876543210987654321' AS VARCHAR(30)));
end;
call t();

create or replace procedure t () as
begin
    dbms_output.put_line('-- VARCHAR SUCCESS CASE');
    dbms_output.put_line(CAST('87654321098765432109876543210987654321' AS VARCHAR));
    dbms_output.put_line(CAST('0.87654321098765432109876543210987654321' AS VARCHAR(100)));
    dbms_output.put_line(CAST('-0.87654321098765432109876543210987654321' AS VARCHAR(1000)));
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
