--+ server-message on
-- Verification for CBRD-24706

-- error: unknown field lookup

create or replace procedure t(i int) as
begin
    for r in (select * from db_collation) loop
        dbms_output.put_line('name=' || r.name);
    end loop;
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

--+ server-message off
