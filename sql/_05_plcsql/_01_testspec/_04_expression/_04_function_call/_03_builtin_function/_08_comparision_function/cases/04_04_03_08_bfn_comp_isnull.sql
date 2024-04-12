--+ server-message on

-- normal: basic usage of a builtin function call
-- Verification for CBRD-25168
create or replace procedure t () as
begin
    
    dbms_output.put_line(ISNULL(NULL));
    dbms_output.put_line(ISNULL(DECODE('a','a',NULL,'a')));
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
