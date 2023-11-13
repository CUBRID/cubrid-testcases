--+ server-message on

-- error: usage of unary operator '-' with time values

create or replace procedure t(i int) as
    a time := time'01:02:03';
    b time := -a;
begin
    null;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';


--+ server-message off
