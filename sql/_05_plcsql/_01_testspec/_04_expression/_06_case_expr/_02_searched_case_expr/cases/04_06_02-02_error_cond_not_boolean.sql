--+ server-message on

-- error: conditions must be of boolean type

create or replace procedure t(i int) as
    c varchar;
begin
    c := case
        when 'true' then 'true'
        else 'false'
        end;
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';

--+ server-message off
