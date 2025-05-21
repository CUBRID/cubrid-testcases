--+ server-message on

-- normal: basic usage of parenthesis
-- Verification for CBRD-25130

create or replace procedure t(i int) as
begin
    dbms_output.put_line('(2+3)*2=' || ((2 + 3) * 2));
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

call t(7);

drop procedure t;


--+ server-message off
