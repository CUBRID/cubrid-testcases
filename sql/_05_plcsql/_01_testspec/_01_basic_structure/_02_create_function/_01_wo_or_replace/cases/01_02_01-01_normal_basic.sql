--+ server-message on

-- basic structure of CREATE FUNCTION without 'OR REPLACE' clause


create function t(i int) return int as
begin
    dbms_output.put_line('i=' || i);
    return i;
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

select t(7);

drop function t;


--+ server-message off
