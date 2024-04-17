--+ server-message on

-- error: usage of operator 'mod' with sys_refcursor values

create or replace procedure t(i int) as
    a sys_refcursor;
    b sys_refcursor;
begin
    dbms_output.put_line(a mod b);
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';


--+ server-message off
