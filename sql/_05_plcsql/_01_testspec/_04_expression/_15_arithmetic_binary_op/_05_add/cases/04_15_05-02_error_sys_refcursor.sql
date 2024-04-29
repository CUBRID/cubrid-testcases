--+ server-message on
-- Verified for CBRD-24565

-- error: usage of operator '+' with sys_refcursor values

create or replace procedure t(i int) as
    a sys_refcursor;
    b sys_refcursor;
begin
    dbms_output.put_line(a + b);
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';


--+ server-message off
