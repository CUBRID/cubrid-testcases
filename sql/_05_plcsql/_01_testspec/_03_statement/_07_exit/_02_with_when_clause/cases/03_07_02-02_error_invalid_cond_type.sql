--+ server-message on

-- error: condition must be of Boolean type

create or replace procedure t(i int) as
begin
    for i in 1 .. 5 loop
        exit when 'true';
    end loop;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';

