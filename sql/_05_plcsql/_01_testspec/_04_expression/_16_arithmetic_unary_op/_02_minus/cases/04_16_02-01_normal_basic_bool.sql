--+ server-message on

-- error: usage of unary operator '-' with bool values

create or replace procedure t(i int) as
    a bool := true;
    b bool := -a;
begin
    null;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

