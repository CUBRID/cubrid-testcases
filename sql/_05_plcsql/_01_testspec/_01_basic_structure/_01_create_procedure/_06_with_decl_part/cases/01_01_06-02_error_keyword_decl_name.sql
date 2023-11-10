--+ server-message on

-- error: declaration name is a keyword

create or replace procedure t(i int) as
    while int;   -- while is a keyword
begin
    null;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';


