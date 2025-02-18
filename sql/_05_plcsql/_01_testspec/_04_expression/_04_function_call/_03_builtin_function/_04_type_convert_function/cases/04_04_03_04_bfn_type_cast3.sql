--+ server-message on

-- normal: basic usage of a builtin function call
-- CAST( AS ) parse case : bit, bit varying

evaluate 'BIT';
create or replace procedure t () as
begin
    dbms_output.put_line(CAST('87654321098765432109876543210987654321' AS BIT));
end;
call t();

create or replace procedure t () as
begin
    dbms_output.put_line(CAST('87654321098765432109876543210987654321' AS BIT(10)));
end;
call t();

create or replace procedure t () as
begin
    dbms_output.put_line(CAST('87654321098765432109876543210987654321' AS BIT(20)));
end;
call t();

create or replace procedure t () as
begin
    dbms_output.put_line(CAST('87654321098765432109876543210987654321' AS BIT(50)));
end;
call t();

create or replace procedure t () as
begin
    dbms_output.put_line(CAST('87654321098765432109876543210987654321' AS BIT(100)));
end;
call t();

create or replace procedure t () as
begin
    dbms_output.put_line(CAST('87654321098765432109876543210987654321' AS BIT(1000)));
end;
call t();

create or replace procedure t () as
begin
    dbms_output.put_line(CAST('87654321098765432109876543210987654321' AS BIT(1000)));
end;
call t();

evaluate 'BIT VARYING';
create or replace procedure t () as
begin
    dbms_output.put_line(CAST('87654321098765432109876543210987654321' AS BIT VARYING));
end;
call t();

create or replace procedure t () as
begin
    dbms_output.put_line(CAST('87654321098765432109876543210987654321' AS BIT VARYING(10)));
end;
call t();

create or replace procedure t () as
begin
    dbms_output.put_line(CAST('87654321098765432109876543210987654321' AS BIT VARYING(20)));
end;
call t();

create or replace procedure t () as
begin
    dbms_output.put_line(CAST('87654321098765432109876543210987654321' AS BIT VARYING(50)));
end;
call t();

create or replace procedure t () as
begin
    dbms_output.put_line(CAST('87654321098765432109876543210987654321' AS BIT VARYING(100)));
end;
call t();

create or replace procedure t () as
begin
    dbms_output.put_line(CAST('87654321098765432109876543210987654321' AS BIT VARYING(1000)));
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
