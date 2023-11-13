--+ server-message on

-- error: no commas between parameters

create or replace procedure t(i int c char) as
begin
    null;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';


--+ server-message off
