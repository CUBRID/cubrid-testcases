--+ server-message on

-- normal: while-loop condition must be boolean


create or replace procedure t(i int) as
begin
    while 'true' loop
        null;
    end loop;
end;

select * from db_stored_procedure where sp_name = 't';
select * from db_stored_procedure_args where sp_name = 't';
