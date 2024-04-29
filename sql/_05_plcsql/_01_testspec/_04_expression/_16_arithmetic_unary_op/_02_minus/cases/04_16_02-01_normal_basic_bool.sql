--+ server-message on
-- Verified for CBRD-24565

-- error: usage of unary operator '-' with bool values

create or replace procedure t(i int) as
    a bool := true;
    b bool := -a;
begin
    null;
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';


--+ server-message off
