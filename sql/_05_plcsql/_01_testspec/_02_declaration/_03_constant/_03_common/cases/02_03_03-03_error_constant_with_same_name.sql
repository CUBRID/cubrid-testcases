--+ server-message on

-- error: constant with the same name

create or replace procedure t(i int) as
    j const int;
    j constant int;
begin
    null;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

