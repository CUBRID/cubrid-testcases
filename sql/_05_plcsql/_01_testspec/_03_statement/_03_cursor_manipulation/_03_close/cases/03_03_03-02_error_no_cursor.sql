--+ server-message on

-- error: closing a non-cursor

create or replace procedure t(i int) as
    c int;
begin
    close c;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

