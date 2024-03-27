--+ server-message on
-- Verified for CBRD-24565

-- error: usage of unary operator '-' with sys_refcursor values

create or replace procedure t(i int) as
    a sys_refcursor;
    b sys_refcursor := -a;
begin
    null;
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';


--+ server-message off
