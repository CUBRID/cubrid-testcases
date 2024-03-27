--+ server-message on
-- Verified for CBRD-24565

-- error caused usage of operator '~'

create or replace procedure t () as
begin
    dbms_output.put_line(~NULL);
    dbms_output.put_line('null is ignore');
END;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
