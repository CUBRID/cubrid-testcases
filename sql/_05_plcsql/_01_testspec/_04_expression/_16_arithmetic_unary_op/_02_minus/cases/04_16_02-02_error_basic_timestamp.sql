--+ server-message on

-- error: usage of unary operator '-' with timestamp values

create or replace procedure t(i int) as
    a timestamp := timestamp'2013-10-09 01:02:03';
    b timestamp := -a;
begin
    null;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

