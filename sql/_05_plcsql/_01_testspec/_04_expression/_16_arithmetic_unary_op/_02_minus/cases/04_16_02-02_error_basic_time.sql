--+ server-message on
-- Verified for CBRD-24565

-- error: usage of unary operator '-' with time values

create or replace procedure t(i int) as
    a time := time'01:02:03';
    b time := -a;
begin
    null;
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';


--+ server-message off
