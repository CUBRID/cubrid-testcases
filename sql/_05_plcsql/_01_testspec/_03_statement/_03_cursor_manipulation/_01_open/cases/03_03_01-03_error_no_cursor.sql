--+ server-message on

-- error: open may not take a non-cursor as its arguement

create or replace procedure t(i int) as
    c int;
begin
    open c;
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

--+ server-message off
