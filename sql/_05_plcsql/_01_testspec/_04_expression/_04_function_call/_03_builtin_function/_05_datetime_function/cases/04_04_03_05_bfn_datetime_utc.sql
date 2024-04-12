--+ server-message on

-- normal: basic usage of a builtin function call
-- Verification for CBRD-25194
create or replace procedure t () as
begin
    
    dbms_output.put_line(case isnull(UTC_DATE()) when 0 then 'ok' when 1 then 'nok' end);
    dbms_output.put_line(case isnull(UTC_TIME()) when 0 then 'ok' when 1 then 'nok' end);
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
