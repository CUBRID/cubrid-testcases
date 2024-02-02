--+ server-message on

-- error: fetching a non_cursor

create or replace procedure t(i int) as
    c int;
    i int;
begin
    fetch c into i;
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';



--+ server-message off
