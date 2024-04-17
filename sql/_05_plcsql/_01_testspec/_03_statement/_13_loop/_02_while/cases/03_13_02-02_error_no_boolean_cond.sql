--+ server-message on

-- normal: while-loop condition must be boolean


create or replace procedure t(i int) as
begin
    while 'true' loop
        null;
    end loop;
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

--+ server-message off
