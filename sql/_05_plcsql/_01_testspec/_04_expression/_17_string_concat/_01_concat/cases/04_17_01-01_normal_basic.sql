--+ server-message on
-- Verified for CBRD-24565

-- normal: basic usage of string concatenation operator '||'


create or replace procedure t(i int) as
begin
    dbms_output.put_line('Hello' || ' world');
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;


--+ server-message off
