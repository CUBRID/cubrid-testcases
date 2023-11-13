--+ server-message on

-- error: usage of unary operator '-' with date values

create or replace procedure t(i int) as
    a date := date'2013-10-09';
    b date := -a;
begin
    null;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';


--+ server-message off
