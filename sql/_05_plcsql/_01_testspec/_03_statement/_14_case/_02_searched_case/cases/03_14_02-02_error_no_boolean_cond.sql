--+ server-message on

-- error: condition must be a boolean value

create or replace procedure t(i int) as
begin
    case
    when 'true' then
        null;
    else
        null;
    end case;
end;

select count(*) from db_stored_procedure where sp_name = 't';
select count(*) from db_stored_procedure_args where sp_name = 't';


--+ server-message off
