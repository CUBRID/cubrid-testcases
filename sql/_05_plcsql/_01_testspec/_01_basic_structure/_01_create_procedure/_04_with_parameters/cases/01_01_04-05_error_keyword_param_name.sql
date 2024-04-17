--+ server-message on

-- error: 'while' is a keyword

create or replace procedure t(while int) as
begin
    null;
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

--+ server-message off
