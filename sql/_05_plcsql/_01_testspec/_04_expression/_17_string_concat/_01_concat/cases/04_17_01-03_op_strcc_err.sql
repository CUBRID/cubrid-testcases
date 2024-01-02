--+ server-message on

-- error caused usage of string concatenation operator '||'
-- CBRD-25095 bug reported

create or replace procedure t() as
begin
    dbms_output.put_line( 10. || null);
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

call t();

drop procedure t;

--+ server-message off
